<%@ Page Title="Select Aircraft" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="PurchaseRentalSelect.aspx.cs" Inherits="AircraftManagement.PurchaseRentalSelect" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <script src="/js/PurchaseRentalSelect.js"></script>
    <link rel="stylesheet" type="text/css" href='<%= ResolveClientUrl("~/css/PurchaseRentalCommon.css") %>' />
    <link rel="stylesheet" type="text/css" href='<%= ResolveClientUrl("~/css/PurchaseRentalSelect.css") %>' />
    <link rel="stylesheet" type="text/css" href='<%= ResolveClientUrl("~/css/PurchaseRental.css") %>' />

    <div class="container mt-5">
        <asp:Label ID="lblMessage" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
        <h2><i class="fas fa-plane"></i> Aircraft Booking - Step 1</h2>

        <div class="step-progress">
            <div class="step-connector"></div>
            <div class="step active" id="step1">Select Aircraft</div>
            <div class="step" id="step2">Booking Details</div>
            <div class="step" id="step3">Payment</div>
        </div>

        <div id="step1Content" class="step-content">
            <div class="selection-row">
                <div class="custom-select">
                    <label class="form-label required"><i class="fas fa-plane"></i> Aircraft Selection</label>
                    <asp:DropDownList ID="ddlAircrafts" runat="server" CssClass="form-control" onchange="changeAircraft(this);" ClientIDMode="Static">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvAircraft" runat="server" ControlToValidate="ddlAircrafts" InitialValue="" ErrorMessage="Please select an aircraft" CssClass="text-danger" Display="Dynamic" ValidationGroup="Step1" />
                </div>
                <div class="transaction-type-info">
                    <label class="form-label"><i class="fas fa-exchange-alt"></i> Transaction Type</label>
                    <asp:Label ID="lblTransactionType" runat="server" CssClass="form-control static-display" ClientIDMode="Static" />
                </div>
                <div class="seller-username-info">
                    <label class="form-label"><i class="fas fa-user"></i> Seller Username</label>
                    <asp:Label ID="lblSellerUsername" runat="server" CssClass="form-control static-display" ClientIDMode="Static" />
                </div>
            </div>

            <asp:Image ID="imgAircraft" runat="server" CssClass="aircraft-image" ClientIDMode="Static" />

            <div id="aircraftInfo" class="aircraft-info" runat="server">
                <div><i class="fas fa-plane"></i> <strong>Model:</strong> <asp:Label ID="lblAircraftModel" runat="server" ClientIDMode="Static" /></div>
                <div><i class="fas fa-industry"></i> <strong>Manufacturer:</strong> <asp:Label ID="lblManufacturer" runat="server" ClientIDMode="Static" /></div>
                <div><i class="fas fa-calendar-alt"></i> <strong>Year Manufactured:</strong> <asp:Label ID="lblYearManufactured" runat="server" ClientIDMode="Static" /></div>
                <div><i class="fas fa-users"></i> <strong>Capacity:</strong> <asp:Label ID="lblAircraftCapacity" runat="server" ClientIDMode="Static" /></div>
                <div><i class="fas fa-tools"></i> <strong>Condition:</strong> <asp:Label ID="lblAircraftCondition" runat="server" ClientIDMode="Static" /></div>
                <div><i class="fas fa-clock"></i> <strong>Engine Hours:</strong> <asp:Label ID="lblEngineHours" runat="server" ClientIDMode="Static" /></div>
                <div><i class="fas fa-gas-pump"></i> <strong>Fuel Type:</strong> <asp:Label ID="lblFuelType" runat="server" ClientIDMode="Static" /></div>
                <div><i class="fas fa-money-bill-wave"></i> <strong>Price:</strong> <asp:Label ID="lblAircraftPrice" runat="server" ClientIDMode="Static" /></div>
                <div style="flex-basis: 100%;"><i class="fas fa-info-circle"></i> <strong>Description:</strong> <asp:Label ID="lblAircraftDescription" runat="server" ClientIDMode="Static" /></div>
            </div>

            <asp:Button ID="btnProceedToBooking" runat="server" CssClass="btn btn-primary" Text="Proceed to Booking" OnClientClick="return confirmAndMoveToStep(2);" OnClick="btnProceedToBooking_Click" ValidationGroup="Step1" />

            <asp:HiddenField ID="hdnAircraftID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnAircraftModel" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnManufacturer" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnYearManufactured" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnCapacity" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnAircraftCondition" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnEngineHours" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnFuelType" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnSellerID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnSellerUsername" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnTransactionType" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnRentalPrice" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnPurchasePrice" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnImageURL" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="hdnDescription" runat="server" ClientIDMode="Static" />
        </div>
    </div>

    <style>


        .custom-select, .transaction-type-info, .seller-username-info {
            flex: 1;
            min-width: 200px;
        }
#lblTransactionType, #lblSellerUsername{
    border: 2px solid #4B0082;
}


    </style>
</asp:Content>