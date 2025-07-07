<%@ Page Title="Sell Aircraft - Saudi Aviation Market" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="SellAircraft.aspx.cs" Inherits="AircraftManagement.SellAircraft" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="../js/SellAircraft.js?v=<%= DateTime.Now.Ticks %>"></script>

    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet" />
    <link href="../css/SellAircraft.css?v=<%= DateTime.Now.Ticks %>" rel="stylesheet" />

    <style>
        .custom-file-upload {
            display: inline-block;
            padding: 8px 16px;
            background-color: #f8f9fa;
            border: 1px solid #ced4da;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            color: #495057;
        }
        .custom-file-upload:hover {
            background-color: #e9ecef;
        }
        .file-name {
            margin-left: 10px;
            font-size: 14px;
            color: #6c757d;
        }
        .photo-preview {
            margin-left: 20px;
            display: inline-block;
            vertical-align: top;
        }
        .photo-preview img {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #ced4da;
        }
    </style>

    <div class="container mt-5">
        <h2 class="text-center mb-4">Sell Your Aircraft</h2>
        <p class="text-center text-muted mb-5">Complete the form below to submit your seller application for the Saudi Aviation Market.</p>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Panel ID="FormPanel" runat="server" CssClass="card p-4 shadow-sm">
                    <h4 class="section-title"><i class="fas fa-user mr-2"></i>Seller Type</h4>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <asp:HiddenField ID="hfSellerType" runat="server" />
                            <div class="seller-type-boxes">
                                <div class="seller-type-box" data-type="Individual">
                                    <i class="fas fa-user fa-2x"></i>
                                    <h5>Individual</h5>
                                </div>
                                <div class="seller-type-box" data-type="Company">
                                    <i class="fas fa-building fa-2x"></i>
                                    <h5>Company</h5>
                                </div>
                            </div>
                            <asp:CustomValidator ID="cvSellerType" runat="server" ErrorMessage="Please select a seller type." 
                                CssClass="text-danger" Display="Dynamic" ClientValidationFunction="validateSellerType" 
                                OnServerValidate="cvSellerType_ServerValidate" ValidationGroup="SellerTypeValidation" />
                        </div>
                    </div>

                    <h4 class="section-title"><i class="fas fa-info-circle mr-2"></i>Seller Information</h4>
                    <asp:Panel ID="pnlIndividual" runat="server" CssClass="seller-panel" Style="display: none;">
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="fuLicense"><i class="fas fa-file-upload mr-2"></i>Upload License</label>
                                <label class="custom-file-upload">
                                    Choose File
                                    <asp:FileUpload ID="fuLicense" runat="server" CssClass="form-control-file d-none" AllowMultiple="false" />
                                </label>
                                <span class="file-name" id="fuLicenseName">No file chosen</span>
                                <asp:CustomValidator ID="cvLicense" runat="server" ErrorMessage="Please upload a license file (PDF/Word)." 
                                    CssClass="text-danger" Display="Dynamic" ClientValidationFunction="validateLicense" 
                                    OnServerValidate="cvLicense_ServerValidate" ValidationGroup="IndividualValidation" />
                                <asp:RegularExpressionValidator ID="revLicense" runat="server" ControlToValidate="fuLicense" 
                                    ValidationExpression="^.*\.(pdf|PDF|doc|DOC|docx|DOCX)$" ErrorMessage="Only PDF or Word files are allowed." 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="IndividualValidation" />
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="txtSellingExperience"><i class="fas fa-briefcase mr-2"></i>Years of Selling Experience</label>
                                <asp:TextBox ID="txtSellingExperience" runat="server" CssClass="form-control" TextMode="Number" />
                                <asp:RequiredFieldValidator ID="rfvSellingExperience" runat="server" ControlToValidate="txtSellingExperience" 
                                    ErrorMessage="Selling Experience is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="IndividualValidation" />
                                <asp:RangeValidator ID="rvSellingExperience" runat="server" ControlToValidate="txtSellingExperience" 
                                    MinimumValue="0" MaximumValue="100" Type="Integer" ErrorMessage="Enter a valid number (0-100)." 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="IndividualValidation" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="ddlContactMethod"><i class="fas fa-address-book mr-2"></i>Preferred Contact Method</label>
                                <asp:DropDownList ID="ddlContactMethod" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="" Text="Select Contact Method" />
                                    <asp:ListItem Value="Email" Text="Email" />
                                    <asp:ListItem Value="Phone" Text="Phone" />
                                    <asp:ListItem Value="WhatsApp" Text="WhatsApp" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvContactMethod" runat="server" ControlToValidate="ddlContactMethod" 
                                    ErrorMessage="Contact Method is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="IndividualValidation" />
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="txtContactInfo"><i class="fas fa-phone mr-2"></i>Contact Information</label>
                                <div class="input-group">
                                    <div class="input-group-prepend" id="phonePrefix" style="display: none;">
                                        <span class="input-group-text">[+966]</span>
                                    </div>
                                    <asp:TextBox ID="txtContactInfo" runat="server" CssClass="form-control" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvContactInfo" runat="server" ControlToValidate="txtContactInfo" 
                                    ErrorMessage="Contact Information is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="IndividualValidation" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtContactInfo" 
                                    ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" ErrorMessage="Enter a valid email address (e.g., user@domain.com)." 
                                    CssClass="text-danger" Display="Dynamic" EnableClientScript="true" ValidationGroup="EmailValidation" />
                                <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtContactInfo" 
                                    ValidationExpression="^5\d{8}$" ErrorMessage="Phone number must start with 5 and be 9 digits long (e.g., 512345678)." 
                                    CssClass="text-danger" Display="Dynamic" EnableClientScript="true" ValidationGroup="PhoneValidation" />
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlCompany" runat="server" CssClass="seller-panel" Style="display: none;">
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="txtCompanyName"><i class="fas fa-building mr-2"></i>Company Name</label>
                                <asp:TextBox ID="txtCompanyName" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="rfvCompanyName" runat="server" ControlToValidate="txtCompanyName" 
                                    ErrorMessage="Company Name is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CompanyValidation" />
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="txtCompanyAge"><i class="fas fa-calendar-alt mr-2"></i>How Long Has Your Company Existed? (Years)</label>
                                <asp:TextBox ID="txtCompanyAge" runat="server" CssClass="form-control" TextMode="Number" />
                                <asp:RequiredFieldValidator ID="rfvCompanyAge" runat="server" ControlToValidate="txtCompanyAge" 
                                    ErrorMessage="Company Age is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CompanyValidation" />
                                <asp:RangeValidator ID="rvCompanyAge" runat="server" ControlToValidate="txtCompanyAge" 
                                    MinimumValue="0" MaximumValue="100" Type="Integer" ErrorMessage="Enter a valid number (0-100)." 
                                    CssClass="text-danger" Display="Dynamic" ValidationGroup="CompanyValidation" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="ddlSellingOnBehalf"><i class="fas fa-handshake mr-2"></i>Selling on Behalf of a Business?</label>
                                <asp:DropDownList ID="ddlSellingOnBehalf" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="" Text="Select Option" />
                                    <asp:ListItem Value="Yes" Text="Yes" />
                                    <asp:ListItem Value="No" Text="No" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvSellingOnBehalf" runat="server" ControlToValidate="ddlSellingOnBehalf" 
                                    ErrorMessage="This field is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CompanyValidation" />
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="ddlIsOwner"><i class="fas fa-user-tie mr-2"></i>Are You the Owner?</label>
                                <asp:DropDownList ID="ddlIsOwner" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="" Text="Select Option" />
                                    <asp:ListItem Value="Yes" Text="Yes" />
                                    <asp:ListItem Value="No" Text="No" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvIsOwner" runat="server" ControlToValidate="ddlIsOwner" 
                                    ErrorMessage="This field is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CompanyValidation" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="ddlAircraftOwnershipCount"><i class="fas fa-plane mr-2"></i>How Many Aircraft Do You Own?</label>
                                <asp:DropDownList ID="ddlAircraftOwnershipCount" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="" Text="Select Range" />
                                    <asp:ListItem Value="1-3" Text="1-3" />
                                    <asp:ListItem Value="3-10" Text="3-10" />
                                    <asp:ListItem Value="10-50" Text="10-50" />
                                    <asp:ListItem Value="50+" Text="50+" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvAircraftOwnershipCount" runat="server" ControlToValidate="ddlAircraftOwnershipCount" 
                                    ErrorMessage="This field is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CompanyValidation" />
                            </div>
                        </div>
                    </asp:Panel>

                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label><i class="fas fa-credit-card mr-2"></i>Payment Method Preferences</label>
                            <asp:HiddenField ID="hfPaymentMethods" runat="server" />
                            <div class="payment-method-boxes">
                                <div class="payment-method-box" data-method="PayPal">
                                    <i class="fab fa-paypal fa-2x"></i>
                                    <span>PayPal</span>
                                </div>
                                <div class="payment-method-box" data-method="Credit Card">
                                    <i class="fas fa-credit-card fa-2x"></i>
                                    <span>Credit Card</span>
                                </div>
                                <div class="payment-method-box" data-method="Cash">
                                    <i class="fas fa-money-bill fa-2x"></i>
                                    <span>Cash</span>
                                </div>
                                <div class="payment-method-box" data-method="STC Pay">
                                    <i class="fas fa-mobile-alt fa-2x"></i>
                                    <span>STC Pay</span>
                                </div>
                                <div class="payment-method-box" data-method="Apple Pay">
                                    <i class="fab fa-apple-pay fa-2x"></i>
                                    <span>Apple Pay</span>
                                </div>
                            </div>
                            <asp:CustomValidator ID="cvPaymentMethods" runat="server" ErrorMessage="Select at least one payment method." 
                                CssClass="text-danger" Display="Dynamic" ClientValidationFunction="validatePaymentMethods" 
                                OnServerValidate="cvPaymentMethods_ServerValidate" ValidationGroup="CommonValidation" />
                        </div>
                        <div class="col-md-6 form-group">
                            <label><i class="fas fa-plane-departure mr-2"></i>Aircraft Types You Know</label>
                            <asp:HiddenField ID="hfAircraftTypes" runat="server" />
                            <div class="aircraft-type-boxes">
                                <div class="aircraft-type-box" data-type="Boeing 737">
                                    <i class="fas fa-plane fa-2x"></i>
                                    <span>Boeing 737</span>
                                </div>
                                <div class="aircraft-type-box" data-type="Airbus A320">
                                    <i class="fas fa-plane fa-2x"></i>
                                    <span>Airbus A320</span>
                                </div>
                                <div class="aircraft-type-box" data-type="Gulfstream G650">
                                    <i class="fas fa-plane fa-2x"></i>
                                    <span>Gulfstream G650</span>
                                </div>
                                <div class="aircraft-type-box" data-type="Cessna Citation">
                                    <i class="fas fa-plane fa-2x"></i>
                                    <span>Cessna Citation</span>
                                </div>
                                <div class="aircraft-type-box" data-type="Bombardier Global 7500">
                                    <i class="fas fa-plane fa-2x"></i>
                                    <span>Bombardier Global 7500</span>
                                </div>
                                <div class="aircraft-type-box" data-type="Embraer Phenom 300">
                                    <i class="fas fa-plane fa-2x"></i>
                                    <span>Embraer Phenom 300</span>
                                </div>
                            </div>
                            <asp:CustomValidator ID="cvAircraftTypes" runat="server" ErrorMessage="Select at least one aircraft type." 
                                CssClass="text-danger" Display="Dynamic" ClientValidationFunction="validateAircraftTypes" 
                                OnServerValidate="cvAircraftTypes_ServerValidate" ValidationGroup="CommonValidation" />
                        </div>
                    </div>

                    <h4 class="section-title"><i class="fas fa-plane mr-2"></i>Aircraft Information</h4>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="ddlAircraftModel"><i class="fas fa-plane-arrival mr-2"></i>Aircraft Model</label>
                            <asp:DropDownList ID="ddlAircraftModel" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select a model" Value="" />
                                <asp:ListItem Text="Boeing 737" Value="Boeing 737" />
                                <asp:ListItem Text="Airbus A320" Value="Airbus A320" />
                                <asp:ListItem Text="Gulfstream G650" Value="Gulfstream G650" />
                                <asp:ListItem Text="Cessna Citation" Value="Cessna Citation" />
                                <asp:ListItem Text="Bombardier Global 7500" Value="Bombardier Global 7500" />
                                <asp:ListItem Text="Embraer Phenom 300" Value="Embraer Phenom 300" />
                                <asp:ListItem Text="Other" Value="Other" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvAircraftModel" runat="server" ControlToValidate="ddlAircraftModel" 
                                ErrorMessage="Aircraft Model is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                            <asp:Panel ID="customModelPanel" runat="server" Style="display: none;">
                                <label for="txtCustomAircraftModel" class="mt-2"><i class="fas fa-plane-arrival mr-2"></i>Specify Aircraft Model</label>
                                <asp:TextBox ID="txtCustomAircraftModel" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="rfvCustomAircraftModel" runat="server" ControlToValidate="txtCustomAircraftModel" 
                                    ErrorMessage="Custom Aircraft Model is required when 'Other' is selected." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" Enabled="false" />
                            </asp:Panel>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="ddlManufacturer"><i class="fas fa-industry mr-2"></i>Manufacturer</label>
                            <asp:DropDownList ID="ddlManufacturer" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="Select Manufacturer" />
                                <asp:ListItem Value="Boeing" Text="Boeing" />
                                <asp:ListItem Value="Airbus" Text="Airbus" />
                                <asp:ListItem Value="Gulfstream" Text="Gulfstream" />
                                <asp:ListItem Value="Cessna" Text="Cessna" />
                                <asp:ListItem Value="Bombardier" Text="Bombardier" />
                                <asp:ListItem Value="Embraer" Text="Embraer" />
                                <asp:ListItem Value="Other" Text="Other" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvManufacturer" runat="server" ControlToValidate="ddlManufacturer" 
                                ErrorMessage="Manufacturer is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                            <asp:Panel ID="customManufacturerPanel" runat="server" Style="display: none;">
                                <label for="txtCustomManufacturer" class="mt-2"><i class="fas fa-industry mr-2"></i>Specify Manufacturer</label>
                                <asp:TextBox ID="txtCustomManufacturer" runat="server" CssClass="form-control" />
                                <asp:RequiredFieldValidator ID="rfvCustomManufacturer" runat="server" ControlToValidate="txtCustomManufacturer" 
                                    ErrorMessage="Custom Manufacturer is required when 'Other' is selected." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" Enabled="false" />
                            </asp:Panel>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="txtYearManufactured"><i class="fas fa-calendar-alt mr-2"></i>Year Manufactured</label>
                            <asp:TextBox ID="txtYearManufactured" runat="server" CssClass="form-control" TextMode="Number" />
                            <asp:RequiredFieldValidator ID="rfvYearManufactured" runat="server" ControlToValidate="txtYearManufactured" 
                                ErrorMessage="Year Manufactured is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                            <asp:RangeValidator ID="rvYearManufactured" runat="server" ControlToValidate="txtYearManufactured" 
                                MinimumValue="1970" MaximumValue="2025" Type="Integer" ErrorMessage="Enter a valid year (1970-2025)." 
                                CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="txtEngineHours"><i class="fas fa-tachometer-alt mr-2"></i>Engine Hours</label>
                            <asp:TextBox ID="txtEngineHours" runat="server" CssClass="form-control" TextMode="Number" />
                            <asp:RequiredFieldValidator ID="rfvEngineHours" runat="server" ControlToValidate="txtEngineHours" 
                                ErrorMessage="Engine Hours is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                            <asp:RangeValidator ID="rvEngineHours" runat="server" ControlToValidate="txtEngineHours" 
                                MinimumValue="0" MaximumValue="100000" Type="Integer" ErrorMessage="Enter a valid number (0-100000)." 
                                CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="ddlFuelType"><i class="fas fa-gas-pump mr-2"></i>Fuel Type</label>
                            <asp:DropDownList ID="ddlFuelType" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="Select Fuel Type" />
                                <asp:ListItem Value="Jet Fuel" Text="Jet Fuel" />
                                <asp:ListItem Value="Avgas" Text="Avgas" />
                                <asp:ListItem Value="Sustainable Aviation Fuel (SAF)" Text="Sustainable Aviation Fuel (SAF)" />
                                <asp:ListItem Value="Biofuel" Text="Biofuel" />
                                <asp:ListItem Value="Mogas" Text="Mogas" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvFuelType" runat="server" ControlToValidate="ddlFuelType" 
                                ErrorMessage="Fuel Type is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="txtCapacity"><i class="fas fa-chair mr-2"></i>Capacity</label>
                            <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" TextMode="Number" />
                            <asp:RequiredFieldValidator ID="rfvCapacity" runat="server" ControlToValidate="txtCapacity" 
                                ErrorMessage="Capacity is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                            <asp:RangeValidator ID="rvCapacity" runat="server" ControlToValidate="txtCapacity" 
                                MinimumValue="1" MaximumValue="500" Type="Integer" ErrorMessage="Enter a valid number (1-500)." 
                                CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="ddlAircraftCondition"><i class="fas fa-tools mr-2"></i>Aircraft Condition</label>
                            <asp:DropDownList ID="ddlAircraftCondition" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="Select Condition" />
                                <asp:ListItem Value="New" Text="New" />
                                <asp:ListItem Value="Used" Text="Used" />
                                <asp:ListItem Value="Refurbished" Text="Refurbished" />
                                <asp:ListItem Value="Needs Repair" Text="Needs Repair" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvAircraftCondition" runat="server" ControlToValidate="ddlAircraftCondition" 
                                ErrorMessage="Aircraft Condition is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 form-group">
                            <label for="txtDescription"><i class="fas fa-align-left mr-2"></i>Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                            <div>
                                <span id="descriptionCounter" class="text-muted">0/30</span>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription" 
                                ErrorMessage="Description is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                            <asp:CustomValidator ID="cvDescriptionLength" runat="server" ControlToValidate="txtDescription" 
                                ErrorMessage="Description must be at least 30 characters." CssClass="text-danger" Display="Dynamic" 
                                ClientValidationFunction="validateDescriptionLength" OnServerValidate="cvDescriptionLength_ServerValidate" 
                                ValidationGroup="CommonValidation" />
                            <asp:RegularExpressionValidator ID="revDescription" runat="server" ControlToValidate="txtDescription" 
                                ValidationExpression="^(?!\s*$).+" ErrorMessage="Description cannot be only whitespace." 
                                CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label><i class="fas fa-handshake mr-2"></i>Transaction Type</label>
                            <asp:HiddenField ID="hfTransactionType" runat="server" Value="Rent" />
                            <asp:DropDownList ID="ddlTransactionType" runat="server" CssClass="form-control transaction-type-dropdown">
                                <asp:ListItem Value="Rent" Text="Rent" Selected="True" />
                                <asp:ListItem Value="Buy" Text="Buy" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvTransactionType" runat="server" ControlToValidate="ddlTransactionType" 
                                ErrorMessage="Please select a transaction type." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" />
                        </div>
                        <div class="col-md-6 form-group price-field" id="buyPricePanel" style="display: none;">
                            <label for="txtPurchasePrice"><i class="fas fa-money-bill mr-2"></i>Purchase Price (SAR)</label>
                            <asp:TextBox ID="txtPurchasePrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" />
                            <asp:RequiredFieldValidator ID="rfvPurchasePrice" runat="server" ControlToValidate="txtPurchasePrice" 
                                ErrorMessage="Purchase Price is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" Enabled="false" />
                            <asp:RangeValidator ID="rvPurchasePrice" runat="server" ControlToValidate="txtPurchasePrice" 
                                MinimumValue="100000" MaximumValue="99999999999" Type="Double" ErrorMessage="Enter a valid price (100,000-99,999,999,999)." 
                                CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" Enabled="false" />
                        </div>
                        <div class="col-md-6 form-group price-field" id="rentPricePanel">
                            <label for="txtRentalPrice"><i class="fas fa-money-bill mr-2"></i>Rental Price (SAR per month)</label>
                            <asp:TextBox ID="txtRentalPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" />
                            <asp:RequiredFieldValidator ID="rfvRentalPrice" runat="server" ControlToValidate="txtRentalPrice" 
                                ErrorMessage="Rental Price is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" Enabled="true" />
                            <asp:RangeValidator ID="rvRentalPrice" runat="server" ControlToValidate="txtRentalPrice" 
                                MinimumValue="1000" MaximumValue="10000000" Type="Double" ErrorMessage="Enter a valid price (1,000-10,000,000)." 
                                CssClass="text-danger" Display="Dynamic" ValidationGroup="CommonValidation" Enabled="true" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 form-group d-flex align-items-start">
                            <div>
                                <label for="fuPhotos"><i class="fas fa-camera mr-2"></i>Upload Photo (JPG/PNG, max 5MB, this photo will be shown to customers)</label>
                                <label class="custom-file-upload">
                                    Choose File
                                    <asp:FileUpload ID="fuPhotos" runat="server" CssClass="form-control-file d-none" AllowMultiple="false" />
                                </label>
                                <span class="file-name" id="fuPhotosName">No file chosen</span>
                                <asp:CustomValidator ID="cvPhotos" runat="server" ErrorMessage="Please upload one photo (JPG/PNG, max 5MB)." 
                                    CssClass="text-danger" Display="Dynamic" ClientValidationFunction="validatePhotos" 
                                    OnServerValidate="cvPhotos_ServerValidate" ValidationGroup="CommonValidation" />
                            </div>
                            <div id="photoPreview" class="photo-preview"></div>
                        </div>
                    </div>

                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Application" CssClass="btn btn-primary btn-block mt-4" 
                        OnClick="btnSubmit_Click" CausesValidation="false" />
                    <asp:Label ID="lblMessage" runat="server" CssClass="mt-3 d-block" />
                </asp:Panel>
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btnSubmit" />
            </Triggers>
        </asp:UpdatePanel>
    </div>

    <script type="text/javascript">
        var fuLicenseClientID = '<%= fuLicense.ClientID %>';
        var ddlContactMethodClientID = '<%= ddlContactMethod.ClientID %>';
        var txtContactInfoClientID = '<%= txtContactInfo.ClientID %>';
        var revEmailClientID = '<%= revEmail.ClientID %>';
        var revPhoneClientID = '<%= revPhone.ClientID %>';
        var phonePrefixID = 'phonePrefix';
        var ddlAircraftModelClientID = '<%= ddlAircraftModel.ClientID %>';
        var customModelPanelClientID = '<%= customModelPanel.ClientID %>';
        var txtCustomAircraftModelClientID = '<%= txtCustomAircraftModel.ClientID %>';
        var rfvCustomAircraftModelClientID = '<%= rfvCustomAircraftModel.ClientID %>';
        var ddlManufacturerClientID = '<%= ddlManufacturer.ClientID %>';
        var customManufacturerPanelClientID = '<%= customManufacturerPanel.ClientID %>';
        var txtCustomManufacturerClientID = '<%= txtCustomManufacturer.ClientID %>';
        var rfvCustomManufacturerClientID = '<%= rfvCustomManufacturer.ClientID %>';
        var rfvManufacturerClientID = '<%= rfvManufacturer.ClientID %>';
        var hfSellerTypeClientID = '<%= hfSellerType.ClientID %>';
        var pnlIndividualClientID = '<%= pnlIndividual.ClientID %>';
        var pnlCompanyClientID = '<%= pnlCompany.ClientID %>';
        var hfPaymentMethodsClientID = '<%= hfPaymentMethods.ClientID %>';
        var hfAircraftTypesClientID = '<%= hfAircraftTypes.ClientID %>';
        var hfTransactionTypeClientID = '<%= hfTransactionType.ClientID %>';
        var ddlTransactionTypeClientID = '<%= ddlTransactionType.ClientID %>';
        var txtPurchasePriceClientID = '<%= txtPurchasePrice.ClientID %>';
        var txtRentalPriceClientID = '<%= txtRentalPrice.ClientID %>';
        var rfvPurchasePriceClientID = '<%= rfvPurchasePrice.ClientID %>';
        var rvPurchasePriceClientID = '<%= rvPurchasePrice.ClientID %>';
        var rfvRentalPriceClientID = '<%= rfvRentalPrice.ClientID %>';
        var rvRentalPriceClientID = '<%= rvRentalPrice.ClientID %>';
        var fuPhotosClientID = '<%= fuPhotos.ClientID %>';
        var photoPreviewID = 'photoPreview';
        var btnSubmitClientID = '<%= btnSubmit.ClientID %>';
        var formPanelClientID = '<%= FormPanel.ClientID %>';
        var lblMessageClientID = '<%= lblMessage.ClientID %>';
        var cvSellerTypeClientID = '<%= cvSellerType.ClientID %>';
        var cvLicenseClientID = '<%= cvLicense.ClientID %>';
        var txtDescriptionClientID = '<%= txtDescription.ClientID %>';
        var cvDescriptionLengthClientID = '<%= cvDescriptionLength.ClientID %>';
        var descriptionCounterID = 'descriptionCounter';

        $(document).ready(function () {
            $('#' + txtDescriptionClientID).on('input', function () {
                var textLength = $(this).val().length;
                $('#' + descriptionCounterID).text(textLength + '/30');
                if (textLength >= 30) {
                    $('#' + descriptionCounterID).hide();
                } else {
                    $('#' + descriptionCounterID).show();
                }
            });

            $('#' + fuLicenseClientID).change(function () {
                var fileName = this.files.length > 0 ? this.files[0].name : 'No file chosen';
                $('#fuLicenseName').text(fileName);
            });

            $('#' + fuPhotosClientID).change(function () {
                var fileName = this.files.length > 0 ? this.files[0].name : 'No file chosen';
                $('#fuPhotosName').text(fileName);
            });
        });
    </script>
</asp:Content>