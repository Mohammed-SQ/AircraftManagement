document.addEventListener('DOMContentLoaded', function () {
    console.log("DOMContentLoaded: Initializing payment form and styles");
    updatePaymentForm();
});

function updatePaymentForm() {
    console.log("updatePaymentForm: Updating payment form visibility");
    var selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');

    document.querySelectorAll('.payment-form').forEach(function (form) {
        if (form.id !== 'payPalForm') {
            form.style.display = 'none';
        }
    });

    if (selectedMethod && selectedMethod.value !== 'PayPal') {
        var method = selectedMethod.value + 'Form';
        var form = document.getElementById(method);
        if (form) {
            console.log("Showing form for " + selectedMethod.value);
            form.style.display = 'block';
        }
    }

    document.getElementById('paymentFormContainer').style.display = 'block';
}

function saveTransactionForPayPal() {
    console.log("saveTransactionForPayPal: Saving transaction before PayPal payment");

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
            paymentStatus: "Pending"
        });

        console.log("saveTransactionForPayPal: Sending data:", requestData);
        xhr.send(requestData);
    });
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

function confirmAndMoveToStep(step) {
    console.log("Moving to step " + step);
    document.getElementById('step1Content').style.display = 'none';
    document.getElementById('step2Content').style.display = 'none';
    document.getElementById('step3Content').style.display = 'none';
    document.getElementById('step' + step + 'Content').style.display = 'block';
    document.getElementById('MainContent_currentStep').value = step;
    return true;
}

function moveToPreviousStep() {
    var currentStep = parseInt(document.getElementById('MainContent_currentStep').value);
    if (currentStep > 1) {
        confirmAndMoveToStep(currentStep - 1);
    }
}

function changeAircraft(select) {
    console.log("Aircraft changed: " + select.value);
}

function updateTransactionType() {
    console.log("Transaction type updated");
}

function updateCompanyOptions() {
    console.log("Customer type updated");
}

function updatePassengerOptions() {
    console.log("Passenger options updated");
}

function updatePrice() {
    console.log("Price updated");
}