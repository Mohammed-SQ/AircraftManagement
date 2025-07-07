using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Configuration;

namespace AircraftManagement
{
    public partial class PurchaseRentalSelect : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAircrafts();
                int aircraftId;
                if (Request.QueryString["AircraftID"] != null && int.TryParse(Request.QueryString["AircraftID"], out aircraftId))
                {
                    ddlAircrafts.SelectedValue = aircraftId.ToString();
                    UpdateAircraftInfo(aircraftId);
                }
            }
        }

        protected void btnProceedToBooking_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                Session["AircraftID"] = ddlAircrafts.SelectedValue;
                Session["TransactionType"] = hdnTransactionType.Value;
                Response.Redirect("PurchaseRentalDetails.aspx");
            }
        }

        private void LoadAircrafts()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT AircraftID, AircraftModel FROM Aircraft WHERE Status = 'Available'";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    ddlAircrafts.Items.Clear();
                    ddlAircrafts.Items.Add(new System.Web.UI.WebControls.ListItem("Select Aircraft", ""));
                    while (reader.Read())
                    {
                        ddlAircrafts.Items.Add(new System.Web.UI.WebControls.ListItem(reader["AircraftModel"].ToString(), reader["AircraftID"].ToString()));
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading aircraft: " + ex.Message;
                lblMessage.Visible = true;
            }
        }

        private void UpdateAircraftInfo(int aircraftId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            a.AircraftID, 
                            a.AircraftModel, 
                            a.Manufacturer, 
                            a.YearManufactured, 
                            a.Capacity, 
                            a.AircraftCondition, 
                            a.EngineHours, 
                            a.FuelType, 
                            a.SellerID, 
                            u.Username, 
                            a.TransactionType, 
                            a.RentalPrice, 
                            a.PurchasePrice, 
                            a.ImageURL, 
                            a.Description 
                        FROM Aircraft a
                        LEFT JOIN Users u ON a.SellerID = u.UserID
                        WHERE a.AircraftID = @AircraftID AND a.Status = 'Available'";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string aircraftModel = reader["AircraftModel"].ToString();
                        string manufacturer = reader["Manufacturer"].ToString();
                        string yearManufactured = reader["YearManufactured"].ToString();
                        string capacity = reader["Capacity"].ToString();
                        string aircraftCondition = reader["AircraftCondition"].ToString();
                        string engineHours = reader["EngineHours"].ToString();
                        string fuelType = reader["FuelType"].ToString();
                        string sellerID = reader["SellerID"].ToString();
                        string sellerUsername = reader["Username"].ToString();
                        string transactionType = reader["TransactionType"].ToString();
                        decimal rentalPrice = reader["RentalPrice"] != DBNull.Value ? Convert.ToDecimal(reader["RentalPrice"]) : 5000.00M;
                        decimal purchasePrice = reader["PurchasePrice"] != DBNull.Value ? Convert.ToDecimal(reader["PurchasePrice"]) : 90000000.00M;
                        string imageURL = reader["ImageURL"].ToString();
                        string description = reader["Description"] != DBNull.Value ? reader["Description"].ToString() : "No description available.";

                        // Debug: Log the description to the message label
                        lblMessage.Visible = true;

                        imgAircraft.ImageUrl = string.IsNullOrEmpty(imageURL) ? "~/Images/default-aircraft.jpg" : imageURL;
                        lblAircraftModel.Text = aircraftModel;
                        lblManufacturer.Text = manufacturer;
                        lblYearManufactured.Text = yearManufactured;
                        lblAircraftCapacity.Text = capacity;
                        lblAircraftCondition.Text = aircraftCondition;
                        lblEngineHours.Text = engineHours;
                        lblFuelType.Text = fuelType;
                        lblSellerUsername.Text = string.IsNullOrEmpty(sellerUsername) ? "Unknown Seller" : sellerUsername;
                        lblTransactionType.Text = transactionType;
                        lblAircraftPrice.Text = transactionType == "Rent" ? rentalPrice.ToString("N2") : purchasePrice.ToString("N2");
                        lblAircraftDescription.Text = description;

                        hdnAircraftID.Value = aircraftId.ToString();
                        hdnAircraftModel.Value = aircraftModel;
                        hdnManufacturer.Value = manufacturer;
                        hdnYearManufactured.Value = yearManufactured;
                        hdnCapacity.Value = capacity;
                        hdnAircraftCondition.Value = aircraftCondition;
                        hdnEngineHours.Value = engineHours;
                        hdnFuelType.Value = fuelType;
                        hdnSellerID.Value = sellerID;
                        hdnSellerUsername.Value = sellerUsername;
                        hdnTransactionType.Value = transactionType;
                        hdnRentalPrice.Value = rentalPrice.ToString("N2");
                        hdnPurchasePrice.Value = purchasePrice.ToString("N2");
                        hdnImageURL.Value = imageURL;
                        hdnDescription.Value = description;

                        Session["AircraftModel"] = aircraftModel;
                        Session["Manufacturer"] = manufacturer;
                        Session["YearManufactured"] = yearManufactured;
                        Session["Capacity"] = capacity;
                        Session["AircraftCondition"] = aircraftCondition;
                        Session["EngineHours"] = engineHours;
                        Session["FuelType"] = fuelType;
                        Session["SellerID"] = sellerID;
                        Session["SellerUsername"] = sellerUsername;
                        Session["TransactionType"] = transactionType;
                        Session["RentalPrice"] = rentalPrice;
                        Session["PurchasePrice"] = purchasePrice;
                        Session["ImageURL"] = imageURL;
                        Session["Description"] = description;
                    }
                    else
                    {
                        lblMessage.Text = "Selected aircraft is not available.";
                        lblMessage.Visible = true;
                        btnProceedToBooking.Enabled = false;
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading aircraft info: " + ex.Message;
                lblMessage.Visible = true;
                btnProceedToBooking.Enabled = false;
            }
        }
    }
}