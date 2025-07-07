using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace AircraftManagement
{
    public partial class MockPayment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                System.Diagnostics.Debug.WriteLine("Page_Load: Starting at " + DateTime.Now.ToString());
                if (Session["ReturnUrl"] != null)
                    hiddenReturnUrl.Value = Session["ReturnUrl"].ToString();

                if (Session["CancelUrl"] != null)
                    hiddenCancelUrl.Value = Session["CancelUrl"].ToString();

                if (Session["OrderId"] != null)
                    lblOrderId.Text = Session["OrderId"].ToString();

                if (Session["Amount"] != null)
                {
                    string amount = Session["Amount"].ToString();
                    lblAmount.Text = amount + " SAR";
                    lblAmountPaypal.Text = amount + " SAR";
                    lblAmountDisplay.Text = amount + " SAR";
                    lblAmountDisplaySummary.Text = amount + " SAR";
                    lblAmountPaypalSummary.Text = amount + " SAR";
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("Page_Load: Session['Amount'] is null");
                }

                lblAircraftModel.Text = Session["AircraftModel"] != null ? Session["AircraftModel"].ToString() : "N/A";
                lblAircraftModelDisplay.Text = lblAircraftModel.Text;
                lblAircraftModelPaypal.Text = lblAircraftModel.Text;

                lblStartDate.Text = Session["StartDate"] != null ? Session["StartDate"].ToString() : "N/A";
                lblStartDateDisplay.Text = lblStartDate.Text;
                lblStartDatePaypal.Text = lblStartDate.Text;

                lblEndDate.Text = Session["EndDate"] != null ? Session["EndDate"].ToString() : "N/A";
                lblEndDateDisplay.Text = lblEndDate.Text;
                lblEndDatePaypal.Text = lblEndDate.Text;

                lblPassengers.Text = Session["NumberOfPassengers"] != null ? Session["NumberOfPassengers"].ToString() : "N/A";
                lblPassengersDisplay.Text = lblPassengers.Text;
                lblPassengersPaypal.Text = lblPassengers.Text;

                string extraServices = BuildExtraServicesString();
                lblExtraServices.Text = extraServices;
                lblExtraServicesDisplay.Text = extraServices;
                lblExtraServicesPaypal.Text = extraServices;

                LoadSavedCards();
                System.Diagnostics.Debug.WriteLine("Page_Load: Completed at " + DateTime.Now.ToString());
            }
        }

        private void LoadSavedCards()
        {
            System.Diagnostics.Debug.WriteLine("LoadSavedCards: Starting at " + DateTime.Now.ToString());
            if (Session["UserID"] == null)
            {
                System.Diagnostics.Debug.WriteLine("LoadSavedCards: Session['UserID'] is null");
                lblPaymentMessage.Text = "❌ Session expired. Please log in again.";
                lblPaymentMessage.CssClass = "alert alert-danger";
                lblPaymentMessage.Visible = true;
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT CardID, CardholderName, CardNumberLastFour, FullCardNumber, ExpiryMonth, ExpiryYear, CVV, CardType FROM SavedCards WHERE UserID = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                SavedCardsPanel.Controls.Clear();

                while (reader.Read())
                {
                    string cardHtml = string.Format(
                        "<div class='col-md-4 col-sm-6 col-xs-12'>" +
                        "<div class='payment-card' " +
                        "onclick='selectCard({0}, \"{3}\", \"{5}\", \"{4}/{6}\", \"{7}\")' " +
                        "id='card-{0}'>" +
                        "<i class='fa {1} payment-icon-big'></i>" +
                        "<h2>**** **** **** {2}</h2>" +
                        "<small><strong>Expiry:</strong> {4}/{6}</small><br />" +
                        "<small><strong>Name:</strong> {5}</small>" +
                        "</div>" +
                        "</div>",
                        reader["CardID"],
                        GetCardIconClass(reader["CardType"].ToString()),
                        reader["CardNumberLastFour"],
                        reader["FullCardNumber"],
                        reader["ExpiryMonth"],
                        reader["CardholderName"],
                        reader["ExpiryYear"],
                        reader["CVV"]
                    );
                    SavedCardsPanel.Controls.Add(new LiteralControl(cardHtml));
                }
                conn.Close();
                System.Diagnostics.Debug.WriteLine("LoadSavedCards: Completed at " + DateTime.Now.ToString());
            }
        }

        private string GetCardIconClass(string cardType)
        {
            switch (cardType)
            {
                case "Visa":
                    return "fa-cc-visa";
                case "MasterCard":
                    return "fa-cc-mastercard";
                case "Discover":
                    return "fa-cc-discover";
                default:
                    return "fa-credit-card";
            }
        }

        protected void BtnPay_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("BtnPay_Click: Button clicked at " + DateTime.Now.ToString());

            if (string.IsNullOrEmpty(hfSelectedCardID.Value))
            {
                lblPaymentMessage.Text = "⚠ Please select a saved card to proceed.";
                lblPaymentMessage.CssClass = "alert alert-warning";
                lblPaymentMessage.Visible = true;
                System.Diagnostics.Debug.WriteLine("BtnPay_Click: No card selected.");
                return;
            }

            if (Session["UserID"] == null || Session["AircraftID"] == null || Session["Amount"] == null)
            {
                lblPaymentMessage.Text = "❌ Session expired or invalid. Please start the booking process again.";
                lblPaymentMessage.CssClass = "alert alert-danger";
                lblPaymentMessage.Visible = true;
                System.Diagnostics.Debug.WriteLine("BtnPay_Click: Missing session variables - UserID: " + Session["UserID"] + ", AircraftID: " + Session["AircraftID"] + ", Amount: " + Session["Amount"]);
                Response.Redirect("Login.aspx", false);
                return;
            }

            int selectedCardId = Convert.ToInt32(hfSelectedCardID.Value);
            System.Diagnostics.Debug.WriteLine("BtnPay_Click: Processing payment for CardID: " + selectedCardId.ToString());
            ProcessPayment(selectedCardId);
        }

        private void ProcessPayment(int selectedCardId)
        {
            System.Diagnostics.Debug.WriteLine("ProcessPayment: Starting for CardID: " + selectedCardId.ToString() + " at " + DateTime.Now.ToString());
            try
            {
                string cardholderName = "";
                string cardNumber = "";
                string cardNumberLastFour = "";
                string expiryMonth = "";
                string expiryYear = "";
                decimal amount = 0;

                if (Session["Amount"] == null)
                {
                    throw new Exception("Amount not found in session.");
                }
                amount = Convert.ToDecimal(Session["Amount"]);
                System.Diagnostics.Debug.WriteLine("ProcessPayment: Amount retrieved: " + amount.ToString());

                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    System.Diagnostics.Debug.WriteLine("ProcessPayment: Retrieving card details for CardID: " + selectedCardId.ToString());
                    string query = "SELECT CardholderName, FullCardNumber, CardNumberLastFour, ExpiryMonth, ExpiryYear FROM SavedCards WHERE CardID = @CardID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@CardID", selectedCardId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        cardholderName = reader["CardholderName"].ToString();
                        cardNumber = reader["FullCardNumber"].ToString();
                        cardNumberLastFour = reader["CardNumberLastFour"].ToString();
                        expiryMonth = reader["ExpiryMonth"].ToString();
                        expiryYear = reader["ExpiryYear"].ToString();
                        System.Diagnostics.Debug.WriteLine("ProcessPayment: Card details retrieved - Cardholder: " + cardholderName);
                    }
                    else
                    {
                        throw new Exception("Card not found for CardID: " + selectedCardId.ToString());
                    }
                    conn.Close();
                }

                Session["CardholderName"] = cardholderName;
                Session["CardNumber"] = cardNumber;
                Session["CardNumberLastFour"] = cardNumberLastFour;
                Session["ExpiryMonth"] = expiryMonth;
                Session["ExpiryYear"] = expiryYear;
                Session["AuthorizationCode"] = GenerateMockAuthorizationCode();

                System.Diagnostics.Debug.WriteLine("ProcessPayment: Creating transaction");
                string transactionId = GetOrCreateTransaction();
                System.Diagnostics.Debug.WriteLine("ProcessPayment: Transaction created with ID: " + transactionId);

                System.Diagnostics.Debug.WriteLine("ProcessPayment: Saving payment");
                SavePayment(transactionId, "Visa", amount, "Completed", "Paid via Visa");

                System.Diagnostics.Debug.WriteLine("ProcessPayment: Updating transaction status");
                UpdateTransactionStatus(transactionId, "Confirmed");

                lblPaymentMessage.Text = "✅ Payment Successful (Mock Payment).";
                lblPaymentMessage.CssClass = "alert alert-success";
                lblPaymentMessage.Visible = true;
                System.Diagnostics.Debug.WriteLine("ProcessPayment: Payment successful message displayed");

                string redirectUrl = "TransactionConfirmation.aspx?TransactionID=" + transactionId +
                    "&Amount=" + amount.ToString() +
                    "&CardholderName=" + Uri.EscapeDataString(cardholderName) +
                    "&CardNumberLastFour=" + cardNumberLastFour +
                    "&PaymentMethod=Visa";
                System.Diagnostics.Debug.WriteLine("ProcessPayment: Redirecting to " + redirectUrl);
                Response.Redirect(redirectUrl, false);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("ProcessPayment: Error - " + ex.ToString());
                lblPaymentMessage.Text = "❌ Error processing payment: " + ex.Message;
                lblPaymentMessage.CssClass = "alert alert-danger";
                lblPaymentMessage.Visible = true;
            }
            System.Diagnostics.Debug.WriteLine("ProcessPayment: Completed at " + DateTime.Now.ToString());
        }

        private string GetOrCreateTransaction()
        {
            System.Diagnostics.Debug.WriteLine("GetOrCreateTransaction: Starting at " + DateTime.Now.ToString());
            if (Session["TransactionID"] != null)
            {
                System.Diagnostics.Debug.WriteLine("GetOrCreateTransaction: Reusing existing TransactionID: " + Session["TransactionID"].ToString());
                return Session["TransactionID"].ToString();
            }

            string transactionId = SaveTransaction("Visa", "Pending");
            Session["TransactionID"] = transactionId;
            System.Diagnostics.Debug.WriteLine("GetOrCreateTransaction: New TransactionID created: " + transactionId);
            return transactionId;
        }

        private string SaveTransaction(string paymentMethod, string paymentStatus)
        {
            System.Diagnostics.Debug.WriteLine("SaveTransaction: Starting at " + DateTime.Now.ToString());

            // Validate required session variables
            if (Session["UserID"] == null)
            {
                System.Diagnostics.Debug.WriteLine("SaveTransaction: Session['UserID'] is null");
                throw new Exception("User session expired. Please log in again.");
            }
            if (Session["AircraftID"] == null)
            {
                System.Diagnostics.Debug.WriteLine("SaveTransaction: Session['AircraftID'] is null");
                throw new Exception("Aircraft selection is missing. Please start the booking process again.");
            }

            string transactionId = null;
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = "INSERT INTO [dbo].[Transactions] " +
                        "(UserID, AircraftID, TransactionType, StartDate, EndDate, NumberOfPassengers, TotalAmount, PaymentStatus, PaymentMethod, " +
                        "chkMeals, chkWiFi, chkBoarding, chkInsurance, chkConcierge, chkCatering, chkAttendant, chkNavigation, chkEntertainment, chkClimateControl) " +
                        "OUTPUT INSERTED.TransactionID " +
                        "VALUES " +
                        "(@UserID, @AircraftID, @TransactionType, @StartDate, @EndDate, @NumberOfPassengers, @TotalAmount, @PaymentStatus, @PaymentMethod, " +
                        "@chkMeals, @chkWiFi, @chkBoarding, @chkInsurance, @chkConcierge, @chkCatering, @chkAttendant, @chkNavigation, @chkEntertainment, @chkClimateControl)";

                    System.Diagnostics.Debug.WriteLine("SaveTransaction: Executing query: " + query);
                    System.Diagnostics.Debug.WriteLine("SaveTransaction: UserID: " + Session["UserID"].ToString());
                    System.Diagnostics.Debug.WriteLine("SaveTransaction: AircraftID: " + Session["AircraftID"].ToString());

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));
                    cmd.Parameters.AddWithValue("@AircraftID", Convert.ToInt32(Session["AircraftID"]));
                    cmd.Parameters.AddWithValue("@TransactionType", Session["TransactionType"] != null ? Session["TransactionType"] : "Rent");
                    cmd.Parameters.AddWithValue("@StartDate", Session["StartDate"] != null ? Session["StartDate"] : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@EndDate", Session["EndDate"] != null ? Session["EndDate"] : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@NumberOfPassengers", Session["NumberOfPassengers"] != null ? Session["NumberOfPassengers"] : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@TotalAmount", Session["Amount"] != null ? Convert.ToDecimal(Session["Amount"]) : 0);
                    cmd.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
                    cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);

                    // Add extra services parameters
                    cmd.Parameters.AddWithValue("@chkMeals", Session["chkMeals"] != null && Convert.ToBoolean(Session["chkMeals"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkWiFi", Session["chkWiFi"] != null && Convert.ToBoolean(Session["chkWiFi"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkBoarding", Session["chkBoarding"] != null && Convert.ToBoolean(Session["chkBoarding"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkInsurance", Session["chkInsurance"] != null && Convert.ToBoolean(Session["chkInsurance"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkConcierge", Session["chkConcierge"] != null && Convert.ToBoolean(Session["chkConcierge"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkCatering", Session["chkCatering"] != null && Convert.ToBoolean(Session["chkCatering"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkAttendant", Session["chkAttendant"] != null && Convert.ToBoolean(Session["chkAttendant"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkNavigation", Session["chkNavigation"] != null && Convert.ToBoolean(Session["chkNavigation"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkEntertainment", Session["chkEntertainment"] != null && Convert.ToBoolean(Session["chkEntertainment"]) ? 1 : 0);
                    cmd.Parameters.AddWithValue("@chkClimateControl", Session["chkClimateControl"] != null && Convert.ToBoolean(Session["chkClimateControl"]) ? 1 : 0);

                    transactionId = cmd.ExecuteScalar().ToString();
                    System.Diagnostics.Debug.WriteLine("SaveTransaction: TransactionID created: " + transactionId);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("SaveTransaction: Error - " + ex.ToString());
                throw;
            }
            System.Diagnostics.Debug.WriteLine("SaveTransaction: Completed at " + DateTime.Now.ToString());
            return transactionId;
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("BtnCancel_Click: Starting at " + DateTime.Now.ToString());
            string cancelUrl = Session["CancelUrl"] != null ? Session["CancelUrl"].ToString() : null;
            System.Diagnostics.Debug.WriteLine("BtnCancel_Click: Cancelling, redirecting to: " + cancelUrl + "&status=cancelled");
            Response.Redirect(cancelUrl + "&status=cancelled", false);
        }

        protected void btnSaveNewCard_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("btnSaveNewCard_Click: Starting at " + DateTime.Now.ToString());
            int userId = Convert.ToInt32(Session["UserID"]);
            string cardholderName = txtModalCardholderName.Text.Trim();
            string cardNumber = txtModalCardNumber.Text.Trim();
            string expiryDate = txtModalExpiryDate.Text.Trim();

            string expiryMonth = expiryDate.Substring(0, 2);
            string expiryYear = expiryDate.Substring(3, 2);

            if (string.IsNullOrEmpty(cardholderName) || string.IsNullOrEmpty(cardNumber) || string.IsNullOrEmpty(expiryDate))
            {
                lblNewCardMessage.Text = "⚠ Please fill all fields.";
                lblNewCardMessage.CssClass = "text-danger";
                System.Diagnostics.Debug.WriteLine("btnSaveNewCard_Click: Validation failed - missing fields");
                return;
            }

            long cardNumberParsed;
            if (cardNumber.Length != 16 || !long.TryParse(cardNumber, out cardNumberParsed))
            {
                lblNewCardMessage.Text = "⚠ Invalid card number.";
                lblNewCardMessage.CssClass = "text-danger";
                System.Diagnostics.Debug.WriteLine("btnSaveNewCard_Click: Validation failed - invalid card number");
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    string countQuery = "SELECT COUNT(*) FROM SavedCards WHERE UserID = @UserID";
                    SqlCommand countCmd = new SqlCommand(countQuery, con);
                    countCmd.Parameters.AddWithValue("@UserID", userId);
                    int cardCount = (int)countCmd.ExecuteScalar();
                    if (cardCount >= 3)
                    {
                        lblNewCardMessage.Text = "⚠ You can only save up to 3 cards.";
                        lblNewCardMessage.CssClass = "text-danger";
                        System.Diagnostics.Debug.WriteLine("btnSaveNewCard_Click: User has reached card limit");
                        return;
                    }

                    string insertQuery = "INSERT INTO SavedCards (UserID, CardholderName, CardNumberLastFour, ExpiryMonth, ExpiryYear, CardType) " +
                        "VALUES (@UserID, @CardholderName, @CardNumberLastFour, @ExpiryMonth, @ExpiryYear, @CardType)";
                    SqlCommand insertCmd = new SqlCommand(insertQuery, con);
                    insertCmd.Parameters.AddWithValue("@UserID", userId);
                    insertCmd.Parameters.AddWithValue("@CardholderName", cardholderName);
                    insertCmd.Parameters.AddWithValue("@CardNumberLastFour", cardNumber.Substring(12));
                    insertCmd.Parameters.AddWithValue("@ExpiryMonth", expiryMonth);
                    insertCmd.Parameters.AddWithValue("@ExpiryYear", expiryYear);
                    insertCmd.Parameters.AddWithValue("@CardType", GetCardType(cardNumber));
                    insertCmd.ExecuteNonQuery(); // Fixed typo: Corrected "LaplaceExecuteNonQuery" to "ExecuteNonQuery"

                    lblNewCardMessage.Text = "✅ Card added successfully!";
                    lblNewCardMessage.CssClass = "text-success";
                    LoadSavedCards();
                    System.Diagnostics.Debug.WriteLine("btnSaveNewCard_Click: Card added successfully");
                }
            }
            catch (Exception ex)
            {
                lblNewCardMessage.Text = "⚠ Error: " + ex.Message;
                lblNewCardMessage.CssClass = "text-danger";
                System.Diagnostics.Debug.WriteLine("btnSaveNewCard_Click: Error - " + ex.ToString());
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

        private void SavePayment(string transactionId, string paymentMethod, decimal amount, string paymentStatus, string transactionReference)
        {
            System.Diagnostics.Debug.WriteLine("SavePayment: Starting for TransactionID: " + transactionId + " at " + DateTime.Now.ToString());
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string checkQuery = "SELECT COUNT(*) FROM Payments WHERE TransactionID = @TransactionID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@TransactionID", transactionId);
                        int count = (int)checkCmd.ExecuteScalar();

                        if (count > 0)
                        {
                            lblPaymentMessage.Text = "⚠ Duplicate transaction detected. Payment not processed.";
                            lblPaymentMessage.CssClass = "alert alert-warning";
                            lblPaymentMessage.Visible = true;
                            System.Diagnostics.Debug.WriteLine("SavePayment: Duplicate transaction detected");
                            return;
                        }
                    }

                    string query = "INSERT INTO [dbo].[Payments] " +
                        "(TransactionID, PaymentMethod, Amount, PaymentDate, PaymentStatus, TransactionReference, " +
                        "CardholderName, CardNumber, CardNumberLastFour, ExpiryDate, CVVStatus, AuthorizationCode, PaymentProcessor, " +
                        "MockTransactionStatus, MockResponseMessage, SimulationTimestamp, TestModeIndicator, IsTestPayment) " +
                        "VALUES " +
                        "(@TransactionID, @PaymentMethod, @Amount, @PaymentDate, @PaymentStatus, @TransactionReference, " +
                        "@CardholderName, @CardNumber, @CardNumberLastFour, @ExpiryDate, @CVVStatus, @AuthorizationCode, @PaymentProcessor, " +
                        "@MockTransactionStatus, @MockResponseMessage, @SimulationTimestamp, @TestModeIndicator, @IsTestPayment);";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                        cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                        cmd.Parameters.AddWithValue("@Amount", amount);
                        cmd.Parameters.AddWithValue("@PaymentDate", DateTime.Now);
                        cmd.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
                        cmd.Parameters.AddWithValue("@TransactionReference", transactionReference != null ? transactionReference : (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@CardholderName", Session["CardholderName"] != null ? Session["CardholderName"] : "TEST");
                        cmd.Parameters.AddWithValue("@CardNumber", Session["CardNumber"] != null ? Session["CardNumber"] : "4111111111111111");
                        cmd.Parameters.AddWithValue("@CardNumberLastFour", Session["CardNumberLastFour"] != null ? Session["CardNumberLastFour"] : "1111");
                        cmd.Parameters.AddWithValue("@ExpiryDate",
                            (Session["ExpiryMonth"] != null ? Session["ExpiryMonth"].ToString() : "01") + "/" +
                            (Session["ExpiryYear"] != null ? Session["ExpiryYear"].ToString() : "25"));
                        cmd.Parameters.AddWithValue("@CVVStatus", "Valid");
                        cmd.Parameters.AddWithValue("@AuthorizationCode", Session["AuthorizationCode"] != null ? Session["AuthorizationCode"] : "AUTH-123456");
                        cmd.Parameters.AddWithValue("@PaymentProcessor", "MockProcessor");
                        cmd.Parameters.AddWithValue("@MockTransactionStatus", "Completed");
                        cmd.Parameters.AddWithValue("@MockResponseMessage", "Transaction successful");
                        cmd.Parameters.AddWithValue("@SimulationTimestamp", DateTime.Now);
                        cmd.Parameters.AddWithValue("@TestModeIndicator", true);
                        cmd.Parameters.AddWithValue("@IsTestPayment", true);

                        cmd.ExecuteNonQuery();
                        System.Diagnostics.Debug.WriteLine("SavePayment: Payment saved successfully");
                    }

                    lblPaymentMessage.Text = "✅ Payment saved successfully.";
                    lblPaymentMessage.CssClass = "alert alert-success";
                    lblPaymentMessage.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("SavePayment: Error - " + ex.ToString());
                lblPaymentMessage.Text = "❌ Error saving payment: " + ex.Message;
                lblPaymentMessage.CssClass = "alert alert-danger";
                lblPaymentMessage.Visible = true;
                throw;
            }
            System.Diagnostics.Debug.WriteLine("SavePayment: Completed at " + DateTime.Now.ToString());
        }

        private void UpdateTransactionStatus(string transactionId, string status)
        {
            System.Diagnostics.Debug.WriteLine("UpdateTransactionStatus: Starting for TransactionID: " + transactionId + " at " + DateTime.Now.ToString());
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE [dbo].[Transactions] " +
                        "SET Status = @Status, " +
                        "ConfirmedAt = CASE WHEN @Status = 'Confirmed' THEN @ConfirmedAt ELSE NULL END, " +
                        "PaymentStatus = @Status " +
                        "WHERE TransactionID = @TransactionID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@ConfirmedAt", status == "Confirmed" ? (object)DateTime.Now : DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    System.Diagnostics.Debug.WriteLine("UpdateTransactionStatus: Transaction status updated to " + status);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("UpdateTransactionStatus: Error - " + ex.ToString());
                throw;
            }
            System.Diagnostics.Debug.WriteLine("UpdateTransactionStatus: Completed at " + DateTime.Now.ToString());
        }

        private bool ValidateExpiryDate(string expiry)
        {
            if (string.IsNullOrEmpty(expiry) || expiry.Length != 5 || expiry[2] != '/')
                return false;

            string[] parts = expiry.Split('/');
            if (parts.Length != 2)
                return false;

            int month;
            if (!int.TryParse(parts[0], out month) || month < 1 || month > 12)
                return false;

            int year;
            if (!int.TryParse(parts[1], out year) || year < 25 || year > 50)
                return false;

            int fullYear = 2000 + year;
            DateTime currentDate = DateTime.Now;
            DateTime expiryDate = new DateTime(fullYear, month, DateTime.DaysInMonth(fullYear, month));

            return expiryDate >= currentDate;
        }

        private bool ValidateCardNumber(string cardNumber)
        {
            long dummy;
            return cardNumber.Length == 16 && long.TryParse(cardNumber, out dummy);
        }

        private bool ValidateCVV(string cvv)
        {
            int dummyCvv;
            return (cvv.Length == 3 || cvv.Length == 4) && int.TryParse(cvv, out dummyCvv);
        }

        private string BuildExtraServicesString()
        {
            var services = new List<string>();
            if (Session["chkMeals"] != null && Convert.ToBoolean(Session["chkMeals"])) services.Add("In-flight Meals");
            if (Session["chkWiFi"] != null && Convert.ToBoolean(Session["chkWiFi"])) services.Add("WiFi");
            if (Session["chkBoarding"] != null && Convert.ToBoolean(Session["chkBoarding"])) services.Add("Priority Boarding");
            if (Session["chkInsurance"] != null && Convert.ToBoolean(Session["chkInsurance"])) services.Add("Basic Insurance");
            if (Session["chkConcierge"] != null && Convert.ToBoolean(Session["chkConcierge"])) services.Add("Private Concierge");
            if (Session["chkCatering"] != null && Convert.ToBoolean(Session["chkCatering"])) services.Add("Premium Catering");
            if (Session["chkAttendant"] != null && Convert.ToBoolean(Session["chkAttendant"])) services.Add("Flight Attendant");
            if (Session["chkNavigation"] != null && Convert.ToBoolean(Session["chkNavigation"])) services.Add("Navigation System");
            if (Session["chkEntertainment"] != null && Convert.ToBoolean(Session["chkEntertainment"])) services.Add("Entertainment System");
            if (Session["chkClimateControl"] != null && Convert.ToBoolean(Session["chkClimateControl"])) services.Add("Climate Control");

            return services.Count > 0 ? string.Join(", ", services) : "None";
        }

        private string GenerateMockAuthorizationCode()
        {
            Random random = new Random();
            int code = random.Next(100000, 999999);
            return "AUTH-" + code.ToString();
        }
    }
}