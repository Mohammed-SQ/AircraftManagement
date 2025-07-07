using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

namespace AircraftManagement
{
    public partial class TransactionConfirmation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string transactionId = Request.QueryString["TransactionID"];
                System.Diagnostics.Debug.WriteLine("Page_Load: TransactionID=" + transactionId);

                if (string.IsNullOrEmpty(transactionId))
                {
                    lblMessage.Text = "Invalid transaction ID.";
                    lblMessage.Visible = true;
                    System.Diagnostics.Debug.WriteLine("Page_Load: TransactionID is null or empty.");
                    return;
                }

                try
                {
                    // Store current timestamp in session for PDF filename
                    Session["TransactionTimestamp"] = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                    LoadTransactionDetails(transactionId);
                    LoadPaymentDetails(transactionId);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Page_Load: Error - " + ex.ToString());
                    lblMessage.Text = "Error loading transaction details: " + ex.Message;
                    lblMessage.Visible = true;
                }
            }
        }

        private void LoadTransactionDetails(string transactionId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT t.TransactionID, t.AircraftID, t.StartDate, t.EndDate, t.NumberOfPassengers, t.TotalAmount, t.PaymentStatus,
                           a.AircraftModel
                    FROM [dbo].[Transactions] t
                    LEFT JOIN [dbo].[Aircraft] a ON t.AircraftID = a.AircraftID
                    WHERE t.TransactionID = @TransactionID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblTransactionId.Text = reader["TransactionID"].ToString();
                    lblAircraftModel.Text = reader["AircraftModel"] != DBNull.Value ? reader["AircraftModel"].ToString() : "N/A";
                    lblStartDate.Text = reader["StartDate"] != DBNull.Value ? Convert.ToDateTime(reader["StartDate"]).ToString("yyyy-MM-dd") : "N/A";
                    lblEndDate.Text = reader["EndDate"] != DBNull.Value ? Convert.ToDateTime(reader["EndDate"]).ToString("yyyy-MM-dd") : "N/A";
                    lblPassengers.Text = reader["NumberOfPassengers"] != DBNull.Value ? reader["NumberOfPassengers"].ToString() : "N/A";
                    lblTotalAmount.Text = reader["TotalAmount"] != DBNull.Value ? Convert.ToDecimal(reader["TotalAmount"]).ToString("N2") + " SAR" : "N/A";
                    lblPaymentStatus.Text = reader["PaymentStatus"] != DBNull.Value ? reader["PaymentStatus"].ToString() : "N/A";

                    // Fetch extra services from session
                    List<string> services = new List<string>();

                    if (Session["chkMeals"] != null && Convert.ToBoolean(Session["chkMeals"]) == true)
                        services.Add("In-flight Meals");

                    if (Session["chkWiFi"] != null && Convert.ToBoolean(Session["chkWiFi"]) == true)
                        services.Add("WiFi");

                    if (Session["chkBoarding"] != null && Convert.ToBoolean(Session["chkBoarding"]) == true)
                        services.Add("Priority Boarding");

                    if (Session["chkInsurance"] != null && Convert.ToBoolean(Session["chkInsurance"]) == true)
                        services.Add("Basic Insurance");

                    if (Session["chkConcierge"] != null && Convert.ToBoolean(Session["chkConcierge"]) == true)
                        services.Add("Private Concierge");

                    if (Session["chkCatering"] != null && Convert.ToBoolean(Session["chkCatering"]) == true)
                        services.Add("Premium Catering");

                    if (Session["chkAttendant"] != null && Convert.ToBoolean(Session["chkAttendant"]) == true)
                        services.Add("Flight Attendant");

                    if (Session["chkNavigation"] != null && Convert.ToBoolean(Session["chkNavigation"]) == true)
                        services.Add("Navigation System");

                    if (Session["chkEntertainment"] != null && Convert.ToBoolean(Session["chkEntertainment"]) == true)
                        services.Add("Entertainment System");

                    if (Session["chkClimateControl"] != null && Convert.ToBoolean(Session["chkClimateControl"]) == true)
                        services.Add("Climate Control");

                    System.Diagnostics.Debug.WriteLine("LoadTransactionDetails: Extra Services - " + string.Join(", ", services));
                    lblExtraServices.Text = services.Count > 0 ? string.Join(", ", services) : "None";
                }
                else
                {
                    lblTransactionId.Text = transactionId;
                    lblAircraftModel.Text = "N/A";
                    lblStartDate.Text = "N/A";
                    lblEndDate.Text = "N/A";
                    lblPassengers.Text = "N/A";
                    lblTotalAmount.Text = "N/A";
                    lblExtraServices.Text = "None";
                    System.Diagnostics.Debug.WriteLine("LoadTransactionDetails: No transaction found for TransactionID=" + transactionId);
                }
                reader.Close();
            }
        }

        private void LoadPaymentDetails(string transactionId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT 
                p.PaymentMethod,
                p.CardholderName,
                p.CardNumberLastFour,
                p.AuthorizationCode,
                p.PaymentStatus,
                sc.CardType,
                sc.ExpiryMonth,
                sc.ExpiryYear
            FROM [dbo].[Payments] p
            LEFT JOIN [dbo].[SavedCards] sc ON p.CardNumber = sc.FullCardNumber
            WHERE p.TransactionID = @TransactionID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TransactionID", transactionId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string paymentMethod = reader["PaymentMethod"] != DBNull.Value ? reader["PaymentMethod"].ToString() : "N/A";
                    lblPaymentMethod.Text = paymentMethod;

                    if (paymentMethod == "PayPal")
                    {
                        // For PayPal, use the payer name and transaction ID
                        lblCardholderName.Text = reader["CardholderName"] != DBNull.Value ? reader["CardholderName"].ToString() : "N/A";
                        lblAuthorizationCode.Text = reader["AuthorizationCode"] != DBNull.Value ? reader["AuthorizationCode"].ToString() : "N/A";
                        lblPaymentStatus.Text = reader["PaymentStatus"] != DBNull.Value ? reader["PaymentStatus"].ToString() : "N/A";

                        // Retrieve PayPal email from session (set during payment)
                        string payerEmail = Session["PayPalPayerEmail"] != null ? Session["PayPalPayerEmail"].ToString() : "N/A";
                        lblPayPalEmail.Text = payerEmail; // New label we'll add in the UI

                        // Hide irrelevant fields for PayPal
                        lblCardType.Text = "N/A";
                        lblCardNumberLastFour.Text = "N/A";
                        lblExpiryDate.Text = "N/A";
                    }
                    else
                    {
                        // For other payment methods (e.g., Visa)
                        lblCardholderName.Text = reader["CardholderName"] != DBNull.Value ? reader["CardholderName"].ToString() : "N/A";
                        lblCardType.Text = reader["CardType"] != DBNull.Value ? reader["CardType"].ToString() : "N/A";
                        lblCardNumberLastFour.Text = reader["CardNumberLastFour"] != DBNull.Value ? reader["CardNumberLastFour"].ToString() : "N/A";
                        lblExpiryDate.Text = reader["ExpiryMonth"] != DBNull.Value && reader["ExpiryYear"] != DBNull.Value
                            ? reader["ExpiryMonth"].ToString() + "/" + reader["ExpiryYear"].ToString()
                            : "N/A";
                        lblAuthorizationCode.Text = reader["AuthorizationCode"] != DBNull.Value ? reader["AuthorizationCode"].ToString() : "N/A";
                        lblPaymentStatus.Text = reader["PaymentStatus"] != DBNull.Value ? reader["PaymentStatus"].ToString() : "N/A";
                        lblPayPalEmail.Text = "N/A"; // Hide PayPal email for non-PayPal payments
                    }
                }
                else
                {
                    lblPaymentMethod.Text = "N/A";
                    lblCardholderName.Text = "N/A";
                    lblCardType.Text = "N/A";
                    lblCardNumberLastFour.Text = "N/A";
                    lblExpiryDate.Text = "N/A";
                    lblAuthorizationCode.Text = "N/A";
                    lblPaymentStatus.Text = "N/A";
                    lblPayPalEmail.Text = "N/A";
                    System.Diagnostics.Debug.WriteLine("LoadPaymentDetails: No payment found for TransactionID=" + transactionId);
                }
                reader.Close();
            }
        }

        protected void BtnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx", false);
        }
    }
}