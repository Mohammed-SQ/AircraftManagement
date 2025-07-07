using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace AircraftManagement
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected string SellerRole { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        // Fetch SellerRole for the user
                        if (Session["UserID"] != null)
                        {
                            string userId = Session["UserID"].ToString();
                            string roleQuery = "SELECT SellerRole FROM Users WHERE UserID = @UserID";
                            using (SqlCommand cmd = new SqlCommand(roleQuery, conn))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                object result = cmd.ExecuteScalar();
                                SellerRole = result != null ? result.ToString() : null;
                            }
                        }

                        // Load unclaimed regular promotions into the banner
                        string query;
                        if (Session["UserID"] != null && Session["Username"] != null && Session["Username"].ToString() != "Guest")
                        {
                            string userId = Session["UserID"].ToString();
                            query = "SELECT PromotionID, Title, Description, ExpiryDate " +
                                    "FROM Promotions " +
                                    "WHERE ExpiryDate > GETDATE() " +
                                    "AND PromotionType = 'Regular' " +
                                    "AND NOT EXISTS (SELECT 1 FROM UserPromotions WHERE UserPromotions.PromotionID = Promotions.PromotionID AND UserPromotions.UserID = @UserID)";
                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                using (SqlDataReader reader = cmd.ExecuteReader())
                                {
                                    rptPromotions.DataSource = reader;
                                    rptPromotions.DataBind();
                                }
                            }

                            // Load claimed offers (including loyalty rewards) into the notification box
                            query = "SELECT p.PromotionID, p.Title, p.Description, p.ExpiryDate, up.ClaimedDate " +
                                    "FROM Promotions p " +
                                    "INNER JOIN UserPromotions up ON p.PromotionID = up.PromotionID " +
                                    "WHERE up.UserID = @UserID AND p.ExpiryDate > GETDATE() AND up.ClaimedDate >= DATEADD(DAY, -30, GETDATE()) " +
                                    "ORDER BY up.ClaimedDate DESC";
                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userId);
                                using (SqlDataReader reader = cmd.ExecuteReader())
                                {
                                    DataTable dt = new DataTable();
                                    dt.Load(reader);
                                    rptNotificationsAdmin.DataSource = dt;
                                    rptNotificationsAdmin.DataBind();
                                    rptNotificationsUser.DataSource = dt;
                                    rptNotificationsUser.DataBind();
                                }
                            }
                        }
                        else
                        {
                            query = "SELECT PromotionID, Title, Description, ExpiryDate " +
                                    "FROM Promotions " +
                                    "WHERE ExpiryDate > GETDATE() " +
                                    "AND PromotionType = 'Regular'";
                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                using (SqlDataReader reader = cmd.ExecuteReader())
                                {
                                    rptPromotions.DataSource = reader;
                                    rptPromotions.DataBind();
                                }
                            }
                        }
                    }
                }
                catch (SqlException ex)
                {
                    System.Diagnostics.Debug.WriteLine("SQL Error: " + ex.Message);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
                }

                if (Session["Username"] == null)
                {
                    Session["Username"] = "Guest";
                    Session["Role"] = "Guest";
                }
            }
        }
    }
}