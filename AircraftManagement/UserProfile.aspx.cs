﻿using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration; // Required to read from Web.config

namespace AircraftManagement
{
    public partial class UserProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Users"] == null) // Changed from Session["UserID"] to Session["Users"]
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadUserProfile();
                LoadBookingHistory();
                LoadWishlist();
            }
        }

        private void LoadUserProfile()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT FullName, Email FROM Users WHERE Users = @Users"; // Changed from UserID to Users

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Users", Session["Users"]); // Changed from @UserID to @Users
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        txtFullName.Text = reader["FullName"].ToString();
                        txtEmail.Text = reader["Email"].ToString();
                    }
                }
            }
        }

        private void LoadBookingHistory()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"
                SELECT A.Model AS AircraftModel, T.TransactionType, T.StartDate, T.EndDate, T.TotalAmount, T.PaymentStatus
                FROM Transactions T
                INNER JOIN Aircraft A ON T.AircraftID = A.AircraftID
                WHERE T.Users = @Users"; // Changed from UserID to Users

                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    adapter.SelectCommand.Parameters.AddWithValue("@Users", Session["Users"]); // Changed from @UserID to @Users

                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    gvBookings.DataSource = dt;
                    gvBookings.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error loading booking history: " + ex.Message;
            }
        }

        private void LoadWishlist()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"
                SELECT A.Model AS AircraftModel, W.AddedAt, W.Notes
                FROM Wishlist W
                INNER JOIN Aircraft A ON W.AircraftID = A.AircraftID
                WHERE W.Users = @Users"; // Changed from UserID to Users

                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    adapter.SelectCommand.Parameters.AddWithValue("@Users", Session["Users"]); // Changed from @UserID to @Users

                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    gvWishlist.DataSource = dt;
                    gvWishlist.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error loading wishlist: " + ex.Message;
            }
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (string.IsNullOrEmpty(fullName))
            {
                lblError.Text = "Full Name cannot be empty.";
                return;
            }

            if (!string.IsNullOrEmpty(password) && password != confirmPassword)
            {
                lblError.Text = "Passwords do not match.";
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "UPDATE Users SET FullName = @FullName" +
                                   (string.IsNullOrEmpty(password) ? "" : ", Password = @Password") +
                                   " WHERE Users = @Users"; // Changed from UserID to Users

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        if (!string.IsNullOrEmpty(password))
                            cmd.Parameters.AddWithValue("@Password", password);
                        cmd.Parameters.AddWithValue("@Users", Session["Users"]); // Changed from @UserID to @Users

                        cmd.ExecuteNonQuery();
                    }
                }

                Session["FullName"] = fullName; // Update session with new FullName
                lblSuccess.Text = "Profile updated successfully.";
            }
            catch (Exception ex)
            {
                lblError.Text = "Error: " + ex.Message;
            }
        }
    }
}