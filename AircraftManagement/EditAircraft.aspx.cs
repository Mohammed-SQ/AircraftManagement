using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class EditAircraft : System.Web.UI.Page
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
                string aircraftId = Request.QueryString["AircraftID"];
                if (string.IsNullOrEmpty(aircraftId))
                {
                    lblFeedbackMessage.Text = "Invalid Aircraft ID.";
                    lblFeedbackMessage.CssClass = "alert alert-danger";
                    lblFeedbackMessage.Visible = true;
                    return;
                }

                LoadAircraftDetails(aircraftId);
            }
        }

        private void LoadAircraftDetails(string aircraftId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT AircraftModel, YearManufactured, EngineHours, RegistrationNumber, Capacity, 
                               RentalPrice, PurchasePrice, Status, ImageURL, Manufacturer, 
                               FuelType, AircraftCondition
                        FROM Aircraft
                        WHERE AircraftID = @AircraftID AND SellerID = @SellerID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                        cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtModel.Text = reader["AircraftModel"].ToString();
                                txtYearManufactured.Text = reader["YearManufactured"].ToString();
                                txtEngineHours.Text = reader["EngineHours"].ToString();
                                txtRegistrationNumber.Text = reader["RegistrationNumber"].ToString();
                                txtCapacity.Text = reader["Capacity"].ToString();
                                txtRentalPrice.Text = reader["RentalPrice"].ToString();
                                txtPurchasePrice.Text = reader["PurchasePrice"].ToString();
                                ddlStatus.SelectedValue = reader["Status"].ToString();
                                txtImageURL.Text = reader["ImageURL"].ToString();
                                txtManufacturer.Text = reader["Manufacturer"].ToString();
                                txtFuelType.Text = reader["FuelType"].ToString();
                                txtAircraftCondition.Text = reader["AircraftCondition"].ToString();
                            }
                            else
                            {
                                lblFeedbackMessage.Text = "Aircraft not found or you do not have permission to edit it.";
                                lblFeedbackMessage.CssClass = "alert alert-danger";
                                lblFeedbackMessage.Visible = true;
                                btnSave.Visible = false;
                            }
                        }
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error loading aircraft details: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Validate required fields
            if (string.IsNullOrEmpty(txtModel.Text) ||
                string.IsNullOrEmpty(txtYearManufactured.Text) ||
                string.IsNullOrEmpty(txtEngineHours.Text) ||
                string.IsNullOrEmpty(txtRegistrationNumber.Text) ||
                string.IsNullOrEmpty(txtCapacity.Text) ||
                string.IsNullOrEmpty(txtRentalPrice.Text) ||
                string.IsNullOrEmpty(txtPurchasePrice.Text) ||
                string.IsNullOrEmpty(txtImageURL.Text) ||
                string.IsNullOrEmpty(txtManufacturer.Text) ||
                string.IsNullOrEmpty(txtFuelType.Text) ||
                string.IsNullOrEmpty(txtAircraftCondition.Text))
            {
                lblFeedbackMessage.Text = "All fields are required.";
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
                return;
            }

            string aircraftId = Request.QueryString["AircraftID"];
            if (string.IsNullOrEmpty(aircraftId))
            {
                lblFeedbackMessage.Text = "Invalid Aircraft ID.";
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string updateQuery = @"
                        UPDATE Aircraft
                        SET AircraftModel = @AircraftModel, 
                            YearManufactured = @YearManufactured, 
                            EngineHours = @EngineHours, 
                            RegistrationNumber = @RegistrationNumber,
                            Capacity = @Capacity,
                            RentalPrice = @RentalPrice,
                            PurchasePrice = @PurchasePrice,
                            Status = @Status,
                            ImageURL = @ImageURL,
                            Manufacturer = @Manufacturer,
                            FuelType = @FuelType,
                            AircraftCondition = @AircraftCondition
                        WHERE AircraftID = @AircraftID AND SellerID = @SellerID";
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@AircraftModel", txtModel.Text);
                        cmd.Parameters.AddWithValue("@YearManufactured", Convert.ToInt32(txtYearManufactured.Text));
                        cmd.Parameters.AddWithValue("@EngineHours", Convert.ToInt32(txtEngineHours.Text));
                        cmd.Parameters.AddWithValue("@RegistrationNumber", txtRegistrationNumber.Text);
                        cmd.Parameters.AddWithValue("@Capacity", Convert.ToInt32(txtCapacity.Text));
                        cmd.Parameters.AddWithValue("@RentalPrice", Convert.ToDecimal(txtRentalPrice.Text));
                        cmd.Parameters.AddWithValue("@PurchasePrice", Convert.ToDecimal(txtPurchasePrice.Text));
                        cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                        cmd.Parameters.AddWithValue("@ImageURL", txtImageURL.Text);
                        cmd.Parameters.AddWithValue("@Manufacturer", txtManufacturer.Text);
                        cmd.Parameters.AddWithValue("@FuelType", txtFuelType.Text);
                        cmd.Parameters.AddWithValue("@AircraftCondition", txtAircraftCondition.Text);
                        cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                        cmd.Parameters.AddWithValue("@SellerID", Session["UserID"].ToString());

                        int rowsAffected = cmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            lblFeedbackMessage.Text = "Aircraft details updated successfully!";
                            lblFeedbackMessage.CssClass = "alert alert-success";
                            lblFeedbackMessage.Visible = true;
                        }
                        else
                        {
                            lblFeedbackMessage.Text = "Failed to update aircraft details.";
                            lblFeedbackMessage.CssClass = "alert alert-danger";
                            lblFeedbackMessage.Visible = true;
                        }
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error updating aircraft details: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("SellerDashboard.aspx");
        }
    }
}