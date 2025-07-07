<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="AircraftManagement.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid dashboard-container">
    <!-- Section Navigation (Admin Navigation) -->
    <div class="admin-section-nav">
        <asp:LinkButton ID="lnkUsers" runat="server" CssClass="admin-nav-item" OnClick="lnkUsers_Click"><i class="fas fa-users"></i> Users</asp:LinkButton>
        <asp:LinkButton ID="lnkAircrafts" runat="server" CssClass="admin-nav-item" OnClick="lnkAircrafts_Click"><i class="fas fa-plane"></i> Aircraft</asp:LinkButton>
        <asp:LinkButton ID="lnkPendingAircraft" runat="server" CssClass="admin-nav-item" OnClick="lnkPendingAircraft_Click"><i class="fas fa-clock"></i> Pending</asp:LinkButton>
        <asp:LinkButton ID="lnkBookings" runat="server" CssClass="admin-nav-item" OnClick="lnkBookings_Click"><i class="fas fa-ticket-alt"></i> Bookings</asp:LinkButton>
        <asp:LinkButton ID="lnkPayments" runat="server" CssClass="admin-nav-item" OnClick="lnkPayments_Click"><i class="fas fa-money-bill"></i> Payments</asp:LinkButton>
        <asp:LinkButton ID="lnkPromotions" runat="server" CssClass="admin-nav-item" OnClick="lnkPromotions_Click"><i class="fas fa-tag"></i> Promotions</asp:LinkButton>
        <asp:LinkButton ID="lnkComments" runat="server" CssClass="admin-nav-item" OnClick="lnkComments_Click"><i class="fas fa-comments"></i> Comments</asp:LinkButton>
    </div>

    <!-- Users Section -->
    <div id="usersSection" runat="server" class="section-content">
        <div class="section-header">
            <h2><i class="fas fa-users"></i> User Management</h2>
            <div class="section-controls">
                <asp:TextBox ID="txtSearchUsers" runat="server" CssClass="form-control" Placeholder="Search by username/email" />
                <asp:DropDownList ID="ddlUserRoleFilter" runat="server" CssClass="form-select">
                    <asp:ListItem Text="All Roles" Value="" />
                    <asp:ListItem Text="Admin" Value="Admin" />
                    <asp:ListItem Text="Customer" Value="Customer" />
                </asp:DropDownList>
                <asp:Button ID="btnSearchUsers" runat="server" CssClass="btn btn-primary" Text="Search" OnClick="btnSearchUsers_Click" />
                <asp:Button ID="btnClearUsersFilter" runat="server" CssClass="btn btn-secondary" Text="Clear" OnClick="btnClearUsersFilter_Click" />
            </div>
        </div>
        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table table-custom" DataKeyNames="UserID" 
            OnRowCommand="gvUsers_RowCommand" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvUsers_PageIndexChanging" 
            AllowSorting="True" OnSorting="gvUsers_Sorting">
            <Columns>
                <asp:BoundField DataField="UserID" HeaderText="ID" SortExpression="UserID" />
                <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" />
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                <asp:BoundField DataField="Role" HeaderText="Role" SortExpression="Role" />
                <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" SortExpression="PhoneNumber" />
                <asp:BoundField DataField="Address" HeaderText="Address" SortExpression="Address" />
                <asp:BoundField DataField="CreatedAt" HeaderText="Created At" SortExpression="CreatedAt" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkEditUser" runat="server" CommandName="EditUser" CommandArgument='<%# Eval("UserID") %>' CssClass="btn btn-sm btn-info"><i class="fas fa-edit"></i></asp:LinkButton>
                        <asp:LinkButton ID="lnkDeleteUser" runat="server" CommandName="DeleteUser" CommandArgument='<%# Eval("UserID") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Are you sure?');"><i class="fas fa-trash"></i></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

  <!-- Aircraft Section -->
