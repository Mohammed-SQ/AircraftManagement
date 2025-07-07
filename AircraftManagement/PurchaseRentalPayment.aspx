<%@ Page Title="Payment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="PurchaseRentalPayment.aspx.cs" Inherits="AircraftManagement.PurchaseRentalPayment" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <script src="/js/PurchaseRentalPayment.js"></script>
    <link rel="stylesheet" type="text/css" href='<%= ResolveClientUrl("~/css/PurchaseRentalCommon.css") %>' />
    <link rel="stylesheet" type="text/css" href='<%= ResolveClientUrl("~/css/PurchaseRentalPayment.css") %>' />

    <style>
        #paypal-loading-spinner {
            display: block;
            text-align: center;
            padding: 10px;
            color: #0070ba;
        }
        #paypal-error-message {
            display: none;
            color: #dc3545;
            font-size: 14px;
            margin-top: 10px;
        }
        .summary-box {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .summary-box p {
            margin: 10px 0;
            font-size: 16px;
            color: #333;
        }
        .summary-box p strong {
            color: #007bff;
            font-weight: 600;
        }
        .total-amount-label {
            font-size: 18px;
            font-weight: bold;
            color: #28a745;
        }
        .payment-options {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }
        .payment-option {
            flex: 1;
            min-width: 150px;
            background-color: #fff;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .payment-option:hover {
            border-color: #007bff;
            box-shadow: 0 2px 6px rgba(0, 123, 255, 0.2);
        }
        .payment-option input[type="radio"] {
            display: none;
        }
        .payment-option label {
            margin: 0;
            font-size: 16px;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
        }
        .payment-option input[type="radio"]:checked + label {
            color: #007bff;
            font-weight: bold;
        }
        .payment-option input[type="radio"]:checked + label i {
            color: #007bff;
        }
        .payment-form-container {
            margin-top: 20px;
        }
        .payment-form {
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .payment-form label {
            font-weight: 600;
            color: #333;
        }
        .payment-form .text-info {
            font-size: 14px;
            color: #6c757d;
        }
        .form-group.coupon-section {
            margin-top: 30px;
        }
        .form-group.coupon-section .form-label {
            font-weight: 600;
            color: #333;
        }
        .form-control {
            border-radius: 5px;
            border: 1px solid #ced4da;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .button-container {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .btn-success {
            background-color: #28a745;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-secondary {
            background-color: #6c757d;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
    </style>

    <div class="container mt-5">
        <asp:Label ID="lblMessage" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
        <h2><i class="fas fa-plane"></i> Aircraft Management - Step 3</h2>

        <div class="step-progress">
            <div class="step-connector"></div>
            <div class="step" id="step1">Select Aircraft</div>
            <div class="step" id="step2">Booking Details</div>
            <div class="step active" id="step3">Payment</div>
        </div>

        <div id="step3Content" class="step-content">
            <h4><i class="fas fa-info-circle"></i> Booking Summary</h4>
            <div class="summary-box">
                <p><strong>Model:</strong> <asp:Label ID="lblAircraftModel" runat="server" /></p>
                <p><strong>Passengers:</strong> <asp:Label ID="lblPassengers" runat="server" /></p>
                <p><strong>Start Date:</strong> <asp:Label ID="lblStartDate" runat="server" /></p>
                <p><strong>End Date:</strong> <asp:Label ID="lblEndDate" runat="server" /></p>
                <p><strong>Total Amount:</strong> <asp:Label ID="lblTotalAmountDisplay" runat="server" CssClass="total-amount-label" ClientIDMode="Static" ReadOnly="true" /></p>
                <p><strong>Extra Services:</strong> <asp:Label ID="lblExtraServices" runat="server" /></p>
            </div>

            <h4><i class="fas fa-credit-card"></i> Payment Methods</h4>

            <div class="form-group">
                <asp:TextBox ID="txtTotalAmount" runat="server" ReadOnly="true" CssClass="form-control" Style="display: none;" />
                <asp:HiddenField ID="hdnTotalAmount" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hdnPaymentMethod" runat="server" ClientIDMode="Static" />
                <asp:HiddenField ID="hdnOrderId" runat="server" ClientIDMode="Static" Value="MOCK_ORDER_123" />
                <asp:HiddenField ID="hdnPayPalPaid" runat="server" ClientIDMode="Static" Value="false" />
                <asp:HiddenField ID="hdnTransactionId" runat="server" ClientIDMode="Static" />
            </div>

            <div class="form-group">
                <div class="payment-options">
                    <div class="payment-option">
                        <input type="radio" name="paymentMethod" value="PayPal" id="paypalOption" checked="checked" onchange="updatePaymentForm();" />
                        <label for="paypalOption"><i class="fab fa-paypal"></i> PayPal</label>
                    </div>
                    <div class="payment-option">
                        <input type="radio" name="paymentMethod" value="Visa" id="visaOption" onchange="updatePaymentForm();" />
                        <label for="visaOption"><i class="fab fa-cc-visa"></i> Visa</label>
                    </div>
                    <div class="payment-option">
                        <input type="radio" name="paymentMethod" value="BankTransfer" id="bankTransferOption" onchange="updatePaymentForm();" />
                        <label for="bankTransferOption"><i class="fas fa-university"></i> Bank Transfer</label>
                    </div>
                    <div class="payment-option">
                        <input type="radio" name="paymentMethod" value="Cash" id="cashOption" onchange="updatePaymentForm();" />
                        <label for="cashOption"><i class="fas fa-money-bill"></i> Cash</label>
                    </div>
                </div>
            </div>

            <div id="paymentFormContainer" class="form-group payment-form-container">
                <div id="payPalForm" class="payment-form">
                    <div class="form-group">
                        <label class="form-label required"><i class="fab fa-paypal"></i> Pay with PayPal</label>
                        <div id="paypal-container-QQWL8C8BBJS9S"></div>
                        <div id="paypal-loading-spinner" style="display: none;">Loading PayPal Button...</div>
                        <div id="paypal-error-message">
                            <i class="fas fa-exclamation-circle"></i> Unable to load PayPal. Please try a different payment method or check your browser settings.
                        </div>
                        <p class="text-info" id="paypal-currency-info">
                            <i class="fas fa-info-circle"></i> 
                            You will be redirected to PayPal for payment. Note: The amount will be converted to USD (1 SR = 0.266 USD). Total: ~$<span id="totalAmountUSD">0.00</span>. If the PayPal button does not load, please disable any ad blockers or try again later. 
                            <a href="#" onclick="cancelPayment('PayPal'); return false;">Cancel</a>
                        </p>
                    </div>
                </div>
                <div id="visaForm" class="payment-form" style="display: none;">
                    <div class="form-group">
                        <label class="form-label required"><i class="fas fa-user"></i> Cardholder Name</label>
                        <input type="text" id="visaCardholderName" name="visaCardholderName" class="form-control" placeholder="e.g., John Doe" />
                        <span id="visaCardholderNameError" class="text-danger" style="display: none;">Cardholder name is required (2-50 characters, letters and spaces only).</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label required"><i class="fas fa-credit-card"></i> Card Number</label>
                        <input type="text" id="visaCardNumber" name="visaCardNumber" class="form-control" placeholder="e.g., 4111 1111 1111 1111" maxlength="19" oninput="formatCardNumber(this);" />
                        <span id="visaCardNumberError" class="text-danger" style="display: none;">Card number must be 16 digits.</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label required"><i class="fas fa-calendar"></i> Expiry Date</label>
                        <input type="text" id="visaExpiryDate" name="visaExpiryDate" class="form-control" placeholder="MM/YY" maxlength="5" />
                        <span id="visaExpiryDateError" class="text-danger" style="display: none;">Expiry date must be in MM/YY format (e.g., 12/25).</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label required"><i class="fas fa-lock"></i> CVV</label>
                        <input type="text" id="visaCvv" name="visaCvv" class="form-control" placeholder="e.g., 123" maxlength="4" />
                        <span id="visaCvvError" class="text-danger" style="display: none;">CVV must be 3-4 digits.</span>
                    </div>
                    <p class="text-info"><i class="fas fa-info-circle"></i> <a href="#" onclick="cancelPayment('Visa'); return false;">Cancel</a></p>
                </div>
                <div id="bankTransferForm" class="payment-form" style="display: none;">
                    <div class="form-group">
                        <label class="form-label required"><i class="fas fa-university"></i> IBAN</label>
                        <input type="text" id="bankIBAN" name="bankIBAN" class="form-control" readonly="readonly" value="SA123456789012345678" />
                    </div>
                    <div class="form-group">
                        <label class="form-label required"><i class="fas fa-upload"></i> Upload Proof of Transfer</label>
                        <input type="text" id="bankTransferFile" name="bankTransferFile" class="form-control" accept=".pdf,.jpg,.png" />
                        <span id="bankTransferFileError" class="text-danger" style="display: none;">Please upload a valid proof (PDF, JPG, or PNG).</span>
                    </div>
                    <p class="text-info"><i class="fas fa-info-circle"></i> <a href="#" onclick="cancelPayment('BankTransfer'); return false;">Cancel</a></p>
                </div>
                <div id="cashForm" class="payment-form" style="display: none;">
                    <p class="text-info"><i class="fas fa-info-circle"></i> Please proceed to the nearest branch to complete your cash payment. Bring your booking reference number (available after confirmation). <a href="#" onclick="cancelPayment('Cash'); return false;">Cancel</a></p>
                </div>
            </div>

            <div class="form-group coupon-section">
                <label class="form-label"><i class="fas fa-gift"></i> Coupon Code</label>
                <asp:TextBox ID="txtCouponCode" runat="server" CssClass="form-control" />
                <asp:Button ID="btnApplyCoupon" runat="server" CssClass="btn btn-primary mt-3" Text="Apply Coupon" OnClientClick="applyCoupon(); return false;" CausesValidation="false" />
                <asp:Label ID="lblCouponMessage" runat="server" CssClass="text-danger" Visible="false"></asp:Label>
            </div>

            <div class="button-container">
                <asp:Button ID="btnConfirmTransaction" runat="server" CssClass="btn btn-success" Text="Confirm Transaction" OnClick="BtnConfirmTransaction_Click" OnClientClick="return initiatePaymentFlow();" ValidationGroup="Step3" />
                <asp:Button ID="btnBackToStep2" runat="server" CssClass="btn btn-secondary" Text="Back" OnClick="BtnBackToStep2_Click" />
            </div>
        </div>

        <!-- PayPal SDK loaded for Smart Buttons -->
        <script 
            src="https://www.paypal.com/sdk/js?client-id=AYIS72pimwZ6JsuO0cOjN5Y4JANo6MpgBUW_hjUh82CJQ_IiIteCAQqDgmDzDqnX3Owj5gpHj6TvPpEj&components=buttons&disable-funding=venmo&currency=USD">
        </script>

        <!-- PayPal Button Rendering Script -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                console.log("DOM fully loaded. Attempting to initialize PayPal SDK...");

                // Ensure paypal object is available
                if (typeof paypal === 'undefined' || !paypal.Buttons) {
                    console.error("PayPal SDK not loaded. Check network, ad blockers, or client-id.");
                    document.getElementById('payPalForm').style.display = 'none';
                    document.getElementById('paypal-error-message').style.display = 'block';
                    document.getElementById('paypal-error-message').innerText = "PayPal SDK failed to load. Please check your network, disable ad blockers, or contact support.";
                    return;
                }

                console.log("PayPal SDK loaded successfully.");

                // Initialize total amount
                var totalAmount = 0;

                // Try to extract total amount from hidden field
                var totalAmountElement = document.getElementById('MainContent_hdnTotalAmount');
                if (!totalAmountElement || !totalAmountElement.value) {
                    console.warn("Hidden total amount element not found! Falling back to lblTotalAmountDisplay.");
                    // Fallback to lblTotalAmountDisplay
                    var displayAmountElement = document.getElementById('lblTotalAmountDisplay');
                    if (displayAmountElement) {
                        var text = displayAmountElement.innerText || displayAmountElement.textContent;
                        totalAmount = parseFloat(text.replace(/[^0-9.]/g, '')) || 0;
                    }
                } else {
                    totalAmount = parseFloat(totalAmountElement.value) || 0;
                }

                if (totalAmount <= 0) {
                    console.error("Invalid total amount:", totalAmount);
                    document.getElementById('payPalForm').style.display = 'none';
                    document.getElementById('paypal-error-message').style.display = 'block';
                    document.getElementById('paypal-error-message').innerText = "Invalid total amount. Please ensure the booking amount is greater than 0.";
                    return;
                }

                // Convert SR to USD (1 SR = 0.266 USD)
                var exchangeRate = 0.266;
                var totalAmountUSD = (totalAmount * exchangeRate).toFixed(2);
                console.log("Total amount in SR:", totalAmount, "Converted to USD:", totalAmountUSD);

                // Update the UI with the converted amount
                document.getElementById('totalAmountUSD').innerText = totalAmountUSD;

                // Show PayPal form and hide error message initially
                document.getElementById('payPalForm').style.display = 'block';
                document.getElementById('paypal-error-message').style.display = 'none';

                // Render PayPal Smart Buttons
                paypal.Buttons({
                    createOrder: function (data, actions) {
                        var totalAmountUSD = (totalAmount * 0.266).toFixed(2);
                        console.log("Creating PayPal order with amount:", totalAmountUSD);
                        return actions.order.create({
                            purchase_units: [{
                                amount: {
                                    currency_code: 'USD',
                                    value: totalAmountUSD
                                }
                            }]
                        });
                    },
                    onApprove: function (data, actions) {
                        console.log("✅ PayPal approved:", data);
                        return actions.order.capture().then(function (details) {
                            console.log("✅ PayPal payment captured:", details);

                            // Extract PayPal-specific details
                            var payerEmail = details.payer.email_address || 'N/A';
                            var transactionId = details.id || 'N/A';
                            var payerName = (details.payer.name.given_name + ' ' + details.payer.name.surname) || 'N/A';

                            // Save the transaction with PayPal details
                            return saveTransactionForPayPal(payerEmail, payerName, transactionId)
                                .then(function (savedTransactionId) {
                                    console.log("✅ Transaction saved successfully:", savedTransactionId);
                                    document.getElementById('hdnPayPalPaid').value = 'true';
                                    document.getElementById('hdnTransactionId').value = savedTransactionId;
                                    console.log("✅ Redirecting to confirmation page...");
                                    window.location.href = "TransactionConfirmation.aspx?TransactionID=" + savedTransactionId;
                                })
                                .catch(function (error) {
                                    console.error("❌ Error saving transaction:", error);
                                    alert("Failed to save transaction. Please contact support.");
                                });
                        });
                    },
                    onCancel: function (data) {
                        console.log("PayPal payment cancelled:", data);
                        alert("Payment cancelled. You can choose another payment method.");
                    },
                    onError: function (err) {
                        console.error("PayPal button error:", err);
                        alert("An error occurred while processing your payment. Please try again or use a different payment method.");
                        document.getElementById('payPalForm').style.display = 'none';
                        document.getElementById('paypal-error-message').style.display = 'block';
                        document.getElementById('paypal-error-message').innerText = "Error loading PayPal button: " + err.message;
                    }
                }).render("#paypal-container-QQWL8C8BBJS9S").then(function () {
                    console.log("✅ PayPal Button rendered successfully!");
                }).catch(function (error) {
                    console.error("❌ Failed to render PayPal Button:", error);
                    document.getElementById('payPalForm').style.display = 'none';
                    document.getElementById('paypal-error-message').style.display = 'block';
                    document.getElementById('paypal-error-message').innerText = "Failed to render PayPal button: " + error.message;
                });
            });

            // Updated saveTransactionForPayPal to send all parameters
            function saveTransactionForPayPal(payerEmail, payerName, paypalTransactionId) {
                console.log("saveTransactionForPayPal: Saving transaction with PayPal details");

                return new Promise(function (resolve, reject) {
                    var method = 'PayPal';
                    var paymentMethodInput = document.getElementById('MainContent_hdnPaymentMethod') || document.getElementById('hdnPaymentMethod');

                    if (paymentMethodInput) {
                        paymentMethodInput.value = method;
                    } else {
                        console.warn("Payment method input not found!");
                    }

                    var xhr = new XMLHttpRequest();
                    xhr.open("POST", "PurchaseRentalPayment.aspx/SaveTransactionForPayPal", true);
                    xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");

                    xhr.onreadystatechange = function () {
                        if (xhr.readyState === 4) {
                            console.log("saveTransactionForPayPal: AJAX request completed with status:", xhr.status);
                            console.log("saveTransactionForPayPal: Response:", xhr.responseText);

                            if (xhr.status === 200) {
                                try {
                                    var response = JSON.parse(xhr.responseText);
                                    console.log("saveTransactionForPayPal: Parsed response:", response);

                                    if (response.d) {
                                        var transactionInput = document.getElementById('hdnTransactionId');

                                        if (transactionInput) {
                                            transactionInput.value = response.d;
                                            console.log("Transaction ID set successfully:", response.d);
                                        } else {
                                            console.warn("Transaction input field not found. Skipping setting value.");
                                        }

                                        // Store PayPal details in sessionStorage for use on the confirmation page
                                        sessionStorage.setItem('paypalPayerEmail', payerEmail);
                                        sessionStorage.setItem('paypalPayerName', payerName);
                                        sessionStorage.setItem('paypalTransactionId', paypalTransactionId);

                                        resolve(response.d);
                                    } else {
                                        console.error("saveTransactionForPayPal: Empty response or missing 'd' field.", response);
                                        reject("Empty response or missing 'd' field.");
                                    }
                                } catch (e) {
                                    console.error("saveTransactionForPayPal: Failed to parse JSON:", e);
                                    reject("Failed to parse response: " + e.message);
                                }
                            } else {
                                console.error("saveTransactionForPayPal: Server error:", xhr.statusText);
                                reject("HTTP error: " + xhr.statusText);
                            }
                        }
                    };

                    var requestData = JSON.stringify({
                        paymentMethod: method,
                        paymentStatus: "Pending",
                        payerEmail: payerEmail,
                        payerName: payerName,
                        paypalTransactionId: paypalTransactionId
                    });

                    console.log("saveTransactionForPayPal: Sending data:", requestData);
                    xhr.send(requestData);
                });
            }

            function updatePaymentForm() {
                console.log("updatePaymentForm: Updating payment form visibility");
                var selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');

                // Hide all forms except the selected one
                document.querySelectorAll('.payment-form').forEach(function (form) {
                    form.style.display = 'none';
                });

                if (selectedMethod) {
                    var method = selectedMethod.value + 'Form';
                    var form = document.getElementById(method);
                    if (form) {
                        console.log("Showing form for " + selectedMethod.value);
                        form.style.display = 'block';
                    }
                }

                document.getElementById('paymentFormContainer').style.display = 'block';
            }

            function applyCoupon() {
                console.log("applyCoupon: Applying coupon code");
                var code = document.getElementById('MainContent_txtCouponCode').value.toUpperCase();
                var discount = code === "SAVE10" ? 1875 : code === "SAVE20" ? 3750 : 0;
                var total = parseFloat(document.getElementById('MainContent_hdnTotalAmount').value) || 0;
                if (discount > 0) {
                    total = Math.max(total - discount, 0).toFixed(2);
                    document.getElementById('MainContent_hdnTotalAmount').value = total;
                    document.getElementById('MainContent_txtTotalAmount').value = total;
                    document.getElementById('lblTotalAmountDisplay').innerHTML = '<img src="/Symbols/Saudi_Riyal_Symbol-black.ico" class="currency-icon" alt="SR"/> ' + total;
                    document.getElementById('MainContent_lblCouponMessage').innerText = 'Coupon applied! ' + discount + ' SR discount.';
                    document.getElementById('MainContent_lblCouponMessage').className = "text-success";
                } else {
                    document.getElementById('MainContent_lblCouponMessage').innerText = "Invalid coupon code.";
                    document.getElementById('MainContent_lblCouponMessage').className = "text-danger";
                }
                document.getElementById('MainContent_lblCouponMessage').style.display = "block";
            }

            function confirmAndSubmit() {
                console.log("confirmAndSubmit: Validating payment method selection");
                var selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
                var isValid = true;

                if (!selectedMethod) {
                    alert('Please select a payment method.');
                    return false;
                }

                var method = selectedMethod.value;
                document.getElementById('MainContent_hdnPaymentMethod').value = method;

                if (method === 'PayPal' && document.getElementById('hdnPayPalPaid').value !== 'true') {
                    alert('Please complete the PayPal payment before confirming the transaction.');
                    return false;
                }

                if (method === 'Visa') {
                    var name = document.getElementById('visaCardholderName').value;
                    var number = document.getElementById('visaCardNumber').value.replace(/\s/g, '');
                    var expiry = document.getElementById('visaExpiryDate').value;
                    var cvv = document.getElementById('visaCvv').value;

                    if (!name || !/^[a-zA-Z\s]{2,50}$/.test(name)) {
                        document.getElementById('visaCardholderNameError').style.display = 'block';
                        isValid = false;
                    } else {
                        document.getElementById('visaCardholderNameError').style.display = 'none';
                    }
                    if (!number || !/^\d{16}$/.test(number)) {
                        document.getElementById('visaCardNumberError').style.display = 'block';
                        isValid = false;
                    } else {
                        document.getElementById('visaCardNumberError').style.display = 'none';
                    }
                    if (!expiry || !/^(0[1-9]|1[0-2])\/[0-9]{2}$/.test(expiry)) {
                        document.getElementById('visaExpiryDateError').style.display = 'block';
                        isValid = false;
                    } else {
                        document.getElementById('visaExpiryDateError').style.display = 'none';
                    }
                    if (!cvv || !/^\d{3,4}$/.test(cvv)) {
                        document.getElementById('visaCvvError').style.display = 'block';
                        isValid = false;
                    } else {
                        document.getElementById('visaCvvError').style.display = 'none';
                    }
                } else if (method === 'BankTransfer') {
                    var file = document.getElementById('bankTransferFile').value;
                    if (!file || !/\.(pdf|jpg|png)$/i.test(file)) {
                        document.getElementById('bankTransferFileError').style.display = 'block';
                        isValid = false;
                    } else {
                        document.getElementById('bankTransferFileError').style.display = 'none';
                    }
                }

                return isValid;
            }

            function initiatePaymentFlow() {
                console.log("initiatePaymentFlow: Initiating payment flow");
                var isValid = confirmAndSubmit();
                if (!isValid) {
                    return false;
                }

                var method = document.getElementById('MainContent_hdnPaymentMethod').value;
                var totalAmount = document.getElementById('MainContent_hdnTotalAmount').value;
                var orderId = document.getElementById('MainContent_hdnOrderId').value;
                var returnUrl = encodeURIComponent(window.location.href);
                var cancelUrl = encodeURIComponent("CancelPayment.aspx?returnUrl=" + window.location.href);

                if (method === 'PayPal') {
                    return false;
                } else if (method === 'Visa') {
                    window.location.href = "MockPayment.aspx?amount=" + totalAmount + "&orderId=" + orderId + "&returnUrl=" + returnUrl + "&cancelUrl=" + cancelUrl;
                } else if (method === 'BankTransfer' || method === 'Cash') {
                    document.getElementById('MainContent_btnConfirmTransaction').click();
                }

                return false;
            }

            function cancelPayment(method) {
                console.log("cancelPayment: Canceling payment for " + method);
                var cancelUrl = encodeURIComponent("CancelPayment.aspx?returnUrl=" + window.location.href + "&method=" + method);
                window.location.href = "CancelPayment.aspx?returnUrl=" + window.location.href + "&method=" + method;
            }

            function formatCardNumber(input) {
                var value = input.value.replace(/\D/g, '');
                input.value = value.replace(/(\d{4})/g, '$1 ').trim();
            }
        </script>
    </div>
</asp:Content>