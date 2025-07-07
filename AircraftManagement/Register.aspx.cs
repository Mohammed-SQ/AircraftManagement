using System;
using System.Web;
using System.Web.UI;
using System.Data.SqlClient;
using System.Configuration;
using System.Net.Mail;
using System.Web.Services;
using System.Text;
using System.Net;
using System.Security.Cryptography;

namespace AircraftManagement
{
    public partial class Register : System.Web.UI.Page
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

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

        // Method to generate a random 10-character ReferralCode (uppercase letters and/or numbers)
        private static string GenerateReferralCode()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            Random random = new Random();
            StringBuilder referralCode = new StringBuilder(10);

            for (int i = 0; i < 10; i++)
            {
                referralCode.Append(chars[random.Next(chars.Length)]);
            }

            return referralCode.ToString();
        }

        // Method to generate a unique ReferralCode
        private static string GenerateUniqueReferralCode(SqlConnection conn)
        {
            string referralCode;
            bool isUnique = false;
            int maxAttempts = 10; // Prevent infinite loops
            int attempts = 0;

            do
            {
                referralCode = GenerateReferralCode();
                string checkReferralQuery = "SELECT COUNT(*) FROM Users WHERE ReferralCode = @ReferralCode";
                using (SqlCommand cmd = new SqlCommand(checkReferralQuery, conn))
                {
                    cmd.Parameters.Add("@ReferralCode", System.Data.SqlDbType.NVarChar, 20).Value = referralCode;
                    int referralCount = (int)cmd.ExecuteScalar();
                    if (referralCount == 0)
                    {
                        isUnique = true;
                    }
                }
                attempts++;
            } while (!isUnique && attempts < maxAttempts);

            if (!isUnique)
            {
                throw new Exception("Unable to generate a unique referral code after " + maxAttempts + " attempts.");
            }

            return referralCode;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(hfShowVerification.Value) && hfShowVerification.Value == "true")
                {
                    string message = null;
                    if (Session["VerificationMessage"] != null)
                    {
                        message = Session["VerificationMessage"].ToString();
                    }
                    if (!string.IsNullOrEmpty(message))
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "showVerification", "window.showVerification('" + message + "');", true);
                    }
                }
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
                System.Diagnostics.Debug.WriteLine("Error in SetAuthenticationConfig: " + ex.Message + "\n" + ex.StackTrace);
                return new AjaxResponse { success = false, message = "Error setting configuration: " + ex.Message };
            }
        }

        [WebMethod]
        public static AjaxResponse SubmitRegistration(string username, string email, string phone, string state, string password, string contactMethod)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if username already exists
                    string checkUserQuery = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
                    using (SqlCommand cmd = new SqlCommand(checkUserQuery, conn))
                    {
                        cmd.Parameters.Add("@Username", System.Data.SqlDbType.NVarChar, 200).Value = username;
                        int userCount = (int)cmd.ExecuteScalar();
                        if (userCount > 0)
                        {
                            return new AjaxResponse { success = false, message = "Username already exists." };
                        }
                    }

                    // Check if email or phone number is already registered
                    if (contactMethod == "Email")
                    {
                        string checkEmailQuery = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                        using (SqlCommand cmd = new SqlCommand(checkEmailQuery, conn))
                        {
                            cmd.Parameters.Add("@Email", System.Data.SqlDbType.NVarChar, 400).Value = email;
                            int emailCount = (int)cmd.ExecuteScalar();
                            if (emailCount > 0)
                            {
                                return new AjaxResponse { success = false, message = "Email already registered." };
                            }
                        }
                    }
                    else
                    {
                        string checkPhoneQuery = "SELECT COUNT(*) FROM Users WHERE PhoneNumber = @PhoneNumber";
                        using (SqlCommand cmd = new SqlCommand(checkPhoneQuery, conn))
                        {
                            string fullPhoneNumber = "+966" + phone;
                            cmd.Parameters.Add("@PhoneNumber", System.Data.SqlDbType.NVarChar, 100).Value = fullPhoneNumber;
                            int phoneCount = (int)cmd.ExecuteScalar();
                            if (phoneCount > 0)
                            {
                                return new AjaxResponse { success = false, message = "Phone number already registered." };
                            }
                        }
                    }

                    // Generate and store verification code
                    string verificationCode = new Random().Next(100000, 999999).ToString();
                    HttpContext.Current.Session["VerificationCode"] = verificationCode;
                    HttpContext.Current.Session["TempUsername"] = username;
                    HttpContext.Current.Session["TempEmail"] = email;
                    HttpContext.Current.Session["TempPhone"] = phone;
                    HttpContext.Current.Session["TempState"] = state;
                    HttpContext.Current.Session["TempPassword"] = password;
                    HttpContext.Current.Session["TempContactMethod"] = contactMethod;

                    string message;
                    if (contactMethod == "Email")
                    {
                        message = SendEmailVerification(username, email, verificationCode);
                    }
                    else
                    {
                        message = SendSMSVerification(username, phone, verificationCode);
                    }

                    if (!message.StartsWith("We've sent a new 6-digit verification code"))
                    {
                        // Clear session variables on failure
                        ClearTempSessionVariables();
                        return new AjaxResponse { success = false, message = message };
                    }

                    HttpContext.Current.Session["VerificationMessage"] = message;
                    return new AjaxResponse { success = true, message = message };
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in SubmitRegistration: " + ex.Message + "\n" + ex.StackTrace);
                ClearTempSessionVariables();
                return new AjaxResponse { success = false, message = "Error: " + ex.Message };
            }
        }

        private static string SendEmailVerification(string username, string email, string code)
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
                    Credentials = new System.Net.NetworkCredential(smtpUsername, smtpPassword),
                    EnableSsl = true,
                };

                mail.From = new MailAddress(smtpUsername);
                mail.To.Add(email);
                mail.Subject = "FMMS - Verify Your Account";
                mail.IsBodyHtml = true;
                mail.Body = "<html><body>" +
                            "<p>Dear <b>" + username + "</b>,</p>" +
                            "<p style='font-size: 24px; font-weight: bold;'>Your verification code is: " + code + "</p>" +
                            "<p>Thank you for registering with <b>FMMS</b>. Please use this code to complete your registration.</p>" +
                            "<p>If you did not request this, you can safely ignore this message.</p>" +
                            "<p style='font-size: 20px;'>~ FMMS Team</p>" +
                            "</body></html>";

                smtpClient.Send(mail);
                return "We've sent a new 6-digit verification code to your email address (" + email + "). Please check your inbox (and spam/junk folder) to proceed with registration.";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in SendEmailVerification: " + ex.Message + "\n" + ex.StackTrace);
                return "Failed to send email: " + ex.Message;
            }
        }

        private static string SendSMSVerification(string username, string phone, string code)
        {
            try
            {
                // Retrieve UltraMsg configuration from session (set by js/Authentication.js)
                string ultraMsgBaseUrl = HttpContext.Current.Session["UltraMsgBaseUrl"] != null ? HttpContext.Current.Session["UltraMsgBaseUrl"].ToString() : "https://api.ultramsg.com/";
                string ultraMsgToken = HttpContext.Current.Session["UltraMsgToken"] != null ? HttpContext.Current.Session["UltraMsgToken"].ToString() : "th7yaknochdm6lkc";
                string ultraMsgInstanceId = HttpContext.Current.Session["UltraMsgInstanceId"] != null ? HttpContext.Current.Session["UltraMsgInstanceId"].ToString() : "instance112181";
                string ultrasendUrl = ultraMsgBaseUrl + ultraMsgInstanceId + "/messages/chat";

                if (string.IsNullOrEmpty(ultraMsgBaseUrl) || string.IsNullOrEmpty(ultraMsgToken) || string.IsNullOrEmpty(ultraMsgInstanceId))
                {
                    return "UltraMsg configuration not found. Please ensure the authentication configuration is set.";
                }

                string fullPhoneNumber = "+966" + phone;
                string messageBody = "Dear *" + username + "*\n" +
                                     "*Your 6-digit verification code: " + code + "*\n" +
                                     "Use this code to complete your registration\n" +
                                     "~ FMMS Team";
                string formattedPhone = fullPhoneNumber.StartsWith("+") ? fullPhoneNumber.Substring(1) : fullPhoneNumber;

                string postData = "token=" + Uri.EscapeDataString(ultraMsgToken) + "&to=" + Uri.EscapeDataString(formattedPhone) + "&body=" + Uri.EscapeDataString(messageBody) + "&priority=1";

                // Log the URL and data for debugging
                System.Diagnostics.Debug.WriteLine("Sending SMS to URL: " + ultrasendUrl);
                System.Diagnostics.Debug.WriteLine("POST Data: " + postData);

                using (var client = new System.Net.WebClient())
                {
                    client.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                    try
                    {
                        string response = client.UploadString(ultrasendUrl, "POST", postData);
                        System.Diagnostics.Debug.WriteLine("UltraMsg API Response: " + response);
                        if (response.Contains("sent"))
                        {
                            return "We've sent a new 6-digit verification code to your phone number (+966" + phone + "). Please check your messages to proceed with registration.";
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
                System.Diagnostics.Debug.WriteLine("Unexpected error in SendSMSVerification: " + ex.Message + "\n" + ex.StackTrace);
                return "Failed to send SMS: " + ex.Message;
            }
        }

        [WebMethod]
        public static AjaxResponse ResendVerificationCode()
        {
            try
            {
                string verificationCode = HttpContext.Current.Session["VerificationCode"] != null ? HttpContext.Current.Session["VerificationCode"].ToString() : null;
                string contactMethod = HttpContext.Current.Session["TempContactMethod"] != null ? HttpContext.Current.Session["TempContactMethod"].ToString() : null;
                string email = HttpContext.Current.Session["TempEmail"] != null ? HttpContext.Current.Session["TempEmail"].ToString() : null;
                string phone = HttpContext.Current.Session["TempPhone"] != null ? HttpContext.Current.Session["TempPhone"].ToString() : null;
                string username = HttpContext.Current.Session["TempUsername"] != null ? HttpContext.Current.Session["TempUsername"].ToString() : null;

                if (string.IsNullOrEmpty(verificationCode) || string.IsNullOrEmpty(contactMethod))
                {
                    return new AjaxResponse { success = false, message = "Session expired. Please start the registration process again." };
                }

                string message;
                if (contactMethod == "Email")
                {
                    message = SendEmailVerification(username, email, verificationCode);
                }
                else
                {
                    message = SendSMSVerification(username, phone, verificationCode);
                }

                if (!message.StartsWith("We've sent a new 6-digit verification code"))
                {
                    return new AjaxResponse
                    {
                        success = false,
                        message = message
                    };
                }

                HttpContext.Current.Session["VerificationMessage"] = message;
                return new AjaxResponse { success = true, message = message };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in ResendVerificationCode: " + ex.Message + "\n" + ex.StackTrace);
                return new AjaxResponse { success = false, message = "Error: " + ex.Message };
            }
        }

        [WebMethod]
        public static AjaxResponse VerifyCodeAndLogin(string code)
        {
            try
            {
                string storedCode = HttpContext.Current.Session["VerificationCode"] != null ? HttpContext.Current.Session["VerificationCode"].ToString() : null;
                if (string.IsNullOrEmpty(storedCode))
                {
                    return new AjaxResponse { success = false, message = "Session expired. Please start the registration process again." };
                }

                if (code != storedCode)
                {
                    return new AjaxResponse { success = false, message = "Invalid verification code." };
                }

                string username = HttpContext.Current.Session["TempUsername"] != null ? HttpContext.Current.Session["TempUsername"].ToString() : null;
                string email = HttpContext.Current.Session["TempEmail"] != null ? HttpContext.Current.Session["TempEmail"].ToString() : null;
                string phone = HttpContext.Current.Session["TempPhone"] != null ? HttpContext.Current.Session["TempPhone"].ToString() : null;
                string state = HttpContext.Current.Session["TempState"] != null ? HttpContext.Current.Session["TempState"].ToString() : null;
                string password = HttpContext.Current.Session["TempPassword"] != null ? HttpContext.Current.Session["TempPassword"].ToString() : null;
                string contactMethod = HttpContext.Current.Session["TempContactMethod"] != null ? HttpContext.Current.Session["TempContactMethod"].ToString() : null;

                if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(state) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(contactMethod))
                {
                    return new AjaxResponse { success = false, message = "Session data missing. Please start the registration process again." };
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Generate a unique ReferralCode
                    string referralCode = GenerateUniqueReferralCode(conn);

                    // Use OUTPUT ... INTO to avoid conflicts with triggers
                    string insertQuery = @"
                        DECLARE @OutputTable TABLE (UserID int);

                        INSERT INTO Users (Username, Email, PhoneNumber, State, Password, Role, Address, CreatedAt, ZIP, ReferralCode)
                        OUTPUT INSERTED.UserID INTO @OutputTable
                        VALUES (@Username, @Email, @PhoneNumber, @State, @Password, 'Customer', NULL, GETDATE(), NULL, @ReferralCode);

                        SELECT UserID FROM @OutputTable;";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.Add("@Username", System.Data.SqlDbType.NVarChar, 200).Value = username;
                        cmd.Parameters.Add("@Email", System.Data.SqlDbType.NVarChar, 400).Value = contactMethod == "Email" ? email : (object)DBNull.Value;
                        cmd.Parameters.Add("@PhoneNumber", System.Data.SqlDbType.NVarChar, 100).Value = contactMethod == "SMS" ? "+966" + phone : (object)DBNull.Value;
                        cmd.Parameters.Add("@State", System.Data.SqlDbType.NVarChar, 100).Value = state;
                        string hashedPassword = HashPassword(password);
                        cmd.Parameters.Add("@Password", System.Data.SqlDbType.NVarChar, 530).Value = hashedPassword;
                        cmd.Parameters.Add("@Role", System.Data.SqlDbType.NVarChar, 100).Value = "Customer";
                        cmd.Parameters.Add("@ReferralCode", System.Data.SqlDbType.NVarChar, 20).Value = referralCode;

                        int userId = (int)cmd.ExecuteScalar();

                        HttpContext.Current.Session["UserID"] = userId;
                        HttpContext.Current.Session["Username"] = username;
                        HttpContext.Current.Session["Role"] = "Customer";
                        HttpContext.Current.Session["ReferralCode"] = referralCode; // Optionally store ReferralCode in session if needed

                        // Clear temporary session variables
                        ClearTempSessionVariables();

                        return new AjaxResponse { success = true, message = "Registration and login successful. Your referral code is: " + referralCode };
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in VerifyCodeAndLogin: " + ex.Message + "\n" + ex.StackTrace);
                ClearTempSessionVariables();
                return new AjaxResponse { success = false, message = "Error: " + ex.Message };
            }
        }

        private static void ClearTempSessionVariables()
        {
            HttpContext.Current.Session.Remove("VerificationCode");
            HttpContext.Current.Session.Remove("TempUsername");
            HttpContext.Current.Session.Remove("TempEmail");
            HttpContext.Current.Session.Remove("TempPhone");
            HttpContext.Current.Session.Remove("TempState");
            HttpContext.Current.Session.Remove("TempPassword");
            HttpContext.Current.Session.Remove("TempContactMethod");
            HttpContext.Current.Session.Remove("VerificationMessage");
        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            // Collect form data
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string state = ddlState.SelectedValue;
            string password = txtPassword.Text;
            string contactMethod = hfContactMethod.Value;

            // Perform validation (similar to JavaScript validation)
            StringBuilder errors = new StringBuilder();
            if (string.IsNullOrEmpty(username))
            {
                errors.AppendLine("Username is required.");
            }
            else if (!System.Text.RegularExpressions.Regex.IsMatch(username, "^[a-z0-9._]+$"))
            {
                errors.AppendLine("Username can only contain lowercase letters, numbers, periods, and underscores.");
            }

            if (contactMethod == "Email")
            {
                if (string.IsNullOrEmpty(email))
                {
                    errors.AppendLine("Email is required.");
                }
                else if (!System.Text.RegularExpressions.Regex.IsMatch(email, @"^[^\s@]+@[^\s@]+\.[^\s@]+$"))
                {
                    errors.AppendLine("Invalid email address.");
                }
            }
            else
            {
                if (string.IsNullOrEmpty(phone))
                {
                    errors.AppendLine("Phone number is required.");
                }
                else if (!System.Text.RegularExpressions.Regex.IsMatch(phone, @"^5\d{8}$"))
                {
                    errors.AppendLine("Phone must be 9 digits starting with 5.");
                }
            }

            if (string.IsNullOrEmpty(state))
            {
                errors.AppendLine("Please select a state.");
            }

            if (string.IsNullOrEmpty(password))
            {
                errors.AppendLine("Password is required.");
            }
            else if (password.Length < 8 || password.Length > 20)
            {
                errors.AppendLine("Password must be 8-20 characters.");
            }

            if (errors.Length > 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showValidationErrors",
                    "document.getElementById('validationSummary').innerHTML = '<ul>" + errors.ToString().Replace("\r\n", "</li><li>") + "</li></ul>'; " +
                    "document.getElementById('validationSummary').style.display = 'block';", true);
                return;
            }

            // Call the SubmitRegistration logic
            AjaxResponse response = SubmitRegistration(username, email, phone, state, password, contactMethod);
            if (response.success)
            {
                hfShowVerification.Value = "true";
                ScriptManager.RegisterStartupScript(this, GetType(), "showVerification",
                    "window.showVerification('" + response.message + "');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showValidationErrors",
                    "document.getElementById('validationSummary').innerHTML = '<ul><li>" + response.message + "</li></ul>'; " +
                    "document.getElementById('validationSummary').style.display = 'block';", true);
            }
        }

        public class AjaxResponse
        {
            public bool success { get; set; }
            public string message { get; set; }
        }
    }
}