<div id="aircraftSection" runat="server" class="section-content">
    <div class="section-header">
        <h2><i class="fas fa-plane"></i> Aircraft Management</h2>
        <div class="section-controls">
            <asp:TextBox ID="txtSearchAircraft" runat="server" CssClass="form-control" Placeholder="Search by Model or AircraftID" />
            <asp:DropDownList ID="ddlAircraftStatusFilter" runat="server" CssClass="form-select">
                <asp:ListItem Text="All Statuses" Value="" />
                <asp:ListItem Text="Available" Value="Available" />
                <asp:ListItem Text="Rented" Value="Rented" />
                <asp:ListItem Text="Sold" Value="Sold" />
            </asp:DropDownList>
            <asp:Button ID="btnFilterAircrafts" runat="server" CssClass="btn btn-primary" Text="Filter" OnClick="btnFilterAircrafts_Click" />
            <asp:Button ID="btnClearAircraftFilter" runat="server" CssClass="btn btn-secondary" Text="Clear" OnClick="btnClearAircraftFilter_Click" />
            <asp:Button ID="btnAddAircraft" runat="server" CssClass="btn btn-success" Text="Add Aircraft" OnClick="btnAddAircraft_Click" />
        </div>
    </div>
    <asp:Label ID="lblAircraftError" runat="server" CssClass="alert alert-danger d-block text-center mt-3" Visible="false" Text=""></asp:Label>
    <asp:GridView ID="gvAircrafts" runat="server" AutoGenerateColumns="False" CssClass="table table-custom" DataKeyNames="AircraftID" 
        OnRowCommand="gvAircrafts_RowCommand" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvAircrafts_PageIndexChanging" 
        AllowSorting="True" OnSorting="gvAircrafts_Sorting">
        <Columns>
            <asp:BoundField DataField="AircraftID" HeaderText="ID" SortExpression="AircraftID" />
            <asp:BoundField DataField="AircraftModel" HeaderText="Model" SortExpression="AircraftModel" />
            <asp:BoundField DataField="Capacity" HeaderText="Capacity" SortExpression="Capacity" />
            <asp:BoundField DataField="RentalPrice" HeaderText="Rental Price (SR)" DataFormatString="{0:F2}" SortExpression="RentalPrice" />
            <asp:BoundField DataField="PurchasePrice" HeaderText="Purchase Price (SR)" DataFormatString="{0:F2}" SortExpression="PurchasePrice" />
            <asp:TemplateField HeaderText="Image">
                <ItemTemplate>
                    <asp:Image ID="imgAircraft" runat="server" ImageUrl='<%# Eval("ImageURL") %>' CssClass="aircraft-image" AlternateText="Aircraft Image" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkEditAircraft" runat="server" CommandName="EditAircraft" CommandArgument='<%# Eval("AircraftID") %>' CssClass="btn btn-sm btn-info"><i class="fas fa-edit"></i></asp:LinkButton>
                    <asp:LinkButton ID="lnkDeleteAircraft" runat="server" CommandName="DeleteAircraft" CommandArgument='<%# Eval("AircraftID") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Are you sure?');"><i class="fas fa-trash"></i></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblNoAircraft" runat="server" CssClass="alert alert-info d-block text-center mt-3" Visible="false" Text="No aircraft found in the database."></asp:Label>
