using System;
using System.Data.SqlClient;
using System.Configuration;

namespace AircraftManagement
{
    public partial class EditUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["UserID"] == null)
                {
                    lblError.Text = "Invalid User ID.";
                    return;
                }

                int userId;
                if (int.TryParse(Request.QueryString["UserID"], out userId))
                {
                    LoadUserDetails(userId);
                }
                else
                {
                    lblError.Text = "Invalid User ID format.";
                }
            }
        }

        private void LoadUserDetails(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Username, Email, Role FROM Users WHERE UserID = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtFullName.Text = reader["Username"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    ddlRole.SelectedValue = reader["Role"].ToString();
                }
                else
                {
                    lblError.Text = "User not found.";
                }
            }
        }

        protected void btnUpdateUser_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["UserID"] == null)
            {
                lblError.Text = "Invalid User ID.";
                return;
            }

            int userId;
            if (!int.TryParse(Request.QueryString["UserID"], out userId))
            {
                lblError.Text = "Invalid User ID format.";
                return;
            }

            string username = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string role = ddlRole.SelectedValue;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email))
            {
                lblError.Text = "All fields are required.";
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Users SET Username = @Username, Email = @Email, Role = @Role WHERE UserID = @UserID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        Response.Redirect("AdminDashboard.aspx");
                    }
                    else
                    {
                        lblError.Text = "Update failed. User not found.";
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "An error occurred: " + ex.Message;
            }
        }
    }
}