using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace AircraftManagement
{
    public partial class Chats : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Check if SellerRole is ON
            if (!IsSellerRoleOn())
            {
                lblFeedbackMessage.Text = "Access Denied: You are not authorized to access this page.";
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
                txtMessage.Enabled = false;
                btnSend.Enabled = false;
                return;
            }

            // Get the ReceiverID from the query string
            string receiverID = Request.QueryString["UserID"];
            if (string.IsNullOrEmpty(receiverID))
            {
                lblFeedbackMessage.Text = "Error: No user selected to chat with.";
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
                txtMessage.Enabled = false;
                btnSend.Enabled = false;
                return;
            }

            hfReceiverID.Value = receiverID;

            if (!IsPostBack)
            {
                LoadChatUserDetails();
                LoadChatHistory();
            }
        }

        private bool IsSellerRoleOn()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT SellerRole FROM Users WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                    object result = cmd.ExecuteScalar();
                    string sellerRole = result != null ? result.ToString() : null;
                    return sellerRole == "ON";
                }
            }
        }

        private void LoadChatUserDetails()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Username FROM Users WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", hfReceiverID.Value);
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        lblChatUser.Text = result.ToString();
                    }
                    else
                    {
                        lblFeedbackMessage.Text = "Error: User not found.";
                        lblFeedbackMessage.CssClass = "alert alert-danger";
                        lblFeedbackMessage.Visible = true;
                        txtMessage.Enabled = false;
                        btnSend.Enabled = false;
                    }
                }
                conn.Close();
            }
        }

        private void LoadChatHistory()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT SenderID, ReceiverID, MessageContent, SentAt
                    FROM Messages
                    WHERE (SenderID = @SenderID AND ReceiverID = @ReceiverID)
                       OR (SenderID = @ReceiverID AND ReceiverID = @SenderID)
                    ORDER BY SentAt ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SenderID", Session["UserID"].ToString());
                    cmd.Parameters.AddWithValue("@ReceiverID", hfReceiverID.Value);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        DataTable dt = new DataTable();
                        dt.Load(reader);
                        rptMessages.DataSource = dt;
                        rptMessages.DataBind();
                    }
                }

                // Mark messages as read
                string updateQuery = @"
                    UPDATE Messages
                    SET IsRead = 1
                    WHERE ReceiverID = @ReceiverID AND SenderID = @SenderID AND IsRead = 0";
                using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                {
                    updateCmd.Parameters.AddWithValue("@ReceiverID", Session["UserID"].ToString());
                    updateCmd.Parameters.AddWithValue("@SenderID", hfReceiverID.Value);
                    updateCmd.ExecuteNonQuery();
                }

                conn.Close();
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtMessage.Text.Trim()))
            {
                lblFeedbackMessage.Text = "Please enter a message to send.";
                lblFeedbackMessage.CssClass = "alert alert-warning";
                lblFeedbackMessage.Visible = true;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string insertQuery = @"
                        INSERT INTO Messages (SenderID, ReceiverID, MessageContent, SentAt, IsRead)
                        VALUES (@SenderID, @ReceiverID, @MessageContent, @SentAt, @IsRead)";
                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@SenderID", Session["UserID"].ToString());
                        cmd.Parameters.AddWithValue("@ReceiverID", hfReceiverID.Value);
                        cmd.Parameters.AddWithValue("@MessageContent", txtMessage.Text.Trim());
                        cmd.Parameters.AddWithValue("@SentAt", DateTime.Now);
                        cmd.Parameters.AddWithValue("@IsRead", false);
                        cmd.ExecuteNonQuery();
                    }
                    conn.Close();
                }

                // Clear the message input
                txtMessage.Text = "";

                // Reload chat history
                LoadChatHistory();

                lblFeedbackMessage.Text = "Message sent successfully!";
                lblFeedbackMessage.CssClass = "alert alert-success";
                lblFeedbackMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = String.Format("Error sending message: {0}", ex.Message);
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
            }
        }
    }
}