</div>

    <!-- Pending Aircraft Section (Updated with AdminReview Functionality) -->
    <div id="pendingAircraftSection" runat="server" class="section-content">
        <div class="section-header">
            <h2><i class="fas fa-clock"></i> Pending Aircraft</h2>
            <div class="section-controls">
                <asp:DropDownList ID="ddlPendingFilter" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlPendingFilter_SelectedIndexChanged">
                    <asp:ListItem Text="All" Value="" />
                    <asp:ListItem Text="Pending" Value="Pending" Selected="True"/>
                    <asp:ListItem Text="Reviewed" Value="Reviewed" />
                    <asp:ListItem Text="Approved" Value="Approved" />
                    <asp:ListItem Text="Rejected" Value="Rejected" />
                </asp:DropDownList>
                <asp:Button ID="btnClearPendingFilter" runat="server" CssClass="btn btn-secondary" Text="Clear" OnClick="btnClearPendingFilter_Click" />
            </div>
        </div>

        <!-- Individual Seller Applications -->
        <div class="mb-5">
            <h3 class="sub-section-title"><i class="fas fa-user-tie me-2"></i>Individual Seller Applications</h3>
            <asp:GridView ID="gvIndividualApplications" runat="server" AutoGenerateColumns="false" CssClass="table table-custom" DataKeyNames="SellerApplicationID" OnRowDataBound="gvIndividualApplications_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="SellerApplicationID" HeaderText="Application ID" />
                    <asp:BoundField DataField="ApplicantName" HeaderText="Applicant Name" />
                    <asp:TemplateField HeaderText="License File">
                        <ItemTemplate>
                            <a href='<%# Eval("LicenseFilePath") %>' target="_blank" class="text-primary"><i class="fas fa-file-pdf me-1"></i>View License</a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ContactMethod" HeaderText="Contact Method" />
                    <asp:BoundField DataField="ContactInfo" HeaderText="Contact Info" />
                    <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />
                    <asp:BoundField DataField="SellingExperienceYears" HeaderText="Experience (Years)" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <button type="button" class="btn btn-sm btn-info me-2" onclick="viewAircraft(<%# Eval("SellerApplicationID") %>);">
                                <i class="fas fa-plane me-1"></i>View Aircraft
                            </button>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Label ID="lblNoIndividualApplications" runat="server" CssClass="alert alert-info d-block text-center mt-3" Visible="false" Text="No pending applications from Individual sellers."></asp:Label>
        </div>

        <!-- Company Seller Applications -->
        <div class="mb-5">
            <h3 class="sub-section-title"><i class="fas fa-building me-2"></i>Company Seller Applications</h3>
            <asp:GridView ID="gvCompanyApplications" runat="server" AutoGenerateColumns="false" CssClass="table table-custom" DataKeyNames="SellerApplicationID" OnRowDataBound="gvCompanyApplications_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="SellerApplicationID" HeaderText="Application ID" />
                    <asp:BoundField DataField="ApplicantName" HeaderText="Applicant Name" />
                    <asp:BoundField DataField="CompanyName" HeaderText="Company Name" />
                    <asp:BoundField DataField="SellingOnBehalf" HeaderText="Selling On Behalf" />
                    <asp:BoundField DataField="IsOwner" HeaderText="Is Owner" />
                    <asp:BoundField DataField="CompanyAge" HeaderText="Company Age" />
                    <asp:BoundField DataField="AircraftOwnership" HeaderText="Aircraft Ownership" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <button type="button" class="btn btn-sm btn-info me-2" onclick="viewAircraft(<%# Eval("SellerApplicationID") %>);">
                                <i class="fas fa-plane me-1"></i>View Aircraft
                            </button>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Label ID="lblNoCompanyApplications" runat="server" CssClass="alert alert-info d-block text-center mt-3" Visible="false" Text="No pending applications from Company sellers."></asp:Label>
        </div>

        <!-- Aircraft Details Modal -->
        <div class="modal fade" id="aircraftModal" tabindex="-1" aria-labelledby="aircraftModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="aircraftModalLabel"><i class="fas fa-plane me-2"></i>Aircraft Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hdnApplicationId" runat="server" ClientIDMode="Static" />
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card shadow-sm mb-4">
                                    <div class="card-body">
                                        <h6 class="text-primary"><i class="fas fa-info-circle me-2"></i>Aircraft Information</h6>
                                        <table class="table table-bordered" id="aircraftDetailsTable">
                                            <tr><th>Aircraft ID</th><td id="detailAircraftId"></td></tr>
                                            <tr><th>Model</th><td id="detailModel"></td></tr>
                                            <tr><th>Year</th><td id="detailYear"></td></tr>
                                            <tr><th>Engine Hours</th><td id="detailEngineHours"></td></tr>
                                            <tr><th>Fuel Type</th><td id="detailFuelType"></td></tr>
                                            <tr><th>Capacity</th><td id="detailNumberOfSeats"></td></tr>
                                            <tr><th>Aircraft Condition</th><td id="detailAircraftCondition"></td></tr>
                                            <tr><th>Description</th><td id="detailDescription"></td></tr>
                                            <tr><th>Asking Price (SAR)</th><td id="detailAskingPrice"></td></tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card shadow-sm mb-4">
                                    <div class="card-body">
                                        <h6 class="text-primary"><i class="fas fa-user me-2"></i>Seller Information</h6>
                                        <table class="table table-bordered seller-info-table">
                                            <tr><th>Username</th><td id="detailUsername"></td></tr>
                                            <tr id="individualInfoBox" style="display: none;">
                                                <th>Contact Method</th><td id="detailContactMethod"></td>
                                            </tr>
                                            <tr id="individualInfoBox2" style="display: none;">
                                                <th>Contact Info</th><td id="detailContactInfo"></td>
                                            </tr>
                                            <tr id="individualInfoBox3" style="display: none;">
                                                <th>Payment Method</th><td id="detailPaymentMethod"></td>
                                            </tr>
                                            <tr id="individualInfoBox4" style="display: none;">
                                                <th>Experience (Years)</th><td id="detailSellingExperience"></td>
                                            </tr>
                                            <tr id="individualInfoBox5" style="display: none;">
                                                <th>Aircraft Experience</th><td id="detailAircraftExperience"></td>
                                            </tr>
                                            <tr id="individualInfoBox6" style="display: none;">
                                                <th>Selling on Behalf</th><td id="detailSellingOnBehalf"></td>
                                            </tr>
                                            <tr id="individualInfoBox7" style="display: none;">
                                                <th>Is Owner</th><td id="detailIsOwner"></td>
                                            </tr>
                                            <tr id="companyInfoBox" style="display: none;">
                                                <th>Company Name</th><td id="detailCompanyName"></td>
                                            </tr>
                                            <tr id="companyInfoBox2" style="display: none;">
                                                <th>Company Age</th><td id="detailCompanyAge"></td>
                                            </tr>
                                            <tr id="companyInfoBox3" style="display: none;">
                                                <th>Selling on Behalf</th><td id="detailCompanySellingOnBehalf"></td>
                                            </tr>
                                            <tr id="companyInfoBox4" style="display: none;">
                                                <th>Is Owner</th><td id="detailCompanyIsOwner"></td>
                                            </tr>
                                            <tr id="companyInfoBox5" style="display: none;">
                                                <th>Ownership Type</th><td id="detailAircraftOwnership"></td>
                                            </tr>
                                            <tr id="companyInfoBox6" style="display: none;">
                                                <th>Aircraft Owned</th><td id="detailAircraftOwnershipCount"></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card shadow-sm">
                                    <div class="card-body">
                                        <h6 class="text-primary"><i class="fas fa-comment me-2"></i>Admin Comments</h6>
                                        <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" ClientIDMode="Static" Placeholder="Add your comments here..."></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card shadow-sm">
                                    <div class="card-body">
                                        <h6 class="text-primary"><i class="fas fa-images me-2"></i>Photos</h6>
                                        <div class="d-flex flex-wrap gap-2 mb-4" id="photosContainer"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnApprove" runat="server" Text="Approve" CssClass="btn btn-success me-2" OnClick="btnApprove_Click" UseSubmitBehavior="false" />
                        <asp:Button ID="btnReject" runat="server" Text="Reject" CssClass="btn btn-danger me-2" OnClick="btnReject_Click" UseSubmitBehavior="false" />
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <asp:Label ID="lblFeedbackMessage" runat="server" CssClass="alert d-block text-center mt-4" Visible="false"></asp:Label>
    </div>

    <!-- Bookings Section -->
    <div id="bookingsSection" runat="server" class="section-content">
        <div class="section-header">
            <h2><i class="fas fa-ticket-alt"></i> Bookings Management</h2>
            <div class="section-controls">
                <asp:TextBox ID="txtBookingDateFilter" runat="server" CssClass="form-control" Placeholder="Filter by Date (YYYY-MM-DD)" TextMode="Date" />
                <asp:DropDownList ID="ddlBookingStatusFilter" runat="server" CssClass="form-select">
                    <asp:ListItem Text="All Statuses" Value="" />
                    <asp:ListItem Text="Confirmed" Value="Confirmed" />
                    <asp:ListItem Text="Cancelled" Value="Cancelled" />
                    <asp:ListItem Text="Pending" Value="Pending" />
                </asp:DropDownList>
                <asp:Button ID="btnFilterBookings" runat="server" CssClass="btn btn-primary" Text="Filter" OnClick="btnFilterBookings_Click" />
                <asp:Button ID="btnClearBookingsFilter" runat="server" CssClass="btn btn-secondary" Text="Clear" OnClick="btnClearBookingsFilter_Click" />
            </div>
        </div>
        <asp:GridView ID="gvBookings" runat="server" AutoGenerateColumns="False" CssClass="table table-custom" DataKeyNames="BookingID" 
            OnRowCommand="gvBookings_RowCommand" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvBookings_PageIndexChanging" 
            AllowSorting="True" OnSorting="gvBookings_Sorting">
            <Columns>
                <asp:BoundField DataField="BookingID" HeaderText="Booking ID" SortExpression="BookingID" />
                <asp:BoundField DataField="UserID" HeaderText="User ID" SortExpression="UserID" />
                <asp:BoundField DataField="AircraftID" HeaderText="Aircraft ID" SortExpression="AircraftID" />
                <asp:BoundField DataField="StartDate" HeaderText="Start Date" SortExpression="StartDate" />
                <asp:BoundField DataField="EndDate" HeaderText="End Date" SortExpression="EndDate" />
                <asp:BoundField DataField="TotalCost" HeaderText="Total Cost (SR)" DataFormatString="{0:F2}" SortExpression="TotalCost" />
                <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkCancelBooking" runat="server" CommandName="CancelBooking" CommandArgument='<%# Eval("BookingID") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Are you sure?');"><i class="fas fa-times-circle"></i></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

