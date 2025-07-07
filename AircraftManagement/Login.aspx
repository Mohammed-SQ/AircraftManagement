<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="AircraftManagement.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
            <style>
                body {
                    background-color:black;
                }
                .modal-content {
                    border-radius: 15px;
                    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
                    background: #2b2b2b;
                    border: none;
                }

                .modal-header {
                    background: linear-gradient(90deg, #4B0082 20%, #7001D0 51%, #BD87EB 100%);
                    color: white;
                    border-bottom: none;
                    border-top-left-radius: 15px;
                    border-top-right-radius: 15px;
                    padding: 20px 30px;
                }

                .modal-dialog {
                    display: flex;
                    align-items: center;
                    min-height: calc(100vh - 60px);
                    margin-top: 0;
                    margin-bottom: 0;
                }

                .modal-title {
                    font-size: 1.8em;
                    font-weight: 700;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .modal-body {
                    padding: 30px;
                    max-height: 70vh;
                    overflow-y: auto;
                    color: #d0d0d0;
                }

                .form-label {
                    font-weight: 500;
                    color: #d0d0d0;
                }

                .form-control {
                    border: none;
                    padding: 12px 15px;
                    font-size: 1em;
                    transition: all 0.3s ease;
                    background: #3a3a3a;
                    box-shadow: none;
                    color: #ffffff !important;
                    width: 100%;
                    border-radius: 5px;
                }

                .form-control:focus {
                    outline: none;
                    background: #3a3a3a;
                    box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
                    border: 1px solid #007bff;
                }

                .form-control::placeholder {
                    color: white !important;
                    opacity: 1;
                }

                .btn-primary {
                    background-color: #007bff;
                    border-color: #007bff;
                    padding: 12px 30px;
                    font-size: 1.1em;
                    font-weight: 600;
                    border-radius: 10px;
                    transition: all 0.3s ease;
                    width: 100%;
                }

                .btn-primary:hover {
                    background-color: #0056b3;
                    border-color: #0056b3;
                    transform: translateY(-3px);
                    box-shadow: 0 7px 20px rgba(0, 123, 255, 0.4);
                }

                .btn-secondary {
                    background-color: #6c757d !important;
                    border-color: #6c757d !important;
                    padding: 8px 15px;
                    font-size: 0.9em;
                    border-radius: 5px;
                    transition: all 0.3s ease;
                    cursor: pointer;
                }

                .btn-secondary:hover {
                    background-color: #5a6268 !important;
                    border-color: #545b62 !important;
                }

                .text-danger {
                    font-size: 0.9em;
                    font-weight: 500;
                }

                .password-group {
                    position: relative;
                }

                .toggle-password {
                    position: absolute;
                    right: 0px;
                    top: 50%;
                    transform: translateY(-50%);
                    cursor: pointer;
                    color: #ffffff;
                    padding: 13px 15px;
                    border-radius: 5px;
                    font-size: 1.2em;
                }

                .text-center a {
                    font-size: 0.9em;
                    color: #007bff;
                    text-decoration: none;
                    padding: 12px 30px;
                    border-radius: 10px;
                    text-align: center;
                    width: 100%;
                    display: block;
                    transition: all 0.3s ease;
                }

                .text-center a:hover {
                    color: #0056b3;
                    text-decoration: underline;
                    background-color: rgba(255, 255, 255, 0.1);
                }

                .forgot-password {
                    font-size: 0.9em;
                    color: #007bff;
                    text-decoration: none;
                    display: block;
                    margin-top: 5px;
                    transition: all 0.3s ease;
                }

                .forgot-password:hover {
                    color: #0056b3;
                    text-decoration: underline;
                }

                .code-input {
                    width: 50px !important;
                    height: 50px !important;
                    text-align: center;
                    font-size: 1.5em;
                    border: 2px solid #4a4a4a !important;
                    border-radius: 8px;
                    background: #3a3a3a !important;
                    color: #ffffff !important;
                    transition: all 0.3s ease;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
                }

                .code-input:focus {
                    outline: none;
                    border-color: #007bff !important;
                    box-shadow: 0 0 8px rgba(0, 123, 255, 0.5);
                    background: #4a4a4a !important;
                    transform: scale(1.05);
                }

                .code-input:not(:placeholder-shown) {
                    border-color: #28a745 !important;
                    box-shadow: 0 0 8px rgba(40, 167, 69, 0.5);
                }

                .text-muted {
                    font-size: 0.9em;
                    color: #6c757d !important;
                }
            </style>
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="loginModalLabel">
                            <i class="fas fa-plane"></i> Join Our Flight Today!
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Login Section -->
                        <div id="loginSection" style="display: block;">
                            <div class="mb-3">
                                <label for="txtLoginUsername" class="form-label">Username</label>
                                <input type="text" id="txtLoginUsername" class="form-control" placeholder="Enter your username" maxlength="100" />
                            </div>
                            <div class="mb-3">
                                <label for="txtLoginPassword" class="form-label">Password</label>
                                <div class="password-group">
                                    <input type="password" id="txtLoginPassword" class="form-control" placeholder="Enter your password" maxlength="265" />
                                    <span class="toggle-password" onclick="window.togglePassword('txtLoginPassword', this)">👁️</span>
                                </div>
                                <a href="#" class="forgot-password" onclick="window.showForgotPassword(); return false;">Forgot Password?</a>
                            </div>
                            <div id="lblLoginMessage" class="text-danger mb-3 d-block" style="display: none;"></div>
                            <button type="button" id="btnLogin" class="btn btn-primary w-100">Login</button>
                            <div class="text-center mt-3">
                                <a href="#" onclick="window.showRegisterModal(); return false;">Don't have an account? Sign up</a>
                            </div>
                        </div>

                        <!-- Forgot Password: Enter Email/Phone Section -->
                        <div id="forgotPasswordSection" style="display: none;">
                            <h5>RESET YOUR PASSWORD</h5>
                            <div class="mb-3">
                                <label for="txtForgotContact" class="form-label">Email or Phone Number</label>
                                <input type="text" id="txtForgotContact" class="form-control" placeholder="Enter your email or phone number" maxlength="200" oninput="window.validateForgotContact(this)" />
                                <small class="text-muted">Enter your email (e.g., example@domain.com) or phone number (e.g., 5xxxxxxxx for +9665xxxxxxxx).</small>
                            </div>
                             <div id="lblForgotPasswordMessage" class="text-danger mb-3 d-block" style="display: none;"></div>
                            <button type="button" id="btnRequestCode" class="btn btn-primary w-100">Request Verification Code</button>
                            <div class="text-center mt-3">
                                <a href="#" onclick="window.showLoginSection(); return false;">Back to Login</a>
                            </div>
                        </div>

                        <!-- Forgot Password: Verification Code Section -->
                        <div id="verificationSection" style="display: none;">
                            <h5>VERIFY YOUR IDENTITY</h5>
                            <div id="lblVerificationMessageDisplay" class="mb-3 d-block"></div>
                            <div class="mb-3">
                                <label class="form-label">Verification Code</label>
                                <div class="d-flex justify-content-between">
                                    <input type="text" id="txtCode1" class="form-control code-input" maxlength="1" oninput="window.moveToNextOrPrevious(this, 'txtCode2', null)" onpaste="window.handlePaste(event)" onkeydown="window.handleKeyDown(event, this, 'txtCode2', null)" />
                                    <input type="text" id="txtCode2" class="form-control code-input" maxlength="1" oninput="window.moveToNextOrPrevious(this, 'txtCode3', 'txtCode1')" onkeydown="window.handleKeyDown(event, this, 'txtCode3', 'txtCode1')" />
                                    <input type="text" id="txtCode3" class="form-control code-input" maxlength="1" oninput="window.moveToNextOrPrevious(this, 'txtCode4', 'txtCode2')" onkeydown="window.handleKeyDown(event, this, 'txtCode4', 'txtCode2')" />
                                    <input type="text" id="txtCode4" class="form-control code-input" maxlength="1" oninput="window.moveToNextOrPrevious(this, 'txtCode5', 'txtCode3')" onkeydown="window.handleKeyDown(event, this, 'txtCode5', 'txtCode3')" />
                                    <input type="text" id="txtCode5" class="form-control code-input" maxlength="1" oninput="window.moveToNextOrPrevious(this, 'txtCode6', 'txtCode4')" onkeydown="window.handleKeyDown(event, this, 'txtCode6', 'txtCode4')" />
                                    <input type="text" id="txtCode6" class="form-control code-input" maxlength="1" oninput="window.moveToNextOrPrevious(this, null, 'txtCode5')" onkeydown="window.handleKeyDown(event, this, null, 'txtCode5')" />
                                </div>
                            </div>
                            <div class="mb-3">
                                <button type="button" class="btn btn-secondary" onclick="window.pasteCode()">Paste Code</button>
                                <button type="button" class="btn btn-secondary" onclick="window.clearCode()">Clear</button>
                                <span id="resendCodeLink" style="display: inline;">
                                    <a href="#" onclick="window.resendCode(event)">Resend Code</a>
                                </span>
                                <span id="resendTimer" style="display: none;">
                                    Resend available in <span id="timerSeconds">60</span>s
                                </span>
                            </div>
                            <div id="lblVerificationMessage" class="text-danger mb-3 d-block" style="display: none;"></div>
                            <div class="text-center mt-3">
                                <a href="#" onclick="window.showForgotPassword(); return false;">Back</a>
                            </div>
                        </div>

                        <!-- Forgot Password: New Password Section -->
                        <div id="newPasswordSection" style="display: none;">
                            <h5>SET NEW PASSWORD</h5>
                            <div id="lblNewPasswordMessage" class="text-danger mb-3 d-block" style="display: none;"></div>
                            <div class="mb-3">
                                <label for="txtNewPassword" class="form-label">New Password</label>
                                <div class="password-group">
                                    <input type="password" id="txtNewPassword" class="form-control" placeholder="Enter new password" maxlength="20" />
                                    <span class="toggle-password" onclick="window.togglePassword('txtNewPassword', this)">👁️</span>
                                </div>
                                <small class="text-muted">Password must be 8-20 characters.</small>
                            </div>
                            <div class="mb-3">
                                <label for="txtRepeatPassword" class="form-label">Repeat Password</label>
                                <div class="password-group">
                                    <input type="password" id="txtRepeatPassword" class="form-control" placeholder="Repeat new password" maxlength="20" />
                                    <span class="toggle-password" onclick="window.togglePassword('txtRepeatPassword', this)">👁️</span>
                                </div>
                            </div>
                            <button type="button" id="btnResetPassword" class="btn btn-primary w-100">Reset Password</button>
                            <div class="text-center mt-3">
                                <a href="#" onclick="window.showLoginSection(); return false;">Back to Login</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <input type="hidden" id="hfCombinedCode" runat="server" />
            <input type="hidden" id="hfContactMethod" runat="server" Value="" />
            <script>
                function initializeLoginModal() {
                    console.log("Login.aspx JavaScript loaded");

                    var loginModalElement = document.getElementById('loginModal');
                    if (loginModalElement) {
                        var loginModal = new bootstrap.Modal(loginModalElement, { backdrop: 'static', keyboard: false });
                        loginModal.show();
                    } else {
                        console.error("loginModal element not found on page load");
                    }

                    window.togglePassword = function (fieldId, span) {
                        var field = document.getElementById(fieldId);
                        if (field.type === 'password') {
                            field.type = 'text';
                            span.innerHTML = '👁️‍🗨️';
                            span.style.fontSize = '2.2em';
                        } else {
                            field.type = 'password';
                            span.innerHTML = '👁️';
                            span.style.fontSize = '1.2em';
                        }
                    };

                    window.closeModal = function (modalId) {
                        var modal = bootstrap.Modal.getInstance(document.getElementById(modalId));
                        if (modal) {
                            modal.hide();
                            document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
                            document.body.classList.remove('modal-open');
                            document.body.style.overflow = '';
                            document.body.style.paddingRight = '';
                        }
                    };

                    window.showForgotPassword = function () {
                        document.getElementById('loginSection').style.display = 'none';
                        document.getElementById('forgotPasswordSection').style.display = 'block';
                        document.getElementById('verificationSection').style.display = 'none';
                        document.getElementById('newPasswordSection').style.display = 'none';
                        document.getElementById('txtForgotContact').value = '';
                        document.getElementById('lblForgotPasswordMessage').style.display = 'none';
                    };

                    window.showLoginSection = function () {
                        document.getElementById('loginSection').style.display = 'block';
                        document.getElementById('forgotPasswordSection').style.display = 'none';
                        document.getElementById('verificationSection').style.display = 'none';
                        document.getElementById('newPasswordSection').style.display = 'none';
                        document.getElementById('txtLoginUsername').value = '';
                        document.getElementById('txtLoginPassword').value = '';
                        document.getElementById('lblLoginMessage').style.display = 'none';
                    };

                    window.validateForgotContact = function (input) {
                        var value = input.value.trim();
                        var isNumeric = /^\d+$/.test(value);

                        if (isNumeric) {
                            // If starts with '05', remove the leading '0'
                            if (value.startsWith('05')) {
                                input.value = value.substring(1);
                            } else {
                                // Do nothing, leave other inputs as they are
                                input.value = value;
                            }

                            // Clean non-digits just in case
                            input.value = input.value.replace(/\D/g, '');

                            // Limit to 9 digits maximum
                            if (input.value.length > 9) {
                                input.value = input.value.substring(0, 9);
                            }
                        }
                    };


                    window.showVerification = function (message) {
                        document.getElementById('loginSection').style.display = 'none';
                        document.getElementById('forgotPasswordSection').style.display = 'none';
                        document.getElementById('verificationSection').style.display = 'block';
                        document.getElementById('newPasswordSection').style.display = 'none';
                        document.getElementById('lblVerificationMessageDisplay').innerText = message;
                        document.getElementById('lblVerificationMessageDisplay').style.display = 'block';
                        window.clearCode();
                        window.startResendTimer();
                    };

                    window.showNewPassword = function () {
                        document.getElementById('loginSection').style.display = 'none';
                        document.getElementById('forgotPasswordSection').style.display = 'none';
                        document.getElementById('verificationSection').style.display = 'none';
                        document.getElementById('newPasswordSection').style.display = 'block';
                        document.getElementById('txtNewPassword').value = '';
                        document.getElementById('txtRepeatPassword').value = '';
                        document.getElementById('lblNewPasswordMessage').style.display = 'none';
                    };

                    window.moveToNextOrPrevious = function (current, nextFieldId, prevFieldId) {
                        current.value = current.value.replace(/[^0-9]/g, '');
                        if (current.value.length === 1 && nextFieldId) {
                            document.getElementById(nextFieldId).focus();
                        } else if (current.value.length === 0 && prevFieldId) {
                            document.getElementById(prevFieldId).focus();
                        }

                        var codes = ['txtCode1', 'txtCode2', 'txtCode3', 'txtCode4', 'txtCode5', 'txtCode6'].map(id => document.getElementById(id).value);
                        if (current.id === 'txtCode6' && codes.every(c => c)) {
                            window.submitVerification();
                        }
                    };

                    window.handleKeyDown = function (event, current, nextFieldId, prevFieldId) {
                        if ((event.key === 'Backspace' || event.key === 'Delete') && current.value.length === 0 && prevFieldId) {
                            event.preventDefault();
                            document.getElementById(prevFieldId).focus();
                        }
                    };

                    window.clearCode = function () {
                        ['txtCode1', 'txtCode2', 'txtCode3', 'txtCode4', 'txtCode5', 'txtCode6'].forEach(id => document.getElementById(id).value = '');
                        document.getElementById('txtCode1').focus();
                        document.getElementById('<%= hfCombinedCode.ClientID %>').value = '';
                        document.getElementById('lblVerificationMessage').style.display = 'none';
                    };

                    window.pasteCode = function () {
                        navigator.clipboard.readText().then(pastedData => {
                            pastedData = pastedData.trim();
                            if (/^\d{6}$/.test(pastedData)) {
                                var digits = pastedData.split('');
                                ['txtCode1', 'txtCode2', 'txtCode3', 'txtCode4', 'txtCode5', 'txtCode6'].forEach((id, i) => document.getElementById(id).value = digits[i]);
                                document.getElementById('txtCode6').focus();
                                window.submitVerification();
                            } else {
                                document.getElementById('lblVerificationMessage').innerText = "Please paste a valid 6-digit numeric code.";
                                document.getElementById('lblVerificationMessage').style.display = 'block';
                            }
                        }).catch(err => {
                            document.getElementById('lblVerificationMessage').innerText = "Unable to access clipboard. Paste manually.";
                            document.getElementById('lblVerificationMessage').style.display = 'block';
                        });
                    };

                    window.handlePaste = function (event) {
                        event.preventDefault();
                        var pastedData = (event.clipboardData || window.clipboardData).getData('text').trim();
                        if (/^\d{6}$/.test(pastedData)) {
                            var digits = pastedData.split('');
                            ['txtCode1', 'txtCode2', 'txtCode3', 'txtCode4', 'txtCode5', 'txtCode6'].forEach((id, i) => document.getElementById(id).value = digits[i]);
                            document.getElementById('txtCode6').focus();
                            window.submitVerification();
                        } else {
                            document.getElementById('lblVerificationMessage').innerText = "Please paste a valid 6-digit numeric code.";
                            document.getElementById('lblVerificationMessage').style.display = 'block';
                        }
                    };

                    window.startResendTimer = function () {
                        var resendLink = document.getElementById('resendCodeLink');
                        var resendTimer = document.getElementById('resendTimer');
                        var timerSeconds = document.getElementById('timerSeconds');
                        var secondsLeft = 60;
                        timerSeconds.innerText = secondsLeft;
                        resendLink.style.display = 'none';
                        resendTimer.style.display = 'inline';
                        var interval = setInterval(() => {
                            secondsLeft--;
                            timerSeconds.innerText = secondsLeft;
                            if (secondsLeft <= 0) {
                                clearInterval(interval);
                                resendLink.style.display = 'inline';
                                resendTimer.style.display = 'none';
                            }
                        }, 1000);
                    };

                    window.resendCode = function (event) {
                        event.preventDefault();
                        var contact = document.getElementById('txtForgotContact').value.trim();
                        var contactMethod = document.getElementById('<%= hfContactMethod.ClientID %>').value;
                        $.ajax({
                            type: "POST",
                            url: "Login.aspx/ResendVerificationCode",
                            data: JSON.stringify({ contact: contact, contactMethod: contactMethod }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                if (response.d.success) {
                                    document.getElementById('lblVerificationMessageDisplay').innerText = response.d.message;
                                    window.startResendTimer();
                                } else {
                                    document.getElementById('lblVerificationMessage').innerText = response.d.message;
                                    document.getElementById('lblVerificationMessage').style.display = 'block';
                                }
                            },
                            error: function (xhr) {
                                document.getElementById('lblVerificationMessage').innerText = "Error resending code: " + (xhr.responseText || "Unknown error");
                                document.getElementById('lblVerificationMessage').style.display = 'block';
                            }
                        });
                    };

                    window.submitVerification = function () {
                        var combinedCode = ['txtCode1', 'txtCode2', 'txtCode3', 'txtCode4', 'txtCode5', 'txtCode6'].map(id => document.getElementById(id).value).join('');
                        var lblVerificationMessage = document.getElementById('lblVerificationMessage');
                        if (combinedCode.length !== 6) {
                            lblVerificationMessage.innerText = "Please enter a 6-digit verification code.";
                            lblVerificationMessage.style.display = 'block';
                            return;
                        }
                        lblVerificationMessage.style.display = 'none';
                        document.getElementById('<%= hfCombinedCode.ClientID %>').value = combinedCode;
                        $.ajax({
                            type: "POST",
                            url: "Login.aspx/VerifyCode",
                            data: JSON.stringify({ code: combinedCode }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                if (response.d.success) {
                                    window.showNewPassword();
                                } else {
                                    lblVerificationMessage.innerText = response.d.message;
                                    lblVerificationMessage.style.display = 'block';
                                }
                            },
                            error: function (xhr) {
                                lblVerificationMessage.innerText = "Error verifying code: " + (xhr.responseText || "Unknown error");
                                lblVerificationMessage.style.display = 'block';
                            }
                        });
                    };

                    window.showRegisterModal = function () {
                        window.closeModal('loginModal'); // Close login modal first
                        fetch('Register.aspx')
                            .then(response => response.text())
                            .then(html => {
                                var parser = new DOMParser();
                                var doc = parser.parseFromString(html, 'text/html');
                                var modalContent = doc.querySelector('#registerModal');

                                if (modalContent) {
                                    var existingModal = document.querySelector('#registerModal');
                                    if (existingModal) {
                                        existingModal.remove();
                                    }

                                    document.body.appendChild(modalContent);

                                    var scripts = modalContent.getElementsByTagName('script');
                                    for (var i = 0; i < scripts.length; i++) {
                                        var scriptContent = scripts[i].innerHTML;
                                        if (scriptContent) {
                                            try {
                                                eval(scriptContent);
                                            } catch (e) {
                                                console.error("Error executing script:", e);
                                            }
                                        }
                                    }

                                    var modal = new bootstrap.Modal(modalContent, {
                                        backdrop: 'static',
                                        keyboard: false
                                    });
                                    modal.show();

                                    modalContent.addEventListener('hidden.bs.modal', function () {
                                        modalContent.remove();
                                        document.body.classList.remove('modal-open');
                                        var backdrop = document.querySelector('.modal-backdrop');
                                        if (backdrop) backdrop.remove();
                                    });

                                    setTimeout(function () {
                                        var toggleDiv = modalContent.querySelector('#contactMethodToggle');
                                        var togglePasswordIcon = modalContent.querySelector('#togglePasswordIcon');
                                        var switchToLoginLink = modalContent.querySelector('#switchToLoginLink');
                                        var passwordField = modalContent.querySelector('input[type="password"][placeholder="Enter your password"]');
                                        var btnSignUp = modalContent.querySelector('#MainContent_btnSignUp');

                                        if (toggleDiv) {
                                            toggleDiv.removeEventListener('click', window.toggleContactMethod);
                                            toggleDiv.addEventListener('click', window.toggleContactMethod);
                                        }
                                        if (togglePasswordIcon) {
                                            togglePasswordIcon.removeEventListener('click', window.togglePassword);
                                            togglePasswordIcon.addEventListener('click', window.togglePassword);
                                        }
                                        if (switchToLoginLink) {
                                            switchToLoginLink.removeEventListener('click', window.switchToLogin);
                                            switchToLoginLink.addEventListener('click', function (e) {
                                                e.preventDefault();
                                                window.switchToLogin();
                                            });
                                        }
                                        if (passwordField && btnSignUp) {
                                            passwordField.addEventListener('keypress', function (e) {
                                                if (e.key === 'Enter') {
                                                    e.preventDefault();
                                                    btnSignUp.click();
                                                }
                                            });
                                        }
                                    }, 0);
                                } else {
                                    console.error('Register modal not found in Register.aspx');
                                }
                            })
                            .catch(error => {
                                console.error('Error fetching register modal:', error);
                            });
                    };

                    var attempts = 0;
                    var maxAttempts = 50;
                    var interval = setInterval(() => {
                        attempts++;
                        var modal = document.getElementById('loginModal');
                        var passwordField = document.getElementById('txtLoginPassword');
                        var btnLogin = document.getElementById('btnLogin');
                        var btnRequestCode = document.getElementById('btnRequestCode');
                        var btnResetPassword = document.getElementById('btnResetPassword');

                        if (modal && passwordField && btnLogin && btnRequestCode && btnResetPassword) {
                            passwordField.addEventListener('keypress', function (e) {
                                if (e.key === 'Enter') {
                                    e.preventDefault();
                                    btnLogin.click();
                                }
                            });

                            btnLogin.addEventListener('click', function () {
                                var username = document.getElementById('txtLoginUsername').value.trim();
                                var password = document.getElementById('txtLoginPassword').value;
                                var lblLoginMessage = document.getElementById('lblLoginMessage');
                                if (!username) {
                                    lblLoginMessage.innerText = "Username is required.";
                                    lblLoginMessage.style.display = 'block';
                                    return;
                                }
                                if (!password) {
                                    lblLoginMessage.innerText = "Password is required.";
                                    lblLoginMessage.style.display = 'block';
                                    return;
                                }
                                lblLoginMessage.style.display = 'none';
                                $.ajax({
                                    type: "POST",
                                    url: "Login.aspx/LoginUser",
                                    data: JSON.stringify({ username: username, password: password }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (response) {
                                        if (response.d.success) {
                                            window.closeModal('loginModal');
                                            window.location.reload();
                                        } else {
                                            lblLoginMessage.innerText = response.d.message;
                                            lblLoginMessage.style.display = 'block';
                                        }
                                    },
                                    error: function (xhr) {
                                        lblLoginMessage.innerText = "Error during login: " + (xhr.responseText || "Unknown error");
                                        lblLoginMessage.style.display = 'block';
                                    }
                                });
                            });

                            btnRequestCode.addEventListener('click', function () {
                                var contact = document.getElementById('txtForgotContact').value.trim();
                                var lblForgotPasswordMessage = document.getElementById('lblForgotPasswordMessage');
                                var isEmail = contact.includes('@');
                                var contactMethod = isEmail ? 'Email' : 'SMS';
                                document.getElementById('<%= hfContactMethod.ClientID %>').value = contactMethod;

                                if (!contact) {
                                    lblForgotPasswordMessage.innerText = "Email or phone number is required.";
                                    lblForgotPasswordMessage.style.display = 'block';
                                    return;
                                }
                                if (isEmail && (!contact.includes('@') || !contact.includes('.'))) {
                                    lblForgotPasswordMessage.innerText = "Invalid email address (must contain @ and .).";
                                    lblForgotPasswordMessage.style.display = 'block';
                                    return;
                                } else if (!isEmail && !/^5\d{0,8}$/.test(contact)) {
                                    lblForgotPasswordMessage.innerText = "Phone must be up to 9 digits starting with 5.";
                                    lblForgotPasswordMessage.style.display = 'block';
                                    return;
                                }
                                lblForgotPasswordMessage.style.display = 'none';
                                $.ajax({
                                    type: "POST",
                                    url: "Login.aspx/RequestVerificationCode",
                                    data: JSON.stringify({ contact: contact, contactMethod: contactMethod }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (response) {
                                        if (response.d.success) {
                                            window.showVerification(response.d.message);
                                        } else {
                                            lblForgotPasswordMessage.innerText = response.d.message;
                                            lblForgotPasswordMessage.style.display = 'block';
                                        }
                                    },
                                    error: function (xhr) {
                                        lblForgotPasswordMessage.innerText = "Error requesting code: " + (xhr.responseText || "Unknown error");
                                        lblForgotPasswordMessage.style.display = 'block';
                                    }
                                });
                            });

                            btnResetPassword.addEventListener('click', function () {
                                var newPassword = document.getElementById('txtNewPassword').value;
                                var repeatPassword = document.getElementById('txtRepeatPassword').value;
                                var lblNewPasswordMessage = document.getElementById('lblNewPasswordMessage');
                                if (!newPassword) {
                                    lblNewPasswordMessage.innerText = "New password is required.";
                                    lblNewPasswordMessage.style.display = 'block';
                                    return;
                                }
                                if (newPassword.length < 8 || newPassword.length > 20) {
                                    lblNewPasswordMessage.innerText = "Password must be 8-20 characters.";
                                    lblNewPasswordMessage.style.display = 'block';
                                    return;
                                }
                                if (!repeatPassword) {
                                    lblNewPasswordMessage.innerText = "Please repeat your new password.";
                                    lblNewPasswordMessage.style.display = 'block';
                                    return;
                                }
                                if (newPassword !== repeatPassword) {
                                    lblNewPasswordMessage.innerText = "Passwords do not match.";
                                    lblNewPasswordMessage.style.display = 'block';
                                    return;
                                }
                                lblNewPasswordMessage.style.display = 'none';
                                $.ajax({
                                    type: "POST",
                                    url: "Login.aspx/ResetPassword",
                                    data: JSON.stringify({ newPassword: newPassword }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (response) {
                                        if (response.d.success) {
                                            alert("Password reset successful! Please log in with your new password.");
                                            window.showLoginSection();
                                        } else {
                                            lblNewPasswordMessage.innerText = response.d.message;
                                            lblNewPasswordMessage.style.display = 'block';
                                        }
                                    },
                                    error: function (xhr) {
                                        lblNewPasswordMessage.innerText = "Error resetting password: " + (xhr.responseText || "Unknown error");
                                        lblNewPasswordMessage.style.display = 'block';
                                    }
                                });
                            });

                            clearInterval(interval);
                        } else if (attempts >= maxAttempts) {
                            console.error("Failed to find modal elements after " + maxAttempts + " attempts");
                            clearInterval(interval);
                        }
                    }, 100);
                }

                if (typeof jQuery === 'undefined') {
                    var script = document.createElement('script');
                    script.src = 'https://code.jquery.com/jquery-3.6.0.min.js';
                    script.onload = function () {
                        var bootstrapScript = document.createElement('script');
                        bootstrapScript.src = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js';
                        bootstrapScript.onload = function () { initializeLoginModal(); };
                        bootstrapScript.onerror = function () { console.error("Failed to load Bootstrap JS"); };
                        document.head.appendChild(bootstrapScript);
                    };
                    script.onerror = function () { console.error("Failed to load jQuery"); };
                    document.head.appendChild(script);
                } else {
                    if (typeof bootstrap === 'undefined') {
                        var bootstrapScript = document.createElement('script');
                        bootstrapScript.src = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js';
                        bootstrapScript.onload = function () { initializeLoginModal(); };
                        bootstrapScript.onerror = function () { console.error("Failed to load Bootstrap JS"); };
                        document.head.appendChild(bootstrapScript);
                    } else {
                        initializeLoginModal();
                    }
                }
            </script>
        </div>
    </form>
</body>
</html>


