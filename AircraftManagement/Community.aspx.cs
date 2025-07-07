using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Community : Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPosts();
            }
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            // Check if the user is logged in
            if (Session["Username"] == null || Session["Username"].ToString() == "Guest")
            {
                lblMessage.Text = "⚠ Please log in to post or reply.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string message = txtPost.Text.Trim();
            if (string.IsNullOrEmpty(message))
            {
                lblMessage.Text = "⚠ Please enter a message.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int userId = GetUserId(Session["Username"].ToString());
            if (userId == -1)
            {
                lblMessage.Text = "⚠ User not found.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int? parentId = ViewState["ReplyToPostId"] as int?;

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query;
                    SqlCommand cmd;

                    if (parentId.HasValue)
                    {
                        query = "INSERT INTO Replies (ParentPostId, UserId, Message, PostDate, IsDeleted) VALUES (@ParentPostId, @UserId, @Message, @PostDate, 0)";
                        cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@ParentPostId", parentId.Value);
                    }
                    else
                    {
                        query = "INSERT INTO Posts (UserId, Message, PostDate, IsDeleted) VALUES (@UserId, @Message, @PostDate, 0)";
                        cmd = new SqlCommand(query, con);
                    }

                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@Message", message);
                    cmd.Parameters.AddWithValue("@PostDate", DateTime.Now);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                    ViewState.Remove("ReplyToPostId");
                    txtPost.Text = "";
                    lblMessage.Text = "✅ Posted successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    LoadPosts();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "⚠ Error posting: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        private void LoadPosts()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Load posts and their reply counts, excluding posts where both the post and all replies are deleted
                    string query = @"
                        SELECT p.Id, p.Message, p.PostDate, p.IsDeleted, u.Username, u.Role,
                               (SELECT COUNT(*) FROM Replies r WHERE r.ParentPostId = p.Id AND r.IsDeleted = 0) AS ReplyCount
                        FROM Posts p
                        JOIN Users u ON p.UserId = u.UserID
                        WHERE NOT (p.IsDeleted = 1 AND 
                                   (SELECT COUNT(*) FROM Replies r WHERE r.ParentPostId = p.Id AND r.IsDeleted = 0) = 0)
                        ORDER BY p.PostDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            rptPosts.DataSource = dt;
                            rptPosts.DataBind();
                        }
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "⚠ Error loading posts: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void rptPosts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Reply")
            {
                int postId;
                if (int.TryParse(e.CommandArgument.ToString(), out postId))
                {
                    ViewState["ReplyToPostId"] = postId;
                    lblMessage.Text = "↪ You are replying to Post ID: " + postId;
                    lblMessage.ForeColor = System.Drawing.Color.Blue;
                }
            }
            else if (e.CommandName == "DeletePost")
            {
                int postId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand cmd = new SqlCommand("UPDATE Posts SET IsDeleted = 1 WHERE Id = @Id", con);
                        cmd.Parameters.AddWithValue("@Id", postId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                    lblMessage.Text = "✅ Post deleted successfully.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    LoadPosts();
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "⚠ Error deleting post: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        protected void rptReplies_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteReply")
            {
                int replyId = Convert.ToInt32(e.CommandArgument);
                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand cmd = new SqlCommand("UPDATE Replies SET IsDeleted = 1 WHERE Id = @Id", con);
                        cmd.Parameters.AddWithValue("@Id", replyId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                    lblMessage.Text = "✅ Reply deleted successfully.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    LoadPosts();
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "⚠ Error deleting reply: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        protected void rptPosts_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                int postId = Convert.ToInt32(row["Id"]);

                Repeater rptReplies = (Repeater)e.Item.FindControl("rptReplies");

                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = "SELECT r.Id, r.Message, r.PostDate, r.IsDeleted, u.Username, u.Role " +
                                       "FROM Replies r JOIN Users u ON r.UserId = u.UserID " +
                                       "WHERE r.ParentPostId = @ParentPostId " +
                                       "ORDER BY r.PostDate ASC";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@ParentPostId", postId);
                            con.Open();
                            using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                            {
                                DataTable dt = new DataTable();
                                sda.Fill(dt);
                                rptReplies.DataSource = dt;
                                rptReplies.DataBind();
                            }
                            con.Close();
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "⚠ Error loading replies: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        private int GetUserId(string username)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT UserID FROM Users WHERE Username = @Username";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Username", username);

                    con.Open();
                    object result = cmd.ExecuteScalar();
                    con.Close();

                    return result != null ? Convert.ToInt32(result) : -1;
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "⚠ Error retrieving user ID: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return -1;
            }
        }
    }
}