using PayPal.Log;
using System;
using System.ComponentModel;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class SellAircraft : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Text = "";
                EnableViewStateForControls();
            }
            else
            {
                RestoreSelections();
            }
        }

        private void EnableViewStateForControls()
        {
            FormPanel.EnableViewState = true;
            hfSellerType.EnableViewState = true;
            hfPaymentMethods.EnableViewState = true;
            hfAircraftTypes.EnableViewState = true;
            txtSellingExperience.EnableViewState = true;
            txtCompanyName.EnableViewState = true;
            txtCompanyAge.EnableViewState = true;
            ddlContactMethod.EnableViewState = true;
            txtContactInfo.EnableViewState = true;
            ddlSellingOnBehalf.EnableViewState = true;
            ddlIsOwner.EnableViewState = true;
            ddlAircraftOwnershipCount.EnableViewState = true;
            ddlManufacturer.EnableViewState = true;
            txtCustomAircraftModel.EnableViewState = true;
            txtCustomManufacturer.EnableViewState = true;
        }

        private void RestoreSelections()
        {
            string sellerType = hfSellerType.Value;
            if (!string.IsNullOrEmpty(sellerType))
            {
                pnlIndividual.Visible = sellerType == "Individual";
                pnlCompany.Visible = sellerType == "Company";
            }
        }

        private bool ValidateGroup(string validationGroup)
        {
            foreach (IValidator validator in Page.Validators)
            {
                BaseValidator baseValidator = validator as BaseValidator;
                if (baseValidator != null && baseValidator.ValidationGroup == validationGroup)
                {
                    validator.Validate();
                    if (!validator.IsValid)
                    {
                        lblMessage.Text += validator.ErrorMessage + " ";
                        return false;
                    }
                }
            }
            return true;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            bool sellerTypeValid = ValidateGroup("SellerTypeValidation");
            string sellerType = hfSellerType.Value;

            bool individualValid = true;
            bool emailOrPhoneValid = true;
            bool companyValid = true;

            if (sellerType == "Individual")
            {
                individualValid = ValidateGroup("IndividualValidation");
                if (!individualValid)
                {
                    lblMessage.Text += "Individual validation failed. ";
                }
                if (ddlContactMethod.SelectedValue == "Email")
                {
                    emailOrPhoneValid = ValidateGroup("EmailValidation");
                    if (!emailOrPhoneValid)
                    {
                        lblMessage.Text += "Email validation failed. ";
                    }
                }
                else if (ddlContactMethod.SelectedValue == "Phone" || ddlContactMethod.SelectedValue == "WhatsApp")
                {
                    emailOrPhoneValid = ValidateGroup("PhoneValidation");
                    if (!emailOrPhoneValid)
                    {
                        lblMessage.Text += "Phone/WhatsApp validation failed. ";
                    }
                }
            }
            else if (sellerType == "Company")
            {
                companyValid = ValidateGroup("CompanyValidation");
                if (!companyValid)
                {
                    lblMessage.Text += "Company validation failed. ";
                }
            }

            bool commonValid = ValidateGroup("CommonValidation");
            if (!commonValid)
            {
                lblMessage.Text += "Common validation failed. ";
            }

            string transactionType = hfTransactionType.Value;
            bool priceValid = true;

            if (transactionType == "Buy")
            {
                rfvRentalPrice.Enabled = false;
                rvRentalPrice.Enabled = false;
                rfvPurchasePrice.Enabled = true;
                rvPurchasePrice.Enabled = true;

                if (string.IsNullOrEmpty(txtPurchasePrice.Text))
                {
                    priceValid = false;
                    lblMessage.Text += "Purchase Price is required for Buy transactions. ";
                }
            }
            else if (transactionType == "Rent")
            {
                rfvPurchasePrice.Enabled = false;
                rvPurchasePrice.Enabled = false;
                rfvRentalPrice.Enabled = true;
                rvRentalPrice.Enabled = true;

                if (string.IsNullOrEmpty(txtRentalPrice.Text))
                {
                    priceValid = false;
                    lblMessage.Text += "Rental Price is required for Rent transactions. ";
                }
            }

            commonValid = ValidateGroup("CommonValidation");
            if (!commonValid)
            {
                lblMessage.Text += "Common validation failed after price validation. ";
            }

            bool isValid = sellerTypeValid && individualValid && emailOrPhoneValid && companyValid && commonValid && priceValid;
            if (!sellerTypeValid)
            {
                lblMessage.Text += "Seller type validation failed. ";
            }

            if (isValid && ddlAircraftModel.SelectedValue == "Other" && string.IsNullOrEmpty(txtCustomAircraftModel.Text))
            {
                isValid = false;
                lblMessage.Text += "Custom Aircraft Model is required when 'Other' is selected. ";
            }

            if (isValid && ddlManufacturer.SelectedValue == "Other" && string.IsNullOrEmpty(txtCustomManufacturer.Text))
            {
                isValid = false;
                lblMessage.Text += "Custom Manufacturer is required when 'Other' is selected. ";
            }

            if (!isValid)
            {
                lblMessage.CssClass = "text-danger mt-3 d-block";
                RestoreSelections();
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                string licensesDir = Server.MapPath("/images/Licenses/");
                string photosDir = Server.MapPath("/images/Photos/");

                if (!Directory.Exists(licensesDir))
                {
                    Directory.CreateDirectory(licensesDir);
                }
                if (!Directory.Exists(photosDir))
                {
                    Directory.CreateDirectory(photosDir);
                }

                string licensePath = null;
                if (fuLicense.HasFile)
                {
                    string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuLicense.PostedFile.FileName);
                    string savePath = Path.Combine(licensesDir, fileName);
                    fuLicense.SaveAs(savePath);
                    licensePath = "/images/Licenses/" + fileName;
                }

                string photosPath = null;
                if (fuPhotos.HasFile)
                {
                    string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuPhotos.PostedFile.FileName);
                    string savePath = Path.Combine(photosDir, fileName);
                    fuPhotos.SaveAs(savePath);
                    photosPath = "/images/Photos/" + fileName;
                }

                string aircraftModel = ddlAircraftModel.SelectedValue;
                if (aircraftModel == "Other")
                {
                    aircraftModel = txtCustomAircraftModel.Text;
                }

                string manufacturer = ddlManufacturer.SelectedValue;
                if (manufacturer == "Other")
                {
                    manufacturer = txtCustomManufacturer.Text;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (var transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            string insertQuery = @"INSERT INTO SellerApplications (
                                UserID, SellerType, SellingExperience, CompanyName, SellingOnBehalf, 
                                IsOwner, CompanyAge, AircraftOwnership, ContactMethod, ContactInfo, 
                                PaymentMethod, AircraftTypes, Manufacturer, AircraftModel, YearManufactured, EngineHours, 
                                FuelType, Capacity, AircraftCondition, Description, TransactionType, 
                                PurchasePrice, RentalPrice, LicensePath, ImageURL, Status, CreatedAt)
                                VALUES (
                                @UserID, @SellerType, @SellingExperience, @CompanyName, @SellingOnBehalf, 
                                @IsOwner, @CompanyAge, @AircraftOwnership, @ContactMethod, @ContactInfo, 
                                @PaymentMethod, @AircraftTypes, @Manufacturer, @AircraftModel, @YearManufactured, @EngineHours, 
                                @FuelType, @Capacity, @AircraftCondition, @Description, @TransactionType, 
                                @PurchasePrice, @RentalPrice, @LicensePath, @ImageURL, @Status, @CreatedAt)";

                            using (SqlCommand cmd = new SqlCommand(insertQuery, conn, transaction))
                            {
                                if (Session["UserID"] == null)
                                {
                                    throw new Exception("UserID not found in session. Please ensure the user is logged in.");
                                }
                                cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                                cmd.Parameters.AddWithValue("@SellerType", sellerType);
                                cmd.Parameters.AddWithValue("@SellingExperience", sellerType == "Individual" && !string.IsNullOrEmpty(txtSellingExperience.Text) ? Convert.ToInt32(txtSellingExperience.Text) : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@CompanyName", sellerType == "Company" ? txtCompanyName.Text : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@SellingOnBehalf", sellerType == "Company" ? ddlSellingOnBehalf.SelectedValue : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@IsOwner", sellerType == "Company" ? ddlIsOwner.SelectedValue : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@CompanyAge", sellerType == "Company" && !string.IsNullOrEmpty(txtCompanyAge.Text) ? Convert.ToInt32(txtCompanyAge.Text) : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@AircraftOwnership", sellerType == "Company" ? ddlAircraftOwnershipCount.SelectedValue : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@ContactMethod", sellerType == "Individual" ? ddlContactMethod.SelectedValue : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@ContactInfo", sellerType == "Individual" ? txtContactInfo.Text : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@PaymentMethod", hfPaymentMethods.Value);
                                cmd.Parameters.AddWithValue("AircraftTypes", hfAircraftTypes.Value);
                                cmd.Parameters.AddWithValue("@Manufacturer", manufacturer);
                                cmd.Parameters.AddWithValue("@AircraftModel", aircraftModel);
                                cmd.Parameters.AddWithValue("@YearManufactured", Convert.ToInt32(txtYearManufactured.Text));
                                cmd.Parameters.AddWithValue("@EngineHours", Convert.ToInt32(txtEngineHours.Text));
                                cmd.Parameters.AddWithValue("@FuelType", ddlFuelType.SelectedValue);
                                cmd.Parameters.AddWithValue("@Capacity", Convert.ToInt32(txtCapacity.Text));
                                cmd.Parameters.AddWithValue("@AircraftCondition", ddlAircraftCondition.SelectedValue);
                                cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                                cmd.Parameters.AddWithValue("@TransactionType", hfTransactionType.Value);
                                cmd.Parameters.AddWithValue("@PurchasePrice", hfTransactionType.Value == "Buy" && !string.IsNullOrEmpty(txtPurchasePrice.Text) ? Convert.ToDecimal(txtPurchasePrice.Text) : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@RentalPrice", hfTransactionType.Value == "Rent" && !string.IsNullOrEmpty(txtRentalPrice.Text) ? Convert.ToDecimal(txtRentalPrice.Text) : (object)DBNull.Value);
                                cmd.Parameters.AddWithValue("@LicensePath", (object)licensePath ?? DBNull.Value);
                                cmd.Parameters.AddWithValue("@ImageURL", (object)photosPath ?? DBNull.Value);
                                cmd.Parameters.AddWithValue("@Status", "Pending");
                                cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);

                                cmd.ExecuteNonQuery();
                            }

                            if (Session["UserID"] != null)
                            {
                                string userId = Session["UserID"].ToString();
                                string updateQuery = "UPDATE Users SET SellerRole = 'ON' WHERE UserID = @UserID";

                                using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn, transaction))
                                {
                                    updateCmd.Parameters.AddWithValue("@UserID", userId);
                                    int rowsAffected = updateCmd.ExecuteNonQuery();

                                    if (rowsAffected == 0)
                                    {
                                        throw new Exception("User not found or SellerRole update failed.");
                                    }
                                }
                            }

                            transaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            lblMessage.Text = "Error submitting application: " + ex.Message;
                            lblMessage.CssClass = "text-danger mt-3 d-block";
                            return;
                        }
                    }
                    conn.Close();
                }

                lblMessage.Text = "Application submitted successfully! Redirecting to dashboard...";
                lblMessage.CssClass = "text-success mt-3 d-block";
                ClientScript.RegisterStartupScript(this.GetType(), "redirect", "setTimeout(function(){ window.location.href = 'SellerDashboard.aspx'; }, 2000);", true);
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error submitting application: " + ex.Message;
                lblMessage.CssClass = "text-danger mt-3 d-block";
            }
        }

        protected void cvSellerType_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !string.IsNullOrEmpty(hfSellerType.Value);
        }

        protected void cvPaymentMethods_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !string.IsNullOrEmpty(hfPaymentMethods.Value);
        }

        protected void cvAircraftTypes_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !string.IsNullOrEmpty(hfAircraftTypes.Value);
        }

        protected void cvPhotos_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (!fuPhotos.HasFile)
            {
                lblMessage.Text += "Server-side: No photo detected. ";
                args.IsValid = false;
                return;
            }

            var file = fuPhotos.PostedFile;
            lblMessage.Text += "Server-side: Found 1 photo. ";

            const long maxFileSize = 5 * 1024 * 1024;
            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png" };

            string extension = Path.GetExtension(file.FileName).ToLower();
            lblMessage.Text += "Server-side: Photo extension " + extension + ", size " + file.ContentLength + ". ";
            if (!allowedExtensions.Contains(extension))
            {
                args.IsValid = false;
                return;
            }
            if (file.ContentLength > maxFileSize)
            {
                args.IsValid = false;
                return;
            }

            args.IsValid = true;
        }

        protected void cvLicense_ServerValidate(object source, ServerValidateEventArgs args)
        {
            if (hfSellerType.Value == "Company")
            {
                args.IsValid = true;
                return;
            }

            if (!fuLicense.HasFile)
            {
                lblMessage.Text += "Server-side: No license file detected. ";
                args.IsValid = false;
                return;
            }

            string extension = Path.GetExtension(fuLicense.FileName).ToLower();
            lblMessage.Text += "Server-side: License extension is " + extension + ". ";
            args.IsValid = extension == ".pdf" || extension == ".doc" || extension == ".docx";
        }

        protected void cvDescriptionLength_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string description = txtDescription.Text;
            args.IsValid = !string.IsNullOrEmpty(description) && description.Length >= 30;
            if (!args.IsValid)
            {
                lblMessage.Text += "Server-side: Description must be at least 30 characters. ";
            }
        }

        private void ClearForm()
        {
            hfSellerType.Value = "";
            txtSellingExperience.Text = "";
            txtCompanyName.Text = "";
            ddlSellingOnBehalf.SelectedIndex = 0;
            ddlIsOwner.SelectedIndex = 0;
            txtCompanyAge.Text = "";
            ddlAircraftOwnershipCount.SelectedIndex = 0;
            ddlContactMethod.SelectedIndex = 0;
            txtContactInfo.Text = "";
            hfPaymentMethods.Value = "";
            hfAircraftTypes.Value = "";
            ddlManufacturer.SelectedIndex = 0;
            txtCustomManufacturer.Text = "";
            ddlAircraftModel.SelectedIndex = 0;
            txtCustomAircraftModel.Text = "";
            txtYearManufactured.Text = "";
            txtEngineHours.Text = "";
            ddlFuelType.SelectedIndex = 0;
            txtCapacity.Text = "";
            ddlAircraftCondition.SelectedIndex = 0;
            txtDescription.Text = "";
            hfTransactionType.Value = "Rent";
            txtPurchasePrice.Text = "";
            txtRentalPrice.Text = "";
            pnlIndividual.Visible = false;
            pnlCompany.Visible = false;
        }
    }
}