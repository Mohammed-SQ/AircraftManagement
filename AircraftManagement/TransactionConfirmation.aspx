<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TransactionConfirmation.aspx.cs" Inherits="AircraftManagement.TransactionConfirmation" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Transaction Confirmation</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow-x: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body {
            padding-top: 20px;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background: url('/Images/PaymentBG.jpg') no-repeat center center fixed;
            background-size: cover;
            color: #fff;
        }
        .confirmation-container {
            max-width: 700px;
            margin: 40px auto;
            padding: 30px;
            border-radius: 15px;
            background-color: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .confirmation-header {
            background: linear-gradient(135deg, #007bff 0%, #00c6ff 100%);
            color: #fff;
            padding: 15px 20px;
            text-align: center;
            border-radius: 12px 12px 0 0;
            margin: -30px -30px 20px;
            font-size: 1.5rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .confirmation-header i {
            margin-right: 10px;
        }
        .confirmation-body {
            padding: 0 10px;
        }
        .confirmation-body h3 {
            font-size: 1.3rem;
            font-weight: 600;
            color: #f0f0f0;
            margin-bottom: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            padding-bottom: 5px;
            text-transform: uppercase;
        }
        .detail-group {
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            font-size: 1rem;
        }
        .detail-group label {
            font-weight: 500;
            display: inline-block;
            width: 180px;
            color: #e0e0e0;
            text-transform: uppercase;
        }
        .detail-group span {
            color: #ffffff;
            font-weight: 400;
        }
        .btn {
            padding: 10px 20px;
            font-size: 1rem;
            font-weight: 500;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-right: 10px;
            margin-top: 15px;
        }
        .btn-back {
            background-color: #333;
            color: #fff;
        }
        .btn-back:hover {
            background-color: #555;
            transform: translateY(-2px);
        }
        .btn-download {
            background-color: #28a745;
            color: #fff;
        }
        .btn-download:hover {
            background-color: #218838;
            transform: translateY(-2px);
        }
        .btn i {
            margin-right: 5px;
        }

        /* Styles for PDF rendering */
        .pdf-rendering {
            background: none !important;
            background-color: #fff !important;
            color: #000 !important;
            border: 1px solid #000 !important;
            box-shadow: none !important;
            border-radius: 0 !important;
            backdrop-filter: none !important;
            padding: 20px !important;
        }
        .pdf-rendering .confirmation-header {
            background: linear-gradient(135deg, #007bff 0%, #00c6ff 100%) !important;
            color: #fff !important;
            border-radius: 0 !important;
            margin: 0 !important;
            padding: 15px 20px !important;
        }
        .pdf-rendering .confirmation-body {
            padding: 10px !important;
        }
        .pdf-rendering .confirmation-body h3 {
            color: #000 !important;
            border-bottom: 1px solid #ccc !important;
            margin-top: 20px !important;
            text-transform: uppercase;
        }
        .pdf-rendering .detail-group {
            margin-bottom: 8px !important;
        }
        .pdf-rendering .detail-group label,
        .pdf-rendering .detail-group span {
            color: #000 !important;
        }
        .pdf-rendering .detail-group label {
            width: 200px !important;
            text-transform: uppercase;
        }
        .pdf-rendering .btn {
            display: none !important;
        }
        .pdf-rendering .lbl-message {
            display: none !important;
        }
        .pdf-footer {
            display: none;
            text-align: center;
            font-size: 0.8rem;
            color: #666;
            margin-top: 20px;
        }
        .pdf-rendering .pdf-footer {
            display: block !important;
        }

        /* Print media query for browser printing (optional) */
        @media print {
            body {
                background: none !important;
            }
            .confirmation-container {
                background-color: #fff !important;
                border: 1px solid #000 !important;
                box-shadow: none !important;
                backdrop-filter: none !important;
                color: #000 !important;
                border-radius: 0 !important;
            }
            .confirmation-header {
                background: linear-gradient(135deg, #007bff 0%, #00c6ff 100%) !important;
                color: #fff !important;
                border-radius: 0 !important;
                margin: 0 !important;
                padding: 15px 20px !important;
            }
            .confirmation-body {
                padding: 10px !important;
            }
            .confirmation-body h3 {
                color: #000 !important;
                border-bottom: 1px solid #ccc !important;
            }
            .detail-group label,
            .detail-group span {
                color: #000 !important;
            }
            .btn {
                display: none !important;
            }
            .lbl-message {
                display: none !important;
            }
        }
    </style>
    <script type="text/javascript">
        function downloadAsPDF() {
            var transactionId = document.getElementById('<%= lblTransactionId.ClientID %>').innerText;
            var timestamp = '<%= Session["TransactionTimestamp"] %>';
            const element = document.querySelector('.confirmation-container');

            // Debug: Log the content of the labels
            console.log("Transaction ID:", document.getElementById('<%= lblTransactionId.ClientID %>').innerText);
            console.log("Aircraft Model:", document.getElementById('<%= lblAircraftModel.ClientID %>').innerText);
            console.log("Total Amount:", document.getElementById('<%= lblTotalAmount.ClientID %>').innerText);
            
            // Temporarily apply PDF styles
            element.classList.add('pdf-rendering');
            
            setTimeout(() => {
                const opt = {
                    margin: [0.5, 0.5, 1, 0.5],
                    filename: `Transaction_${transactionId}_${timestamp}.pdf`,
                    image: { type: 'jpeg', quality: 0.98 },
                    html2canvas: { scale: 2, useCORS: true },
                    jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
                };
                html2pdf().set(opt).from(element).save().finally(() => {
                    element.classList.remove('pdf-rendering');
                });
            }, 500);
        }

        // JavaScript to dynamically show/hide fields based on payment method
        document.addEventListener('DOMContentLoaded', function () {
            var paymentMethod = document.getElementById('<%= lblPaymentMethod.ClientID %>').innerText;
            if (paymentMethod === 'PayPal') {
                // Hide irrelevant fields for PayPal
                document.getElementById('cardTypeGroup').style.display = 'none';
                document.getElementById('cardNumberGroup').style.display = 'none';
                document.getElementById('expiryDateGroup').style.display = 'none';
                // Show PayPal-specific field
                document.getElementById('paypalEmailGroup').style.display = 'flex';
            } else {
                // Hide PayPal-specific field for non-PayPal payments
                document.getElementById('paypalEmailGroup').style.display = 'none';
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="confirmation-container">
            <div class="confirmation-header">
                <i class="fas fa-check-circle"></i> Transaction Confirmed
            </div>
            <div class="confirmation-body">
                <h3>Transaction Details</h3>
                <div class="detail-group">
                    <label>Transaction ID:</label>
                    <asp:Label ID="lblTransactionId" runat="server" />
                </div>
                <div class="detail-group">
                    <label>Aircraft Model:</label>
                    <asp:Label ID="lblAircraftModel" runat="server" />
                </div>
                <div class="detail-group">
                    <label>Start Date:</label>
                    <asp:Label ID="lblStartDate" runat="server" />
                </div>
                <div class="detail-group">
                    <label>End Date:</label>
                    <asp:Label ID="lblEndDate" runat="server" />
                </div>
                <div class="detail-group">
                    <label>Number of Passengers:</label>
                    <asp:Label ID="lblPassengers" runat="server" />
                </div>
                <div class="detail-group">
                    <label>Total Amount:</label>
                    <asp:Label ID="lblTotalAmount" runat="server" />
                </div>
                <div class="detail-group">
                    <label>Extra Services:</label>
                    <asp:Label ID="lblExtraServices" runat="server" />
                </div>
                <h3>Payment Details</h3>
                <div class="detail-group">
                    <label>Payment Method:</label>
                    <asp:Label ID="lblPaymentMethod" runat="server" />
                </div>
                <div class="detail-group">
                    <label>Cardholder Name:</label>
                    <asp:Label ID="lblCardholderName" runat="server" />
                </div>
                <div class="detail-group" id="cardTypeGroup">
                    <label>Card Type:</label>
                    <asp:Label ID="lblCardType" runat="server" />
                </div>
                <div class="detail-group" id="cardNumberGroup">
                    <label>Card Number (Last 4):</label>
                    <asp:Label ID="lblCardNumberLastFour" runat="server" />
                </div>
                <div class="detail-group" id="expiryDateGroup">
                    <label>Expiry Date:</label>
                    <asp:Label ID="lblExpiryDate" runat="server" />
                </div>
                <div class="detail-group" id="paypalEmailGroup" style="display: none;">
                    <label>PayPal Email:</label>
                    <asp:Label ID="lblPayPalEmail" runat="server" />
                </div>
                <div class="detail-group">
                    <label>Authorization Code:</label>
                    <asp:Label ID="lblAuthorizationCode" runat="server" />
                </div>
                <div class="detail-group">
                    <label>Payment Status:</label>
                    <asp:Label ID="lblPaymentStatus" runat="server" />
                </div>
                <div class="pdf-footer">
                    Generated on: <%= DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") %>
                </div>
                <asp:Button ID="btnBack" runat="server" Text="Back to Home" CssClass="btn btn-back" OnClick="BtnBack_Click" />
                <button type="button" class="btn btn-download" onclick="downloadAsPDF()">Download as PDF</button>
                <asp:Label ID="lblMessage" runat="server" CssClass="lbl-message" ForeColor="Red" Visible="false" />
            </div>
        </div>
    </form>
</body>
</html>