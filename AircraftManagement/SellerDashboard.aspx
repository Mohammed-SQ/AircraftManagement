<%@ Page Title="Seller Dashboard - Saudi Aviation Market" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="SellerDashboard.aspx.cs" Inherits="AircraftManagement.SellerDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>

    <div class="container-fluid my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-center text-md-start"><i class="fas fa-tachometer-alt me-2 text-primary"></i>Seller Dashboard</h2>
            <a href="SellAircraft.aspx" class="btn btn-success btn-lg"><i class="fas fa-plus me-2"></i>Create New Listing</a>
        </div>
        <p class="text-center text-muted mb-5">Manage your seller applications, aircraft listings, chats, and transaction history in the Saudi Aviation Market.</p>

        <asp:Label ID="lblFeedbackMessage" runat="server" CssClass="alert d-block text-center mb-4" Visible="false"></asp:Label>

        <div class="row mb-5">
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm text-center p-4 bg-gradient-primary text-white">
                    <h5><i class="fas fa-plane me-2 fa-lg"></i>Total Listings</h5>
                    <h3><asp:Label ID="lblTotalListings" runat="server" Text="0"></asp:Label></h3>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm text-center p-4 bg-gradient-warning text-white">
                    <h5><i class="fas fa-file-alt me-2 fa-lg"></i>Pending Applications</h5>
                    <h3><asp:Label ID="lblPendingApplications" runat="server" Text="0"></asp:Label></h3>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm text-center p-4 bg-gradient-danger text-white">
                    <h5><i class="fas fa-envelope me-2 fa-lg"></i>Unread Messages</h5>
                    <h3><asp:Label ID="lblUnreadMessages" runat="server" Text="0"></asp:Label></h3>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="card shadow-lg mb-5">
                    <div class="card-body p-5">
                        <h4 class="mb-4"><i class="fas fa-file-alt me-2 text-primary"></i>Your Seller Applications</h4>
                        <asp:GridView ID="gvApplications" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover" AllowPaging="true" PageSize="5" OnPageIndexChanging="gvApplications_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="ApplicationID" HeaderText="Application ID" />
                                <asp:BoundField DataField="AIRCRAFTMODEL" HeaderText="Model" />
                                <asp:BoundField DataField="YearManufactured" HeaderText="Year" />
                                <asp:BoundField DataField="CREATEDAT" HeaderText="Submitted On" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:TemplateField HeaderText="Photos">
                                    <ItemTemplate>
                                        <asp:Image ID="imgAircraft" runat="server" ImageUrl='<%# GetFirstPhoto(Eval("ImageURL")) %>' Width="100" Height="100" CssClass="img-thumbnail" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Airworthiness Certificate">
                                    <ItemTemplate>
                                        <a href='<%# Eval("LICENSEPATH") %>' target="_blank" class="text-primary"><i class="fas fa-file-pdf me-1 fa-lg"></i>View Certificate</a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <button type="button" class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#applicationDetailsModal" 
                                            onclick="showApplicationDetails(<%# Eval("ApplicationID") %>, '<%# Eval("AIRCRAFTMODEL") %>', '<%# Eval("YearManufactured") %>', '<%# Eval("CREATEDAT", "{0:dd/MM/yyyy}") %>', '<%# Eval("SellingExperience") %>', '<%# Eval("CompanyName") %>', '<%# Eval("SellingOnBehalf") %>', '<%# Eval("IsOwner") %>', '<%# Eval("CompanyAge") %>', '<%# Eval("AIRCRAFTOWNERSHIPCOUNT") %>', '<%# Eval("ContactMethod") %>', '<%# Eval("PaymentMethod") %>', '<%# Eval("EngineHours") %>', '<%# Eval("FuelType") %>', '<%# Eval("AirCraftCondition") %>', '<%# Eval("Capacity") %>', '<%# Eval("Description") %>', '<%# Eval("Status") %>', '<%# Eval("PurchasePrice") %>', '<%# Eval("RentalPrice") %>')">
                                            <i class="fas fa-eye me-1 fa-lg"></i>View Details
                                        </button>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagination justify-content-center mt-3" />
                            <EmptyDataTemplate>
                                <div class="text-center text-muted p-3">
                                    No pending seller applications found. <a href="SellAircraft.aspx" class="text-primary">Submit a new application</a> to get started.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>

                <div class="card shadow-lg mb-5">
                    <div class="card-body p-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4><i class="fas fa-plane me-2 text-primary"></i>Your Aircraft Listings</h4>
                            <div class="d-flex align-items-center">
                                <asp:TextBox ID="txtSearchListings" runat="server" CssClass="form-control me-2" Placeholder="Search by Model or Status..." style="width: 200px;"></asp:TextBox>
                                <asp:Button ID="btnSearchListings" runat="server" Text="Search" CssClass="btn btn-primary me-2" OnClick="btnSearchListings_Click" />
                                <asp:Button ID="btnDownloadReport" runat="server" Text="Download Report" CssClass="btn btn-secondary" OnClientClick="downloadReport(); return false;" />
                            </div>
                        </div>
                        <asp:GridView ID="gvAircrafts" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover" DataKeyNames="AircraftID" OnRowCommand="gvAircrafts_RowCommand" AllowPaging="true" PageSize="5" OnPageIndexChanging="gvAircrafts_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="AircraftID" HeaderText="Aircraft ID" />
                                <asp:BoundField DataField="AIRCRAFTMODEL" HeaderText="Model" />
                                <asp:BoundField DataField="YearManufactured" HeaderText="Year" />
                                <asp:BoundField DataField="Description" HeaderText="Description" />
                                <asp:TemplateField HeaderText="Price (SAR)">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Price") != DBNull.Value ? String.Format("{0:N2}", Eval("Price")) : "N/A" %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                                <asp:TemplateField HeaderText="Photos">
                                    <ItemTemplate>
                                        <asp:Image ID="imgAircraft" runat="server" ImageUrl='<%# GetFirstPhoto(Eval("ImageURL")) %>' Width="100" Height="100" CssClass="img-thumbnail" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <button type="button" class="btn btn-info btn-sm me-2" data-bs-toggle="modal" data-bs-target="#aircraftDetailsModal" 
                                            onclick="showAircraftDetails(<%# Eval("AircraftID") %>, '<%# Eval("AIRCRAFTMODEL") %>', '<%# Eval("YearManufactured") %>', '<%# Eval("Description") %>', '<%# Eval("Price", "{0:N2}") %>', '<%# Eval("Status") %>', '<%# Eval("ImageURL") %>', '<%# Eval("EngineHours") %>', '<%# Eval("FuelType") %>', '<%# Eval("AirCraftCondition") %>', '<%# Eval("Capacity") %>', '<%# Eval("SellerID") %>', '<%# Eval("PurchasePrice") %>', '<%# Eval("RentalPrice") %>', '<%# Eval("TransactionType") %>')">
                                            <i class="fas fa-eye me-1 fa-lg"></i>View Details
                                        </button>
                                        <asp:Button ID="btnEdit" runat="server" CommandName="EditAircraft" CommandArgument='<%# Eval("AircraftID") %>' Text="Edit" CssClass="btn btn-primary btn-sm me-2" />
                                        <asp:Button ID="btnToggleVisibility" runat="server" CommandName="ToggleVisibility" CommandArgument='<%# Eval("AircraftID") %>' 
                                            Text='<%# Eval("Status").ToString() == "Hidden" ? "Make Available" : "Hide" %>' 
                                            CssClass='<%# Eval("Status").ToString() == "Hidden" ? "btn btn-success btn-sm me-2" : "btn btn-warning btn-sm me-2" %>' />
                                        <asp:Button ID="btnDelete" runat="server" CommandName="DeleteAircraft" CommandArgument='<%# Eval("AircraftID") %>' Text="Delete" CssClass="btn btn-danger btn-sm" OnClientClick='<%# "return confirmAction(\"delete this aircraft listing\", " + Eval("AircraftID") + ", \"DeleteAircraft\");" %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <PagerStyle CssClass="pagination justify-content-center mt-3" />
                        </asp:GridView>
                    </div>
                </div>

                <div class="card shadow-lg mb-5">
                    <div class="card-body p-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4><i class="fas fa-history me-2 text-primary"></i>Rental and Purchase History</h4>
                            <asp:TextBox ID="txtSearchTransactions" runat="server" CssClass="form-control me-2" Placeholder="Search by Username or Transaction Type..." style="width: 200px;"></asp:TextBox>
                            <asp:Button ID="btnSearchTransactions" runat="server" Text="Search" CssClass="btn btn-primary me-2" OnClick="btnSearchTransactions_Click" />
                        </div>
                        <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="false" CssClass="table table-bordered table-hover" AllowPaging="true" PageSize="5" OnPageIndexChanging="gvTransactions_PageIndexChanging">
                            <Columns>
                                <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" />
                                <asp:BoundField DataField="BuyerUsername" HeaderText="Buyer Username" />
                                <asp:BoundField DataField="AircraftModel" HeaderText="Aircraft Model" />
                                <asp:BoundField DataField="TransactionType" HeaderText="Transaction Type" />
                                <asp:BoundField DataField="TransactionDate" HeaderText="Date" DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="TotalAmount" HeaderText="Amount (SAR)" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                            </Columns>
                            <PagerStyle CssClass="pagination justify-content-center mt-3" />
                        </asp:GridView>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card shadow-lg mb-5">
                    <div class="card-body p-5" id="chatSection">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4><i class="fas fa-comments me-2 text-primary"></i>Chat with Customers</h4>
                            <div class="d-flex align-items-center">
                                <asp:TextBox ID="txtSearchChatUsers" runat="server" CssClass="form-control me-2" Placeholder="Search by Username..." style="width: 200px;"></asp:TextBox>
                                <asp:Button ID="btnSearchChatUsers" runat="server" Text="Search" CssClass="btn btn-primary me-2" OnClick="btnSearchChatUsers_Click" />
                            </div>
                        </div>
                        <div class="chat-users-list">
                            <asp:Repeater ID="rptChatUsers" runat="server">
                                <ItemTemplate>
                                    <a href='Chats.aspx?UserID=<%# Eval("UserID") %>' class="d-flex align-items-center chat-user mb-3 text-decoration-none">
                                        <div class="user-info">
                                            <h5 class="mb-0"><%# Eval("Username") %></h5>
                                            <small class="text-muted"><%# Eval("LastInteraction", "{0:dd/MM/yyyy HH:mm}") %></small>
                                        </div>
                                    </a>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="applicationDetailsModal" tabindex="-1" aria-labelledby="applicationDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="applicationDetailsModalLabel"><i class="fas fa-file-alt me-2"></i>Application Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p><strong>Application ID:</strong> <span id="appDetailID"></span></p>
                    <p><strong>Model:</strong> <span id="appDetailModel"></span></p>
                    <p><strong>Year:</strong> <span id="appDetailYear"></span></p>
                    <p><strong>Submitted On:</strong> <span id="appDetailSubmitted"></span></p>
                    <p><strong>Selling Experience:</strong> <span id="appDetailSellingExperience"></span></p>
                    <p><strong>Company Name:</strong> <span id="appDetailCompanyName"></span></p>
                    <p><strong>Selling On Behalf:</strong> <span id="appDetailSellingOnBehalf"></span></p>
                    <p><strong>Is Owner:</strong> <span id="appDetailIsOwner"></span></p>
                    <p><strong>Company Age:</strong> <span id="appDetailCompanyAge"></span></p>
                    <p><strong>Aircraft Ownership Count:</strong> <span id="appDetailAircraftOwnershipCount"></span></p>
                    <p><strong>Contact Method:</strong> <span id="appDetailContactMethod"></span></p>
                    <p><strong>Payment Method:</strong> <span id="appDetailPaymentMethod"></span></p>
                    <p><strong>Engine Hours:</strong> <span id="appDetailEngineHours"></span></p>
                    <p><strong>Fuel Type:</strong> <span id="appDetailFuelType"></span></p>
                    <p><strong>Aircraft Condition:</strong> <span id="appDetailAirCraftCondition"></span></p>
                    <p><strong>Capacity:</strong> <span id="appDetailCapacity"></span></p>
                    <p><strong>Description:</strong> <span id="appDetailDescription"></span></p>
                    <p><strong>Status:</strong> <span id="appDetailStatus"></span></p>
                    <p><strong>Purchase Price (SAR):</strong> <span id="appDetailPurchasePrice"></span></p>
                    <p><strong>Rental Price (SAR):</strong> <span id="appDetailRentalPrice"></span></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="aircraftDetailsModal" tabindex="-1" aria-labelledby="aircraftDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="aircraftDetailsModalLabel"><i class="fas fa-plane me-2"></i>Aircraft Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p><strong>Aircraft ID:</strong> <span id="aircraftDetailID"></span></p>
                    <p><strong>Model:</strong> <span id="aircraftDetailModel"></span></p>
                    <p><strong>Year:</strong> <span id="aircraftDetailYear"></span></p>
                    <p><strong>Description:</strong> <span id="aircraftDetailDescription"></span></p>
                    <p><strong>Price (SAR):</strong> <span id="aircraftDetailPrice"></span></p>
                    <p><strong>Status:</strong> <span id="aircraftDetailStatus"></span></p>
                    <p><strong>Photos:</strong></p>
                    <div id="aircraftDetailPhotos" class="d-flex flex-wrap"></div>
                    <p><strong>Engine Hours:</strong> <span id="aircraftDetailEngineHours"></span></p>
                    <p><strong>Fuel Type:</strong> <span id="aircraftDetailFuelType"></span></p>
                    <p><strong>Aircraft Condition:</strong> <span id="aircraftDetailAirCraftCondition"></span></p>
                    <p><strong>Capacity:</strong> <span id="aircraftDetailCapacity"></span></p>
                    <p><strong>Seller ID:</strong> <span id="aircraftDetailSellerID"></span></p>
                    <p><strong>Purchase Price (SAR):</strong> <span id="aircraftDetailPurchasePrice"></span></p>
                    <p><strong>Rental Price (SAR):</strong> <span id="aircraftDetailRentalPrice"></span></p>
                    <p><strong>Transaction Type:</strong> <span id="aircraftDetailTransactionType"></span></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #e6f0fa, #b0c4de);
            min-height: 100vh;
        }

        h2, h4 {
            color: #1b5e20;
            font-weight: 700;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
        }

        .card {
            border-radius: 15px;
            border: none;
            background: #fff;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .bg-gradient-primary {
            background: linear-gradient(45deg, #007bff, #00c4ff);
        }

        .bg-gradient-warning {
            background: linear-gradient(45deg, #ffca28, #ffeb3b);
        }

        .bg-gradient-danger {
            background: linear-gradient(45deg, #ff6f61, #ff8a80);
        }

        .table {
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
        }

        .table th {
            background: #1b5e20;
            color: #fff;
            font-weight: 500;
            padding: 15px;
        }

        .table td {
            vertical-align: middle;
            padding: 15px;
        }

        .btn-primary, .btn-warning, .btn-info, .btn-danger, .btn-success, .btn-secondary {
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .btn-primary {
            background: linear-gradient(45deg, #007bff, #00c4ff);
            border: none;
        }

        .btn-primary:hover {
            background: linear-gradient(45deg, #0056b3, #0096d6);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .btn-warning {
            background: linear-gradient(45deg, #ffca28, #ffeb3b);
            border: none;
            color: #333;
        }

        .btn-warning:hover {
            background: linear-gradient(45deg, #e0a800, #ffeb3b);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .btn-info {
            background: linear-gradient(45deg, #17a2b8, #2bc4d9);
            border: none;
        }

        .btn-info:hover {
            background: linear-gradient(45deg, #117a8b, #1a9fb3);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .btn-danger {
            background: linear-gradient(45deg, #ff6f61, #ff8a80);
            border: none;
        }

        .btn-danger:hover {
            background: linear-gradient(45deg, #e04e42, #ff6f61);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .btn-success {
            background: linear-gradient(45deg, #28a745, #34c759);
            border: none;
        }

        .btn-success:hover {
            background: linear-gradient(45deg, #218838, #28a745);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary {
            background: linear-gradient(45deg, #6c757d, #868e96);
            border: none;
        }

        .btn-secondary:hover {
            background: linear-gradient(45deg, #5a6268, #6c757d);
            transform: translateY(-2px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        }

        .img-thumbnail {
            border-radius: 10px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .img-thumbnail:hover {
            transform: scale(1.1);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .alert {
            border-radius: 8px;
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .pagination .page-link {
            color: #1b5e20;
            border-radius: 25px;
            margin: 0 5px;
            transition: all 0.3s ease;
        }

        .pagination .page-item.active .page-link {
            background: linear-gradient(45deg, #1b5e20, #2e7d32);
            border-color: #1b5e20;
            color: #fff;
        }

        .pagination .page-link:hover {
            background: #e6f0fa;
            color: #1b5e20;
        }

        .modal-content {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            background: linear-gradient(45deg, #1b5e20, #2e7d32);
            color: #fff;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }

        .modal-body p {
            margin-bottom: 0.75rem;
            font-size: 1.1rem;
        }

        .modal-body strong {
            color: #1b5e20;
        }

        .photo-preview img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            margin-right: 15px;
            margin-bottom: 15px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .photo-preview img:hover {
            transform: scale(1.05);
        }

        .chat-users-list {
            max-height: 400px;
            overflow-y: auto;
            padding-right: 10px;
        }

        .chat-users-list::-webkit-scrollbar {
            width: 8px;
        }

        .chat-users-list::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .chat-users-list::-webkit-scrollbar-thumb {
            background: #1b5e20;
            border-radius: 10px;
        }

        .chat-user {
            padding: 15px;
            border-radius: 10px;
            transition: background 0.3s ease, transform 0.3s ease;
            background: #f8f9fa;
        }

        .chat-user:hover {
            background: #e6f0fa;
            transform: translateX(5px);
        }

        .avatar {
            position: relative;
        }

        .avatar .online-status {
            position: absolute;
            bottom: 5px;
            right: 5px;
            width: 20px;
            height: 20px;
            background: #28a745;
            border: 2px solid #fff;
            border-radius: 50%;
        }

        .user-info h5 {
            font-size: 1.25rem;
            color: #1b5e20;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .chat-user:hover .user-info h5 {
            color: #2e7d32;
        }

        .text-primary {
            color: #1b5e20 !important;
        }

        .text-primary:hover {
            color: #2e7d32 !important;
        }

        i.fa-lg {
            font-size: 1.3em;
            transition: transform 0.3s ease;
        }

        i.fa-lg:hover {
            transform: scale(1.2);
        }
    </style>

    <script type="text/javascript">
        function showApplicationDetails(id, model, year, submitted, sellingExperience, companyName, sellingOnBehalf, isOwner, companyAge, aircraftOwnershipCount, contactMethod, paymentMethod, engineHours, fuelType, airCraftCondition, capacity, description, status, purchasePrice, rentalPrice) {
            document.getElementById('appDetailID').innerText = id;
            document.getElementById('appDetailModel').innerText = model;
            document.getElementById('appDetailYear').innerText = year;
            document.getElementById('appDetailSubmitted').innerText = submitted;
            document.getElementById('appDetailSellingExperience').innerText = sellingExperience;
            document.getElementById('appDetailCompanyName').innerText = companyName || 'N/A';
            document.getElementById('appDetailSellingOnBehalf').innerText = sellingOnBehalf || 'N/A';
            document.getElementById('appDetailIsOwner').innerText = isOwner || 'N/A';
            document.getElementById('appDetailCompanyAge').innerText = companyAge || 'N/A';
            document.getElementById('appDetailAircraftOwnershipCount').innerText = aircraftOwnershipCount || 'N/A';
            document.getElementById('appDetailContactMethod').innerText = contactMethod || 'N/A';
            document.getElementById('appDetailPaymentMethod').innerText = paymentMethod || 'N/A';
            document.getElementById('appDetailEngineHours').innerText = engineHours || 'N/A';
            document.getElementById('appDetailFuelType').innerText = fuelType || 'N/A';
            document.getElementById('appDetailAirCraftCondition').innerText = airCraftCondition || 'N/A';
            document.getElementById('appDetailCapacity').innerText = capacity || 'N/A';
            document.getElementById('appDetailDescription').innerText = description || 'N/A';
            document.getElementById('appDetailStatus').innerText = status || 'N/A';
            document.getElementById('appDetailPurchasePrice').innerText = purchasePrice || 'N/A';
            document.getElementById('appDetailRentalPrice').innerText = rentalPrice || 'N/A';
        }

        function showAircraftDetails(id, model, year, description, price, status, photos, engineHours, fuelType, airCraftCondition, capacity, sellerID, purchasePrice, rentalPrice, transactionType) {
            document.getElementById('aircraftDetailID').innerText = id;
            document.getElementById('aircraftDetailModel').innerText = model || 'N/A';
            document.getElementById('aircraftDetailYear').innerText = year;
            document.getElementById('aircraftDetailDescription').innerText = description || 'N/A';
            document.getElementById('aircraftDetailPrice').innerText = price || 'N/A';
            document.getElementById('aircraftDetailStatus').innerText = status;
            
            var photosDiv = document.getElementById('aircraftDetailPhotos');
            photosDiv.innerHTML = '';
            if (photos) {
                var photoArray = photos.split(';');
                for (var i = 0; i < photoArray.length; i++) {
                    var photo = photoArray[i];
                    if (photo) {
                        var img = document.createElement('img');
                        img.src = photo;
                        img.className = 'photo-preview';
                        photosDiv.appendChild(img);
                    }
                }
            }

            document.getElementById('aircraftDetailEngineHours').innerText = engineHours || 'N/A';
            document.getElementById('aircraftDetailFuelType').innerText = fuelType || 'N/A';
            document.getElementById('aircraftDetailAirCraftCondition').innerText = airCraftCondition || 'N/A';
            document.getElementById('aircraftDetailCapacity').innerText = capacity || 'N/A';
            document.getElementById('aircraftDetailSellerID').innerText = sellerID || 'N/A';
            document.getElementById('aircraftDetailPurchasePrice').innerText = purchasePrice || 'N/A';
            document.getElementById('aircraftDetailRentalPrice').innerText = rentalPrice || 'N/A';
            document.getElementById('aircraftDetailTransactionType').innerText = transactionType || 'N/A';
        }

        function confirmAction(actionText, id, command) {
            if (confirm('Are you sure you want to ' + actionText + '?')) {
                return true;
            }
            return false;
        }

        function downloadReport() {
            var element = document.getElementById('<%= gvAircrafts.ClientID %>').parentElement;
            var opt = {
                margin: 1,
                filename: 'AircraftListingsReport.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2 },
                jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
            };
            html2pdf().set(opt).from(element).save();
        }

        function scrollToChatSection() {
            document.getElementById('chatSection').scrollIntoView({ behavior: 'smooth' });
        }
    </script>
</asp:Content>