<!-- Payments Section -->
<div id="paymentsSection" runat="server" class="section-content">
    <div class="section-header">
        <h2><i class="fas fa-money-bill"></i> Payments Management</h2>
        <div class="section-controls">
            <asp:TextBox ID="txtPaymentDateFilter" runat="server" CssClass="form-control" Placeholder="Filter by Date (YYYY-MM-DD)" TextMode="Date" />
            <asp:DropDownList ID="ddlPaymentStatusFilter" runat="server" CssClass="form-select">
                <asp:ListItem Text="All Statuses" Value="" />
                <asp:ListItem Text="Completed" Value="Completed" />
                <asp:ListItem Text="Refunded" Value="Refunded" />
                <asp:ListItem Text="Pending" Value="Pending" />
            </asp:DropDownList>
            <asp:Button ID="btnFilterPayments" runat="server" CssClass="btn btn-primary" Text="Filter" OnClick="btnFilterPayments_Click" />
            <asp:Button ID="btnClearPaymentsFilter" runat="server" CssClass="btn btn-secondary" Text="Clear" OnClick="btnClearPaymentsFilter_Click" />
        </div>
    </div>
    <asp:Label ID="lblPaymentsError" runat="server" CssClass="alert alert-danger d-block text-center mt-3" Visible="false" Text=""></asp:Label>
    <asp:GridView ID="gvPayments" runat="server" AutoGenerateColumns="False" CssClass="table table-custom" DataKeyNames="PaymentID" 
        OnRowCommand="gvPayments_RowCommand" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvPayments_PageIndexChanging" 
        AllowSorting="True" OnSorting="gvPayments_Sorting">
        <Columns>
            <asp:BoundField DataField="PaymentID" HeaderText="Payment ID" SortExpression="PaymentID" />
            <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" SortExpression="TransactionID" />
            <asp:BoundField DataField="Amount" HeaderText="Amount (SR)" DataFormatString="{0:F2}" SortExpression="Amount" />
            <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" SortExpression="PaymentDate" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
            <asp:BoundField DataField="PaymentMethod" HeaderText="Method" SortExpression="PaymentMethod" />
            <asp:BoundField DataField="PaymentStatus" HeaderText="Status" SortExpression="PaymentStatus" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkRefundPayment" runat="server" CommandName="RefundPayment" CommandArgument='<%# Eval("PaymentID") %>' CssClass="btn btn-sm btn-warning" OnClientClick="return confirm('Are you sure?');"><i class="fas fa-undo"></i></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblNoPayments" runat="server" CssClass="alert alert-info d-block text-center mt-3" Visible="false" Text="No payments found in the database."></asp:Label>
