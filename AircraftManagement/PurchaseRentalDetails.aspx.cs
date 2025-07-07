using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace AircraftManagement
{
    public partial class PurchaseRentalDetails : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["AircraftID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string aircraftId = Session["AircraftID"].ToString();
                LoadAircraftDetails(aircraftId);

                // Populate hidden fields with session data from Step 1
                hdnAircraftModel.Value = (Session["AircraftModel"] != null) ? Session["AircraftModel"].ToString() : "";
                hdnCapacity.Value = (Session["Capacity"] != null) ? Session["Capacity"].ToString() : "4";
                hdnRentalPrice.Value = (Session["RentalPrice"] != null) ? Convert.ToDecimal(Session["RentalPrice"]).ToString("N2") : "5000.00";
                hdnPurchasePrice.Value = (Session["PurchasePrice"] != null) ? Convert.ToDecimal(Session["PurchasePrice"]).ToString("N2") : "90000000.00";
                hdnImageURL.Value = (Session["ImageURL"] != null) ? Session["ImageURL"].ToString() : "";
                hdnDescription.Value = (Session["Description"] != null) ? Session["Description"].ToString() : "";

                UpdatePassengerOptions();
                HandleTransactionType();
            }
        }

        protected void btnProceedToPayment_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Store booking details in Session
                Session["StartDate"] = txtStartDate.Text;
                Session["EndDate"] = txtEndDate.Text;
                Session["CustomerType"] = ddlCustomerType.SelectedValue;
                Session["NumberOfPassengers"] = ddlNumberOfPassengers.SelectedValue;
                Session["PurposeOfUse"] = txtPurposeOfUse.Text;
                Session["CompanyName"] = txtCompanyName.Text;
                Session["CompanyRepresentative"] = txtCompanyRepresentative.Text;
                Session["TotalAmount"] = hdnTotalAmount.Value;
                Session["TransactionType"] = (Session["TransactionType"] != null) ? Session["TransactionType"].ToString() : "Rent";

                // Store individual service selections in Session for PurchaseRentalPayment.aspx.cs
                Session["chkMeals"] = chkMeals.Checked;
                Session["chkWiFi"] = chkWiFi.Checked;
                Session["chkBoarding"] = chkBoarding.Checked;
                Session["chkInsurance"] = chkInsurance.Checked;
                Session["chkConcierge"] = chkConcierge.Checked;
                Session["chkCatering"] = chkCatering.Checked;
                Session["chkAttendant"] = chkAttendant.Checked;
                Session["chkNavigation"] = chkNavigation.Checked;
                Session["chkEntertainment"] = chkEntertainment.Checked;
                Session["chkClimateControl"] = chkClimateControl.Checked;

                // Debug: Log the total amount and selections
                System.Diagnostics.Debug.WriteLine("Total Amount before redirect: " + Session["TotalAmount"]);
                System.Diagnostics.Debug.WriteLine("chkMeals: " + Session["chkMeals"]);
                System.Diagnostics.Debug.WriteLine("chkWiFi: " + Session["chkWiFi"]);
                System.Diagnostics.Debug.WriteLine("chkConcierge: " + Session["chkConcierge"]);

                Response.Redirect("PurchaseRentalPayment.aspx");
            }
        }

        protected void btnBackToStep1_Click(object sender, EventArgs e)
        {
            Response.Redirect("PurchaseRentalSelect.aspx");
        }

        private void UpdatePassengerOptions()
        {
            int capacity = (Session["Capacity"] != null) ? Convert.ToInt32(Session["Capacity"]) : 4; // Default to 4 if not set
            for (int i = 1; i <= capacity; i++)
            {
                int additionalCost = (ddlCustomerType.SelectedValue == "Individual" && i > 1) ? (i - 1) * 188 : 0;
                string optionText = additionalCost > 0 ? i + " (+" + additionalCost + " SR)" : i.ToString();
                ddlNumberOfPassengers.Items.Add(new System.Web.UI.WebControls.ListItem(optionText, i.ToString()));
            }
        }

        private void HandleTransactionType()
        {
            bool isPurchase = (Session["TransactionType"] != null && Session["TransactionType"].ToString() == "Purchase");
            txtStartDate.Enabled = !isPurchase;
            txtEndDate.Enabled = !isPurchase;
            if (isPurchase) txtEndDate.Text = "";
        }

        private void LoadAircraftDetails(string aircraftId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT AircraftModel FROM Aircraft WHERE AircraftID = @AircraftID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        Session["AircraftModel"] = result.ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading aircraft details: " + ex.Message;
                lblMessage.Visible = true;
            }
        }
    }
}