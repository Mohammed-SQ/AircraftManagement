using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Linq; // Add this namespace

namespace AircraftManagement
{
    public partial class EditProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProfile();
                LoadSavedCards();
            }
        }

        private void LoadProfile()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Username, Email, PhoneNumber, DateOfBirth, Gender, Address, State, ZIP, ReferralCode, Bio FROM Users WHERE UserID = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtUsername.Text = reader["Username"].ToString();
                    txtEmail.Text = reader["Email"].ToString();
                    txtPhone.Text = reader["PhoneNumber"].ToString();
                    txtDateOfBirth.Text = reader["DateOfBirth"].ToString();
                    ddlGender.SelectedValue = reader["Gender"].ToString();
                    txtAddress.Text = reader["Address"].ToString();
                    txtState.Text = reader["State"].ToString();
                    txtZIP.Text = reader["ZIP"].ToString();
                    txtReferralCode.Text = reader["ReferralCode"].ToString();
                    txtBio.Text = reader["Bio"].ToString();
                }
            }
        }

        private void LoadSavedCards()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT CardID, CardType, CardholderName, CardNumberLastFour, ExpiryMonth, ExpiryYear, CVV, AddedAt
                                     FROM SavedCards
                                     WHERE UserID = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                conn.Open();
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                gvSavedCards.DataSource = dt;
                gvSavedCards.DataBind();
            }
        }

        protected void gvSavedCards_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCard")
            {
                int cardId = Convert.ToInt32(e.CommandArgument);
                LoadCardDetails(cardId); // Fill the fields

                // Call the JS function to open modal in Edit Mode
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowEditModal", "openEditCardModal();", true);
            }
            else if (e.CommandName == "DeleteCard")
            {
                int cardId = Convert.ToInt32(e.CommandArgument);
                DeleteCard(cardId);
                LoadSavedCards();
            }
        }

        private void LoadCardDetails(int cardId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT CardholderName, FullCardNumber, CVV, ExpiryMonth, ExpiryYear
                                     FROM SavedCards
                                     WHERE CardID = @CardID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@CardID", cardId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtCardholderName.Text = reader["CardholderName"].ToString();
                    txtCardNumber.Text = reader["FullCardNumber"].ToString();
                    txtCVV.Text = reader["CVV"].ToString();
                    txtExpiryMonth.Text = reader["ExpiryMonth"].ToString();
                    txtExpiryYear.Text = reader["ExpiryYear"].ToString();
                    hfCardID.Value = cardId.ToString();  // IMPORTANT: Store CardID for Save
                }
            }
        }

        protected void btnSaveCard_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            if (userId == 0)
            {
                lblCardMessage.Text = "Invalid user ID.";
                lblCardMessage.CssClass = "message error";
                return;
            }

            int cardId = string.IsNullOrEmpty(hfCardID.Value) ? 0 : Convert.ToInt32(hfCardID.Value);
            string cardholderName = txtCardholderName.Text.Trim();
            string cardNumber = txtCardNumber.Text.Trim();
            string cvv = txtCVV.Text.Trim();
            string expiryMonth = txtExpiryMonth.Text.Trim();
            string expiryYear = txtExpiryYear.Text.Trim();

            // --------- Validation Starts ---------
            if (string.IsNullOrEmpty(cardholderName) || string.IsNullOrEmpty(cardNumber) ||
                string.IsNullOrEmpty(cvv) || string.IsNullOrEmpty(expiryMonth) || string.IsNullOrEmpty(expiryYear))
            {
                lblCardMessage.Text = "All fields are required.";
                lblCardMessage.CssClass = "message error";
                return;
            }

            // Card Number validation (16 digits)
            if (cardNumber.Length != 16 || !cardNumber.All(char.IsDigit))
            {
                lblCardMessage.Text = "Card number must be exactly 16 digits.";
                lblCardMessage.CssClass = "message error";
                return;
            }

            // CVV validation (must be exactly 3 digits)
            if (cvv.Length != 3 || !cvv.All(char.IsDigit))
            {
                lblCardMessage.Text = "CVV must be exactly 3 digits.";
                lblCardMessage.CssClass = "message error";
                return;
            }

            // Expiry Month validation
            int expMonth;
            if (!int.TryParse(expiryMonth, out expMonth) || expMonth < 1 || expMonth > 12)
            {
                lblCardMessage.Text = "Expiry month must be between 01 and 12.";
                lblCardMessage.CssClass = "message error";
                return;
            }

            // Expiry Year validation
            int expYear;
            if (!int.TryParse(expiryYear, out expYear))
            {
                lblCardMessage.Text = "Expiry year must be numeric.";
                lblCardMessage.CssClass = "message error";
                return;
            }
            int currentYear = DateTime.Now.Year % 100; // Get last 2 digits
            if (expYear < currentYear)
            {
                lblCardMessage.Text = "Expiry year cannot be in the past.";
                lblCardMessage.CssClass = "message error";
                return;
            }
            // --------- Validation Ends ---------

            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query;
                if (cardId == 0)
                {
                    query = @"INSERT INTO SavedCards (UserID, CardType, CardholderName, CardNumberLastFour, FullCardNumber, CVV, ExpiryMonth, ExpiryYear, AddedAt)
                                  VALUES (@UserID, @CardType, @CardholderName, @CardNumberLastFour, @FullCardNumber, @CVV, @ExpiryMonth, @ExpiryYear, @AddedAt)";
                }
                else
                {
                    query = @"UPDATE SavedCards
                                  SET CardholderName = @CardholderName, 
                                      CardNumberLastFour = @CardNumberLastFour,
                                      FullCardNumber = @FullCardNumber,
                                      CVV = @CVV,
                                      ExpiryMonth = @ExpiryMonth,
                                      ExpiryYear = @ExpiryYear
                                  WHERE CardID = @CardID";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@CardType", GetCardType(cardNumber));
                cmd.Parameters.AddWithValue("@CardholderName", cardholderName);
                cmd.Parameters.AddWithValue("@CardNumberLastFour", cardNumber.Substring(cardNumber.Length - 4));
                cmd.Parameters.AddWithValue("@FullCardNumber", cardNumber);
                cmd.Parameters.AddWithValue("@CVV", cvv);
                cmd.Parameters.AddWithValue("@ExpiryMonth", expMonth);
                cmd.Parameters.AddWithValue("@ExpiryYear", expYear);
                if (cardId == 0)
                {
                    cmd.Parameters.AddWithValue("@AddedAt", DateTime.Now);
                }
                if (cardId != 0)
                {
                    cmd.Parameters.AddWithValue("@CardID", cardId);
                }

                conn.Open();
                try
                {
                    cmd.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    lblCardMessage.Text = "Error: " + ex.Message;
                    lblCardMessage.CssClass = "message error";
                    return;
                }
            }

            hfCardID.Value = ""; // reset hidden field
            LoadSavedCards();
            ScriptManager.RegisterStartupScript(this, GetType(), "HideEditModal", "$('#cardModal').modal('hide');", true);
        }

        private void DeleteCard(int cardId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM SavedCards WHERE CardID = @CardID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@CardID", cardId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private string GetCardType(string cardNumber)
        {
            if (cardNumber.StartsWith("4"))
                return "Visa";
            else if (cardNumber.StartsWith("5"))
                return "MasterCard";
            else if (cardNumber.StartsWith("6"))
                return "Discover";
            else
                return "Unknown";
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string dateOfBirth = txtDateOfBirth.Text.Trim();
            string gender = ddlGender.SelectedValue;
            string address = txtAddress.Text.Trim();
            string state = txtState.Text.Trim();
            string zip = txtZIP.Text.Trim();
            string bio = txtBio.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) && string.IsNullOrEmpty(phone))
            {
                lblMessage.Text = "You must provide at least an email or a phone number.";
                lblMessage.CssClass = "message error";
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE Users SET Email = @Email, PhoneNumber = @PhoneNumber, DateOfBirth = @DateOfBirth, Gender = @Gender, Address = @Address, State = @State, ZIP = @ZIP, Bio = @Bio WHERE UserID = @UserID";
                if (!string.IsNullOrEmpty(newPassword))
                {
                    query += ", Password = @Password";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@PhoneNumber", phone);
                cmd.Parameters.AddWithValue("@DateOfBirth", dateOfBirth);
                cmd.Parameters.AddWithValue("@Gender", gender);
                cmd.Parameters.AddWithValue("@Address", address);
                cmd.Parameters.AddWithValue("@State", state);
                cmd.Parameters.AddWithValue("@ZIP", zip);
                cmd.Parameters.AddWithValue("@Bio", bio);
                cmd.Parameters.AddWithValue("@UserID", userId);
                if (!string.IsNullOrEmpty(newPassword))
                {
                    cmd.Parameters.AddWithValue("@Password", newPassword);
                }
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Profile updated successfully.";
            lblMessage.CssClass = "message success";
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Profile.aspx");
        }
    }
}


