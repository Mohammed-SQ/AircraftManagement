using System;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

namespace AircraftManagement
{
    public partial class AddAircraft : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void BtnAddAircraft_Click(object sender, EventArgs e)
        {
            // Validate all text fields
            if (string.IsNullOrEmpty(txtModel.Text) ||
                string.IsNullOrEmpty(txtCapacity.Text) ||
                string.IsNullOrEmpty(txtRentalPrice.Text) ||
                string.IsNullOrEmpty(txtPurchasePrice.Text) ||
                string.IsNullOrEmpty(txtManufacturer.Text) ||
                string.IsNullOrEmpty(txtYearManufactured.Text) ||
                string.IsNullOrEmpty(txtDescription.Text))
            {
                lblError.Text = "⚠️ All text fields are required.";
                return;
            }

            // Validate the file upload
            if (!fileUpload.HasFile)
            {
                lblError.Text = "⚠️ Please upload an image.";
                return;
            }

            // Validate file type (optional: restrict to image files)
            string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
            string fileExtension = Path.GetExtension(fileUpload.FileName).ToLower();
            if (!Array.Exists(allowedExtensions, ext => ext == fileExtension))
            {
                lblError.Text = "⚠️ Only image files (.jpg, .jpeg, .png, .gif) are allowed.";
                return;
            }

            try
            {
                // Save the uploaded image to the server
                string uploadFolder = Server.MapPath("~/Images/Aircraft/");
                if (!Directory.Exists(uploadFolder))
                {
                    Directory.CreateDirectory(uploadFolder);
                }

                string fileName = Guid.NewGuid().ToString() + fileExtension; // Use a unique file name to avoid conflicts
                string filePath = Path.Combine(uploadFolder, fileName);
                fileUpload.SaveAs(filePath);

                // Get the relative path to store in the database
                string imageUrl = "~/Images/Aircraft/" + fileName;

                // Save the aircraft details to the database
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Aircraft (Model, Capacity, RentalPrice, PurchasePrice, Status, Manufacturer, YearManufactured, Description, ImageURL, CreatedAt) 
                        VALUES (@Model, @Capacity, @RentalPrice, @PurchasePrice, @Status, @Manufacturer, @YearManufactured, @Description, @ImageURL, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Model", txtModel.Text);
                        cmd.Parameters.AddWithValue("@Capacity", Convert.ToInt32(txtCapacity.Text));
                        cmd.Parameters.AddWithValue("@RentalPrice", Convert.ToDecimal(txtRentalPrice.Text));
                        cmd.Parameters.AddWithValue("@PurchasePrice", Convert.ToDecimal(txtPurchasePrice.Text));
                        cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                        cmd.Parameters.AddWithValue("@Manufacturer", txtManufacturer.Text);
                        cmd.Parameters.AddWithValue("@YearManufactured", txtYearManufactured.Text);
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                        cmd.Parameters.AddWithValue("@ImageURL", imageUrl); // Use the saved image path

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Redirect to the admin dashboard on success
                Response.Redirect("AdminDashboard.aspx");
            }
            catch (Exception ex)
            {
                lblError.Text = "❌ Error: " + ex.Message;
            }
        }
    }
}