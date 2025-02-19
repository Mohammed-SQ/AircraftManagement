using System;
using System.Data.SqlClient;
using System.Configuration;  

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
            if (string.IsNullOrEmpty(txtModel.Text) ||
                string.IsNullOrEmpty(txtCapacity.Text) ||
                string.IsNullOrEmpty(txtRentalPrice.Text) ||
                string.IsNullOrEmpty(txtPurchasePrice.Text) ||
                string.IsNullOrEmpty(txtManufacturer.Text) ||
                string.IsNullOrEmpty(txtYearManufactured.Text) ||
                string.IsNullOrEmpty(txtDescription.Text) ||
                string.IsNullOrEmpty(txtImageURL.Text))
            {
                lblError.Text = "⚠️ All fields are required.";
                return;
            }

            try
            {
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
                        cmd.Parameters.AddWithValue("@ImageURL", txtImageURL.Text);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    Response.Redirect("AdminDashboard.aspx");
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "❌ Error: " + ex.Message;
            }
        }
    }
}
