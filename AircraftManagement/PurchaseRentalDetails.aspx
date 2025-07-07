<%@ Page Title="Booking Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="PurchaseRentalDetails.aspx.cs" Inherits="AircraftManagement.PurchaseRentalDetails" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/flatpickr@4.6.13/dist/flatpickr.min.js"></script>
    <script src="/js/PurchaseRentalDetails.js"></script>
    <link rel="stylesheet" type="text/css" href='<%= ResolveClientUrl("~/css/PurchaseRentalCommon.css") %>' />
    <link rel="stylesheet" type="text/css" href='<%= ResolveClientUrl("~/css/PurchaseRentalDetails.css") %>' />

    <div class="container mt-5">
        <asp:Label ID="lblMessage" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
        <h2><i class="fas fa-plane"></i> Aircraft Booking - Step 2</h2>

        <div class="step-progress">
            <div class="step-connector"></div>
            <div class="step" id="step1">Select Aircraft</div>
            <div class="step active" id="step2">Booking Details</div>
            <div class="step" id="step3">Payment</div>
        </div>

        <!-- Step 2: Booking Details -->
        <div id="step2Content" class="step-content">
            <div class="booking-details-box">
                <h4><i class="fas fa-calendar-check"></i> Booking Details</h4>
                <div class="booking-details-grid">
                    <div>
                        <div class="date-row">
                            <div class="date-group form-group">
                                <label class="form-label required"><i class="far fa-calendar-alt"></i> Start Date</label>
                                <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control flatpickr-input" ClientIDMode="Static" />
                                <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="txtStartDate" ErrorMessage="Start date is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="Step2" />
                            </div>
                            <div class="date-group form-group">
                                <label class="form-label required"><i class="far fa-calendar-alt"></i> End Date</label>
                                <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control flatpickr-input" ClientIDMode="Static" />
                                <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="txtEndDate" ErrorMessage="End date is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="Step2" />
                                <asp:CompareValidator ID="cvDates" runat="server" ControlToValidate="txtEndDate" ControlToCompare="txtStartDate" Operator="GreaterThanEqual" Type="Date" ErrorMessage="End date must be after start date" CssClass="text-danger" Display="Dynamic" ValidationGroup="Step2" />
                            </div>
                        </div>

                        <div class="customer-row">
                            <div class="customer-group form-group">
                                <label class="form-label required"><i class="fas fa-user"></i> Customer Type</label>
                                <asp:DropDownList ID="ddlCustomerType" runat="server" CssClass="form-control" ClientIDMode="Static" onchange="updateCompanyOptions(); updatePassengerOptions(); updatePrice();">
                                    <asp:ListItem Text="Individual" Value="Individual" Selected="True" />
                                    <asp:ListItem Text="Company" Value="Company" />
                                </asp:DropDownList>
                            </div>
                            <div class="customer-group form-group">
                                <label class="form-label required"><i class="fas fa-user-friends"></i> Number of Passengers</label>
                                <asp:DropDownList ID="ddlNumberOfPassengers" runat="server" CssClass="form-control" ClientIDMode="Static" onchange="updatePrice();">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvNumberOfPassengers" runat="server" ControlToValidate="ddlNumberOfPassengers" InitialValue="" ErrorMessage="Number of passengers is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="Step2" />
                            </div>
                        </div>

                        <asp:Panel ID="companyOptions" runat="server" CssClass="company-options" Style="display:none;" ClientIDMode="Static">
                            <div class="form-group">
                                <label class="form-label required"><i class="fas fa-building"></i> Company Name</label>
                                <asp:TextBox ID="txtCompanyName" runat="server" CssClass="form-control" placeholder="e.g., ABC Corp" ClientIDMode="Static" />
                                <asp:RequiredFieldValidator ID="rfvCompanyName" runat="server" ControlToValidate="txtCompanyName" ErrorMessage="Company name is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="Step2" Enabled="false" ClientIDMode="Static" />
                            </div>
                            <div class="form-group">
                                <label class="form-label required"><i class="fas fa-user-tie"></i> Company Representative</label>
                                <asp:TextBox ID="txtCompanyRepresentative" runat="server" CssClass="form-control" placeholder="e.g., John Doe" ClientIDMode="Static" />
                                <asp:RequiredFieldValidator ID="rfvCompanyRepresentative" runat="server" ControlToValidate="txtCompanyRepresentative" ErrorMessage="Company representative is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="Step2" Enabled="false" ClientIDMode="Static" />
                            </div>
                        </asp:Panel>

                        <div class="form-group">
                            <label class="form-label required"><i class="fas fa-info-circle"></i> Purpose of Use</label>
                            <asp:TextBox ID="txtPurposeOfUse" runat="server" CssClass="form-control" placeholder="e.g., Business Trip" ClientIDMode="Static" />
                            <asp:RequiredFieldValidator ID="rfvPurposeOfUse" runat="server" ControlToValidate="txtPurposeOfUse" ErrorMessage="Purpose of use is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="Step2" ClientIDMode="Static" />
                        </div>
                    </div>

                    <div>
                        <div class="service-box">
                            <h5><i class="fas fa-cogs"></i> Extra Services</h5>
                            <div class="feature-options">
                                <div class="feature-option">
                                    <asp:CheckBox ID="chkMeals" runat="server" ClientIDMode="Static" onchange="updatePrice();" />
                                    <label for="chkMeals"><i class="fas fa-utensils"></i> In-flight Meals <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+375)</span></label>
                                </div>
                                <div class="feature-option">
                                    <asp:CheckBox ID="chkWiFi" runat="server" ClientIDMode="Static" onchange="updatePrice();" />
                                    <label for="chkWiFi"><i class="fas fa-wifi"></i> WiFi <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+188)</span></label>
                                </div>
                                <div class="feature-option">
                                    <asp:CheckBox ID="chkBoarding" runat="server" ClientIDMode="Static" onchange="updatePrice();" />
                                    <label for="chkBoarding"><i class="fas fa-plane-departure"></i> Priority Boarding <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+281)</span></label>
                                </div>
                                <div class="feature-option">
                                    <asp:CheckBox ID="chkInsurance" runat="server" ClientIDMode="Static" onchange="updatePrice();" Checked="true" Enabled="false" />
                                    <label for="chkInsurance"><i class="fas fa-shield-alt"></i> Basic Insurance <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+300)</span></label>
                                </div>
                            </div>
                        </div>

                        <div class="service-box">
                            <h5><i class="fas fa-briefcase"></i> Business Package</h5>
                            <div class="feature-options">
                                <div class="feature-option">
                                    <asp:CheckBox ID="chkConcierge" runat="server" ClientIDMode="Static" onchange="updatePrice();" />
                                    <label for="chkConcierge"><i class="fas fa-concierge-bell"></i> Private Concierge <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+750)</span></label>
                                </div>
                                <div class="feature-option">
                                    <asp:CheckBox ID="chkCatering" runat="server" ClientIDMode="Static" onchange="updatePrice();" />
                                    <label for="chkCatering"><i class="fas fa-glass-cheers"></i> Premium Catering <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+563)</span></label>
                                </div>
                                <div class="feature-option">
                                    <asp:CheckBox ID="chkAttendant" runat="server" ClientIDMode="Static" onchange="updatePrice();" />
                                    <label for="chkAttendant"><i class="fas fa-user-shield"></i> Flight Attendant <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+938)</span></label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="service-box service-box-footer">
                        <h5><i class="fas fa-plane"></i> Aircraft Features</h5>
                        <div class="feature-options">
                            <div class="feature-option">
                                <asp:CheckBox ID="chkNavigation" runat="server" ClientIDMode="Static" onchange="updatePrice();" Checked="true" Enabled="false" />
                                <label for="chkNavigation"><i class="fas fa-map-marked-alt"></i> Navigation System <span class="price">(Included)</span></label>
                            </div>
                            <div class="feature-option">
                                <asp:CheckBox ID="chkEntertainment" runat="server" ClientIDMode="Static" onchange="updatePrice();" />
                                <label for="chkEntertainment"><i class="fas fa-tv"></i> Entertainment System <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+750)</span></label>
                            </div>
                            <div class="feature-option">
                                <asp:CheckBox ID="chkClimateControl" runat="server" ClientIDMode="Static" onchange="updatePrice();" />
                                <label for="chkClimateControl"><i class="fas fa-thermometer-half"></i> Climate Control <span class="price">(<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/>+563)</span></label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Price Display -->
                <div class="total-price-box">
                    <span id="totalAmountDisplay">Total: 0.00 SR</span>
                </div>

                <div class="button-container">
                    <asp:Button ID="btnProceedToPayment" runat="server" CssClass="btn btn-primary" Text="Proceed to Payment" OnClientClick="return confirmAndMoveToStep(3);" OnClick="btnProceedToPayment_Click" ValidationGroup="Step2" />
                    <asp:Button ID="btnBackToStep1" runat="server" CssClass="btn btn-secondary" Text="Back" OnClick="btnBackToStep1_Click" />
                </div>
            </div>
        </div>

        <!-- Hidden fields for aircraft data -->
        <asp:HiddenField ID="hdnAircraftModel" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnCapacity" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnRentalPrice" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnPurchasePrice" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnImageURL" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnDescription" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnTotalAmount" runat="server" Value="0" ClientIDMode="Static" />
    </div>
</asp:Content>