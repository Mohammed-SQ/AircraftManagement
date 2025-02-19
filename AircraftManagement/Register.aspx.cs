using System;
using System.Data.SqlClient;
using System.Configuration; // Required to read from Web.config

namespace AircraftManagement
{
    public partial class Register : System.Web.UI.Page
    {
        protected void BtnRegister_Click(object sender, EventArgs e)
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
                        cmd.Parameters.AddWithValue("@Password", txtPassword.Text); // Consider hashing the password
                        cmd.Parameters.AddWithValue("@Role", "Customer");
                        cmd.Parameters.AddWithValue("@PhoneNumber", txtPhoneNumber.Text);
                        cmd.Parameters.AddWithValue("@Address", txtAddress.Text);
                        cmd.Parameters.AddWithValue("@State", ddlState.SelectedValue);
                        cmd.Parameters.AddWithValue("@ZIP", txtZip.Text);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            lblMessage.Text = "✅ Registration successful!";
                            lblMessage.ForeColor = System.Drawing.Color.Green;
                        }
                        else
                        {
                            lblMessage.Text = "❌ Registration failed. Please try again.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "⚠️ Error: " + ex.Message;
            }
        }
    }
}
