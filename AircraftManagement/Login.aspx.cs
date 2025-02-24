using System;
using System.Data.SqlClient;
using System.Web.Security;
using System.Configuration;

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
                    string query = "SELECT Users, FullName, Email, Role, Password FROM Users WHERE LOWER(Email) = LOWER(@Email)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string storedPassword = reader["Password"].ToString();
                                if (storedPassword != password)
                                {
                                    lblError.Text = "❌ Invalid email or password.";
                                    return;
                                }
                                Session["Users"] = reader["Users"].ToString(); // User ID (using Users column)
                                Session["FullName"] = reader["FullName"] != DBNull.Value ? reader["FullName"].ToString() : "Unknown User"; // Default if null
                                Session["Email"] = reader["Email"].ToString();
                                Session["Role"] = reader["Role"] != DBNull.Value ? reader["Role"].ToString() : "Customer"; // Default if null
                                FormsAuthentication.SetAuthCookie(email, false);

                                // Enhanced Debug: Log raw database values and session data
                                System.Diagnostics.Debug.WriteLine("Login Data - Database Values: Users=" + reader["Users"].ToString() +
                                    ", FullName=" + (reader["FullName"] != DBNull.Value ? reader["FullName"].ToString() : "null") +
                                    ", Role=" + (reader["Role"] != DBNull.Value ? reader["Role"].ToString() : "null") +
                                    ", Email=" + reader["Email"].ToString());
                                System.Diagnostics.Debug.WriteLine("Session Data: Users=" + Session["Users"] +
                                    ", FullName=" + Session["FullName"] +
                                    ", Role=" + Session["Role"] +
                                    ", Email=" + Session["Email"]);

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