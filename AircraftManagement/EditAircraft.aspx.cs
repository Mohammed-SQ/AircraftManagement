using System;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;
using System.Configuration; // Required to read from Web.config

namespace AircraftManagement
{
    public partial class EditAircraft : System.Web.UI.Page
    {
        protected Label lblError;
        protected TextBox txtModel;
        protected TextBox txtCapacity;
        protected TextBox txtRentalPrice;
        protected TextBox txtPurchasePrice;
        protected DropDownList ddlStatus;
        protected TextBox txtImageUrl;
        protected FileUpload fileUpload;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["AircraftID"] != null)
                {
                    if (int.TryParse(Request.QueryString["AircraftID"], out int aircraftId))
                    {
                        lblError.Text = "🔍 Debug: Aircraft ID Retrieved = " + aircraftId.ToString();
                        LoadAircraftDetails(aircraftId);
                    }
                    else
                    {
                        lblError.Text = "❌ Invalid Aircraft ID format.";
                    }
                }
                else
                {
                    lblError.Text = "❌ Aircraft ID is missing in the URL.";
                }
            }
        }

        private void LoadAircraftDetails(int aircraftId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Aircraft WHERE AircraftID = @AircraftID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AircraftID", aircraftId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtModel.Text = reader["Model"].ToString();
                    txtCapacity.Text = reader["Capacity"].ToString();
                    txtRentalPrice.Text = reader["RentalPrice"].ToString();
                    txtPurchasePrice.Text = reader["PurchasePrice"].ToString();
                    ddlStatus.SelectedValue = reader["Status"].ToString();
                    txtImageUrl.Text = reader["ImageUrl"].ToString();

                    lblError.Text = "<span style='color:green;'>Aircraft Loaded Successfully!</span>";
                }
                else
                {
                    lblError.Text = "<span style='color:red;'>❌ Debug: No record found for AircraftID = " + aircraftId + "</span>";
                }
            }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["AircraftID"], out int aircraftId))
            {
                lblError.Text = "❌ Invalid Aircraft ID.";
                return;
            }

            string model = txtModel.Text.Trim();
            if (!int.TryParse(txtCapacity.Text, out int capacity) ||
                !decimal.TryParse(txtRentalPrice.Text, out decimal rentalPrice) ||
                !decimal.TryParse(txtPurchasePrice.Text, out decimal purchasePrice))
            {
                lblError.Text = "❌ Please enter valid values for all fields.";
                return;
            }

            string status = ddlStatus.SelectedValue;
            string imageUrl = txtImageUrl.Text.Trim();

            if (rentalPrice > 9999999.99m || purchasePrice > 9999999.99m)
            {
                lblError.Text = "❌ Error: Price values exceed allowed range (Max: 9,999,999.99).";
                return;
            }

            try
            {
                if (fileUpload.HasFile)
                {
                    string uploadFolder = Server.MapPath("~/uploads/aircrafts/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    string fileExtension = Path.GetExtension(fileUpload.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };

                    if (Array.Exists(allowedExtensions, ext => ext == fileExtension))
                    {
                        string fileName = Guid.NewGuid() + fileExtension;
                        string fullPath = Path.Combine(uploadFolder, fileName);
                        fileUpload.SaveAs(fullPath);

                        imageUrl = "/uploads/aircrafts/" + fileName;
                    }
                    else
                    {
                        lblError.Text = "❌ Invalid file format. Only JPG, JPEG, PNG, and GIF are allowed.";
                        return;
                    }
                }

                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string checkQuery = "SELECT COUNT(*) FROM Aircraft WHERE AircraftID = @AircraftID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                        int exists = (int)checkCmd.ExecuteScalar();

                        if (exists == 0)
                        {
                            lblError.Text = "❌ Update failed. No matching Aircraft found.";
                            return;
                        }
                    }

                    string query = @"
                    UPDATE Aircraft 
                    SET Model = @Model, Capacity = @Capacity, RentalPrice = @RentalPrice, 
                        PurchasePrice = @PurchasePrice, Status = @Status, ImageURL = @ImageUrl
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
                            Response.Redirect("AdminDashboard.aspx?msg=AircraftUpdated");
                        }
                        else
                        {
                            lblError.Text = "❌ Update failed. No rows affected.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "❌ An error occurred: " + ex.Message;
            }
        }
    }
}
