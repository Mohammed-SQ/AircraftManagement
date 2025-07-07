using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Text;

namespace AircraftManagement
{
    public partial class Maintenance : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                CheckEligibility();
                LoadAircrafts();
                LoadScheduledTasks();
                LoadServiceHistory();
            }
        }

        private void CheckEligibility()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if the user has any bookings (pending or confirmed)
                    string bookingQuery = @"
                        SELECT COUNT(*) 
                        FROM Bookings 
                        WHERE UserID = @UserID 
                        AND BookingStatus IN ('Pending', 'Confirmed')";
                    using (SqlCommand cmd = new SqlCommand(bookingQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        int bookingCount = (int)cmd.ExecuteScalar();

                        // Check for free maintenance offers in UserPromotions and Promotions
                        string freeMaintenanceQuery = @"
                            SELECT COUNT(*) 
                            FROM UserPromotions up
                            INNER JOIN Promotions p ON up.PromotionID = p.PromotionID
                            WHERE up.UserID = @UserID 
                            AND p.PromotionType = 'LoyaltyReward' 
                            AND p.Title LIKE '%Maintenance%'
                            AND p.ExpiryDate > GETDATE()
                            AND NOT EXISTS (
                                SELECT 1 
                                FROM Maintenance m 
                                WHERE m.UserID = @UserID 
                                AND m.Cost = 0 
                                AND m.MaintenanceType = p.Title
                            )";
                        cmd.CommandText = freeMaintenanceQuery;
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        int freeMaintenanceOffers = (int)cmd.ExecuteScalar();

                        // Check how many free maintenances have already been used
                        string usedFreeMaintenanceQuery = @"
                            SELECT COUNT(*) 
                            FROM Maintenance 
                            WHERE UserID = @UserID 
                            AND Cost = 0";
                        cmd.CommandText = usedFreeMaintenanceQuery;
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        int usedFreeMaintenances = (int)cmd.ExecuteScalar();

                        // Determine eligibility for free maintenance
                        bool isEligibleForFree = freeMaintenanceOffers > 0 && usedFreeMaintenances == 0;
                        hdnIsFree.Value = isEligibleForFree.ToString().ToLower();
                        lblEligibilityMessage.Visible = true;

                        if (isEligibleForFree)
                        {
                            lblEligibilityMessage.Text = "Congratulations! You have a free maintenance offer available.";
                            lblEligibilityMessage.CssClass = "alert alert-success text-center";
                            lblCostMessage.Text = "This maintenance service is free!";
                            lblCostMessage.Visible = true;
                        }
                        else if (bookingCount > 0)
                        {
                            lblEligibilityMessage.Text = "You are not eligible for free maintenance. Standard rates will apply.";
                            lblEligibilityMessage.CssClass = "alert alert-warning text-center";
                            lblCostMessage.Text = "Estimated cost will be calculated after submission.";
                            lblCostMessage.Visible = true;
                        }
                        else
                        {
                            lblEligibilityMessage.Text = "You need to have at least one booking to request maintenance.";
                            lblEligibilityMessage.CssClass = "alert alert-warning text-center";
                            maintenanceOptions.Visible = false;
                            return;
                        }

                        maintenanceOptions.Visible = bookingCount > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                lblEligibilityMessage.Text = "Error checking eligibility: " + ex.Message;
                lblEligibilityMessage.CssClass = "alert alert-danger text-center";
                lblEligibilityMessage.Visible = true;
            }
        }

        private void LoadAircrafts()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT DISTINCT a.AircraftID, a.Model 
                        FROM Aircraft a
                        INNER JOIN Bookings b ON a.AircraftID = b.AircraftID
                        WHERE b.UserID = @UserID 
                        AND b.BookingStatus IN ('Pending', 'Confirmed')";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            ddlAircrafts.DataSource = dt;
                            ddlAircrafts.DataTextField = "Model";
                            ddlAircrafts.DataValueField = "AircraftID";
                            ddlAircrafts.DataBind();
                            ddlAircrafts.Items.Insert(0, new ListItem("Select an Aircraft", ""));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblEligibilityMessage.Text = "Error loading aircrafts: " + ex.Message;
                lblEligibilityMessage.CssClass = "alert alert-danger text-center";
                lblEligibilityMessage.Visible = true;
            }
        }

        private void LoadScheduledTasks()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT m.MaintenanceID, a.Model as AircraftModel, m.MaintenanceType, 
                               m.PartsRepaired, m.AdditionalOptions, m.Description, 
                               m.ScheduledDate, m.Status, m.Cost
                        FROM Maintenance m
                        INNER JOIN Aircraft a ON m.AircraftID = a.AircraftID
                        WHERE m.UserID = @UserID
                        AND (m.Status = 'Pending' OR m.Status = 'In Progress')";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        conn.Open();
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            gvScheduledTasks.DataSource = dt;
                            gvScheduledTasks.DataBind();
                        }
                        conn.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                lblEligibilityMessage.Text = "Error loading scheduled tasks: " + ex.Message;
                lblEligibilityMessage.CssClass = "alert alert-danger text-center";
                lblEligibilityMessage.Visible = true;
            }
        }

        private void LoadServiceHistory()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT m.MaintenanceID, m.MaintenanceType, m.PartsRepaired, 
                               m.AdditionalOptions, m.CompletedDate, m.Cost, m.Rating
                        FROM Maintenance m
                        WHERE m.UserID = @UserID
                        AND m.Status = 'Completed'
                        AND m.CompletedDate IS NOT NULL";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        conn.Open();
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            gvServiceHistory.DataSource = dt;
                            gvServiceHistory.DataBind();
                        }
                        conn.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                lblEligibilityMessage.Text = "Error loading service history: " + ex.Message;
                lblEligibilityMessage.CssClass = "alert alert-danger text-center";
                lblEligibilityMessage.Visible = true;
            }
        }

        protected void btnSubmitRequest_Click(object sender, EventArgs e)
        {
            try
            {
                // Build the list of parts to repair
                StringBuilder partsRepaired = new StringBuilder();
                if (chkEngine.Checked) partsRepaired.Append("Engine, ");
                if (chkWings.Checked) partsRepaired.Append("Wings, ");
                if (chkAvionics.Checked) partsRepaired.Append("Avionics, ");
                if (chkLandingGear.Checked) partsRepaired.Append("Landing Gear, ");
                if (chkFuselage.Checked) partsRepaired.Append("Fuselage, ");
                string partsRepairedStr = partsRepaired.ToString().TrimEnd(',', ' ');

                // Build the list of additional options
                StringBuilder additionalOptions = new StringBuilder();
                if (chkPriorityService.Checked) additionalOptions.Append("Priority Service, ");
                if (chkExtendedWarranty.Checked) additionalOptions.Append("Extended Warranty, ");
                if (chkDetailedReport.Checked) additionalOptions.Append("Detailed Report, ");
                string additionalOptionsStr = additionalOptions.ToString().TrimEnd(',', ' ');

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Maintenance (UserID, AircraftID, MaintenanceType, PartsRepaired, AdditionalOptions, Description, ScheduledDate, Cost, Status, CreatedAt)
                        VALUES (@UserID, @AircraftID, @MaintenanceType, @PartsRepaired, @AdditionalOptions, @Description, @ScheduledDate, @Cost, 'Pending', GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        cmd.Parameters.AddWithValue("@AircraftID", ddlAircrafts.SelectedValue);
                        cmd.Parameters.AddWithValue("@MaintenanceType", txtMaintenanceType.Text);
                        cmd.Parameters.AddWithValue("@PartsRepaired", partsRepairedStr);
                        cmd.Parameters.AddWithValue("@AdditionalOptions", additionalOptionsStr);
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                        cmd.Parameters.AddWithValue("@ScheduledDate", Convert.ToDateTime(txtScheduledDate.Text));
                        decimal cost = CalculateCost(txtMaintenanceType.Text, chkPriorityService.Checked, chkExtendedWarranty.Checked, chkDetailedReport.Checked);
                        if (bool.Parse(hdnIsFree.Value)) cost = 0;
                        cmd.Parameters.AddWithValue("@Cost", cost);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }
                LoadScheduledTasks();
                lblEligibilityMessage.Text = "Maintenance request submitted successfully!";
                lblEligibilityMessage.CssClass = "alert alert-success text-center";
                lblEligibilityMessage.Visible = true;

                // If this was a free maintenance, mark it as used by updating the logic
                if (bool.Parse(hdnIsFree.Value))
                {
                    CheckEligibility(); // Re-check eligibility to update the UI
                }
            }
            catch (Exception ex)
            {
                lblEligibilityMessage.Text = "Error submitting request: " + ex.Message;
                lblEligibilityMessage.CssClass = "alert alert-danger text-center";
                lblEligibilityMessage.Visible = true;
            }
        }

        protected void gvScheduledTasks_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            int maintenanceId = Convert.ToInt32(gvScheduledTasks.DataKeys[index].Value);

            if (e.CommandName == "ViewDetails")
            {
                Response.Redirect("MaintenanceDetails.aspx?MaintenanceID=" + maintenanceId);
            }
            else if (e.CommandName == "CancelRequest")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        string query = "UPDATE Maintenance SET Status = 'Cancelled' WHERE MaintenanceID = @MaintenanceID AND Status = 'Pending'";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaintenanceID", maintenanceId);
                            conn.Open();
                            int rowsAffected = cmd.ExecuteNonQuery();
                            conn.Close();

                            if (rowsAffected > 0)
                            {
                                lblEligibilityMessage.Text = "Maintenance request cancelled successfully.";
                                lblEligibilityMessage.CssClass = "alert alert-success text-center";
                            }
                            else
                            {
                                lblEligibilityMessage.Text = "Unable to cancel request. It may no longer be pending.";
                                lblEligibilityMessage.CssClass = "alert alert-warning text-center";
                            }
                            lblEligibilityMessage.Visible = true;
                        }
                    }
                    LoadScheduledTasks();
                }
                catch (Exception ex)
                {
                    lblEligibilityMessage.Text = "Error cancelling request: " + ex.Message;
                    lblEligibilityMessage.CssClass = "alert alert-danger text-center";
                    lblEligibilityMessage.Visible = true;
                }
            }
        }

        protected void gvServiceHistory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DropDownList ddlRating = (DropDownList)e.Row.FindControl("ddlRating");
                Label lblRating = (Label)e.Row.FindControl("lblRating");
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                object rating = rowView["Rating"];

                if (rating != DBNull.Value && rating != null)
                {
                    ddlRating.Visible = false;
                    lblRating.Visible = true;
                    lblRating.Text = rating.ToString() + " / 5";
                }
                else
                {
                    ddlRating.Visible = true;
                    lblRating.Visible = false;
                }
            }
        }

        protected void ddlRating_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlRating = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddlRating.NamingContainer;
            int maintenanceId = Convert.ToInt32(gvServiceHistory.DataKeys[row.RowIndex].Value);
            int rating;

            if (!int.TryParse(ddlRating.SelectedValue, out rating) || string.IsNullOrEmpty(ddlRating.SelectedValue))
            {
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Maintenance SET Rating = @Rating WHERE MaintenanceID = @MaintenanceID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Rating", rating);
                        cmd.Parameters.AddWithValue("@MaintenanceID", maintenanceId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }
                LoadServiceHistory();
                lblEligibilityMessage.Text = "Thank you for your feedback!";
                lblEligibilityMessage.CssClass = "alert alert-success text-center";
                lblEligibilityMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblEligibilityMessage.Text = "Error submitting rating: " + ex.Message;
                lblEligibilityMessage.CssClass = "alert alert-danger text-center";
                lblEligibilityMessage.Visible = true;
            }
        }

        private decimal CalculateCost(string maintenanceType, bool priorityService, bool extendedWarranty, bool detailedReport)
        {
            decimal baseCost = 0;
            switch (maintenanceType)
            {
                case "Heavy Maintenance": baseCost = 15000.00m; break;
                case "Shop/Component Maintenance": baseCost = 8000.00m; break;
                case "Consistent Oil Changes": baseCost = 500.00m; break;
                case "Failure Rectification": baseCost = 3000.00m; break;
                case "Avionics Upgrade": baseCost = 12000.00m; break;
                case "Engine Overhaul": baseCost = 20000.00m; break;
                case "Paint Refinishing": baseCost = 10000.00m; break;
                case "Interior Refurbishment": baseCost = 9000.00m; break;
                default: baseCost = 5000.00m; break;
            }

            // Add costs for additional options
            if (priorityService) baseCost += 2000.00m;
            if (extendedWarranty) baseCost += 1500.00m;
            if (detailedReport) baseCost += 500.00m;

            return baseCost;
        }
    }
}