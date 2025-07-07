using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Promotions : Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    LoadLoyaltyPoints();
                }

                if (Request.QueryString["PromotionID"] != null)
                {
                    int promotionId;
                    if (int.TryParse(Request.QueryString["PromotionID"], out promotionId))
                    {
                        ClaimPromotion(promotionId);
                    }
                }

                LoadClaimedOffers();
            }
        }

        private void LoadLoyaltyPoints()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Points, TotalPoints FROM Loyalty WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        int points = 0;
                        int totalPoints = 0;
                        if (reader.Read())
                        {
                            points = reader["Points"] != DBNull.Value ? Convert.ToInt32(reader["Points"]) : 0;
                            totalPoints = reader["TotalPoints"] != DBNull.Value ? Convert.ToInt32(reader["TotalPoints"]) : 0;
                        }

                        lblLoyaltyPoints.Text = points.ToString();

                        btnClaimMaintenance.Enabled = points >= 150;
                        btnClaimDiscount.Enabled = points >= 300;
                        btnClaimRent.Enabled = points >= 1000;

                        if (points >= 1000)
                        {
                            lblRewardMessage.Text = "You can claim 1 Day Free Aircraft Rent ✈️";
                            lblRewardMessage.Visible = true;
                        }
                        else if (points >= 300)
                        {
                            lblRewardMessage.Text = "You can claim a 30% Discount 💸";
                            lblRewardMessage.Visible = true;
                        }
                        else if (points >= 150)
                        {
                            lblRewardMessage.Text = "You can claim 1 Free Maintenance 🛠️";
                            lblRewardMessage.Visible = true;
                        }

                        string tier = "Pilot";
                        int progressMax = 1000;
                        int progressValue = Math.Min(totalPoints, progressMax);
                        double progressPercentage = (double)progressValue / progressMax * 100;

                        if (totalPoints >= 1000)
                        {
                            tier = "Ace";
                        }
                        else if (totalPoints >= 500)
                        {
                            tier = "Captain";
                        }

                        lblTier.Text = tier;
                        loyaltyProgressBar.Attributes["style"] = "width: " + progressPercentage.ToString() + "%;";
                        loyaltyProgressBar.Attributes["aria-valuenow"] = progressValue.ToString();
                    }
                }
            }
        }

        private bool IsLoyaltyBonusActive(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT COUNT(*) FROM Promotions p " +
                               "INNER JOIN UserPromotions up ON p.PromotionID = up.PromotionID " +
                               "WHERE up.UserID = @UserID AND p.Title = 'Loyalty Bonus' AND p.ExpiryDate > GETDATE()";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private void AwardPoints(int userId, int points)
        {
            bool doublePoints = IsLoyaltyBonusActive(userId);
            int finalPoints = doublePoints ? points * 2 : points;
            int currentPoints = 0;
            int totalPoints = 0;
            bool recordExists = false;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Points, TotalPoints FROM Loyalty WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            currentPoints = reader["Points"] != DBNull.Value ? Convert.ToInt32(reader["Points"]) : 0;
                            totalPoints = reader["TotalPoints"] != DBNull.Value ? Convert.ToInt32(reader["TotalPoints"]) : 0;
                            recordExists = true;
                        }
                    }
                }

                if (recordExists)
                {
                    string updateQuery = "UPDATE Loyalty SET Points = @Points, TotalPoints = @TotalPoints WHERE UserID = @UserID";
                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                    {
                        updateCmd.Parameters.AddWithValue("@UserID", userId);
                        updateCmd.Parameters.AddWithValue("@Points", currentPoints + finalPoints);
                        updateCmd.Parameters.AddWithValue("@TotalPoints", totalPoints + finalPoints);
                        updateCmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    string insertQuery = "INSERT INTO Loyalty (UserID, Points, TotalPoints) VALUES (@UserID, @Points, @TotalPoints)";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@UserID", userId);
                        insertCmd.Parameters.AddWithValue("@Points", finalPoints);
                        insertCmd.Parameters.AddWithValue("@TotalPoints", finalPoints);
                        insertCmd.ExecuteNonQuery();
                    }
                }
            }
        }

        private void DeductPoints(int userId, int pointsToDeduct)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string updateQuery = "UPDATE Loyalty SET Points = Points - @PointsToDeduct WHERE UserID = @UserID AND Points >= @PointsToDeduct";
                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@PointsToDeduct", pointsToDeduct);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void AddRewardPromotion(int userId, string title, string description)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                // Insert the reward as a new promotion with PromotionType = 'LoyaltyReward'
                string insertPromoQuery = "INSERT INTO Promotions (Title, Description, ExpiryDate, PromotionType) OUTPUT INSERTED.PromotionID " +
                                         "VALUES (@Title, @Description, DATEADD(MONTH, 1, GETDATE()), 'LoyaltyReward')";
                int promotionId;
                using (SqlCommand cmd = new SqlCommand(insertPromoQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    promotionId = (int)cmd.ExecuteScalar();
                }

                // Insert into UserPromotions
                string insertUserPromoQuery = "INSERT INTO UserPromotions (UserID, PromotionID, ClaimedDate) VALUES (@UserID, @PromotionID, GETDATE())";
                using (SqlCommand cmd = new SqlCommand(insertUserPromoQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@PromotionID", promotionId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnClaimMaintenance_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int pointsRequired = 150;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Points FROM Loyalty WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    object result = cmd.ExecuteScalar();
                    int points = result != null ? Convert.ToInt32(result) : 0;

                    if (points >= pointsRequired)
                    {
                        DeductPoints(userId, pointsRequired);
                        AddRewardPromotion(userId, "Cessna Skyhawk Maintenance", "Free maintenance for your Cessna Skyhawk aircraft 🛠️");
                        Response.Redirect("Promotions.aspx");
                    }
                    else
                    {
                        lblRewardMessage.Text = "⚠ Not enough points to claim this reward!";
                        lblRewardMessage.Visible = true;
                    }
                }
            }
        }

        protected void btnClaimDiscount_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int pointsRequired = 300;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Points FROM Loyalty WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    object result = cmd.ExecuteScalar();
                    int points = result != null ? Convert.ToInt32(result) : 0;

                    if (points >= pointsRequired)
                    {
                        DeductPoints(userId, pointsRequired);
                        AddRewardPromotion(userId, "Piper Cherokee Discount", "30% discount on your next Piper Cherokee rental 💸");
                        Response.Redirect("Promotions.aspx");
                    }
                    else
                    {
                        lblRewardMessage.Text = "⚠ Not enough points to claim this reward!";
                        lblRewardMessage.Visible = true;
                    }
                }
            }
        }

        protected void btnClaimRent_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int pointsRequired = 1000;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Points FROM Loyalty WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    object result = cmd.ExecuteScalar();
                    int points = result != null ? Convert.ToInt32(result) : 0;

                    if (points >= pointsRequired)
                    {
                        DeductPoints(userId, pointsRequired);
                        AddRewardPromotion(userId, "Beechcraft Bonanza Free Rent", "1 day free rental of a Beechcraft Bonanza ✈️");
                        Response.Redirect("Promotions.aspx");
                    }
                    else
                    {
                        lblRewardMessage.Text = "⚠ Not enough points to claim this reward!";
                        lblRewardMessage.Visible = true;
                    }
                }
            }
        }

        private void ClaimPromotion(int promotionId)
        {
            if (Session["UserID"] == null || Session["Username"] == null || Session["Username"].ToString() == "Guest")
            {
                Response.Redirect("Login.aspx?ReturnUrl=Promotions.aspx?PromotionID=" + promotionId);
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string checkPromoQuery = "SELECT ExpiryDate " +
                                        "FROM Promotions " +
                                        "WHERE PromotionID = @PromotionID AND ExpiryDate > GETDATE()";
                using (SqlCommand checkCmd = new SqlCommand(checkPromoQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@PromotionID", promotionId);
                    object expiryDate = checkCmd.ExecuteScalar();
                    if (expiryDate == null)
                    {
                        lblNoOffers.Text = "This promotion is no longer available or has expired. ⏲️";
                        lblNoOffers.Visible = true;
                        return;
                    }
                }

                string checkUserPromoQuery = "SELECT COUNT(*) FROM UserPromotions WHERE UserID = @UserID AND PromotionID = @PromotionID";
                using (SqlCommand checkUserCmd = new SqlCommand(checkUserPromoQuery, conn))
                {
                    checkUserCmd.Parameters.AddWithValue("@UserID", userId);
                    checkUserCmd.Parameters.AddWithValue("@PromotionID", promotionId);
                    int count = (int)checkUserCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        lblNoOffers.Text = "This promotion has already been claimed by you! 🎉";
                        lblNoOffers.Visible = true;
                        return;
                    }
                }

                string insertQuery = "INSERT INTO UserPromotions (UserID, PromotionID, ClaimedDate) VALUES (@UserID, @PromotionID, GETDATE())";
                using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                {
                    insertCmd.Parameters.AddWithValue("@UserID", userId);
                    insertCmd.Parameters.AddWithValue("@PromotionID", promotionId);
                    int rowsAffected = insertCmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        AwardPoints(userId, 10);
                        Response.Redirect("Promotions.aspx");
                    }
                    else
                    {
                        lblNoOffers.Text = "An error occurred while claiming the promotion. Please try again.";
                        lblNoOffers.Visible = true;
                    }
                }
            }
        }

        private void LoadClaimedOffers()
        {
            if (Session["UserID"] == null || Session["Username"] == null || Session["Username"].ToString() == "Guest")
            {
                gvClaimedOffers.DataSource = null;
                gvClaimedOffers.DataBind();
                lblNoOffers.Visible = true;
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(
                        "SELECT p.Title, p.Description, p.ExpiryDate, up.ClaimedDate " +
                        "FROM Promotions p " +
                        "INNER JOIN UserPromotions up ON p.PromotionID = up.PromotionID " +
                        "WHERE up.UserID = @UserID", conn);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = new DataTable();
                        dt.Load(reader);
                        gvClaimedOffers.DataSource = dt;
                        gvClaimedOffers.DataBind();

                        lblNoOffers.Visible = (dt.Rows.Count == 0);
                    }
                }
            }
            catch (Exception ex)
            {
                lblNoOffers.Text = "⚠ Error loading claimed offers: " + ex.Message;
                lblNoOffers.Visible = true;
            }
        }

        [System.Web.Services.WebMethod]
        public static string ClaimPromotionAjax(int promotionId)
        {
            if (HttpContext.Current.Session["UserID"] == null || HttpContext.Current.Session["Username"] == null || HttpContext.Current.Session["Username"].ToString() == "Guest")
            {
                return "NotLoggedIn";
            }

            int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string checkPromoQuery = "SELECT ExpiryDate FROM Promotions WHERE PromotionID = @PromotionID AND ExpiryDate > GETDATE()";
                using (SqlCommand checkCmd = new SqlCommand(checkPromoQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@PromotionID", promotionId);
                    object expiryDate = checkCmd.ExecuteScalar();
                    if (expiryDate == null)
                    {
                        return "Expired";
                    }
                }

                string checkUserPromoQuery = "SELECT COUNT(*) FROM UserPromotions WHERE UserID = @UserID AND PromotionID = @PromotionID";
                using (SqlCommand checkUserCmd = new SqlCommand(checkUserPromoQuery, conn))
                {
                    checkUserCmd.Parameters.AddWithValue("@UserID", userId);
                    checkUserCmd.Parameters.AddWithValue("@PromotionID", promotionId);
                    int count = (int)checkUserCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        return "AlreadyClaimed";
                    }
                }

                string insertQuery = "INSERT INTO UserPromotions (UserID, PromotionID, ClaimedDate) VALUES (@UserID, @PromotionID, GETDATE())";
                using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                {
                    insertCmd.Parameters.AddWithValue("@UserID", userId);
                    insertCmd.Parameters.AddWithValue("@PromotionID", promotionId);
                    int rowsAffected = insertCmd.ExecuteNonQuery();

                    if (rowsAffected == 0)
                    {
                        return "Error";
                    }
                }

                bool doublePoints = false;
                int points = 0;
                int currentPoints = 0;
                int totalPoints = 0;
                bool recordExists = false;

                using (SqlConnection conn2 = new SqlConnection(connectionString))
                {
                    conn2.Open();
                    string loyaltyQuery = "SELECT COUNT(*) FROM Promotions p " +
                                         "INNER JOIN UserPromotions up ON p.PromotionID = up.PromotionID " +
                                         "WHERE up.UserID = @UserID AND p.Title = 'Loyalty Bonus' AND p.ExpiryDate > GETDATE()";
                    using (SqlCommand loyaltyCmd = new SqlCommand(loyaltyQuery, conn2))
                    {
                        loyaltyCmd.Parameters.AddWithValue("@UserID", userId);
                        int count = (int)loyaltyCmd.ExecuteScalar();
                        doublePoints = count > 0;
                    }

                    points = doublePoints ? 20 : 10;
                    string checkQuery = "SELECT Points, TotalPoints FROM Loyalty WHERE UserID = @UserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn2))
                    {
                        checkCmd.Parameters.AddWithValue("@UserID", userId);
                        using (SqlDataReader reader = checkCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                currentPoints = reader["Points"] != DBNull.Value ? Convert.ToInt32(reader["Points"]) : 0;
                                totalPoints = reader["TotalPoints"] != DBNull.Value ? Convert.ToInt32(reader["TotalPoints"]) : 0;
                                recordExists = true;
                            }
                        }
                    }

                    if (recordExists)
                    {
                        string updateQuery = "UPDATE Loyalty SET Points = @Points, TotalPoints = @TotalPoints WHERE UserID = @UserID";
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn2))
                        {
                            updateCmd.Parameters.AddWithValue("@UserID", userId);
                            updateCmd.Parameters.AddWithValue("@Points", currentPoints + points);
                            updateCmd.Parameters.AddWithValue("@TotalPoints", totalPoints + points);
                            updateCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertQuery2 = "INSERT INTO Loyalty (UserID, Points, TotalPoints) VALUES (@UserID, @Points, @TotalPoints)";
                        using (SqlCommand insertCmd = new SqlCommand(insertQuery2, conn2))
                        {
                            insertCmd.Parameters.AddWithValue("@UserID", userId);
                            insertCmd.Parameters.AddWithValue("@Points", points);
                            insertCmd.Parameters.AddWithValue("@TotalPoints", points);
                            insertCmd.ExecuteNonQuery();
                        }
                    }
                }

                return "Success";
            }
        }
    }
}