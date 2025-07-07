using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace AircraftManagement
{
    public partial class CustomerDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                LoadInvitations();
                LoadBookings();
            }
        }

        private void LoadInvitations()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT ip.*, b.AircraftID, b.StartDate, b.EndDate, b.TotalAmount, b.chkMeals, b.chkWIFI, b.chkCatering, a.AircraftModel, a.Manufacturer, u.Email AS SellerEmail
                    FROM InvitedPeople ip
                    INNER JOIN Bookings b ON ip.BookingID = b.BookingID
                    INNER JOIN Aircraft a ON b.AircraftID = a.AircraftID
                    LEFT JOIN Users u ON b.SellerID = u.UserID
                    WHERE ip.InvitedUserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = new DataTable();
                        dt.Load(reader);
                        rptInvitations.DataSource = dt;
                        rptInvitations.DataBind();
                        lblNoInvitations.Visible = dt.Rows.Count == 0;
                    }
                }
            }
        }

        private void LoadBookings()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT b.*, a.AircraftModel, a.Manufacturer, a.ImageURL, u.Email AS SellerEmail, u.UserID AS SellerID
                    FROM Bookings b
                    INNER JOIN Aircraft a ON b.AircraftID = a.AircraftID
                    LEFT JOIN Users u ON b.SellerID = u.UserID
                    WHERE b.UserID = @UserID AND b.BookingStatus != 'Cancelled'";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = new DataTable();
                        dt.Load(reader);
                        rptBookings.DataSource = dt;
                        rptBookings.DataBind();
                        lblNoBookings.Visible = dt.Rows.Count == 0;
                    }
                }

                foreach (RepeaterItem item in rptBookings.Items)
                {
                    DataRowView row = item.DataItem as DataRowView;
                    int bookingID = row != null ? Convert.ToInt32(row["BookingID"]) : 0;

                    Repeater rptInvited = (Repeater)item.FindControl("rptInvitedPeople");
                    Literal litInviteCounter = (Literal)item.FindControl("litInviteCounter");
                    DropDownList ddlUsers = (DropDownList)item.FindControl("ddlUsers");

                    // Populate users for the Invite People modal
                    query = "SELECT UserID, Email FROM Users WHERE UserID != @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlUsers.DataSource = reader;
                            ddlUsers.DataTextField = "Email";
                            ddlUsers.DataValueField = "UserID";
                            ddlUsers.DataBind();
                            ddlUsers.Items.Insert(0, new ListItem("-- Select User --", ""));
                        }
                    }

                    // Calculate invite counter using Capacity from Bookings
                    int totalCapacity = 0;
                    int acceptedInvites = 0;
                    query = "SELECT Capacity FROM Bookings WHERE BookingID = @BookingID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingID", bookingID);
                        object result = cmd.ExecuteScalar();
                        totalCapacity = result != null ? Convert.ToInt32(result) : 0;
                    }

                    query = "SELECT COUNT(*) FROM InvitedPeople WHERE BookingID = @BookingID AND Status = 'Accepted'";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingID", bookingID);
                        acceptedInvites = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    litInviteCounter.Text = acceptedInvites + "/" + totalCapacity + " Capacity Filled";

                    // Load invited people with user details
                    query = @"
                        SELECT ip.*, u.Email, u.Username, u.ProfilePicture
                        FROM InvitedPeople ip
                        LEFT JOIN Users u ON ip.InvitedUserID = u.UserID
                        WHERE ip.BookingID = @BookingID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingID", bookingID);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            rptInvited.DataSource = reader;
                            rptInvited.DataBind();
                        }
                    }
                }
            }
        }

        protected string CalculateProgress(object startDate, object endDate)
        {
            DateTime start = Convert.ToDateTime(startDate);
            DateTime end = Convert.ToDateTime(endDate);
            DateTime now = DateTime.Now;

            if (now < start) return "0";
            if (now > end) return "100";

            double totalDuration = (end - start).TotalMinutes;
            double elapsed = (now - start).TotalMinutes;
            double progress = (elapsed / totalDuration) * 100;
            return Math.Round(progress).ToString();
        }

        protected string CalculateInviteProgress(object bookingID)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                int totalCapacity = 0;
                int acceptedInvites = 0;

                string query = "SELECT Capacity FROM Bookings WHERE BookingID = @BookingID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@BookingID", bookingID);
                    object result = cmd.ExecuteScalar();
                    totalCapacity = result != null ? Convert.ToInt32(result) : 0;
                }

                query = "SELECT COUNT(*) FROM InvitedPeople WHERE BookingID = @BookingID AND Status = 'Accepted'";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@BookingID", bookingID);
                    acceptedInvites = Convert.ToInt32(cmd.ExecuteScalar());
                }

                if (totalCapacity == 0) return "0";
                double progress = (acceptedInvites / (double)totalCapacity) * 100;
                return Math.Round(progress).ToString();
            }
        }

        protected void rptBookings_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int bookingID = Convert.ToInt32(e.CommandArgument);
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                if (e.CommandName == "CancelBooking")
                {
                    string query = "UPDATE Bookings SET BookingStatus = 'Cancelled', ConfirmedAt = GETDATE() WHERE BookingID = @BookingID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingID", bookingID);
                        cmd.ExecuteNonQuery();
                    }
                }
                else if (e.CommandName == "InvitePerson")
                {
                    HiddenField hdnBookingID = (HiddenField)e.Item.FindControl("hdnBookingID");
                    DropDownList ddlUsers = (DropDownList)e.Item.FindControl("ddlUsers");
                    TextBox txtEmail = (TextBox)e.Item.FindControl("txtEmail");

                    string invitedUserID = ddlUsers != null ? ddlUsers.SelectedValue : null;
                    string invitedEmail = txtEmail != null ? txtEmail.Text.Trim() : null;

                    if (string.IsNullOrEmpty(invitedUserID) && string.IsNullOrEmpty(invitedEmail))
                    {
                        return;
                    }

                    // Check capacity
                    int totalCapacity = 0;
                    int currentInvites = 0;
                    string query = "SELECT Capacity FROM Bookings WHERE BookingID = @BookingID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingID", bookingID);
                        object result = cmd.ExecuteScalar();
                        totalCapacity = result != null ? Convert.ToInt32(result) : 0;
                    }

                    query = "SELECT COUNT(*) FROM InvitedPeople WHERE BookingID = @BookingID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingID", bookingID);
                        currentInvites = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    if (currentInvites >= totalCapacity)
                    {
                        // Display an error message to the user
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Invitation limit reached for this booking.');", true);
                        return;
                    }

                    // Generate invitation code
                    string invitationCode = GenerateInvitationCode();

                    // Insert invitation
                    query = "INSERT INTO InvitedPeople (BookingID, InvitedUserID, InvitedEmail, Status, InvitedAt, InvitationCode) VALUES (@BookingID, @InvitedUserID, @InvitedEmail, 'Pending', GETDATE(), @InvitationCode)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingID", bookingID);
                        cmd.Parameters.AddWithValue("@InvitedUserID", string.IsNullOrEmpty(invitedUserID) ? (object)DBNull.Value : invitedUserID);
                        cmd.Parameters.AddWithValue("@InvitedEmail", string.IsNullOrEmpty(invitedEmail) ? (object)DBNull.Value : invitedEmail);
                        cmd.Parameters.AddWithValue("@InvitationCode", invitationCode);
                        cmd.ExecuteNonQuery();
                    }

                    // Send notification to the invited user (if userID is provided)
                    if (!string.IsNullOrEmpty(invitedUserID))
                    {
                        query = @"
                            SELECT a.AircraftModel, b.StartDate
                            FROM Bookings b
                            INNER JOIN Aircraft a ON b.AircraftID = a.AircraftID
                            WHERE b.BookingID = @BookingID";
                        string aircraftModel = "";
                        DateTime startDate = DateTime.Now;
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@BookingID", bookingID);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    aircraftModel = reader["AircraftModel"].ToString();
                                    startDate = Convert.ToDateTime(reader["StartDate"]);
                                }
                            }
                        }

                        query = @"
                            INSERT INTO Notifications (UserID, Title, Message, CreatedAt, IsRead)
                            VALUES (@UserID, @Title, @Message, GETDATE(), 0)";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", invitedUserID);
                            cmd.Parameters.AddWithValue("@Title", "New Flight Invitation");
                            cmd.Parameters.AddWithValue("@Message", "You have been invited to a flight on " + aircraftModel + " starting on " + startDate.ToString("MMM dd, yyyy HH:mm") + ". Use the invitation code " + invitationCode + " to accept.");
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                else if (e.CommandName == "UpdateExtras")
                {
                    HiddenField hdnExtrasBookingID = (HiddenField)e.Item.FindControl("hdnExtrasBookingID");
                    CheckBox chkMeals = (CheckBox)e.Item.FindControl("chkMeals");
                    CheckBox chkWIFI = (CheckBox)e.Item.FindControl("chkWIFI");
                    CheckBox chkCatering = (CheckBox)e.Item.FindControl("chkCatering");

                    decimal extraCost = 0;
                    if (chkMeals.Checked) extraCost += 50;
                    if (chkWIFI.Checked) extraCost += 20;
                    if (chkCatering.Checked) extraCost += 100;

                    string query = @"
                        UPDATE Bookings 
                        SET chkMeals = @chkMeals, chkWIFI = @chkWIFI, chkCatering = @chkCatering,
                            TotalAmount = TotalAmount + @ExtraCost
                        WHERE BookingID = @BookingID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@chkMeals", chkMeals.Checked);
                        cmd.Parameters.AddWithValue("@chkWIFI", chkWIFI.Checked);
                        cmd.Parameters.AddWithValue("@chkCatering", chkCatering.Checked);
                        cmd.Parameters.AddWithValue("@ExtraCost", extraCost);
                        cmd.Parameters.AddWithValue("@BookingID", bookingID);
                        cmd.ExecuteNonQuery();
                    }
                }
                else if (e.CommandName == "SetReminder")
                {
                    HiddenField hdnReminderBookingID = (HiddenField)e.Item.FindControl("hdnReminderBookingID");
                    DropDownList ddlReminder = (DropDownList)e.Item.FindControl("ddlReminder");
                    // Simulated reminder logic - in a real app, you might integrate with a notification system
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Reminder set successfully for Flight #" + bookingID + "');", true);
                }
                else if (e.CommandName == "RateFlight")
                {
                    HiddenField hdnRating = (HiddenField)e.Item.FindControl("hdnRating");
                    int rating = Convert.ToInt32(hdnRating.Value);
                    // In a real app, save the rating to a database table
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Flight #" + bookingID + " rated successfully with " + rating + " stars!');", true);
                }
                else if (e.CommandName == "ChatWithSeller")
                {
                    // Redirect to Chats.aspx with the BookingID
                    Response.Redirect("Chats.aspx?BookingID=" + bookingID);
                    return; // Stop further processing
                }

                LoadInvitations();
                LoadBookings();
            }
        }

        protected void rptInvitations_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int invitationID = Convert.ToInt32(e.CommandArgument);
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string status = "";
                if (e.CommandName == "AcceptInvite")
                {
                    status = "Accepted";
                }
                else if (e.CommandName == "DeclineInvite")
                {
                    status = "Declined";
                }

                string query = "UPDATE InvitedPeople SET Status = @Status WHERE InvitationID = @InvitationID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@InvitationID", invitationID);
                    cmd.ExecuteNonQuery();
                }

                if (status == "Accepted")
                {
                    query = @"
                        SELECT ip.InvitedUserID, a.AircraftModel, b.StartDate
                        FROM InvitedPeople ip
                        INNER JOIN Bookings b ON ip.BookingID = b.BookingID
                        INNER JOIN Aircraft a ON b.AircraftID = a.AircraftID
                        WHERE ip.InvitationID = @InvitationID";
                    int userID = 0;
                    string aircraftModel = "";
                    DateTime startDate = DateTime.Now;
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@InvitationID", invitationID);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                userID = Convert.ToInt32(reader["InvitedUserID"]);
                                aircraftModel = reader["AircraftModel"].ToString();
                                startDate = Convert.ToDateTime(reader["StartDate"]);
                            }
                        }
                    }

                    query = @"
                        INSERT INTO Notifications (UserID, Title, Message, CreatedAt, IsRead)
                        VALUES (@UserID, @Title, @Message, GETDATE(), 0)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        cmd.Parameters.AddWithValue("@Title", "Flight Invitation Accepted");
                        cmd.Parameters.AddWithValue("@Message", "You have accepted an invitation to a flight on " + aircraftModel + " starting on " + startDate.ToString("MMM dd, yyyy HH:mm") + ". Check your dashboard for details.");
                        cmd.ExecuteNonQuery();
                    }
                }

                LoadInvitations();
                LoadBookings();
            }
        }

        protected void btnSubmitCode_Click(object sender, EventArgs e)
        {
            string inviteCode = txtInviteCode.Text.Trim();
            if (string.IsNullOrEmpty(inviteCode))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please enter an invitation code.');", true);
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT ip.InvitationID, ip.BookingID, ip.InvitedUserID, a.AircraftModel, b.StartDate
                    FROM InvitedPeople ip
                    INNER JOIN Bookings b ON ip.BookingID = b.BookingID
                    INNER JOIN Aircraft a ON b.AircraftID = a.AircraftID
                    WHERE ip.InvitationCode = @InviteCode AND ip.Status = 'Pending'";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@InviteCode", inviteCode);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int invitationID = Convert.ToInt32(reader["InvitationID"]);
                            int userID = Convert.ToInt32(reader["InvitedUserID"]);
                            string aircraftModel = reader["AircraftModel"].ToString();
                            DateTime startDate = Convert.ToDateTime(reader["StartDate"]);

                            reader.Close();
                            query = "UPDATE InvitedPeople SET Status = 'Accepted' WHERE InvitationID = @InvitationID";
                            using (SqlCommand updateCmd = new SqlCommand(query, conn))
                            {
                                updateCmd.Parameters.AddWithValue("@InvitationID", invitationID);
                                updateCmd.ExecuteNonQuery();
                            }

                            query = @"
                                INSERT INTO Notifications (UserID, Title, Message, CreatedAt, IsRead)
                                VALUES (@UserID, @Title, @Message, GETDATE(), 0)";
                            using (SqlCommand notifyCmd = new SqlCommand(query, conn))
                            {
                                notifyCmd.Parameters.AddWithValue("@UserID", userID);
                                notifyCmd.Parameters.AddWithValue("@Title", "Flight Invitation Accepted");
                                notifyCmd.Parameters.AddWithValue("@Message", "You have accepted an invitation to a flight on " + aircraftModel + " starting on " + startDate.ToString("MMM dd, yyyy HH:mm") + ". Check your dashboard for details.");
                                notifyCmd.ExecuteNonQuery();
                            }

                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Code submitted successfully!');", true);
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Invalid or expired invitation code.');", true);
                        }
                    }
                }
            }

            LoadInvitations();
            LoadBookings();
        }

        private string GenerateInvitationCode()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            Random random = new Random();
            char[] code = new char[6];
            for (int i = 0; i < 6; i++)
            {
                code[i] = chars[random.Next(chars.Length)];
            }
            return new string(code);
        }
    }
}