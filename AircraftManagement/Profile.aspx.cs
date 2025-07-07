using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Profile : Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["Username"] == null || Session["Username"].ToString() == "Guest")
                {
                    Response.Redirect("Login.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // Check user role
                string userRole = Session["Role"] != null ? Session["Role"].ToString() : string.Empty;
                if (userRole != "Customer" && userRole != "Seller" && userRole != "Admin")
                {
                    Response.Redirect("AccessDenied.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                LoadProfileDetails();
                LoadReferralInfo();
                LoadAuditLogs();
                LoadSavedCards();
            }
        }

        private void LoadProfileDetails()
        {
            string username = Session["Username"] != null ? Session["Username"].ToString() : null;

            if (string.IsNullOrEmpty(username))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT Username, Email, PhoneNumber, DateOfBirth, Gender, Bio, Address, State, ZIP, ReferralCode, CreatedAt
                        FROM Users
                        WHERE Username = @Username";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        con.Open();

                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            lblUsername.Text = reader["Username"].ToString();
                            lblUsernameDetail.Text = reader["Username"].ToString();
                            lblEmail.Text = reader["Email"] != DBNull.Value ? reader["Email"].ToString() : "Not provided";
                            lblPhone.Text = reader["PhoneNumber"] != DBNull.Value ? reader["PhoneNumber"].ToString() : "Not provided";
                            lblDateOfBirth.Text = reader["DateOfBirth"] != DBNull.Value ? Convert.ToDateTime(reader["DateOfBirth"]).ToString("yyyy-MM-dd") : "Not provided";
                            lblGender.Text = reader["Gender"] != DBNull.Value ? reader["Gender"].ToString() : "Not provided";
                            lblBio.Text = reader["Bio"] != DBNull.Value ? reader["Bio"].ToString() : "Not provided";
                            lblAddress.Text = reader["Address"] != DBNull.Value ? reader["Address"].ToString() : "Not provided";
                            lblState.Text = reader["State"] != DBNull.Value ? reader["State"].ToString() : "Not provided";
                            lblZIP.Text = reader["ZIP"] != DBNull.Value ? reader["ZIP"].ToString() : "Not provided";
                            lblReferralCode.Text = reader["ReferralCode"] != DBNull.Value ? reader["ReferralCode"].ToString() : "Not provided";
                            lblJoinedDate.Text = reader["CreatedAt"] != DBNull.Value ? Convert.ToDateTime(reader["CreatedAt"]).ToString("yyyy-MM-dd") : "Not provided";
                        }

                        reader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadProfileDetails Exception: " + ex.Message);
                Response.Redirect("Error.aspx");
            }
        }

        private void LoadReferralInfo()
        {
            string username = Session["Username"] != null ? Session["Username"].ToString() : null;
            if (string.IsNullOrEmpty(username))
            {
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT u2.Username AS ReferredUser, r.ReferralDate, r.Status
                        FROM Referrals r
                        JOIN Users u1 ON r.ReferrerUserID = u1.UserID
                        JOIN Users u2 ON r.ReferredUserID = u2.UserID
                        WHERE u1.Username = @Username";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvReferralInfo.DataSource = dt;
                        gvReferralInfo.DataBind();
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadReferralInfo Exception: " + ex.Message);
            }
        }

        private void LoadAuditLogs()
        {
            string username = Session["Username"] != null ? Session["Username"].ToString() : null;
            if (string.IsNullOrEmpty(username))
            {
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 5 a.Action, a.Details, a.Timestamp
                        FROM AuditLogs a
                        JOIN Users u ON a.UserID = u.UserID
                        WHERE u.Username = @Username
                        ORDER BY a.Timestamp DESC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        con.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvAuditLogs.DataSource = dt;
                        gvAuditLogs.DataBind();
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadAuditLogs Exception: " + ex.Message);
            }
        }

        protected void btnEditProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditProfile.aspx");
        }

        private void LoadSavedCards()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            if (userId == 0)
            {
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                SELECT CardType, CardholderName, CardNumberLastFour, ExpiryMonth, ExpiryYear
                FROM SavedCards
                WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        conn.Open();

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvSavedCards.DataSource = dt;
                        gvSavedCards.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadSavedCards Exception: " + ex.Message);
            }
        }
    }
}
