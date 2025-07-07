using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Security : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Load2FASettings();
                LoadAuditLog();
                LogAction("Visited Security Page");
            }
        }

        private void Load2FASettings()
        {
            if (Session["UserID"] != null)
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    SqlCommand cmd = new SqlCommand("SELECT Is2FAEnabled, PreferredMethod FROM SecuritySettings WHERE UserID = @UserID", conn);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        chk2FA.Checked = Convert.ToBoolean(reader["Is2FAEnabled"]);
                        ddl2FAMethod.SelectedValue = reader["PreferredMethod"].ToString();
                    }
                    conn.Close();
                }
            }
        }

        private void LoadAuditLog()
        {
            if (Session["UserID"] != null)
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    SqlCommand cmd = new SqlCommand("SELECT Action, Timestamp FROM AuditLog WHERE UserID = @UserID ORDER BY Timestamp DESC", conn);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    conn.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    gvAuditLog.DataSource = dt;
                    gvAuditLog.DataBind();
                    conn.Close();
                }
            }
        }

        protected void btnSave2FA_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] != null && !string.IsNullOrEmpty(ddl2FAMethod.SelectedValue))
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO SecuritySettings (UserID, Is2FAEnabled, PreferredMethod) VALUES (@UserID, @Is2FAEnabled, @PreferredMethod) ON DUPLICATE KEY UPDATE Is2FAEnabled = @Is2FAEnabled, PreferredMethod = @PreferredMethod", conn);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@Is2FAEnabled", chk2FA.Checked);
                    cmd.Parameters.AddWithValue("@PreferredMethod", ddl2FAMethod.SelectedValue);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
                Response.Write("<script>alert('2FA Settings Updated! 🔐');</script>");
                LogAction("Updated 2FA Settings");
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                Response.Write("<script>alert('Passwords do not match! ⚠️');</script>");
                return;
            }

            if (Session["UserID"] != null)
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    // Verify current password (simplified, assumes password is stored in Users table)
                    SqlCommand cmd = new SqlCommand("SELECT Password FROM Users WHERE UserID = @UserID", conn);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    conn.Open();
                    string currentPassword = cmd.ExecuteScalar()?.ToString();
                    if (currentPassword != txtCurrentPassword.Text) // In production, use hashed passwords
                    {
                        Response.Write("<script>alert('Current password incorrect! ⚠️');</script>");
                        conn.Close();
                        return;
                    }

                    // Update password
                    cmd = new SqlCommand("UPDATE Users SET Password = @NewPassword WHERE UserID = @UserID", conn);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@NewPassword", txtNewPassword.Text);
                    cmd.ExecuteNonQuery();

                    // Log old password
                    cmd = new SqlCommand("INSERT INTO PasswordHistory (UserID, OldPassword, ChangeDate) VALUES (@UserID, @OldPassword, @ChangeDate)", conn);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@OldPassword", currentPassword);
                    cmd.Parameters.AddWithValue("@ChangeDate", DateTime.Now);
                    cmd.ExecuteNonQuery();

                    conn.Close();
                }
                Response.Write("<script>alert('Password Changed! 🔒');</script>");
                LogAction("Changed Password");
            }
        }

        private void LogAction(string action)
        {
            if (Session["UserID"] != null)
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO AuditLog (UserID, Action, Timestamp) VALUES (@UserID, @Action, @Timestamp)", conn);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@Action", action);
                    cmd.Parameters.AddWithValue("@Timestamp", DateTime.Now);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }
    }
}