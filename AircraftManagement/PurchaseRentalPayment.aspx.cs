using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Specialized;
using System.Web.Services;
using System.Web;
using System.Diagnostics;
using System.Web.SessionState;
using System.Net.Mail;
using System.Text;
using PayPal.Log;

namespace AircraftManagement
{
    public partial class PurchaseRentalPayment : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                Debug.WriteLine("Page_Load started. IsPostBack=" + IsPostBack.ToString());

                if (Session["UserID"] == null || Session["AircraftID"] == null)
                {
                    Debug.WriteLine("Session[UserID] or Session[AircraftID] is null. Redirecting to Login.aspx");
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                string status = Request.QueryString["status"];
                string orderId = Request.QueryString["orderId"];
                hdnOrderId.Value = (orderId != null) ? orderId : hdnOrderId.Value;

                Debug.WriteLine("status=" + status + ", orderId=" + orderId);

                if (!IsPostBack)
                {
                    string totalAmount = (Session["TotalAmount"] != null) ? Session["TotalAmount"].ToString() : "0";
                    txtTotalAmount.Text = totalAmount;
                    hdnTotalAmount.Value = totalAmount;
                    lblTotalAmountDisplay.Text = "<img src='/Symbols/Saudi_Riyal_Symbol-black.ico' class='currency-icon' alt='SR'/> " + totalAmount;

                    lblAircraftModel.Text = (Session["AircraftModel"] != null) ? Session["AircraftModel"].ToString() : "N/A";
                    lblPassengers.Text = (Session["NumberOfPassengers"] != null) ? Session["NumberOfPassengers"].ToString() : "N/A";
                    lblStartDate.Text = (Session["StartDate"] != null) ? Session["StartDate"].ToString() : "N/A";
                    lblEndDate.Text = (Session["EndDate"] != null) ? Session["EndDate"].ToString() : "N/A";
                    lblExtraServices.Text = BuildExtraServicesString();

                    if (status == "success")
                    {
                        Debug.WriteLine("Payment success detected. Finalizing transaction...");
                        FinalizeTransaction(orderId);
                        return;
                    }
                }
                else
                {
                    if (status == "cancelled")
                    {
                        ShowError("Payment was cancelled. Please choose another method.");
                    }
                    else if (status == "failure")
                    {
                        ShowError("Payment failed. Please try again.");
                    }
                    else if (!string.IsNullOrEmpty(status))
                    {
                        ShowError("Unknown payment status: " + status);
                    }
                }
            }
            catch (Exception ex)
            {
                LogError(ex);
                ShowError("Error loading payment page: " + ex.Message);
            }
        }

        [WebMethod(EnableSession = true)]
        public static string SaveTransactionForPayPal(string paymentMethod, string paymentStatus, string payerEmail, string payerName, string paypalTransactionId)
        {
            try
            {
                Debug.WriteLine("SaveTransactionForPayPal started.");

                HttpContext context = HttpContext.Current;
                if (context == null || context.Session == null)
                {
                    throw new Exception("Session not available.");
                }

                // Ensure a booking exists before saving the transaction
                if (context.Session["BookingID"] == null)
                {
                    Debug.WriteLine("BookingID is null in SaveTransactionForPayPal. Creating a new booking...");
                    string bookingId = CreateBooking(context.Session);
                    if (string.IsNullOrEmpty(bookingId))
                    {
                        throw new Exception("Failed to create booking in SaveTransactionForPayPal.");
                    }
                    context.Session["BookingID"] = bookingId;
                    Debug.WriteLine("New BookingID created in SaveTransactionForPayPal: " + bookingId);
                }
                else
                {
                    Debug.WriteLine("BookingID already exists in SaveTransactionForPayPal: " + context.Session["BookingID"].ToString());
                }

                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            int nextInvoice = Convert.ToInt32(new SqlCommand("SELECT ISNULL(MAX(InvoiceNumber), 0) FROM Transactions", conn, transaction).ExecuteScalar()) + 1;

                            SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Transactions
                        (UserID, AircraftID, TransactionType, StartDate, EndDate, TotalAmount, PaymentStatus,
                        CreatedAt, PaymentMethod, NumberOfPassengers, Status, InvoiceNumber, BookingID,
                        chkMeals, chkWiFi, chkBoarding, chkInsurance, chkConcierge, chkCatering,
                        chkAttendant, chkNavigation, chkEntertainment, chkClimateControl)
                        VALUES
                        (@UserID, @AircraftID, @TransactionType, @StartDate, @EndDate, @TotalAmount, @PaymentStatus,
                        @CreatedAt, @PaymentMethod, @NumberOfPassengers, @Status, @InvoiceNumber, @BookingID,
                        @chkMeals, @chkWiFi, @chkBoarding, @chkInsurance, @chkConcierge, @chkCatering,
                        @chkAttendant, @chkNavigation, @chkEntertainment, @chkClimateControl);
                        SELECT SCOPE_IDENTITY();
                    ", conn, transaction);

                            cmd.Parameters.AddWithValue("@UserID", context.Session["UserID"]);
                            cmd.Parameters.AddWithValue("@AircraftID", context.Session["AircraftID"]);
                            cmd.Parameters.AddWithValue("@TransactionType", (context.Session["TransactionType"] != null) ? context.Session["TransactionType"] : "Rent");
                            cmd.Parameters.AddWithValue("@StartDate", (context.Session["StartDate"] != null) ? context.Session["StartDate"] : (object)DBNull.Value);
                            cmd.Parameters.AddWithValue("@EndDate", (context.Session["EndDate"] != null) ? context.Session["EndDate"] : (object)DBNull.Value);
                            cmd.Parameters.AddWithValue("@TotalAmount", (context.Session["TotalAmount"] != null) ? decimal.Parse(context.Session["TotalAmount"].ToString()) : 0);
                            cmd.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
                            cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                            cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                            cmd.Parameters.AddWithValue("@NumberOfPassengers", (context.Session["NumberOfPassengers"] != null) ? context.Session["NumberOfPassengers"] : (object)DBNull.Value);
                            cmd.Parameters.AddWithValue("@Status", "Pending");
                            cmd.Parameters.AddWithValue("@InvoiceNumber", nextInvoice);
                            cmd.Parameters.AddWithValue("@BookingID", context.Session["BookingID"]);

                            AddExtraServicesParams(cmd, context.Session);

                            object result = cmd.ExecuteScalar();
                            if (result == null)
                            {
                                throw new Exception("Failed to retrieve Transaction ID after INSERT.");
                            }
                            string transactionId = result.ToString();

                            // Save PayPal payment details
                            SqlCommand paymentCmd = new SqlCommand(@"
                        INSERT INTO Payments
                        (TransactionID, PaymentMethod, Amount, PaymentDate, PaymentStatus, TransactionReference,
                         CardholderName, AuthorizationCode)
                        VALUES
                        (@TransactionID, @PaymentMethod, @Amount, @PaymentDate, @PaymentStatus, @TransactionReference,
                         @CardholderName, @AuthorizationCode);
                    ", conn, transaction);

                            paymentCmd.Parameters.AddWithValue("@TransactionID", int.Parse(transactionId));
                            paymentCmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                            paymentCmd.Parameters.AddWithValue("@Amount", (context.Session["TotalAmount"] != null) ? decimal.Parse(context.Session["TotalAmount"].ToString()) : 0);
                            paymentCmd.Parameters.AddWithValue("@PaymentDate", DateTime.Now);
                            paymentCmd.Parameters.AddWithValue("@PaymentStatus", "Completed");
                            paymentCmd.Parameters.AddWithValue("@TransactionReference", paypalTransactionId);
                            paymentCmd.Parameters.AddWithValue("@CardholderName", payerName);
                            paymentCmd.Parameters.AddWithValue("@AuthorizationCode", paypalTransactionId);

                            paymentCmd.ExecuteNonQuery();

                            // Store PayPal details in session for later use
                            context.Session["PayPalPayerEmail"] = payerEmail;
                            context.Session["PayPalPayerName"] = payerName;
                            context.Session["PayPalTransactionId"] = paypalTransactionId;

                            // Update transaction status to Confirmed
                            SqlCommand updateCmd = new SqlCommand(@"
                        UPDATE Transactions
                        SET Status = 'Confirmed',
                            PaymentStatus = 'Confirmed',
                            ConfirmedAt = @ConfirmedAt
                        WHERE TransactionID = @TransactionID;
                    ", conn, transaction);

                            updateCmd.Parameters.AddWithValue("@TransactionID", int.Parse(transactionId));
                            updateCmd.Parameters.AddWithValue("@ConfirmedAt", DateTime.Now);
                            updateCmd.ExecuteNonQuery();

                            // Update BuyerID after transaction is saved
                            Debug.WriteLine("Calling UpdateBookingBuyerID from SaveTransactionForPayPal for BookingID=" + context.Session["BookingID"].ToString());
                            UpdateBookingBuyerID(context.Session["BookingID"].ToString(), conn, transaction);

                            transaction.Commit();
                            Debug.WriteLine("SaveTransactionForPayPal successful. TransactionID=" + transactionId);

                            return transactionId;
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            Debug.WriteLine("SaveTransactionForPayPal rollback. " + ex.ToString());
                            throw new Exception("Error in SaveTransactionForPayPal: " + ex.Message + (ex.InnerException != null ? " Inner Exception: " + ex.InnerException.Message : ""));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("SaveTransactionForPayPal Error: " + ex.ToString());
                throw;
            }
        }

        protected void BtnConfirmTransaction_Click(object sender, EventArgs e)
        {
            try
            {
                Debug.WriteLine("BtnConfirmTransaction_Click started.");

                NameValueCollection formData = Request.Form;
                string[] selectedMethods = formData.GetValues("paymentMethod");

                if (selectedMethods == null || selectedMethods.Length != 1)
                {
                    ShowError("Please select exactly one payment method.");
                    return;
                }

                string method = selectedMethods[0];
                Session["PaymentMethod"] = method;

                if (method == "PayPal" && hdnPayPalPaid.Value != "true")
                {
                    ShowError("Please complete the PayPal payment first.");
                    return;
                }

                if (Session["BookingID"] == null)
                {
                    Debug.WriteLine("BookingID is null. Creating a new booking...");
                    string newBookingId = CreateBooking();
                    if (string.IsNullOrEmpty(newBookingId))
                    {
                        ShowError("Failed to create booking. Please try again.");
                        return;
                    }
                    Session["BookingID"] = newBookingId;
                    Debug.WriteLine("New BookingID created: " + newBookingId);
                }
                else
                {
                    Debug.WriteLine("BookingID already exists: " + Session["BookingID"].ToString());
                }

                string transactionId = SaveTransaction(method, "Pending");
                if (string.IsNullOrEmpty(transactionId))
                {
                    ShowError("Transaction creation failed. Try again.");
                    return;
                }

                string orderId = transactionId + "-" + DateTime.Now.Ticks.ToString();
                hdnOrderId.Value = orderId;

                if (method == "Visa")
                {
                    Session["Amount"] = hdnTotalAmount.Value;
                    string redirectUrl = String.Format("MockPayment.aspx?returnUrl={0}&cancelUrl={1}&orderId={2}&amount={3}",
                        Uri.EscapeDataString(Request.Url.AbsoluteUri),
                        Uri.EscapeDataString(Request.Url.AbsoluteUri),
                        orderId,
                        hdnTotalAmount.Value);
                    Response.Redirect(redirectUrl, false);
                }
                else if (method == "PayPal")
                {
                    SavePayment(transactionId, "PayPal", decimal.Parse(hdnTotalAmount.Value), "Completed", "PayPal Order ID: " + orderId);
                    UpdateTransactionStatus(transactionId, "Confirmed");

                    // Send confirmation email after PayPal transaction is confirmed
                    SendBookingConfirmationEmail(transactionId);

                    Response.Redirect("TransactionConfirmation.aspx?TransactionID=" + transactionId, false);
                }
                else
                {
                    string paymentStatus = (method == "BankTransfer" || method == "Cash") ? "Pending" : "Completed";
                    SavePayment(transactionId, method, decimal.Parse(hdnTotalAmount.Value), paymentStatus, (method == "BankTransfer") ? "IBAN: " + Request.Form["bankIBAN"] : "Branch Visit");
                    UpdateTransactionStatus(transactionId, paymentStatus == "Completed" ? "Confirmed" : "Pending");

                    // Send confirmation email for non-PayPal methods (if status is Confirmed)
                    if (paymentStatus == "Completed")
                    {
                        SendBookingConfirmationEmail(transactionId);
                    }

                    Response.Redirect("TransactionConfirmation.aspx?TransactionID=" + transactionId, false);
                }
            }
            catch (Exception ex)
            {
                LogError(ex);
                ShowError("Error confirming transaction: " + ex.Message);
            }
        }

        protected void BtnBackToStep2_Click(object sender, EventArgs e)
        {
            Response.Redirect("PurchaseRentalDetails.aspx");
        }

        private string CreateBooking()
        {
            SqlConnection conn = null;
            SqlTransaction transaction = null;
            try
            {
                Debug.WriteLine("CreateBooking started.");

                // Validate all required session variables
                if (Session["UserID"] == null)
                    throw new Exception("UserID is missing in session.");
                if (Session["AircraftID"] == null)
                    throw new Exception("AircraftID is missing in session.");
                if (Session["StartDate"] == null)
                    throw new Exception("StartDate is missing in session.");
                if (Session["EndDate"] == null)
                    throw new Exception("EndDate is missing in session.");
                if (string.IsNullOrEmpty(hdnTotalAmount.Value))
                    throw new Exception("TotalAmount is missing or empty in hdnTotalAmount.");
                if (Session["NumberOfPassengers"] == null)
                    throw new Exception("NumberOfPassengers is missing in session.");

                Debug.WriteLine("Session variables validated: UserID=" + Session["UserID"].ToString() +
                               ", AircraftID=" + Session["AircraftID"].ToString() +
                               ", StartDate=" + Session["StartDate"].ToString() +
                               ", EndDate=" + Session["EndDate"].ToString() +
                               ", TotalAmount=" + hdnTotalAmount.Value +
                               ", NumberOfPassengers=" + Session["NumberOfPassengers"].ToString());

                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                conn = new SqlConnection(connectionString);
                conn.Open();
                transaction = conn.BeginTransaction();

                // Retrieve SellerID from Aircraft table using AircraftID
                int sellerId;
                string sellerQuery = "SELECT SellerID FROM Aircraft WHERE AircraftID = @AircraftID";
                using (SqlCommand sellerCmd = new SqlCommand(sellerQuery, conn, transaction))
                {
                    sellerCmd.Parameters.AddWithValue("@AircraftID", Session["AircraftID"]);
                    object result = sellerCmd.ExecuteScalar();
                    if (result == null || result == DBNull.Value)
                    {
                        throw new Exception("SellerID not found for AircraftID: " + Session["AircraftID"].ToString());
                    }
                    sellerId = Convert.ToInt32(result);
                    Debug.WriteLine("SellerID retrieved: " + sellerId);
                }

                // Insert into Bookings table with SellerID and BuyerID (initially NULL)
                string query = @"
                INSERT INTO [dbo].[Bookings] 
                (UserID, AircraftID, BookingType, StartDate, EndDate, TotalAmount, BookingStatus, 
                 CreatedAt, chkMeals, chkWiFi, chkBoarding, chkInsurance, chkConcierge, chkCatering, 
                 chkAttendant, chkNavigation, chkEntertainment, chkClimateControl, SellerID, BuyerID, NumberOfPassengers)
                VALUES 
                (@UserID, @AircraftID, @BookingType, @StartDate, @EndDate, @TotalAmount, @BookingStatus, 
                 @CreatedAt, @chkMeals, @chkWiFi, @chkBoarding, @chkInsurance, @chkConcierge, @chkCatering, 
                 @chkAttendant, @chkNavigation, @chkEntertainment, @chkClimateControl, @SellerID, @BuyerID, @NumberOfPassengers);
                SELECT SCOPE_IDENTITY();";
                using (SqlCommand cmd = new SqlCommand(query, conn, transaction))
                {
                    cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));
                    cmd.Parameters.AddWithValue("@AircraftID", Convert.ToInt32(Session["AircraftID"]));
                    cmd.Parameters.AddWithValue("@BookingType", (Session["TransactionType"] != null) ? Session["TransactionType"].ToString() : "Rent");
                    cmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(Session["StartDate"]));
                    cmd.Parameters.AddWithValue("@EndDate", Convert.ToDateTime(Session["EndDate"]));
                    cmd.Parameters.AddWithValue("@TotalAmount", decimal.Parse(hdnTotalAmount.Value));
                    cmd.Parameters.AddWithValue("@BookingStatus", "Pending");
                    cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                    cmd.Parameters.AddWithValue("@chkMeals", (Session["chkMeals"] != null) && Convert.ToBoolean(Session["chkMeals"]));
                    cmd.Parameters.AddWithValue("@chkWiFi", (Session["chkWiFi"] != null) && Convert.ToBoolean(Session["chkWiFi"]));
                    cmd.Parameters.AddWithValue("@chkBoarding", (Session["chkBoarding"] != null) && Convert.ToBoolean(Session["chkBoarding"]));
                    cmd.Parameters.AddWithValue("@chkInsurance", (Session["chkInsurance"] != null) && Convert.ToBoolean(Session["chkInsurance"]));
                    cmd.Parameters.AddWithValue("@chkConcierge", (Session["chkConcierge"] != null) && Convert.ToBoolean(Session["chkConcierge"]));
                    cmd.Parameters.AddWithValue("@chkCatering", (Session["chkCatering"] != null) && Convert.ToBoolean(Session["chkCatering"]));
                    cmd.Parameters.AddWithValue("@chkAttendant", (Session["chkAttendant"] != null) && Convert.ToBoolean(Session["chkAttendant"]));
                    cmd.Parameters.AddWithValue("@chkNavigation", (Session["chkNavigation"] != null) && Convert.ToBoolean(Session["chkNavigation"]));
                    cmd.Parameters.AddWithValue("@chkEntertainment", (Session["chkEntertainment"] != null) && Convert.ToBoolean(Session["chkEntertainment"]));
                    cmd.Parameters.AddWithValue("@chkClimateControl", (Session["chkClimateControl"] != null) && Convert.ToBoolean(Session["chkClimateControl"]));
                    cmd.Parameters.AddWithValue("@SellerID", sellerId);
                    cmd.Parameters.AddWithValue("@BuyerID", (object)DBNull.Value); // Initially NULL
                    cmd.Parameters.AddWithValue("@NumberOfPassengers", Convert.ToInt32(Session["NumberOfPassengers"]));

                    Debug.WriteLine("Executing INSERT into Bookings table...");
                    object bookingResult = cmd.ExecuteScalar();
                    if (bookingResult != null)
                    {
                        string bookingId = bookingResult.ToString();
                        Debug.WriteLine("CreateBooking: Booking saved successfully. BookingID=" + bookingId);

                        // Update BuyerID immediately after creating the booking
                        UpdateBookingBuyerID(bookingId, conn, transaction);

                        transaction.Commit();
                        Debug.WriteLine("CreateBooking: Transaction committed successfully.");
                        return bookingId;
                    }
                    else
                    {
                        throw new Exception("Failed to retrieve Booking ID after INSERT.");
                    }
                }
            }
            catch (Exception ex)
            {
                if (transaction != null)
                {
                    try
                    {
                        transaction.Rollback();
                        Debug.WriteLine("CreateBooking: Transaction rolled back due to error.");
                    }
                    catch (Exception rollbackEx)
                    {
                        Debug.WriteLine("CreateBooking: Error during transaction rollback: " + rollbackEx.ToString());
                    }
                }

                Debug.WriteLine("CreateBooking: Error - " + ex.ToString());
                LogError(ex);
                throw new Exception("Error creating booking: " + ex.Message + (ex.InnerException != null ? " Inner Exception: " + ex.InnerException.Message : ""));
            }
            finally
            {
                if (conn != null)
                {
                    conn.Close();
                    conn.Dispose();
                    Debug.WriteLine("CreateBooking: Database connection closed.");
                }
            }
        }

        // Overload of CreateBooking to use in SaveTransactionForPayPal
        private static string CreateBooking(HttpSessionState session)
        {
            SqlConnection conn = null;
            SqlTransaction transaction = null;
            try
            {
                Debug.WriteLine("CreateBooking (static) started.");

                // Validate all required session variables
                if (session["UserID"] == null)
                    throw new Exception("UserID is missing in session.");
                if (session["AircraftID"] == null)
                    throw new Exception("AircraftID is missing in session.");
                if (session["StartDate"] == null)
                    throw new Exception("StartDate is missing in session.");
                if (session["EndDate"] == null)
                    throw new Exception("EndDate is missing in session.");
                if (session["TotalAmount"] == null)
                    throw new Exception("TotalAmount is missing in session.");
                if (session["NumberOfPassengers"] == null)
                    throw new Exception("NumberOfPassengers is missing in session.");

                Debug.WriteLine("Session variables validated: UserID=" + session["UserID"].ToString() +
                               ", AircraftID=" + session["AircraftID"].ToString() +
                               ", StartDate=" + session["StartDate"].ToString() +
                               ", EndDate=" + session["EndDate"].ToString() +
                               ", TotalAmount=" + session["TotalAmount"].ToString() +
                               ", NumberOfPassengers=" + session["NumberOfPassengers"].ToString());

                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                conn = new SqlConnection(connectionString);
                conn.Open();
                transaction = conn.BeginTransaction();

                // Retrieve SellerID from Aircraft table using AircraftID
                int sellerId;
                string sellerQuery = "SELECT SellerID FROM Aircraft WHERE AircraftID = @AircraftID";
                using (SqlCommand sellerCmd = new SqlCommand(sellerQuery, conn, transaction))
                {
                    sellerCmd.Parameters.AddWithValue("@AircraftID", session["AircraftID"]);
                    object result = sellerCmd.ExecuteScalar();
                    if (result == null || result == DBNull.Value)
                    {
                        throw new Exception("SellerID not found for AircraftID: " + session["AircraftID"].ToString());
                    }
                    sellerId = Convert.ToInt32(result);
                    Debug.WriteLine("SellerID retrieved: " + sellerId);
                }

                // Insert into Bookings table with SellerID and BuyerID (initially NULL)
                string query = @"
                INSERT INTO [dbo].[Bookings] 
                (UserID, AircraftID, BookingType, StartDate, EndDate, TotalAmount, BookingStatus, 
                 CreatedAt, chkMeals, chkWiFi, chkBoarding, chkInsurance, chkConcierge, chkCatering, 
                 chkAttendant, chkNavigation, chkEntertainment, chkClimateControl, SellerID, BuyerID, NumberOfPassengers)
                VALUES 
                (@UserID, @AircraftID, @BookingType, @StartDate, @EndDate, @TotalAmount, @BookingStatus, 
                 @CreatedAt, @chkMeals, @chkWiFi, @chkBoarding, @chkInsurance, @chkConcierge, @chkCatering, 
                 @chkAttendant, @chkNavigation, @chkEntertainment, @chkClimateControl, @SellerID, @BuyerID, @NumberOfPassengers);
                SELECT SCOPE_IDENTITY();";
                using (SqlCommand cmd = new SqlCommand(query, conn, transaction))
                {
                    cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(session["UserID"]));
                    cmd.Parameters.AddWithValue("@AircraftID", Convert.ToInt32(session["AircraftID"]));
                    cmd.Parameters.AddWithValue("@BookingType", (session["TransactionType"] != null) ? session["TransactionType"].ToString() : "Rent");
                    cmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(session["StartDate"]));
                    cmd.Parameters.AddWithValue("@EndDate", Convert.ToDateTime(session["EndDate"]));
                    cmd.Parameters.AddWithValue("@TotalAmount", decimal.Parse(session["TotalAmount"].ToString()));
                    cmd.Parameters.AddWithValue("@BookingStatus", "Pending");
                    cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                    cmd.Parameters.AddWithValue("@chkMeals", (session["chkMeals"] != null) && Convert.ToBoolean(session["chkMeals"]));
                    cmd.Parameters.AddWithValue("@chkWiFi", (session["chkWiFi"] != null) && Convert.ToBoolean(session["chkWiFi"]));
                    cmd.Parameters.AddWithValue("@chkBoarding", (session["chkBoarding"] != null) && Convert.ToBoolean(session["chkBoarding"]));
                    cmd.Parameters.AddWithValue("@chkInsurance", (session["chkInsurance"] != null) && Convert.ToBoolean(session["chkInsurance"]));
                    cmd.Parameters.AddWithValue("@chkConcierge", (session["chkConcierge"] != null) && Convert.ToBoolean(session["chkConcierge"]));
                    cmd.Parameters.AddWithValue("@chkCatering", (session["chkCatering"] != null) && Convert.ToBoolean(session["chkCatering"]));
                    cmd.Parameters.AddWithValue("@chkAttendant", (session["chkAttendant"] != null) && Convert.ToBoolean(session["chkAttendant"]));
                    cmd.Parameters.AddWithValue("@chkNavigation", (session["chkNavigation"] != null) && Convert.ToBoolean(session["chkNavigation"]));
                    cmd.Parameters.AddWithValue("@chkEntertainment", (session["chkEntertainment"] != null) && Convert.ToBoolean(session["chkEntertainment"]));
                    cmd.Parameters.AddWithValue("@chkClimateControl", (session["chkClimateControl"] != null) && Convert.ToBoolean(session["chkClimateControl"]));
                    cmd.Parameters.AddWithValue("@SellerID", sellerId);
                    cmd.Parameters.AddWithValue("@BuyerID", (object)DBNull.Value); // Initially NULL
                    cmd.Parameters.AddWithValue("@NumberOfPassengers", Convert.ToInt32(session["NumberOfPassengers"]));

                    Debug.WriteLine("Executing INSERT into Bookings table (static)...");
                    object bookingResult = cmd.ExecuteScalar();
                    if (bookingResult != null)
                    {
                        string bookingId = bookingResult.ToString();
                        Debug.WriteLine("CreateBooking (static): Booking saved successfully. BookingID=" + bookingId);

                        // Update BuyerID immediately after creating the booking
                        UpdateBookingBuyerID(bookingId, conn, transaction);

                        transaction.Commit();
                        Debug.WriteLine("CreateBooking (static): Transaction committed successfully.");
                        return bookingId;
                    }
                    else
                    {
                        throw new Exception("Failed to retrieve Booking ID after INSERT.");
                    }
                }
            }
            catch (Exception ex)
            {
                if (transaction != null)
                {
                    try
                    {
                        transaction.Rollback();
                        Debug.WriteLine("CreateBooking (static): Transaction rolled back due to error.");
                    }
                    catch (Exception rollbackEx)
                    {
                        Debug.WriteLine("CreateBooking (static): Error during transaction rollback: " + rollbackEx.ToString());
                    }
                }

                Debug.WriteLine("CreateBooking (static): Error - " + ex.ToString());
                throw new Exception("Error creating booking in static method: " + ex.Message + (ex.InnerException != null ? " Inner Exception: " + ex.InnerException.Message : ""));
            }
            finally
            {
                if (conn != null)
                {
                    conn.Close();
                    conn.Dispose();
                    Debug.WriteLine("CreateBooking (static): Database connection closed.");
                }
            }
        }

        private string SaveTransaction(string paymentMethod, string paymentStatus)
        {
            try
            {
                Debug.WriteLine("SaveTransaction started.");
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            string invoiceQuery = "SELECT ISNULL(MAX(InvoiceNumber), 0) FROM [dbo].[Transactions] WITH (UPDLOCK, ROWLOCK)";
                            SqlCommand invoiceCmd = new SqlCommand(invoiceQuery, conn, transaction);
                            int nextInvoiceNumber = Convert.ToInt32(invoiceCmd.ExecuteScalar()) + 1;

                            string query = @"
                                INSERT INTO [dbo].[Transactions] 
                                (UserID, AircraftID, TransactionType, StartDate, EndDate, TotalAmount, PaymentStatus, 
                                 CreatedAt, PaymentMethod, NumberOfPassengers, Status, InvoiceNumber, BookingID,
                                 chkMeals, chkWiFi, chkBoarding, chkInsurance, chkConcierge, chkCatering, chkAttendant, 
                                 chkNavigation, chkEntertainment, chkClimateControl)
                                VALUES 
                                (@UserID, @AircraftID, @TransactionType, @StartDate, @EndDate, @TotalAmount, @PaymentStatus, 
                                 @CreatedAt, @PaymentMethod, @NumberOfPassengers, @Status, @InvoiceNumber, @BookingID,
                                 @chkMeals, @chkWiFi, @chkBoarding, @chkInsurance, @chkConcierge, @chkCatering, @chkAttendant, 
                                 @chkNavigation, @chkEntertainment, @chkClimateControl);
                                SELECT SCOPE_IDENTITY();";
                            SqlCommand cmd = new SqlCommand(query, conn, transaction);
                            cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                            cmd.Parameters.AddWithValue("@AircraftID", Session["AircraftID"]);
                            cmd.Parameters.AddWithValue("@TransactionType", (Session["TransactionType"] != null) ? Session["TransactionType"] : "Rent");
                            cmd.Parameters.AddWithValue("@StartDate", (Session["StartDate"] != null) ? Session["StartDate"] : (object)DBNull.Value);
                            cmd.Parameters.AddWithValue("@EndDate", (Session["EndDate"] != null) ? Session["EndDate"] : (object)DBNull.Value);
                            cmd.Parameters.AddWithValue("@TotalAmount", decimal.Parse(hdnTotalAmount.Value));
                            cmd.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
                            cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                            cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                            cmd.Parameters.AddWithValue("@NumberOfPassengers", (Session["NumberOfPassengers"] != null) ? Session["NumberOfPassengers"] : (object)DBNull.Value);
                            cmd.Parameters.AddWithValue("@Status", "Pending");
                            cmd.Parameters.AddWithValue("@InvoiceNumber", nextInvoiceNumber);
                            cmd.Parameters.AddWithValue("@BookingID", (Session["BookingID"] != null) ? Session["BookingID"] : (object)DBNull.Value);
                            cmd.Parameters.AddWithValue("@chkMeals", (Session["chkMeals"] != null) && Convert.ToBoolean(Session["chkMeals"]));
                            cmd.Parameters.AddWithValue("@chkWiFi", (Session["chkWiFi"] != null) && Convert.ToBoolean(Session["chkWiFi"]));
                            cmd.Parameters.AddWithValue("@chkBoarding", (Session["chkBoarding"] != null) && Convert.ToBoolean(Session["chkBoarding"]));
                            cmd.Parameters.AddWithValue("@chkInsurance", (Session["chkInsurance"] != null) && Convert.ToBoolean(Session["chkInsurance"]));
                            cmd.Parameters.AddWithValue("@chkConcierge", (Session["chkConcierge"] != null) && Convert.ToBoolean(Session["chkConcierge"]));
                            cmd.Parameters.AddWithValue("@chkCatering", (Session["chkCatering"] != null) && Convert.ToBoolean(Session["chkCatering"]));
                            cmd.Parameters.AddWithValue("@chkAttendant", (Session["chkAttendant"] != null) && Convert.ToBoolean(Session["chkAttendant"]));
                            cmd.Parameters.AddWithValue("@chkNavigation", (Session["chkNavigation"] != null) && Convert.ToBoolean(Session["chkNavigation"]));
                            cmd.Parameters.AddWithValue("@chkEntertainment", (Session["chkEntertainment"] != null) && Convert.ToBoolean(Session["chkEntertainment"]));
                            cmd.Parameters.AddWithValue("@chkClimateControl", (Session["chkClimateControl"] != null) && Convert.ToBoolean(Session["chkClimateControl"]));

                            object result = cmd.ExecuteScalar();
                            if (result != null)
                            {
                                transaction.Commit();
                                Debug.WriteLine("SaveTransaction: Transaction saved successfully. TransactionID=" + result.ToString() + ", InvoiceNumber=" + nextInvoiceNumber.ToString() + ", BookingID=" + (Session["BookingID"] != null ? Session["BookingID"].ToString() : "NULL"));
                                return result.ToString();
                            }
                            throw new Exception("Failed to retrieve Transaction ID.");
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            throw new Exception("Error in transaction: " + ex.Message);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError(ex);
                throw new Exception("Error saving transaction: " + ex.Message);
            }
        }

        private void SavePayment(string transactionId, string paymentMethod, decimal amount, string paymentStatus, string transactionReference)
        {
            try
            {
                Debug.WriteLine("SavePayment started. TransactionID=" + transactionId + ", Amount=" + amount.ToString());
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO [dbo].[Payments] 
                        (TransactionID, PaymentMethod, Amount, PaymentDate, PaymentStatus, TransactionReference,
                         CardholderName, CardNumberLastFour, ExpiryDate, CVVStatus, AuthorizationCode, PaymentProcessor,
                         MockTransactionStatus, MockResponseMessage, SimulationTimestamp, TestModeIndicator)
                        VALUES 
                        (@TransactionID, @PaymentMethod, @Amount, @PaymentDate, @PaymentStatus, @TransactionReference,
                         @CardholderName, @CardNumberLastFour, @ExpiryDate, @CVVStatus, @AuthorizationCode, @PaymentProcessor,
                         @MockTransactionStatus, @MockResponseMessage, @SimulationTimestamp, @TestModeIndicator);";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@TransactionID", int.Parse(transactionId));
                    cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@PaymentDate", DateTime.Now);
                    cmd.Parameters.AddWithValue("@PaymentStatus", paymentStatus);
                    cmd.Parameters.AddWithValue("@TransactionReference", (transactionReference != null) ? transactionReference : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@CardholderName", (paymentMethod == "Visa" && Session["CardholderName"] != null) ? Session["CardholderName"] : "");
                    cmd.Parameters.AddWithValue("@CardNumberLastFour", (paymentMethod == "Visa" && Session["CardNumberLastFour"] != null) ? Session["CardNumberLastFour"] : "0000");
                    cmd.Parameters.AddWithValue("@ExpiryDate", (paymentMethod == "Visa" && Session["ExpiryDate"] != null) ? Session["ExpiryDate"] : "01/25");
                    cmd.Parameters.AddWithValue("@CVVStatus", (paymentMethod == "Visa" && Session["CVVStatus"] != null) ? Session["CVVStatus"] : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@AuthorizationCode", (paymentMethod == "Visa" && Session["AuthorizationCode"] != null) ? Session["AuthorizationCode"] : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@PaymentProcessor", (paymentMethod == "Visa" && Session["PaymentProcessor"] != null) ? Session["PaymentProcessor"] : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@MockTransactionStatus", (paymentMethod == "Visa" && Session["MockTransactionStatus"] != null) ? Session["MockTransactionStatus"] : "PendingReview");
                    cmd.Parameters.AddWithValue("@MockResponseMessage", (paymentMethod == "Visa" && Session["MockResponseMessage"] != null) ? Session["MockResponseMessage"] : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@SimulationTimestamp", (paymentMethod == "Visa" && Session["SimulationTimestamp"] != null) ? Session["SimulationTimestamp"] : (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@TestModeIndicator", (paymentMethod == "Visa" && Session["TestModeIndicator"] != null) ? (bool)Session["TestModeIndicator"] : true);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    Debug.WriteLine("SavePayment: Payment saved successfully. Rows affected=" + rowsAffected.ToString());
                }
            }
            catch (Exception ex)
            {
                LogError(ex);
                throw new Exception("Error saving payment: " + ex.Message);
            }
        }

        private void UpdateTransactionStatus(string transactionId, string status)
        {
            try
            {
                Debug.WriteLine("UpdateTransactionStatus started. TransactionID=" + transactionId + ", Status=" + status);
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            // Update Transactions table
                            string query = @"
                        UPDATE [dbo].[Transactions] 
                        SET Status = @Status,
                            ConfirmedAt = CASE WHEN @Status = 'Confirmed' THEN @ConfirmedAt ELSE NULL END,
                            PaymentStatus = @Status
                        WHERE TransactionID = @TransactionID";
                            SqlCommand cmd = new SqlCommand(query, conn, transaction);
                            cmd.Parameters.AddWithValue("@TransactionID", int.Parse(transactionId));
                            cmd.Parameters.AddWithValue("@Status", status);
                            cmd.Parameters.AddWithValue("@ConfirmedAt", (status == "Confirmed") ? (object)DateTime.Now : (object)DBNull.Value);
                            cmd.ExecuteNonQuery();
                            Debug.WriteLine("UpdateTransactionStatus: Transaction status updated successfully.");

                            // If the status is "Confirmed", update the BuyerID in the Bookings table
                            if (status == "Confirmed" && Session["BookingID"] != null)
                            {
                                Debug.WriteLine("Calling UpdateBookingBuyerID from UpdateTransactionStatus for BookingID=" + Session["BookingID"].ToString());
                                UpdateBookingBuyerID(Session["BookingID"].ToString(), conn, transaction);
                            }
                            else
                            {
                                Debug.WriteLine("Cannot update BuyerID in UpdateTransactionStatus: Status=" + status + ", BookingID=" + (Session["BookingID"] != null ? Session["BookingID"].ToString() : "null"));
                            }

                            transaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            LogError(ex);
                            throw new Exception("Error in UpdateTransactionStatus: " + ex.Message);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogError(ex);
                throw new Exception("Error updating transaction status: " + ex.Message);
            }
        }

        private static void UpdateBookingBuyerID(string bookingId, SqlConnection conn = null, SqlTransaction transaction = null)
        {
            bool closeConnection = false;
            try
            {
                Debug.WriteLine("UpdateBookingBuyerID started. BookingID=" + bookingId);

                if (string.IsNullOrEmpty(bookingId))
                {
                    throw new ArgumentNullException("BookingID is null or empty. BookingID=" + bookingId);
                }

                // Ensure session is available to get UserID
                HttpContext context = HttpContext.Current;
                if (context == null || context.Session == null || context.Session["UserID"] == null)
                {
                    throw new Exception("Session or UserID not available in UpdateBookingBuyerID.");
                }

                int buyerId = Convert.ToInt32(context.Session["UserID"]);
                Debug.WriteLine("UpdateBookingBuyerID: Using UserID as BuyerID=" + buyerId);

                if (conn == null)
                {
                    conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString);
                    conn.Open();
                    closeConnection = true;
                }

                // Update the Bookings table with the Buyer's UserID
                string query = @"
            UPDATE [dbo].[Bookings] 
            SET BuyerID = @BuyerID
            WHERE BookingID = @BookingID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (transaction != null)
                    {
                        cmd.Transaction = transaction;
                    }
                    cmd.Parameters.AddWithValue("@BookingID", int.Parse(bookingId));
                    cmd.Parameters.AddWithValue("@BuyerID", buyerId);

                    int rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected == 0)
                    {
                        Debug.WriteLine("UpdateBookingBuyerID: No rows affected. BookingID=" + bookingId + " might not exist.");
                    }
                    else
                    {
                        Debug.WriteLine("UpdateBookingBuyerID: BuyerID updated successfully for BookingID=" + bookingId + ", BuyerID=" + buyerId + ", Rows affected=" + rowsAffected.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Error updating BuyerID for BookingID=" + bookingId + ": " + ex.Message);
                throw new Exception("Error updating BuyerID for BookingID=" + bookingId + ": " + ex.Message);
            }
            finally
            {
                if (closeConnection && conn != null)
                {
                    conn.Close();
                    conn.Dispose();
                }
            }
        }

        private void FinalizeTransaction(string orderId)
        {
            try
            {
                Debug.WriteLine("FinalizeTransaction started. OrderId=" + orderId);
                if (string.IsNullOrEmpty(orderId))
                {
                    throw new Exception("OrderId is null or empty.");
                }
                string transactionId = orderId.Split('-')[0];
                string paymentMethod = (Session["PaymentMethod"] != null) ? Session["PaymentMethod"].ToString() : "PayPal";
                decimal totalAmount;
                if (!string.IsNullOrEmpty(hdnTotalAmount.Value))
                {
                    totalAmount = decimal.Parse(hdnTotalAmount.Value);
                }
                else if (Session["TotalAmount"] != null)
                {
                    totalAmount = decimal.Parse(Session["TotalAmount"].ToString());
                }
                else
                {
                    throw new Exception("TotalAmount is missing from both hdnTotalAmount and Session.");
                }
                string transactionReference = paymentMethod + " Order ID: " + orderId;
                string paymentStatus = "Completed";

                Debug.WriteLine("FinalizeTransaction: transactionId=" + transactionId + ", paymentMethod=" + paymentMethod + ", totalAmount=" + totalAmount.ToString());

                SavePayment(transactionId, paymentMethod, totalAmount, paymentStatus, transactionReference);
                UpdateTransactionStatus(transactionId, "Confirmed");

                // Send confirmation email after finalizing the transaction
                SendBookingConfirmationEmail(transactionId);

                string redirectUrl = "TransactionConfirmation.aspx?TransactionID=" + transactionId;
                Debug.WriteLine("FinalizeTransaction: Redirecting to: " + redirectUrl);
                Response.Redirect(redirectUrl, false);
            }
            catch (Exception ex)
            {
                LogError(ex);
                ShowError("Error finalizing transaction: " + ex.Message);
                Debug.WriteLine("FinalizeTransaction: Failed - " + ex.Message);
            }
        }

        private void SendBookingConfirmationEmail(string transactionId)
        {
            try
            {
                Debug.WriteLine("SendBookingConfirmationEmail started. TransactionID=" + transactionId);

                // Step 1: Retrieve user email and booking details from the database
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                string userEmail = string.Empty;
                string userName = string.Empty;
                string bookingDetails = string.Empty;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get user email and name from Users table
                    string userQuery = @"
                        SELECT Email, FirstName + ' ' + LastName AS FullName
                        FROM [dbo].[Users]
                        WHERE UserID = @UserID";
                    using (SqlCommand userCmd = new SqlCommand(userQuery, conn))
                    {
                        userCmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                        using (SqlDataReader reader = userCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                userEmail = reader["Email"].ToString();
                                userName = reader["FullName"].ToString();
                            }
                            else
                            {
                                throw new Exception("User not found for UserID: " + Session["UserID"]);
                            }
                        }
                    }

                    // Get booking and transaction details
                    string bookingQuery = @"
                        SELECT b.BookingID, b.BuyerID, b.AircraftID, b.StartDate, b.EndDate, b.TotalAmount, b.NumberOfPassengers,
                               b.chkMeals, b.chkWiFi, b.chkBoarding, b.chkInsurance, b.chkConcierge, b.chkCatering,
                               b.chkAttendant, b.chkNavigation, b.chkEntertainment, b.chkClimateControl,
                               t.InvoiceNumber, t.PaymentMethod, a.Model AS AircraftModel
                        FROM [dbo].[Bookings] b
                        INNER JOIN [dbo].[Transactions] t ON b.BookingID = t.BookingID
                        INNER JOIN [dbo].[Aircraft] a ON b.AircraftID = a.AircraftID
                        WHERE t.TransactionID = @TransactionID";
                    using (SqlCommand bookingCmd = new SqlCommand(bookingQuery, conn))
                    {
                        bookingCmd.Parameters.AddWithValue("@TransactionID", transactionId);
                        using (SqlDataReader reader = bookingCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                StringBuilder details = new StringBuilder();
                                details.AppendLine("Booking ID: " + reader["BookingID"].ToString());
                                details.AppendLine("Buyer ID: " + reader["BuyerID"].ToString());
                                details.AppendLine("Aircraft Model: " + reader["AircraftModel"].ToString());
                                details.AppendLine("Start Date: " + reader["StartDate"].ToString());
                                details.AppendLine("End Date: " + reader["EndDate"].ToString());
                                details.AppendLine("Total Amount: " + reader["TotalAmount"].ToString() + " SR");
                                details.AppendLine("Number of Passengers: " + reader["NumberOfPassengers"].ToString());
                                details.AppendLine("Payment Method: " + reader["PaymentMethod"].ToString());
                                details.AppendLine("Invoice Number: " + reader["InvoiceNumber"].ToString());
                                details.AppendLine("Extra Services:");
                                if (Convert.ToBoolean(reader["chkMeals"])) details.AppendLine("- In-flight Meals");
                                if (Convert.ToBoolean(reader["chkWiFi"])) details.AppendLine("- WiFi");
                                if (Convert.ToBoolean(reader["chkBoarding"])) details.AppendLine("- Priority Boarding");
                                if (Convert.ToBoolean(reader["chkInsurance"])) details.AppendLine("- Basic Insurance");
                                if (Convert.ToBoolean(reader["chkConcierge"])) details.AppendLine("- Private Concierge");
                                if (Convert.ToBoolean(reader["chkCatering"])) details.AppendLine("- Premium Catering");
                                if (Convert.ToBoolean(reader["chkAttendant"])) details.AppendLine("- Flight Attendant");
                                if (Convert.ToBoolean(reader["chkNavigation"])) details.AppendLine("- Navigation System");
                                if (Convert.ToBoolean(reader["chkEntertainment"])) details.AppendLine("- Entertainment System");
                                if (Convert.ToBoolean(reader["chkClimateControl"])) details.AppendLine("- Climate Control");

                                bookingDetails = details.ToString();
                            }
                            else
                            {
                                throw new Exception("Booking details not found for TransactionID: " + transactionId);
                            }
                        }
                    }
                }

                // Step 2: Send the email
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("your-email@example.com"); // Replace with your email
                mail.To.Add(userEmail);
                mail.Subject = "Aircraft Booking Confirmation - Transaction ID: " + transactionId;
                mail.Body = "Dear " + userName + ",\n\n" +
                            "Thank you for your booking with Aircraft Management! Your booking has been successfully confirmed. Below are the details:\n\n" +
                            bookingDetails + "\n\n" +
                            "If you have any questions, please contact us at support@example.com.\n\n" +
                            "Best regards,\n" +
                            "Aircraft Management Team";

                SmtpClient smtpClient = new SmtpClient("smtp.example.com") // Replace with your SMTP server
                {
                    Port = 587, // Replace with your SMTP port
                    Credentials = new System.Net.NetworkCredential("your-email@example.com", "your-password"), // Replace with your SMTP credentials
                    EnableSsl = true,
                };

                smtpClient.Send(mail);
                Debug.WriteLine("SendBookingConfirmationEmail: Email sent successfully to " + userEmail);
            }
            catch (Exception ex)
            {
                Debug.WriteLine("SendBookingConfirmationEmail: Failed - " + ex.Message);
                LogError(ex);
                // Don't throw the exception to avoid interrupting the transaction flow
            }
        }

        private void RollbackTransactionIfExists()
        {
            Debug.WriteLine("RollbackTransactionIfExists called (placeholder).");
        }

        private void LogError(Exception ex)
        {
            Debug.WriteLine("Error: " + ex.ToString());
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }

        private string BuildExtraServicesString()
        {
            var services = new System.Collections.Generic.List<string>();
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
            return (services.Count > 0) ? string.Join(", ", services) : "None";
        }

        private static void AddExtraServicesParams(SqlCommand cmd, HttpSessionState session)
        {
            cmd.Parameters.AddWithValue("@chkMeals", (session["chkMeals"] != null) && Convert.ToBoolean(session["chkMeals"]));
            cmd.Parameters.AddWithValue("@chkWiFi", (session["chkWiFi"] != null) && Convert.ToBoolean(session["chkWiFi"]));
            cmd.Parameters.AddWithValue("@chkBoarding", (session["chkBoarding"] != null) && Convert.ToBoolean(session["chkBoarding"]));
            cmd.Parameters.AddWithValue("@chkInsurance", (session["chkInsurance"] != null) && Convert.ToBoolean(session["chkInsurance"]));
            cmd.Parameters.AddWithValue("@chkConcierge", (session["chkConcierge"] != null) && Convert.ToBoolean(session["chkConcierge"]));
            cmd.Parameters.AddWithValue("@chkCatering", (session["chkCatering"] != null) && Convert.ToBoolean(session["chkCatering"]));
            cmd.Parameters.AddWithValue("@chkAttendant", (session["chkAttendant"] != null) && Convert.ToBoolean(session["chkAttendant"]));
            cmd.Parameters.AddWithValue("@chkNavigation", (session["chkNavigation"] != null) && Convert.ToBoolean(session["chkNavigation"]));
            cmd.Parameters.AddWithValue("@chkEntertainment", (session["chkEntertainment"] != null) && Convert.ToBoolean(session["chkEntertainment"]));
            cmd.Parameters.AddWithValue("@chkClimateControl", (session["chkClimateControl"] != null) && Convert.ToBoolean(session["chkClimateControl"]));
        }
    }
}