</div>

    <!-- Promotions Section -->
    <div id="promotionsSection" runat="server" class="section-content">
        <div class="section-header">
            <h2><i class="fas fa-tag"></i> Promotions Management</h2>
            <div class="section-controls">
                <asp:DropDownList ID="ddlPromotionStatusFilter" runat="server" CssClass="form-select">
                    <asp:ListItem Text="All Statuses" Value="" />
                    <asp:ListItem Text="Active" Value="1" />
                    <asp:ListItem Text="Inactive" Value="0" />
                    <asp:ListItem Text="Expired" Value="2" />
                </asp:DropDownList>
                <asp:Button ID="btnFilterPromotions" runat="server" CssClass="btn btn-primary" Text="Filter" OnClick="btnFilterPromotions_Click" />
                <asp:Button ID="btnClearPromotionsFilter" runat="server" CssClass="btn btn-secondary" Text="Clear" OnClick="btnClearPromotionsFilter_Click" />
                <asp:Button ID="btnAddPromotion" runat="server" CssClass="btn btn-success" Text="Add Promotion" OnClick="btnAddPromotion_Click" />
            </div>
        </div>
        <asp:GridView ID="gvPromotions" runat="server" AutoGenerateColumns="False" CssClass="table table-custom" DataKeyNames="PromotionID" 
            OnRowCommand="gvPromotions_RowCommand" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvPromotions_PageIndexChanging" 
            AllowSorting="True" OnSorting="gvPromotions_Sorting">
            <Columns>
                <asp:BoundField DataField="PromotionID" HeaderText="Promotion ID" SortExpression="PromotionID" />
                <asp:BoundField DataField="Title" HeaderText="Title" SortExpression="Title" />
                <asp:BoundField DataField="Discount" HeaderText="Discount" SortExpression="Discount" />
                <asp:BoundField DataField="ExpiryDate" HeaderText="Expiry Date" SortExpression="ExpiryDate" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="IsActive" HeaderText="Status" SortExpression="IsActive" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkEditPromotion" runat="server" CommandName="EditPromotion" CommandArgument='<%# Eval("PromotionID") %>' CssClass="btn btn-sm btn-info"><i class="fas fa-edit"></i></asp:LinkButton>
                        <asp:LinkButton ID="lnkDeletePromotion" runat="server" CommandName="DeletePromotion" CommandArgument='<%# Eval("PromotionID") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return confirm('Are you sure?');"><i class="fas fa-trash"></i></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- Comments Section -->
    <div id="commentsSection" runat="server" class="section-content">
        <div class="section-header">
            <h2><i class="fas fa-comments"></i> Admin Comments</h2>
            <div class="section-controls">
                <asp:DropDownList ID="ddlCommentStatusFilter" runat="server" CssClass="form-select">
                    <asp:ListItem Text="All Statuses" Value="" />
                    <asp:ListItem Text="Correct" Value="Correct" />
                    <asp:ListItem Text="Uncorrect" Value="Uncorrect" />
                    <asp:ListItem Text="Pending" Value="Pending" />
                </asp:DropDownList>
                <asp:Button ID="btnFilterComments" runat="server" CssClass="btn btn-primary" Text="Filter" OnClick="btnFilterComments_Click" />
                <asp:Button ID="btnClearCommentsFilter" runat="server" CssClass="btn btn-secondary" Text="Clear" OnClick="btnClearCommentsFilter_Click" />
            </div>
        </div>
        <div class="comment-input">
            <asp:TextBox ID="txtNewComment" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" Placeholder="Add a new comment..." />
            <asp:Button ID="btnAddComment" runat="server" CssClass="btn btn-success" Text="Add Comment" OnClick="btnAddComment_Click" />
        </div>
        <asp:GridView ID="gvComments" runat="server" AutoGenerateColumns="False" CssClass="table table-custom" DataKeyNames="CommentID" 
            OnRowCommand="gvComments_RowCommand" OnRowDataBound="gvComments_RowDataBound" AllowPaging="True" PageSize="10" 
            OnPageIndexChanging="gvComments_PageIndexChanging" AllowSorting="True" OnSorting="gvComments_Sorting">
            <Columns>
                <asp:BoundField DataField="CommentID" HeaderText="Comment ID" SortExpression="CommentID" />
                <asp:BoundField DataField="AdminID" HeaderText="Admin ID" SortExpression="AdminID" />
                <asp:BoundField DataField="CommentText" HeaderText="Comment" SortExpression="CommentText" />
                <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" SortExpression="CreatedDate" />
                <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkMarkCorrect" runat="server" CommandName="MarkCorrect" CommandArgument='<%# Eval("CommentID") %>' CssClass="btn btn-sm btn-success"><i class="fas fa-check-circle"></i></asp:LinkButton>
                        <asp:LinkButton ID="lnkMarkUncorrect" runat="server" CommandName="MarkUncorrect" CommandArgument='<%# Eval("CommentID") %>' CssClass="btn btn-sm btn-danger"><i class="fas fa-times-circle"></i></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>

