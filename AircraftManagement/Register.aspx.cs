using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Register : System.Web.UI.Page
    {
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        INSERT INTO Users (FullName, Email, Password, Role, PhoneNumber, Address, State, ZIP, CreatedAt)
                        VALUES (@FullName, @Email, @Password, @Role, @PhoneNumber, @Address, @State, @ZIP, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", txtFullName.Text);
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                        cmd.Parameters.AddWithValue("@Password", txtPassword.Text);
                        cmd.Parameters.AddWithValue("@Role", "Customer"); // Default role is "Customer"
                        cmd.Parameters.AddWithValue("@PhoneNumber", txtPhoneNumber.Text);
                        cmd.Parameters.AddWithValue("@Address", txtAddress.Text);
                        cmd.Parameters.AddWithValue("@State", ddlState.SelectedValue); // ✅ FIXED ERROR
                        cmd.Parameters.AddWithValue("@ZIP", txtZip.Text);
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