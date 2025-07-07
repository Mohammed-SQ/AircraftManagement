using System;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;
using System.Configuration;

namespace AircraftManagement
{
    public partial class AdminEditAircraft : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
        private int aircraftId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Role Check
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }

            // Validate AircraftID
            if (!int.TryParse(Request.QueryString["AircraftID"], out aircraftId))
            {
                lblFeedbackMessage.Text = "Invalid Aircraft ID.";
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
                return;
            }

            if (!IsPostBack)
            {
                // Generate and store Anti-CSRF token
                string token = Guid.NewGuid().ToString();
                Session["CsrfToken"] = token;
                hfAntiCsrfToken.Value = token;

                LoadAircraftDetails(aircraftId);
            }
        }

        private void LoadAircraftDetails(int aircraftId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT * FROM Aircraft WHERE AircraftID = @AircraftID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtModel.Text = reader["Model"].ToString();
                                txtCapacity.Text = reader["Capacity"].ToString();
                                txtRentalPrice.Text = reader["RentalPrice"].ToString();
                                txtPurchasePrice.Text = reader["PurchasePrice"].ToString();
                                ddlStatus.SelectedValue = reader["Status"].ToString();
                                txtImageUrl.Text = reader["ImageUrl"].ToString();

                                // Display current image if available
                                string imageUrl = reader["ImageUrl"].ToString();
                                if (!string.IsNullOrEmpty(imageUrl))
                                {
                                    imgAircraft.ImageUrl = imageUrl;
                                }
                                else
                                {
                                    imgAircraft.ImageUrl = "~/Images/placeholder-aircraft.jpg"; // Fallback image
                                }

                                lblFeedbackMessage.Text = "Aircraft loaded successfully!";
                                lblFeedbackMessage.CssClass = "alert alert-success";
                                lblFeedbackMessage.Visible = true;
                            }
                            else
                            {
                                lblFeedbackMessage.Text = "No aircraft found with the specified ID.";
                                lblFeedbackMessage.CssClass = "alert alert-danger";
                                lblFeedbackMessage.Visible = true;
                                BtnUpdate.Enabled = false;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error loading aircraft details: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
            }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            // Validate Anti-CSRF token
            if (hfAntiCsrfToken.Value != Session["CsrfToken"]?.ToString())
            {
                lblFeedbackMessage.Text = "Security error: Invalid CSRF token.";
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
                return;
            }

            try
            {
                // Validate numeric inputs
                int capacity;
                decimal rentalPrice, purchasePrice;
                if (!int.TryParse(txtCapacity.Text, out capacity) ||
                    !decimal.TryParse(txtRentalPrice.Text, out rentalPrice) ||
                    !decimal.TryParse(txtPurchasePrice.Text, out purchasePrice))
                {
                    lblFeedbackMessage.Text = "Please enter valid numeric values for capacity and prices.";
                    lblFeedbackMessage.CssClass = "alert alert-danger";
                    lblFeedbackMessage.Visible = true;
                    return;
                }

                string model = txtModel.Text.Trim();
                string status = ddlStatus.SelectedValue;
                string imageUrl = txtImageUrl.Text.Trim();

                // Handle image upload
                if (fileUpload.HasFile)
                {
                    string uploadFolder = Server.MapPath("~/Uploads/Aircrafts/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    string fileExtension = Path.GetExtension(fileUpload.FileName).ToLower();
                    string[] allowedExtensions = new string[] { ".jpg", ".jpeg", ".png" }; // Explicit array initialization

                    if (Array.Exists(allowedExtensions, ext => ext == fileExtension))
                    {
                        string fileName = Guid.NewGuid() + fileExtension;
                        string fullPath = Path.Combine(uploadFolder, fileName);
                        fileUpload.SaveAs(fullPath);
                        imageUrl = "/Uploads/Aircrafts/" + fileName;
                    }
                    else
                    {
                        lblFeedbackMessage.Text = "Invalid file format. Only JPG and PNG are allowed.";
                        lblFeedbackMessage.CssClass = "alert alert-danger";
                        lblFeedbackMessage.Visible = true;
                        return;
                    }
                }

                // Update the aircraft in the database
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if aircraft exists
                    string checkQuery = "SELECT COUNT(*) FROM Aircraft WHERE AircraftID = @AircraftID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                        int exists = (int)checkCmd.ExecuteScalar();
                        if (exists == 0)
                        {
                            lblFeedbackMessage.Text = "Update failed. No matching aircraft found.";
                            lblFeedbackMessage.CssClass = "alert alert-danger";
                            lblFeedbackMessage.Visible = true;
                            return;
                        }
                    }

                    string query = @"
                        UPDATE Aircraft 
                        SET Model = @Model, Capacity = @Capacity, RentalPrice = @RentalPrice, 
                            PurchasePrice = @PurchasePrice, Status = @Status, ImageUrl = @ImageUrl
                        WHERE AircraftID = @AircraftID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Model", model);
                        cmd.Parameters.AddWithValue("@Capacity", capacity);
                        cmd.Parameters.AddWithValue("@RentalPrice", rentalPrice);
                        cmd.Parameters.AddWithValue("@PurchasePrice", purchasePrice);
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@ImageUrl", imageUrl);
                        cmd.Parameters.AddWithValue("@AircraftID", aircraftId);

                        int rowsAffected = cmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            lblFeedbackMessage.Text = "Aircraft updated successfully!";
                            lblFeedbackMessage.CssClass = "alert alert-success";
                            lblFeedbackMessage.Visible = true;
                        }
                        else
                        {
                            lblFeedbackMessage.Text = "Update failed. No changes were made.";
                            lblFeedbackMessage.CssClass = "alert alert-warning";
                            lblFeedbackMessage.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error updating aircraft: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        protected void cvFileUpload_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (fileUpload.HasFile)
            {
                int maxSize = 5 * 1024 * 1024; // 5MB in bytes
                args.IsValid = fileUpload.PostedFile.ContentLength <= maxSize;
            }
            else
            {
                args.IsValid = true; // No file uploaded, validation passes
            }
        }
    }
}