<style>
    body {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        margin: 0;
        padding: 0;
        background: url('images/AdminDashboardBG.jpg') no-repeat center center fixed;
        background-size: cover;
    }

    .dashboard-container {
        flex: 1;
        padding-top: 120px;
        padding-bottom: 0;
    }

    .section-content {
        display: none;
        background: rgba(255, 255, 255, 0.05);
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 0;
    }

    .section-content.active {
        display: block;
    }

    .footer {
        width: 100%;
        padding: 40px 0;
        color: white;
        text-align: center;
        backdrop-filter: blur(10px);
        background: rgba(255, 255, 255, 0.1);
        background-clip: padding-box;
        box-sizing: border-box;
        margin-top: auto;
    }

    .admin-section-nav {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 30px;
        justify-content: center;
    }

    .admin-nav-item {
        padding: 10px 20px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 25px;
        color: #fff;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .admin-nav-item:hover {
        background: #6e48aa;
        transform: translateY(-2px);
    }

    .table-custom {
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(10px);
        border-radius: 10px;
        width: 100%;
        color: white;
        border-collapse: separate;
        border-spacing: 0;
    }

    .table-custom th {
        background: rgba(110, 72, 170, 0.8);
        color: white;
        padding: 15px;
        cursor: pointer;
        text-align: left;
    }

    .table-custom td {
        padding: 15px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        text-align: left;
    }

    .table-custom tr:hover {
        background: rgba(255, 255, 255, 0.2);
    }

    .btn {
        backdrop-filter: blur(10px);
        color: white;
        border: 1px solid rgba(255, 255, 255, 0.3);
        border-radius: 5px;
        padding: 10px 20px;
        transition: all 0.3s ease;
        text-align: center;
        text-decoration: none;
        display: inline-block;
    }

    .btn:hover {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        transform: translateY(-2px);
    }

    .btn-primary {
        background: rgba(110, 72, 170, 0.8);
        border: none;
    }

    .btn-primary:hover {
        background: rgba(157, 80, 187, 0.9);
    }

    .btn-success {
        background: rgba(40, 167, 69, 0.8);
    }

    .btn-success:hover {
        background: rgba(33, 136, 56, 0.9);
    }

    .btn-secondary {
        background: rgba(108, 117, 125, 0.8);
    }

    .btn-secondary:hover {
        background: rgba(90, 98, 104, 0.9);
    }

    .form-control, .form-select {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.3);
        color: #fff;
    }
    .form-select option { color: #000; }
    .aircraft-image {
        width: 100px;
        height: auto;
        border-radius: 5px;
    }

    /* Additional Styles for Pending Section (from AdminReview) */
    .sub-section-title {
        color: #fff;
        font-weight: 500;
        margin-bottom: 15px;
        padding-bottom: 5px;
        border-bottom: 2px solid #6e48aa;
        display: inline-block;
    }

    .modal-content {
        border-radius: 10px;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
    }

    .modal-header {
        background: #6e48aa;
        color: #fff;
    }

    .modal-body {
        background: #f8f9fa;
    }

    .form-control {
        border-radius: 5px;
        box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .form-control:focus {
        border-color: #6e48aa;
        box-shadow: 0 0 5px rgba(110, 72, 170, 0.3);
    }

    .alert {
        border-radius: 8px;
        animation: fadeIn 0.5s ease-in-out;
    }

    .card {
        border-radius: 8px;
        transition: transform 0.3s ease;
    }

    .card:hover {
        transform: translateY(-5px);
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    .photo-preview {
        width: 150px;
        height: 150px;
        object-fit: cover;
        border-radius: 5px;
        transition: transform 0.3s ease;
    }

    .photo-preview:hover {
        transform: scale(1.05);
    }

    .seller-info-table th {
        background: #6e48aa;
        color: #fff;
        font-weight: 500;
        width: 40%;
    }

    .seller-info-table td {
        background: #fff;
        color: #333;
    }
</style>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script type="text/javascript">
    function viewAircraft(sellerApplicationId) {
        axios.post('AdminDashboard.aspx/GetAircraftDetails', {
            sellerApplicationId: sellerApplicationId
        }, {
            headers: {
                'Content-Type': 'application/json; charset=utf-8'
            }
        })
            .then(function (response) {
                var result = response.data.d;
                var data = JSON.parse(result);

                if (data.success) {
                    document.getElementById('hdnApplicationId').value = sellerApplicationId;

                    document.getElementById('individualInfoBox').style.display = 'none';
                    document.getElementById('individualInfoBox2').style.display = 'none';
                    document.getElementById('individualInfoBox3').style.display = 'none';
                    document.getElementById('individualInfoBox4').style.display = 'none';
                    document.getElementById('individualInfoBox5').style.display = 'none';
                    document.getElementById('individualInfoBox6').style.display = 'none';
                    document.getElementById('individualInfoBox7').style.display = 'none';
                    document.getElementById('companyInfoBox').style.display = 'none';
                    document.getElementById('companyInfoBox2').style.display = 'none';
                    document.getElementById('companyInfoBox3').style.display = 'none';
                    document.getElementById('companyInfoBox4').style.display = 'none';
                    document.getElementById('companyInfoBox5').style.display = 'none';
                    document.getElementById('companyInfoBox6').style.display = 'none';

                    document.getElementById('detailUsername').innerText = data.username || 'Not Available';

                    if (data.sellerType === 'Individual') {
                        document.getElementById('individualInfoBox').style.display = 'table-row';
                        document.getElementById('individualInfoBox2').style.display = 'table-row';
                        document.getElementById('individualInfoBox3').style.display = 'table-row';
                        document.getElementById('individualInfoBox4').style.display = 'table-row';
                        document.getElementById('individualInfoBox5').style.display = 'table-row';
                        document.getElementById('individualInfoBox6').style.display = 'table-row';
                        document.getElementById('individualInfoBox7').style.display = 'table-row';
                        document.getElementById('detailContactMethod').innerText = data.contactMethod || 'Not Available';
                        document.getElementById('detailContactInfo').innerText = data.contactInfo || 'Not Available';
                        document.getElementById('detailPaymentMethod').innerText = data.paymentMethod || 'Not Available';
                        document.getElementById('detailSellingExperience').innerText = data.sellingExperience || 'Not Available';
                        document.getElementById('detailAircraftExperience').innerText = data.aircraftExperience || 'Not Available';
                        document.getElementById('detailSellingOnBehalf').innerText = data.sellingOnBehalf || 'Not Available';
                        document.getElementById('detailIsOwner').innerText = data.isOwner || 'Not Available';
                    } else if (data.sellerType === 'Company') {
                        document.getElementById('companyInfoBox').style.display = 'table-row';
                        document.getElementById('companyInfoBox2').style.display = 'table-row';
                        document.getElementById('companyInfoBox3').style.display = 'table-row';
                        document.getElementById('companyInfoBox4').style.display = 'table-row';
                        document.getElementById('companyInfoBox5').style.display = 'table-row';
                        document.getElementById('companyInfoBox6').style.display = 'table-row';
                        document.getElementById('detailCompanyName').innerText = data.companyName || 'Not Available';
                        document.getElementById('detailCompanyAge').innerText = data.companyAge || 'Not Available';
                        document.getElementById('detailCompanySellingOnBehalf').innerText = data.sellingOnBehalf || 'Not Available';
                        document.getElementById('detailCompanyIsOwner').innerText = data.isOwner || 'Not Available';
                        document.getElementById('detailAircraftOwnership').innerText = data.aircraftOwnership || 'Not Available';
                        document.getElementById('detailAircraftOwnershipCount').innerText = data.aircraftOwnershipCount || 'Not Available';
                    }

                    document.getElementById('detailAircraftId').innerText = data.aircraftId || 'Not Available';
                    document.getElementById('detailModel').innerText = data.model || 'Not Available';
                    document.getElementById('detailYear').innerText = data.year || 'Not Available';
                    document.getElementById('detailEngineHours').innerText = data.engineHours || 'Not Available';
                    document.getElementById('detailFuelType').innerText = data.fuelType || 'Not Available';
                    document.getElementById('detailNumberOfSeats').innerText = data.numberOfSeats || 'Not Available';
                    document.getElementById('detailAircraftCondition').innerText = data.aircraftCondition || 'Not Available';
                    document.getElementById('detailDescription').innerText = data.description || 'Not Available';
                    document.getElementById('detailAskingPrice').innerText = data.askingPrice || 'Not Available';

                    var photosContainer = document.getElementById('photosContainer');
                    photosContainer.innerHTML = '';
                    if (data.photos && data.photos.length > 0) {
                        data.photos.forEach(function (photo) {
                            if (photo) {
                                var img = document.createElement('img');
                                img.src = photo;
                                img.className = 'photo-preview';
                                img.alt = 'Aircraft Photo';
                                photosContainer.appendChild(img);
                            }
                        });
                    } else {
                        photosContainer.innerHTML = '<p>No photos available.</p>';
                    }

                    var modal = new bootstrap.Modal(document.getElementById('aircraftModal'), { backdrop: 'static', keyboard: false });
                    modal.show();
                } else {
                    alert(data.message);
                }
            })
            .catch(function (error) {
                alert('Error loading aircraft details: ' + error.message);
            });
    }
</script>
    </asp:Content>