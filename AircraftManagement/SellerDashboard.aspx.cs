using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.Util;

namespace AircraftManagement
{
    public partial class SellerDashboard : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            lblFeedbackMessage.Text = String.Format("Session UserID: {0}", Session["UserID"]);
            lblFeedbackMessage.CssClass = "alert alert-info";
            lblFeedbackMessage.Visible = true;

            if (!IsSellerRoleOn())
            {
                lblFeedbackMessage.Text = "Access Denied: You are not authorized to access the Seller Dashboard. Please submit a seller application to activate your seller role.";
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
                gvApplications.Visible = false;
                gvAircrafts.Visible = false;
                gvTransactions.Visible = false;
                btnSearchListings.Visible = false;
                btnSearchChatUsers.Visible = false;
                btnSearchTransactions.Visible = false;
                btnDownloadReport.Visible = false;
                return;
            }

            if (!IsPostBack)
            {
                LoadQuickStats();
                LoadSellerApplications();
                LoadAircraftListings();
                LoadChatUsers();
                LoadTransactions();
            }
        }

        private bool IsSellerRoleOn()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT SellerRole FROM Users WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                    object result = cmd.ExecuteScalar();
                    string sellerRole = result != null ? result.ToString() : null;
                    return sellerRole == "ON";
                }
            }
        }

        private void LoadQuickStats()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string listingsQuery = "SELECT COUNT(*) FROM Aircraft WHERE SellerID = @SellerID";
                using (SqlCommand cmd = new SqlCommand(listingsQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                    lblTotalListings.Text = cmd.ExecuteScalar().ToString();
                }

                string applicationsQuery = "SELECT COUNT(*) FROM SellerApplications WHERE UserID = @UserID AND Status = 'Pending'";
                using (SqlCommand cmd = new SqlCommand(applicationsQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                    lblPendingApplications.Text = cmd.ExecuteScalar().ToString();
                }

                string unreadMessagesQuery = @"
                    SELECT COUNT(*) 
                    FROM Notifications n
                    INNER JOIN Users u ON n.UserID = u.UserID
                    INNER JOIN Bookings b ON b.UserID = u.UserID
                    WHERE b.SellerID = @SellerID 
                    AND n.IsRead = 0 
                    AND n.Message LIKE '%Message from Seller%'";
                using (SqlCommand cmd = new SqlCommand(unreadMessagesQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                    lblUnreadMessages.Text = cmd.ExecuteScalar().ToString();
                }

                conn.Close();
            }
        }

        protected string GetFirstPhoto(object photos)
        {
            if (photos == null || string.IsNullOrEmpty(photos.ToString()))
            {
                return "~/images/placeholder.jpg";
            }

            string[] photoArray = photos.ToString().Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
            return photoArray.Length > 0 ? photoArray[0] : "~/images/placeholder.jpg";
        }

        private DataTable ConvertReaderToDataTable(SqlDataReader reader)
        {
            DataTable table = new DataTable();
            table.Load(reader);
            return table;
        }

        private void LoadSellerApplications()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string userId = Session["UserID"].ToString();
                string query = @"
                    SELECT 
                        ApplicationID, 
                        AIRCRAFTMODEL, 
                        YearManufactured, 
                        CREATEDAT, 
                        ImageURL, 
                        LICENSEPATH,
                        SellingExperience,
                        CompanyName,
                        SellingOnBehalf,
                        IsOwner,
                        CompanyAge,
                        AIRCRAFTOWNERSHIPCOUNT,
                        ContactMethod,
                        PaymentMethod,
                        EngineHours,
                        FuelType,
                        AirCraftCondition,
                        Capacity,
                        Description,
                        Status,
                        PurchasePrice,
                        RentalPrice
                    FROM SellerApplications
                    WHERE UserID = @UserID AND Status = 'Pending'";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = ConvertReaderToDataTable(reader);
                        if (dt.Rows.Count == 0)
                        {
                            lblFeedbackMessage.Text = "Debug: No pending seller applications found for UserID: " + userId;
                            lblFeedbackMessage.CssClass = "alert alert-warning";
                            lblFeedbackMessage.Visible = true;
                        }
                        else
                        {
                            lblFeedbackMessage.Text = "Debug: Found " + dt.Rows.Count + " pending seller applications for UserID: " + userId;
                            lblFeedbackMessage.CssClass = "alert alert-info";
                            lblFeedbackMessage.Visible = true;
                        }
                        gvApplications.DataSource = dt;
                        gvApplications.DataBind();
                    }
                }
                conn.Close();
            }
        }

        private void LoadAircraftListings()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT 
                        AircraftID, 
                        AIRCRAFTMODEL, 
                        YearManufactured, 
                        Description, 
                        CASE 
                            WHEN TransactionType = 'Buy' THEN PurchasePrice 
                            WHEN TransactionType = 'Rent' THEN RentalPrice 
                            ELSE NULL 
                        END AS Price,
                        Status,
                        ImageURL,
                        EngineHours,
                        FuelType,
                        AirCraftCondition,
                        Capacity,
                        SellerID,
                        PurchasePrice,
                        RentalPrice,
                        TransactionType
                    FROM Aircraft
                    WHERE SellerID = @SellerID";

                if (!string.IsNullOrEmpty(txtSearchListings.Text))
                {
                    query += " AND (AIRCRAFTMODEL LIKE '%' + @SearchText + '%' OR Status LIKE '%' + @SearchText + '%')";
                }

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                    if (!string.IsNullOrEmpty(txtSearchListings.Text))
                    {
                        cmd.Parameters.AddWithValue("@SearchText", txtSearchListings.Text);
                    }
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = ConvertReaderToDataTable(reader);
                        gvAircrafts.DataSource = dt;
                        gvAircrafts.DataBind();
                    }
                }
                conn.Close();
            }
        }

        private void LoadChatUsers()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT DISTINCT 
                        u.UserID, 
                        u.Username, 
                        u.Email, 
                        b.CreatedAt AS LastInteraction, 
                        a.AIRCRAFTMODEL AS AircraftModel
                    FROM Bookings b
                    INNER JOIN Users u ON b.UserID = u.UserID
                    INNER JOIN Aircraft a ON b.AircraftID = a.AircraftID
                    WHERE b.SellerID = @SellerID";

                if (!string.IsNullOrEmpty(txtSearchChatUsers.Text))
                {
                    query += " AND u.Username LIKE '%' + @SearchText + '%'";
                }

                query += " ORDER BY b.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (Session["UserID"] == null)
                    {
                        throw new Exception("SellerID is not set in session.");
                    }
                    cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                    if (!string.IsNullOrEmpty(txtSearchChatUsers.Text))
                    {
                        cmd.Parameters.AddWithValue("@SearchText", txtSearchChatUsers.Text);
                    }
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = ConvertReaderToDataTable(reader);
                        rptChatUsers.DataSource = dt;
                        rptChatUsers.DataBind();
                    }
                }
                conn.Close();
            }
        }

        private void LoadTransactions()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT 
                        t.TransactionID, 
                        u.Username AS BuyerUsername, 
                        a.AIRCRAFTMODEL AS AircraftModel, 
                        t.TransactionType, 
                        t.TransactionDate, 
                        t.TotalAmount,
                        t.Status
                    FROM Transactions t
                    INNER JOIN Bookings b ON t.BookingID = b.BookingID
                    INNER JOIN Users u ON b.UserID = u.UserID
                    INNER JOIN Aircraft a ON b.AircraftID = a.AircraftID
                    WHERE b.SellerID = @SellerID";

                if (!string.IsNullOrEmpty(txtSearchTransactions.Text))
                {
                    query += " AND (u.Username LIKE '%' + @SearchText + '%' OR t.TransactionType LIKE '%' + @SearchText + '%')";
                }

                query += " ORDER BY t.TransactionDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                    if (!string.IsNullOrEmpty(txtSearchTransactions.Text))
                    {
                        cmd.Parameters.AddWithValue("@SearchText", txtSearchTransactions.Text);
                    }
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = ConvertReaderToDataTable(reader);
                        gvTransactions.DataSource = dt;
                        gvTransactions.DataBind();
                    }
                }
                conn.Close();
            }
        }

        protected void btnSearchListings_Click(object sender, EventArgs e)
        {
            LoadAircraftListings();
        }

        protected void btnSearchChatUsers_Click(object sender, EventArgs e)
        {
            LoadChatUsers();
        }

        protected void btnSearchTransactions_Click(object sender, EventArgs e)
        {
            LoadTransactions();
        }

        protected void gvApplications_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvApplications.PageIndex = e.NewPageIndex;
            LoadSellerApplications();
        }

        protected void gvAircrafts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAircrafts.PageIndex = e.NewPageIndex;
            LoadAircraftListings();
        }

        protected void gvTransactions_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTransactions.PageIndex = e.NewPageIndex;
            LoadTransactions();
        }

        protected void gvAircrafts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int aircraftId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditAircraft")
            {
                Response.Redirect("EditAircraft.aspx?AircraftID=" + aircraftId);
            }
            else if (e.CommandName == "ToggleVisibility")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        string currentStatusQuery = "SELECT Status FROM Aircraft WHERE AircraftID = @AircraftID AND SellerID = @SellerID";
                        string newStatus = "";
                        using (SqlCommand cmd = new SqlCommand(currentStatusQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                            cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                            newStatus = cmd.ExecuteScalar() != null && cmd.ExecuteScalar().ToString() == "Hidden" ? "Available" : "Hidden";
                        }

                        string updateQuery = @"
                            UPDATE Aircraft
                            SET Status = @NewStatus
                            WHERE AircraftID = @AircraftID AND SellerID = @SellerID";
                        using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                            cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                            cmd.Parameters.AddWithValue("@NewStatus", newStatus);
                            int rowsAffected = cmd.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                lblFeedbackMessage.Text = "Aircraft visibility updated to " + newStatus + " successfully!";
                                lblFeedbackMessage.CssClass = "alert alert-success";
                                lblFeedbackMessage.Visible = true;
                            }
                            else
                            {
                                lblFeedbackMessage.Text = "Failed to update aircraft visibility.";
                                lblFeedbackMessage.CssClass = "alert alert-danger";
                                lblFeedbackMessage.Visible = true;
                            }
                        }
                        conn.Close();
                    }

                    LoadAircraftListings();
                    LoadQuickStats();
                }
                catch (Exception ex)
                {
                    lblFeedbackMessage.Text = "Error updating aircraft visibility: " + ex.Message;
                    lblFeedbackMessage.CssClass = "alert alert-danger";
                    lblFeedbackMessage.Visible = true;
                }
            }
            else if (e.CommandName == "DeleteAircraft")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        string deleteQuery = @"
                            DELETE FROM Aircraft
                            WHERE AircraftID = @AircraftID AND SellerID = @SellerID";
                        using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                            cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                            int rowsAffected = cmd.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                lblFeedbackMessage.Text = "Aircraft listing deleted successfully!";
                                lblFeedbackMessage.CssClass = "alert alert-success";
                                lblFeedbackMessage.Visible = true;
                            }
                            else
                            {
                                lblFeedbackMessage.Text = "Failed to delete aircraft listing.";
                                lblFeedbackMessage.CssClass = "alert alert-danger";
                                lblFeedbackMessage.Visible = true;
                            }
                        }
                        conn.Close();
                    }

                    LoadAircraftListings();
                    LoadQuickStats();
                }
                catch (Exception ex)
                {
                    lblFeedbackMessage.Text = "Error deleting aircraft listing: " + ex.Message;
                    lblFeedbackMessage.CssClass = "alert alert-danger";
                    lblFeedbackMessage.Visible = true;
                }
            }
        }
    }
}