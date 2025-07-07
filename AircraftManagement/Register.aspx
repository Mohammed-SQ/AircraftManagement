<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="AircraftManagement.Register" MasterPageFile="~/Site.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="modal fade" id="registerModal" tabindex="-1" aria-labelledby="registerModalLabel" aria-hidden="true">
        <style>
            body {
                background-color: black;
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
                max-height: 70vh;
                overflow-y: auto;
                color: #d0d0d0;
            }
            .modal-footer {
                border-top: none;
                padding: 20px 30px;
                justify-content: center;
                flex-direction: column;
                gap: 10px;
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
                cursor: pointer;
            }
            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #0056b3;
                transform: translateY(-3px);
                box-shadow: 0 7px 20px rgba(0, 123, 255, 0.4);
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
            .contact-method-container {
                margin-top: 10px;
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }
            .contact-method-toggle {
                color: #007bff;
                background: none;
                padding: 5px 10px;
                border-radius: 5px;
                cursor: pointer;
                text-align: left;
                display: inline-block;
                transition: color 0.3s ease;
            }
            .contact-method-toggle:hover {
                color: #0056b3;
            }
            .contact-method-toggle.active {
                color: #007bff;
            }
            .phone-prefix {
                background: #3a3a3a;
                padding: 12px 15px;
                border-top-left-radius: 5px;
                border-bottom-left-radius: 5px;
                color: #ffffff;
                display: inline-block;
            }
            .phone-input {
                border-top-left-radius: 0;
                border-bottom-left-radius: 0;
                flex: 1;
            }
            .text-muted {
                font-size: 0.9em;
                color: #6c757d !important;
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
        </style>
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="registerModalLabel">
                        <i class="fas fa-plane"></i> Join Our Flight Today!
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="registrationForm" style="display: block;">
                        <div class="mb-3">
                            <label for="txtUsername" class="form-label">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your username" MaxLength="30"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" ErrorMessage="Username is required." CssClass="text-danger" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revUsername" runat="server" ControlToValidate="txtUsername" ErrorMessage="Username can only contain lowercase letters, numbers, periods, and underscores." ValidationExpression="^[a-z0-9._]+$" CssClass="text-danger" Display="Dynamic" />
                        </div>
                        <div class="mb-3">
                            <div id="divEmail">
                                <label for="txtEmail" class="form-label">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter email address" MaxLength="200"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="EmailGroup" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Invalid email address." ValidationExpression="^[^\s@]+@[^\s@]+\.[^\s@]+$" CssClass="text-danger" Display="Dynamic" ValidationGroup="EmailGroup" />
                            </div>
                            <div id="divPhone" style="display: none;">
                                <label for="txtPhone" class="form-label">Phone Number</label>
                                <div class="d-flex align-items-center">
                                    <span class="phone-prefix">Saudi Arabia +966</span>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control phone-input" placeholder="Enter mobile number" MaxLength="9" oninput="window.validatePhoneNumber(this)"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Phone number is required." CssClass="text-danger" Display="Dynamic" ValidationGroup="PhoneGroup" />
                                <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Phone must be 9 digits starting with 5." ValidationExpression="^5\d{8}$" CssClass="text-danger" Display="Dynamic" ValidationGroup="PhoneGroup" />
                            </div>
                            <div class="contact-method-container">
                                <div id="contactMethodToggle" class="contact-method-toggle">Use Phone number instead</div>
                                <asp:HiddenField ID="hfContactMethod" runat="server" Value="Email" />
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="ddlState" class="form-label">State</label>
                            <asp:DropDownList ID="ddlState" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select a state</asp:ListItem>
                                <asp:ListItem Value="Khobar">Khobar</asp:ListItem>
                                <asp:ListItem Value="Dammam">Dammam</asp:ListItem>
                                <asp:ListItem Value="Riyadh">Riyadh</asp:ListItem>
                                <asp:ListItem Value="Jeddah">Jeddah</asp:ListItem>
                                <asp:ListItem Value="Makkah">Makkah</asp:ListItem>
                                <asp:ListItem Value="Medina">Medina</asp:ListItem>
                                <asp:ListItem Value="Jubail">Jubail</asp:ListItem>
                                <asp:ListItem Value="Qatif">Qatif</asp:ListItem>
                                <asp:ListItem Value="Taif">Taif</asp:ListItem>
                                <asp:ListItem Value="Abha">Abha</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="ddlState" InitialValue="" ErrorMessage="Please select a state." CssClass="text-danger" Display="Dynamic" />
                        </div>
                        <div class="mb-3">
                            <label for="txtPassword" class="form-label">Password</label>
                            <div class="password-group">
                                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password" MaxLength="20"></asp:TextBox>
                                <span id="togglePasswordIcon" class="toggle-password">👁️</span>
                            </div>
                            <small class="text-muted">Password must be 8-20 characters. Click the eye icon to show/hide your password.</small>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." CssClass="text-danger" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password must be 8-20 characters." ValidationExpression="^.{8,20}$" CssClass="text-danger" Display="Dynamic" />
                        </div>
                    </div>
                    <div id="verificationSection" style="display: none;">
                        <h5>VERIFY YOUR ACCOUNT</h5>
                        <div id="lblVerificationMessageDisplay" class="mb-3 d-block"></div>
                        <div class="mb-3">
                            <label class="form-label">Enter 6-Digit Verification Code</label>
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
                    </div>
                </div>
                <div class="modal-footer">
                    <div id="validationSummary" class="text-danger small text-start w-100 mb-3" style="display: none;"></div>
                    <asp:Button ID="btnSignUp" runat="server" Text="Sign Up" CssClass="btn btn-primary w-100" CausesValidation="true" style="display: block;" />
                    <div class="text-center">
                        <a href="#" id="switchToLoginLink">Already have an account? Log in</a>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="hfCombinedCode" runat="server" />
        <input type="hidden" id="hfVerificationCode" runat="server" value="" />
        <asp:HiddenField ID="hfShowVerification" runat="server" value="" />
        <script>
            window.isSwitchingToLogin = false;

            // Ensure authentication configuration is set when the page loads
            document.addEventListener('DOMContentLoaded', function () {
                console.log("Page loaded, setting authentication configuration...");
                var ultraMsgBaseUrl = window.Authentication.getUltraMsgBaseUrl();
                var ultraMsgToken = window.Authentication.getUltraMsgToken();
                var ultraMsgInstanceId = window.Authentication.getUltraMsgInstanceId();
                var emailConfig = window.Authentication.getEmailConfig();
                var smtpUsername = emailConfig.username;
                var smtpPassword = emailConfig.password;

                var xhr = new XMLHttpRequest();
                xhr.open("POST", "Register.aspx/SetAuthenticationConfig", true);
                xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            var response = JSON.parse(xhr.responseText);
                            if (response.d.success) {
                                console.log("Authentication configuration set successfully: " + response.d.message);
                            } else {
                                console.error("Failed to set authentication configuration: " + response.d.message);
                            }
                        } else {
                            console.error("Error setting authentication configuration: " + xhr.responseText);
                        }
                    }
                };
                xhr.send(JSON.stringify({
                    ultraMsgBaseUrl: ultraMsgBaseUrl,
                    ultraMsgToken: ultraMsgToken,
                    ultraMsgInstanceId: ultraMsgInstanceId,
                    smtpUsername: smtpUsername,
                    smtpPassword: smtpPassword
                }));
            });

            window.validatePhoneNumber = function (input) {
                input.value = input.value.replace(/\D/g, '');
                if (input.value.startsWith("05")) {
                    input.value = input.value.substring(1);
                }
                if (input.value.length > 9) {
                    input.value = input.value.substring(0, 9);
                }
            };

            window.moveToNextOrPrevious = function (current, nextFieldId, prevFieldId) {
                current.value = current.value.replace(/[^0-9]/g, '');
                if (current.value.length === 1) {
                    if (nextFieldId) {
                        document.getElementById(nextFieldId).focus();
                    }
                    var code1 = document.getElementById('txtCode1').value;
                    var code2 = document.getElementById('txtCode2').value;
                    var code3 = document.getElementById('txtCode3').value;
                    var code4 = document.getElementById('txtCode4').value;
                    var code5 = document.getElementById('txtCode5').value;
                    var code6 = document.getElementById('txtCode6').value;
                    if (code1 && code2 && code3 && code4 && code5 && code6) {
                        window.submitVerification();
                    }
                } else if (current.value.length === 0 && prevFieldId) {
                    document.getElementById(prevFieldId).focus();
                }
            };

            window.handleKeyDown = function (event, current, nextFieldId, prevFieldId) {
                if (event.key === 'Backspace' || event.key === 'Delete') {
                    if (current.value.length === 0 && prevFieldId) {
                        event.preventDefault();
                        document.getElementById(prevFieldId).focus();
                    }
                }
            };

            window.clearCode = function () {
                console.log("Clearing verification code inputs...");
                document.getElementById('txtCode1').value = '';
                document.getElementById('txtCode2').value = '';
                document.getElementById('txtCode3').value = '';
                document.getElementById('txtCode4').value = '';
                document.getElementById('txtCode5').value = '';
                document.getElementById('txtCode6').value = '';
                document.getElementById('txtCode1').focus();
                document.getElementById('<%= hfCombinedCode.ClientID %>').value = '';
                document.getElementById('lblVerificationMessage').style.display = 'none';
            };

            window.pasteCode = function () {
                navigator.clipboard.readText().then(function (pastedData) {
                    pastedData = pastedData.trim();
                    if (/^\d{6}$/.test(pastedData)) {
                        var digits = pastedData.split('');
                        document.getElementById('txtCode1').value = digits[0];
                        document.getElementById('txtCode2').value = digits[1];
                        document.getElementById('txtCode3').value = digits[2];
                        document.getElementById('txtCode4').value = digits[3];
                        document.getElementById('txtCode5').value = digits[4];
                        document.getElementById('txtCode6').value = digits[5];
                        document.getElementById('txtCode6').focus();
                        window.submitVerification();
                    } else {
                        alert("Please copy a valid 6-digit numeric code to paste.");
                        document.getElementById('lblVerificationMessage').innerText = "Please copy a valid 6-digit numeric code to paste.";
                        document.getElementById('lblVerificationMessage').style.display = 'block';
                    }
                }).catch(function (err) {
                    alert("Unable to access clipboard. Please paste the code manually.");
                    document.getElementById('lblVerificationMessage').innerText = "Unable to access clipboard. Please paste the code manually.";
                    document.getElementById('lblVerificationMessage').style.display = 'block';
                });
            };

            window.handlePaste = function (event) {
                event.preventDefault();
                var clipboardData = event.clipboardData || window.clipboardData;
                var pastedData = clipboardData.getData('text').trim();
                if (/^\d{6}$/.test(pastedData)) {
                    var digits = pastedData.split('');
                    document.getElementById('txtCode1').value = digits[0];
                    document.getElementById('txtCode2').value = digits[1];
                    document.getElementById('txtCode3').value = digits[2];
                    document.getElementById('txtCode4').value = digits[3];
                    document.getElementById('txtCode5').value = digits[4];
                    document.getElementById('txtCode6').value = digits[5];
                    document.getElementById('txtCode6').focus();
                    window.submitVerification();
                } else {
                    alert("Please paste a valid 6-digit numeric code.");
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

                var interval = setInterval(function () {
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
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "Register.aspx/ResendVerificationCode", true);
                xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            var response = JSON.parse(xhr.responseText);
                            if (response.d.success) {
                                document.getElementById('lblVerificationMessageDisplay').innerText = response.d.message;
                                window.startResendTimer();
                            } else {
                                document.getElementById('lblVerificationMessage').innerText = response.d.message;
                                document.getElementById('lblVerificationMessage').style.display = 'block';
                            }
                        } else {
                            console.error("AJAX error:", xhr.responseText);
                            document.getElementById('lblVerificationMessage').innerText = "Error resending code: " + (xhr.responseText || "Unknown error");
                            document.getElementById('lblVerificationMessage').style.display = 'block';
                        }
                    }
                };
                xhr.send(JSON.stringify({}));
            };

            window.showVerification = function (message) {
                console.log("showVerification called with message: " + message);
                var registrationForm = document.getElementById('registrationForm');
                var verificationSection = document.getElementById('verificationSection');
                var btnSignUp = document.getElementById('<%= btnSignUp.ClientID %>');
                var txtCode1 = document.getElementById('txtCode1');
                var lblVerificationMessageDisplay = document.getElementById('lblVerificationMessageDisplay');

                // Log the presence of each element for debugging
                console.log("registrationForm:", registrationForm);
                console.log("verificationSection:", verificationSection);
                console.log("btnSignUp:", btnSignUp);
                console.log("txtCode1:", txtCode1);
                console.log("lblVerificationMessageDisplay:", lblVerificationMessageDisplay);

                if (!registrationForm || !verificationSection || !btnSignUp || !txtCode1 || !lblVerificationMessageDisplay) {
                    console.error("Required elements for showVerification not found.");
                    return;
                }

                // Ensure the registration form is hidden and verification section is shown
                registrationForm.style.display = 'none';
                verificationSection.style.display = 'block';
                btnSignUp.style.display = 'none';

                // Ensure the first code input is enabled and focused
                txtCode1.disabled = false;
                window.clearCode();
                txtCode1.focus();

                // Display the verification message
                lblVerificationMessageDisplay.innerText = message;
                lblVerificationMessageDisplay.style.display = 'block';

                // Start the resend timer
                window.startResendTimer();
            };

            window.updateNavbar = function (username) {
                var navbarNav = document.querySelector('#navbarNav');
                if (!navbarNav) {
                    console.error("Navbar not found for updating.");
                    return;
                }
                var loginLink = navbarNav.querySelector('a[href="#"][onclick*="showLoginModal"]');
                var registerLink = navbarNav.querySelector('a[href="#"][onclick*="showRegisterModal"]');
                if (loginLink) loginLink.parentElement.remove();
                if (registerLink) registerLink.parentElement.remove();
                var userNav = document.createElement('ul');
                userNav.className = 'navbar-nav';
                userNav.innerHTML = `
                    <li class="nav-item dropdown">
                        <span class="notification-wrapper">
                            <i class="fas fa-bell notification-icon" onclick="toggleNotificationBox(this)"></i>
                            <div class="notification-box">
                                You don't have any notifications
                            </div>
                        </span>
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user"></i> ${username}
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="UserProfile.aspx"><i class="fas fa-user-circle"></i> Profile</a></li>
                            <li><a class="dropdown-item" href="Promotions.aspx"><i class="fas fa-gift"></i> Promotions</a></li>
                            <li><a class="dropdown-item" href="Settings.aspx"><i class="fas fa-cog"></i> Settings</a></li>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-danger" href="Logout.aspx"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </li>
                `;
                navbarNav.querySelector('.navbar-nav:last-child').replaceWith(userNav);
            };

            window.submitVerification = function () {
                var code1 = document.getElementById('txtCode1').value;
                var code2 = document.getElementById('txtCode2').value;
                var code3 = document.getElementById('txtCode3').value;
                var code4 = document.getElementById('txtCode4').value;
                var code5 = document.getElementById('txtCode5').value;
                var code6 = document.getElementById('txtCode6').value;
                var combinedCode = code1 + code2 + code3 + code4 + code5 + code6;

                var lblVerificationMessage = document.getElementById('lblVerificationMessage');
                if (combinedCode.length !== 6) {
                    lblVerificationMessage.innerText = "Please enter a 6-digit verification code.";
                    lblVerificationMessage.style.display = 'block';
                    return;
                }

                lblVerificationMessage.style.display = 'none';
                document.getElementById('<%= hfCombinedCode.ClientID %>').value = combinedCode;

                var xhr = new XMLHttpRequest();
                xhr.open("POST", "Register.aspx/VerifyCodeAndLogin", true);
                xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            var response = JSON.parse(xhr.responseText);
                            if (response.d.success) {
                                window.closeModal('registerModal');
                                var username = document.getElementById('<%= txtUsername.ClientID %>').value;
                                window.updateNavbar(username);
                                var successMessage = document.createElement('div');
                                successMessage.className = 'alert alert-success';
                                successMessage.innerText = 'Registration successful! You are now logged in.';
                                document.body.appendChild(successMessage);
                                setTimeout(function () {
                                    successMessage.remove();
                                }, 3000);
                            } else {
                                lblVerificationMessage.innerText = response.d.message;
                                lblVerificationMessage.style.display = 'block';
                            }
                        } else {
                            console.error("AJAX error:", xhr.responseText);
                            lblVerificationMessage.innerText = "Error verifying code: " + (xhr.responseText || "Unknown error");
                            lblVerificationMessage.style.display = 'block';
                        }
                    }
                };
                xhr.send(JSON.stringify({ code: combinedCode }));
            };

            window.initializeRegisterModal = function () {
                console.log("Register.aspx JavaScript loaded");

                window.togglePassword = function () {
                    console.log("togglePassword called");
                    var field = document.getElementById('<%= txtPassword.ClientID %>');
                    var span = document.getElementById('togglePasswordIcon');
                    if (!field || !span) {
                        console.error("Password field or toggle icon not found");
                        return;
                    }
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
                    console.log("closeModal called for: " + modalId);
                    var modal = bootstrap.Modal.getInstance(document.getElementById(modalId));
                    if (modal) {
                        modal.hide();
                        document.querySelectorAll('.modal-backdrop').forEach(function (backdrop) { backdrop.remove(); });
                        document.body.classList.remove('modal-open');
                        document.body.style.overflow = '';
                        document.body.style.paddingRight = '';
                    } else {
                        console.error("Modal instance not found for: " + modalId);
                    }
                };

                window.toggleContactMethod = function () {
                    console.log("toggleContactMethod called");
                    var hfContactMethod = document.getElementById('<%= hfContactMethod.ClientID %>');
                    var toggleDiv = document.getElementById('contactMethodToggle');
                    var divEmail = document.getElementById('divEmail');
                    var divPhone = document.getElementById('divPhone');
                    var txtEmail = document.getElementById('<%= txtEmail.ClientID %>');
                    var txtPhone = document.getElementById('<%= txtPhone.ClientID %>');
                    var rfvEmail = document.getElementById('<%= rfvEmail.ClientID %>');
                    var revEmail = document.getElementById('<%= revEmail.ClientID %>');
                    var rfvPhone = document.getElementById('<%= rfvPhone.ClientID %>');
                    var revPhone = document.getElementById('<%= revPhone.ClientID %>');

                    if (!hfContactMethod || !toggleDiv || !divEmail || !divPhone || !txtEmail || !txtPhone) {
                        console.error('Required elements for toggleContactMethod not found.');
                        return;
                    }

                    if (hfContactMethod.value === 'Email') {
                        hfContactMethod.value = 'SMS';
                        toggleDiv.innerText = 'Use Email instead';
                        divEmail.style.display = 'none';
                        divPhone.style.display = 'block';
                        txtEmail.value = '';
                        if (rfvEmail && typeof ValidatorEnable === 'function') {
                            ValidatorEnable(rfvEmail, false);
                            ValidatorEnable(revEmail, false);
                        }
                        if (rfvPhone && typeof ValidatorEnable === 'function') {
                            ValidatorEnable(rfvPhone, true);
                            ValidatorEnable(revPhone, true);
                        }
                    } else {
                        hfContactMethod.value = 'Email';
                        toggleDiv.innerText = 'Use Phone number instead';
                        divEmail.style.display = 'block';
                        divPhone.style.display = 'none';
                        txtPhone.value = '';
                        if (rfvEmail && typeof ValidatorEnable === 'function') {
                            ValidatorEnable(rfvEmail, true);
                            ValidatorEnable(revEmail, true);
                        }
                        if (rfvPhone && typeof ValidatorEnable === 'function') {
                            ValidatorEnable(rfvPhone, false);
                            ValidatorEnable(revPhone, false);
                        }
                    }

                    toggleDiv.classList.add('active');
                    console.log("Contact method toggled to: " + hfContactMethod.value);
                };

                window.switchToLogin = function () {
                    console.log("switchToLogin called");
                    if (window.isSwitchingToLogin) {
                        console.log("Already switching to login, ignoring duplicate click");
                        return;
                    }
                    window.isSwitchingToLogin = true;
                    window.closeModal('registerModal');
                    setTimeout(function () {
                        if (typeof showLoginModal === 'function') {
                            showLoginModal();
                        } else {
                            console.error("showLoginModal function not found");
                        }
                        window.isSwitchingToLogin = false;
                    }, 100);
                };

                var modal = document.getElementById('registerModal');
                var passwordField = document.getElementById('<%= txtPassword.ClientID %>');
                var btnSignUp = document.getElementById('<%= btnSignUp.ClientID %>');
                var toggleDiv = document.getElementById('contactMethodToggle');
                var togglePasswordIcon = document.getElementById('togglePasswordIcon');
                var switchToLoginLink = document.getElementById('switchToLoginLink');

                if (modal && passwordField && btnSignUp && toggleDiv && togglePasswordIcon && switchToLoginLink) {
                    console.log("All elements found: modal, password field, sign up button, toggle div, toggle password icon, and switch link");

                    toggleDiv.removeEventListener('click', window.toggleContactMethod);
                    toggleDiv.addEventListener('click', window.toggleContactMethod);

                    togglePasswordIcon.removeEventListener('click', window.togglePassword);
                    togglePasswordIcon.addEventListener('click', window.togglePassword);

                    switchToLoginLink.removeEventListener('click', window.switchToLogin);
                    switchToLoginLink.addEventListener('click', function (e) {
                        e.preventDefault();
                        window.switchToLogin();
                    });

                    passwordField.addEventListener('keypress', function (e) {
                        if (e.key === 'Enter') {
                            e.preventDefault();
                            console.log("Enter key pressed, triggering sign up");
                            btnSignUp.click();
                        }
                    });

                    btnSignUp.addEventListener('click', function (e) {
                        e.preventDefault();
                        console.log("Sign Up button clicked");

                        var contactMethod = document.getElementById('<%= hfContactMethod.ClientID %>').value;
                        var validationGroup = contactMethod === 'Email' ? 'EmailGroup' : 'PhoneGroup';

                        if (typeof (Page_ClientValidate) === 'function') {
                            Page_ClientValidate(validationGroup);
                            if (!Page_IsValid) {
                                var validationSummary = document.getElementById('validationSummary');
                                validationSummary.innerHTML = '<ul>' +
                                    Array.from(document.querySelectorAll('.text-danger'))
                                        .filter(el => el.style.display !== 'none')
                                        .map(el => '<li>' + el.innerText + '</li>')
                                        .join('') + '</ul>';
                                validationSummary.style.display = 'block';
                                return;
                            }
                        }

                        var errors = [];
                        var username = document.getElementById('<%= txtUsername.ClientID %>').value.trim();
                        var email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
                        var phone = document.getElementById('<%= txtPhone.ClientID %>').value.trim();
                        var state = document.getElementById('<%= ddlState.ClientID %>').value;
                        var password = document.getElementById('<%= txtPassword.ClientID %>').value;
                        var contactMethod = document.getElementById('<%= hfContactMethod.ClientID %>').value;

                        if (!username) {
                            errors.push("Username is required.");
                        } else if (!/^[a-z0-9._]+$/.test(username)) {
                            errors.push("Username can only contain lowercase letters, numbers, periods, and underscores.");
                        }

                        if (contactMethod === 'Email') {
                            if (!email) {
                                errors.push("Email is required.");
                            } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                                errors.push("Invalid email address.");
                            }
                        } else {
                            if (!phone) {
                                errors.push("Phone number is required.");
                            } else if (!/^5\d{8}$/.test(phone)) {
                                errors.push("Phone must be 9 digits starting with 5.");
                            }
                        }

                        if (!state) {
                            errors.push("Please select a state.");
                        }

                        if (!password) {
                            errors.push("Password is required.");
                        } else if (password.length < 8 || password.length > 20) {
                            errors.push("Password must be 8-20 characters.");
                        }

                        var validationSummary = document.getElementById('validationSummary');
                        if (errors.length > 0) {
                            validationSummary.innerHTML = '<ul>' + errors.map(function (err) { return '<li>' + err + '</li>'; }).join('') + '</ul>';
                            validationSummary.style.display = 'block';
                            console.log("Validation failed: ", errors);
                            return;
                        }

                        validationSummary.style.display = 'none';
                        console.log("Validation passed, making AJAX call to SubmitRegistration");
                        var registrationData = {
                            username: username,
                            email: email,
                            phone: phone,
                            state: state,
                            password: password,
                            contactMethod: contactMethod
                        };

                        var xhr = new XMLHttpRequest();
                        xhr.open("POST", "Register.aspx/SubmitRegistration", true);
                        xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
                        xhr.onreadystatechange = function () {
                            if (xhr.readyState === 4) {
                                if (xhr.status === 200) {
                                    var response = JSON.parse(xhr.responseText);
                                    if (response.d.success) {
                                        console.log("SubmitRegistration successful, showing verification section");
                                        window.showVerification(response.d.message);
                                    } else {
                                        validationSummary.innerHTML = '<ul><li>' + response.d.message + '</li></ul>';
                                        validationSummary.style.display = 'block';
                                        console.log("SubmitRegistration failed: ", response.d.message);
                                    }
                                } else {
                                    console.error("AJAX error:", xhr.responseText);
                                    validationSummary.innerHTML = '<ul><li>Error submitting registration: ' + (xhr.responseText || "Unknown error") + '</li></ul>';
                                    validationSummary.style.display = 'block';
                                }
                            }
                        };
                        xhr.send(JSON.stringify(registrationData));
                    });
                } else {
                    console.error("Required elements not found for modal initialization");
                }
            };

            // Initialize the modal immediately
            window.initializeRegisterModal();
        </script>
    </div>
</asp:Content>