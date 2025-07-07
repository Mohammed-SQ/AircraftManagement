using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Net.Mail;
using System.Net;

namespace AircraftManagement
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Login.aspx Page_Load called");
        }

        private static string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(password);
                byte[] hash = sha256.ComputeHash(bytes);
                StringBuilder result = new StringBuilder();
                for (int i = 0; i < hash.Length; i++)
                {
                    result.Append(hash[i].ToString("x2"));
                }
                return result.ToString();
            }
        }

        [WebMethod]
        public static AjaxResponse SetAuthenticationConfig(string ultraMsgBaseUrl, string ultraMsgToken, string ultraMsgInstanceId, string smtpUsername, string smtpPassword)
        {
            try
            {
                // Store the configuration values in the session
                HttpContext.Current.Session["UltraMsgBaseUrl"] = ultraMsgBaseUrl;
                HttpContext.Current.Session["UltraMsgToken"] = ultraMsgToken;
                HttpContext.Current.Session["UltraMsgInstanceId"] = ultraMsgInstanceId;
                HttpContext.Current.Session["SmtpUsername"] = smtpUsername;
                HttpContext.Current.Session["SmtpPassword"] = smtpPassword;

                return new AjaxResponse { success = true, message = "Configuration set successfully." };
            }
            catch (Exception ex)
            {
                return new AjaxResponse { success = false, message = "Error setting configuration: " + ex.Message };
            }
        }

        [WebMethod]
        public static LoginResult LoginUser(string username, string password)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("LoginUser Web Method called");

                if (string.IsNullOrEmpty(username))
                {
                    return new LoginResult { success = false, message = "Username is required." };
                }

                if (string.IsNullOrEmpty(password))
                {
                    return new LoginResult { success = false, message = "Password is required." };
                }

                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                System.Diagnostics.Debug.WriteLine("Connection string: " + connectionString);
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    System.Diagnostics.Debug.WriteLine("Database connection opened");

                    string query = "SELECT UserID, Username, Role, Password FROM [Users] WHERE Username = @Username";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        System.Diagnostics.Debug.WriteLine("Executing query with Username: " + username);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string storedHash = reader["Password"].ToString();
                                string role = reader["Role"].ToString();
                                string userId = reader["UserID"].ToString();
                                string storedUsername = reader["Username"].ToString();

                                string hashedInputPassword = HashPassword(password);
                                bool passwordMatches = storedHash == hashedInputPassword;
                                bool hashMatches = storedHash == password;

                                if (passwordMatches || hashMatches)
                                {
                                    // Setting session variables after successful login
                                    HttpContext.Current.Session["UserID"] = userId;
                                    HttpContext.Current.Session["Username"] = storedUsername;
                                    HttpContext.Current.Session["Role"] = role;
                                    System.Diagnostics.Debug.WriteLine("Login successful for user: " + username + ", Role: " + role);

                                    // Set authentication cookie for Forms Authentication
                                    FormsAuthentication.SetAuthCookie(username, false);

                                    return new LoginResult { success = true, message = "Login successful." };
                                }
                                else
                                {
                                    System.Diagnostics.Debug.WriteLine("Login failed: Invalid username or password");
                                    return new LoginResult { success = false, message = "Invalid username or password." };
                                }
                            }
                            else
                            {
                                System.Diagnostics.Debug.WriteLine("Login failed: Invalid username or password");
                                return new LoginResult { success = false, message = "Invalid username or password." };
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Exception in LoginUser: " + ex.ToString());
                return new LoginResult { success = false, message = "Error during login: " + ex.Message };
            }
        }

        [WebMethod]
        public static AjaxResponse RequestVerificationCode(string contact, string contactMethod)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("RequestVerificationCode called with contact: " + contact + ", contactMethod: " + contactMethod);
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString))
                {
                    conn.Open();
                    string query = contactMethod == "Email"
                        ? "SELECT Username FROM Users WHERE Email = @Contact"
                        : "SELECT Username FROM Users WHERE PhoneNumber = @Contact";
                    if (contactMethod == "SMS") contact = "+966" + contact;

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Contact", contact);
                        object result = cmd.ExecuteScalar();
                        if (result == null)
                        {
                            return new AjaxResponse { success = false, message = contactMethod == "Email" ? "Email not found." : "Phone number not found." };
                        }
                        string username = result.ToString();

                        string verificationCode = new Random().Next(100000, 999999).ToString();
                        HttpContext.Current.Session["ForgotPasswordVerificationCode"] = verificationCode;
                        HttpContext.Current.Session["ForgotPasswordContact"] = contact;
                        HttpContext.Current.Session["ForgotPasswordContactMethod"] = contactMethod;
                        HttpContext.Current.Session["ForgotPasswordUsername"] = username;

                        string message = contactMethod == "Email"
                            ? SendEmailVerification(contact, verificationCode, username)
                            : SendSMSVerification(contact, verificationCode, username);

                        if (!message.StartsWith("We've sent a new 6-digit verification code"))
                        {
                            return new AjaxResponse { success = false, message = message };
                        }
                        return new AjaxResponse { success = true, message = message };
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Exception in RequestVerificationCode: " + ex.ToString());
                return new AjaxResponse { success = false, message = "Error: " + ex.Message };
            }
        }

        [WebMethod]
        public static AjaxResponse ResendVerificationCode(string contact, string contactMethod)
        {
            try
            {
                string verificationCode = HttpContext.Current.Session["ForgotPasswordVerificationCode"] != null ? HttpContext.Current.Session["ForgotPasswordVerificationCode"].ToString() : null;
                if (string.IsNullOrEmpty(verificationCode))
                {
                    return new AjaxResponse { success = false, message = "Session expired. Please request a new verification code." };
                }
                string storedContact = HttpContext.Current.Session["ForgotPasswordContact"] != null ? HttpContext.Current.Session["ForgotPasswordContact"].ToString() : null;
                if (contact != storedContact)
                {
                    return new AjaxResponse { success = false, message = "Contact mismatch. Please request a new verification code." };
                }
                string username = HttpContext.Current.Session["ForgotPasswordUsername"] != null ? HttpContext.Current.Session["ForgotPasswordUsername"].ToString() : null;
                string message = contactMethod == "Email"
                    ? SendEmailVerification(contact, verificationCode, username)
                    : SendSMSVerification(contact, verificationCode, username);

                if (!message.StartsWith("We've sent a new 6-digit verification code"))
                {
                    return new AjaxResponse { success = false, message = message };
                }
                return new AjaxResponse { success = true, message = message };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Exception in ResendVerificationCode: " + ex.ToString());
                return new AjaxResponse { success = false, message = "Error: " + ex.Message };
            }
        }

        private static string SendEmailVerification(string email, string code, string username)
        {
            try
            {
                // Retrieve SMTP configuration from session (set by js/Authentication.js)
                string smtpUsername = HttpContext.Current.Session["SmtpUsername"] != null ? HttpContext.Current.Session["SmtpUsername"].ToString() : "aircraftmanagementofficial@gmail.com";
                string smtpPassword = HttpContext.Current.Session["SmtpPassword"] != null ? HttpContext.Current.Session["SmtpPassword"].ToString() : "ecfvuvienrhfkcob";

                if (string.IsNullOrEmpty(smtpUsername) || string.IsNullOrEmpty(smtpPassword))
                {
                    return "SMTP configuration not found. Please ensure the authentication configuration is set.";
                }

                MailMessage mail = new MailMessage();
                SmtpClient smtpClient = new SmtpClient("smtp.gmail.com")
                {
                    Port = 587,
                    Credentials = new NetworkCredential(smtpUsername, smtpPassword),
                    EnableSsl = true,
                };
                mail.From = new MailAddress(smtpUsername);
                mail.To.Add(email);
                mail.Subject = "FMMS - Password Reset Verification Code";
                mail.IsBodyHtml = true;
                mail.Body = "<html><body><p>Dear " + (string.IsNullOrEmpty(username) ? "User" : username) + ",</p>" +
                            "<p style='font-size: 24px; font-weight: bold;'>Your verification code is: " + code + "</p>" +
                            "<p>Please use this code to reset your password.</p>" +
                            "<p>If you did not request this, you can safely ignore this message.</p>" +
                            "<p style='font-size: 20px;'>~ FMMS Team</p></body></html>";
                smtpClient.Send(mail);
                return "We've sent a new 6-digit verification code to your email address (" + email + "). Please check your inbox (and spam/junk folder).";
            }
            catch (Exception ex)
            {
                return "Failed to send email: " + ex.Message;
            }
        }

        private static string SendSMSVerification(string phone, string code, string username)
        {
            try
            {
                // Retrieve UltraMsg configuration from session (set by js/Authentication.js)
                string ultraMsgBaseUrl = HttpContext.Current.Session["UltraMsgBaseUrl"] != null ? HttpContext.Current.Session["UltraMsgBaseUrl"].ToString() : "https://api.ultramsg.com/";
                string ultraMsgToken = HttpContext.Current.Session["UltraMsgToken"] != null ? HttpContext.Current.Session["UltraMsgToken"].ToString() : "th7yaknochdm6lkc";
                string ultraMsgInstanceId = HttpContext.Current.Session["UltraMsgInstanceId"] != null ? HttpContext.Current.Session["UltraMsgInstanceId"].ToString() : "instance112181";
                string ultrasendUrl = ultraMsgBaseUrl + ultraMsgInstanceId + "/messages/chat"; // Base URL for sending messages

                if (string.IsNullOrEmpty(ultraMsgBaseUrl) || string.IsNullOrEmpty(ultraMsgToken) || string.IsNullOrEmpty(ultraMsgInstanceId))
                {
                    return "UltraMsg configuration not found. Please ensure the authentication configuration is set.";
                }

                string messageBody = "Dear *" + (string.IsNullOrEmpty(username) ? "User" : username) + "*\n" +
                                     "*Your 6-digit verification code: " + code + "*\n" +
                                     "Use this code to reset your password\n" +
                                     "~ FMMS Team";
                string formattedPhone = phone.StartsWith("+") ? phone.Substring(1) : phone;

                string postData = "token=" + Uri.EscapeDataString(ultraMsgToken) + "&to=" + Uri.EscapeDataString(formattedPhone) + "&body=" + Uri.EscapeDataString(messageBody) + "&priority=1";

                // Log the URL and data for debugging
                System.Diagnostics.Debug.WriteLine("Sending SMS to URL: " + ultrasendUrl);
                System.Diagnostics.Debug.WriteLine("POST Data: " + postData);

                using (var client = new WebClient())
                {
                    client.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                    try
                    {
                        string response = client.UploadString(ultrasendUrl, "POST", postData);
                        System.Diagnostics.Debug.WriteLine("UltraMsg API Response: " + response);
                        if (response.Contains("sent"))
                        {
                            return "We've sent a new 6-digit verification code to your phone number (" + phone + "). Please check your messages.";
                        }
                        else
                        {
                            return "Failed to send SMS: " + response;
                        }
                    }
                    catch (System.Net.WebException webEx)
                    {
                        // Log the detailed error
                        string errorDetails = webEx.Message;
                        if (webEx.Response != null)
                        {
                            using (var errorResponse = webEx.Response.GetResponseStream())
                            {
                                using (var reader = new System.IO.StreamReader(errorResponse))
                                {
                                    errorDetails = errorDetails + " - Response: " + reader.ReadToEnd();
                                }
                            }
                        }
                        System.Diagnostics.Debug.WriteLine("UltraMsg API Error: " + errorDetails);
                        return "Failed to send SMS: " + errorDetails;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Unexpected error in SendSMSVerification: " + ex.Message);
                return "Failed to send SMS: " + ex.Message;
            }
        }

        [WebMethod]
        public static AjaxResponse VerifyCode(string code)
        {
            try
            {
                string storedCode = HttpContext.Current.Session["ForgotPasswordVerificationCode"] != null ? HttpContext.Current.Session["ForgotPasswordVerificationCode"].ToString() : null;
                if (string.IsNullOrEmpty(storedCode))
                {
                    return new AjaxResponse { success = false, message = "Session expired. Please request a new verification code." };
                }
                if (code != storedCode)
                {
                    return new AjaxResponse { success = false, message = "Invalid verification code." };
                }
                return new AjaxResponse { success = true, message = "Verification successful. Please set your new password." };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Exception in VerifyCode: " + ex.ToString());
                return new AjaxResponse { success = false, message = "Error: " + ex.Message };
            }
        }

        [WebMethod]
        public static AjaxResponse ResetPassword(string newPassword)
        {
            try
            {
                string contact = HttpContext.Current.Session["ForgotPasswordContact"] != null ? HttpContext.Current.Session["ForgotPasswordContact"].ToString() : null;
                if (string.IsNullOrEmpty(contact))
                {
                    return new AjaxResponse { success = false, message = "Session expired. Please start the process again." };
                }
                string hashedPassword = HashPassword(newPassword);
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString))
                {
                    conn.Open();
                    string contactMethod = HttpContext.Current.Session["ForgotPasswordContactMethod"].ToString();
                    string updateQuery = contactMethod == "Email"
                        ? "UPDATE Users SET Password = @Password WHERE Email = @Contact"
                        : "UPDATE Users SET Password = @Password WHERE PhoneNumber = @Contact";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Password", hashedPassword);
                        cmd.Parameters.AddWithValue("@Contact", contact);
                        int rowsAffected = cmd.ExecuteNonQuery();
                        if (rowsAffected == 0)
                        {
                            return new AjaxResponse { success = false, message = "No user found with the provided contact." };
                        }
                    }
                    HttpContext.Current.Session.Remove("ForgotPasswordVerificationCode");
                    HttpContext.Current.Session.Remove("ForgotPasswordContact");
                    HttpContext.Current.Session.Remove("ForgotPasswordContactMethod");
                    HttpContext.Current.Session.Remove("ForgotPasswordUsername");
                    return new AjaxResponse { success = true, message = "Password reset successful." };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Exception in ResetPassword: " + ex.ToString());
                return new AjaxResponse { success = false, message = "Error: " + ex.Message };
            }
        }

        public class LoginResult
        {
            public bool success { get; set; }
            public string message { get; set; }
        }

        public class AjaxResponse
        {
            public bool success { get; set; }
            public string message { get; set; }
        }
    }
}

