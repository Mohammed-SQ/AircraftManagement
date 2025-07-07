<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MockPayment.aspx.cs" Inherits="AircraftManagement.MockPayment" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Mock Visa Payment</title>

    <!-- Bootstrap and FontAwesome -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" />

    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: url('/Images/PaymentBG.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: Arial, sans-serif;
            color: white;
        }

        .container { 
            max-width: 900px; 
            margin: 0 auto; 
        }

        .wrapper { 
            padding: 0 20px; 
        }
        
        .wrapper-content { 
            padding: 20px 10px 40px; 
        }

        .ibox {
            margin-bottom: 25px; 
            padding: 0; 
            border-radius: 10px;
            overflow: hidden;
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .ibox-title {
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid #e7eaec;
            padding: 15px;
            font-size: 20px;
            font-weight: bold;
        }

        .ibox-content {
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            padding: 20px;
            border-top: none;
        }

        .payment-card {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            margin-bottom: 25px;
            border: 1px solid #e7eaec;
            text-align: center;
            border-radius: 10px;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }

        .payment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }

        .payment-icon-big {
            font-size: 60px;
        }

        .text-visa { color: #1a1f71; }
        .text-mastercard { color: #ff0000; }
        .text-discover { color: #ff6000; }

        .btn { margin-top: 10px; }
        .btn-success, .btn-primary, .btn-danger {
            padding: 10px 20px;
            border: none;
        }

        .btn-success { background-color: #1c84c6; color: white; }
        .btn-primary { background-color: #1ab394; color: white; }
        .btn-danger { background-color: #ed5565; color: white; }

        .nav-tabs > li > a {
            color: white;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: background 0.3s, color 0.3s;
        }

        .nav-tabs > li.active > a,
        .nav-tabs > li > a:hover {
            background: rgba(255, 255, 255, 0.3);
            color: black;
        }

        .selected-card {
            border: 2px solid #1abc9c;
            box-shadow: 0 0 10px #1abc9c;
        }

        .alert {
            display: block !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Hidden Labels for Backend Access -->
        <asp:Label ID="lblAmount" runat="server" Visible="false" />
        <asp:Label ID="lblAmountPaypal" runat="server" Visible="false" />
        <asp:Label ID="lblAmountDisplay" runat="server" Visible="false" />
        <asp:Label ID="lblAircraftModel" runat="server" Visible="false" />
        <asp:Label ID="lblStartDate" runat="server" Visible="false" />
        <asp:Label ID="lblEndDate" runat="server" Visible="false" />
        <asp:Label ID="lblPassengers" runat="server" Visible="false" />
        <asp:Label ID="lblExtraServices" runat="server" Visible="false" />

        <!-- Hidden Fields for ReturnUrl and CancelUrl -->
        <asp:HiddenField ID="hiddenReturnUrl" runat="server" />
        <asp:HiddenField ID="hiddenCancelUrl" runat="server" />

        <!-- Label for OrderId -->
        <asp:Label ID="lblOrderId" runat="server" Visible="false" />

        <div class="container">
            <div class="wrapper wrapper-content animated fadeInRight">

                <!-- Label for Payment Messages -->
                <asp:Label ID="lblPaymentMessage" runat="server" CssClass="alert" style="display:none;"></asp:Label>

                <!-- Your Cards Box -->
                <div class="ibox blurred-box">
                    <div class="ibox-title text-center">Your Cards</div>
                    <div class="ibox-content">
                        <div id="SavedCardsPanel" runat="server" class="row">
                            <!-- Cards will be loaded here dynamically -->
                        </div>
                    </div>
                </div>

                <!-- Payment Method Box -->
                <div class="ibox blurred-box">
                    <div class="ibox-title text-center">Payment method</div>
                    <div class="ibox-content">

                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab-card" data-toggle="tab">Credit Card</a></li>
                            <li><a href="#tab-paypal" data-toggle="tab">PayPal</a></li>
                        </ul>

                        <div class="tab-content" style="margin-top:20px;">
                            <!-- Credit Card Tab -->
                            <div class="tab-pane fade in active" id="tab-card">
                                <div class="row">
                                    <div class="col-md-6 col-sm-12">
                                        <h2>Summary</h2>
                                        <p><strong>Model:</strong> <asp:Label ID="lblAircraftModelDisplay" runat="server" /></p>
                                        <p><strong>Start Date:</strong> <asp:Label ID="lblStartDateDisplay" runat="server" /></p>
                                        <p><strong>End Date:</strong> <asp:Label ID="lblEndDateDisplay" runat="server" /></p>
                                        <p><strong>Passengers:</strong> <asp:Label ID="lblPassengersDisplay" runat="server" /></p>
                                        <p><strong>Extra Services:</strong> <asp:Label ID="lblExtraServicesDisplay" runat="server" /></p>
                                        <p><strong>Amount:</strong> <asp:Label ID="lblAmountDisplaySummary" runat="server" /></p>
                                    </div>

                                    <div class="col-md-6 col-sm-12">
                                        <asp:HiddenField ID="hfSelectedCardID" runat="server" />
                                        <asp:Button ID="btnAddNewCard" runat="server" Text="➕ Add New Card" CssClass="btn btn-success mb-3" OnClientClick="openAddCardModal(); return false;" />
                                        <div class="form-group">
                                            <label>CARD HANDLER NAME</label>
                                            <asp:TextBox ID="txtCardholderName" runat="server" placeholder="Name and Surname" CssClass="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label>CARD NUMBER</label>
                                            <div class="input-group">
                                                <asp:TextBox ID="txtCardNumber" runat="server" placeholder="Valid Card Number" CssClass="form-control" maxlength="19" oninput="formatCardNumber(this)" />
                                                <span class="input-group-addon"><i class="fa fa-credit-card"></i></span>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-6">
                                                <div class="form-group">
                                                    <label>EXPIRATION DATE</label>
                                                    <asp:TextBox ID="txtExpiryDate" runat="server" placeholder="MM / YY" CssClass="form-control" maxlength="5" oninput="formatExpiryDate(this)" />
                                                </div>
                                            </div>
                                            <div class="col-xs-6">
                                                <div class="form-group">
                                                    <label>CV CODE</label>
                                                    <asp:TextBox ID="txtCvv" runat="server" placeholder="CVC" CssClass="form-control" maxlength="4" />
                                                </div>
                                            </div>
                                        </div>

                                        <asp:Button ID="btnPay" runat="server" Text="Make a payment!" CssClass="btn btn-primary" OnClientClick="return validateCardSelection();" OnClick="BtnPay_Click" />
                                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-danger" OnClick="BtnCancel_Click" />
                                    </div>
                                </div>
                            </div>

                            <!-- PayPal Tab -->
                            <div class="tab-pane fade" id="tab-paypal">
                                <h2>Summary</h2>
                                <p><strong>Model:</strong> <asp:Label ID="lblAircraftModelPaypal" runat="server" /></p>
                                <p><strong>Start Date:</strong> <asp:Label ID="lblStartDatePaypal" runat="server" /></p>
                                <p><strong>End Date:</strong> <asp:Label ID="lblEndDatePaypal" runat="server" /></p>
                                <p><strong>Passengers:</strong> <asp:Label ID="lblPassengersPaypal" runat="server" /></p>
                                <p><strong>Extra Services:</strong> <asp:Label ID="lblExtraServicesPaypal" runat="server" /></p>
                                <p><strong>Amount:</strong> <asp:Label ID="lblAmountPaypalSummary" runat="server" /></p>
                                <a class="btn btn-success" href="MockPaypalPayment.aspx">
                                    <i class="fa fa-cc-paypal"></i> Purchase via PayPal
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for Adding a New Card (Updated for Bootstrap 3) -->
        <div class="modal fade" id="addCardModal" tabindex="-1" role="dialog" aria-labelledby="addCardModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="addCardModalLabel">Add New Card</h4>
              </div>
              <div class="modal-body">
                <div class="form-group">
                    <label for="txtModalCardholderName" class="control-label">Cardholder Name</label>
                    <asp:TextBox ID="txtModalCardholderName" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtModalCardNumber" class="control-label">Card Number</label>
                    <asp:TextBox ID="txtModalCardNumber" runat="server" CssClass="form-control" MaxLength="16" />
                </div>
                <div class="form-group">
                    <label for="txtModalExpiryDate" class="control-label">Expiry Date (MM/YY)</label>
                    <asp:TextBox ID="txtModalExpiryDate" runat="server" CssClass="form-control" MaxLength="5" />
                </div>
                <asp:Button ID="btnSaveNewCard" runat="server" Text="Save Card" CssClass="btn btn-primary" OnClick="btnSaveNewCard_Click" />
                <asp:Label ID="lblNewCardMessage" runat="server" CssClass="d-block mt-2" />
              </div>
            </div>
          </div>
        </div>

    </form>

    <!-- Scripts -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        function formatCardNumber(input) {
            var value = input.value.replace(/\D/g, '');
            input.value = value.replace(/(\d{4})/g, '$1 ').trim();
        }

        function formatExpiryDate(input) {
            var value = input.value.replace(/[^0-9]/g, '');
            if (value.length > 2) {
                input.value = value.substring(0, 2) + '/' + value.substring(2, 4);
            } else if (value.length === 2 && !input.value.includes('/')) {
                input.value = value + '/';
            }
        }

        function openAddCardModal() {
            $('#addCardModal').modal('show');
        }

        function selectCard(cardId, fullCardNumber, cardholderName, expiryDate, cvv) {
            console.log("selectCard called with CardID: " + cardId);
            document.getElementById('<%= hfSelectedCardID.ClientID %>').value = cardId;
            document.getElementById('<%= txtCardholderName.ClientID %>').value = cardholderName;
            document.getElementById('<%= txtCardNumber.ClientID %>').value = fullCardNumber;
            document.getElementById('<%= txtExpiryDate.ClientID %>').value = expiryDate;
            document.getElementById('<%= txtCvv.ClientID %>').value = cvv;

            $('.payment-card').removeClass('selected-card');
            $('#card-' + cardId).addClass('selected-card');
        }

        function validateCardSelection() {
            console.log("validateCardSelection called");
            var selectedCardId = document.getElementById('<%= hfSelectedCardID.ClientID %>').value;
            if (!selectedCardId) {
                var lblPaymentMessage = document.getElementById('<%= lblPaymentMessage.ClientID %>');
                lblPaymentMessage.innerText = "⚠ Please select a saved card to proceed.";
                lblPaymentMessage.className = "alert alert-warning";
                lblPaymentMessage.style.display = "block";
                console.log("No card selected");
                return false;
            }
            console.log("Card selected: " + selectedCardId);
            return true;
        }
    </script>
</body>
</html>