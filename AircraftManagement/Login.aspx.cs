using System;
using System.Data.SqlClient;
using System.Web.Security;
using System.Configuration; // Required to read from Web.config

namespace AircraftManagement
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblError.Text = "⚠️ Email and password are required.";
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = "SELECT UserID, FullName, Email, Role, Password FROM Users WHERE LOWER(Email) = LOWER(@Email)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string storedPassword = reader["Password"].ToString();

                                if (storedPassword != password)  // Consider using hashed password verification
                                {
                                    lblError.Text = "❌ Invalid email or password.";
                                    return;
                                }

                                Session["UserID"] = reader["UserID"].ToString();
                                Session["FullName"] = reader["FullName"].ToString();
                                Session["Email"] = reader["Email"].ToString();
                                Session["Role"] = reader["Role"].ToString();

                                FormsAuthentication.SetAuthCookie(email, false);

                                if (Session["Role"].ToString() == "Admin")
                                {
                                    Response.Redirect("AdminDashboard.aspx");
                                }
                                else
                                {
                                    Response.Redirect("Aircrafts.aspx");
                                }
                            }
                            else
                            {
                                lblError.Text = "❌ Invalid email or password.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "⚠️ Error: " + ex.Message;
            }
        }
    }
}
