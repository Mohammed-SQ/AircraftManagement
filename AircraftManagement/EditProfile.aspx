<%@ Page Title="Edit Profile - Aircraft Rental Platform" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="EditProfile.aspx.cs" Inherits="AircraftManagement.EditProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }

        .edit-profile-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            border: 1px solid #e0e0e0;
        }

        h2 {
            text-align: center;
            color: #1e3c72;
            margin-bottom: 30px;
            font-size: 28px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            color: #444;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"],
        .form-group input[type="date"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            font-size: 14px;
            color: #333;
            background-color: #f9f9f9;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="email"]:focus,
        .form-group input[type="password"]:focus,
        .form-group input[type="date"]:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #1e3c72;
            box-shadow: 0 0 8px rgba(30, 60, 114, 0.2);
            outline: none;
            background-color: #fff;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-group select {
            appearance: none;
            background: #f9f9f9 url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"><path fill="%23333" d="M7 10l5 5 5-5z"/></svg>') no-repeat right 10px center;
        }

        .form-group .required::after {
            content: "*";
            color: #e74c3c;
            margin-left: 4px;
        }

        .form-note {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }

        .form-buttons {
            text-align: center;
            margin-top: 30px;
        }

        .btn-save {
            background-color: #1abc9c;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            margin-right: 10px;
        }

        .btn-save:hover {
            background-color: #16a085;
            transform: translateY(-2px);
        }

        .btn-cancel {
            background-color: #e0e0e0;
            color: #333;
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-cancel:hover {
            background-color: #d0d0d0;
            transform: translateY(-2px);
        }

        .message {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .message.success {
            color: #27ae60;
        }

        .message.error {
            color: #e74c3c;
        }
    </style>

    <div class="edit-profile-container">
        <h2><i class="fas fa-user-edit"></i> Edit Profile</h2>
        <div class="form-group">
            <label for="txtUsername">Username</label>
            <asp:TextBox ID="txtUsername" runat="server" ReadOnly="true" />
        </div>
        <div class="form-group">
            <label for="txtEmail">Email</label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" />
            <div class="form-note">Note: You must provide at least an email or a phone number.</div>
        </div>
        <div class="form-group">
            <label for="txtPhone">Phone Number (e.g., 5XXXXXXXX)</label>
            <asp:TextBox ID="txtPhone" runat="server" placeholder="Enter phone number starting with 5" />
            <div class="form-note">Note: You must provide at least an email or a phone number.</div>
        </div>
        <div class="form-group">
            <label for="txtDateOfBirth">Date of Birth</label>
            <asp:TextBox ID="txtDateOfBirth" runat="server" TextMode="Date" />
        </div>
        <div class="form-group">
            <label for="ddlGender">Gender</label>
            <asp:DropDownList ID="ddlGender" runat="server">
                <asp:ListItem Value="Select">Select</asp:ListItem>
                <asp:ListItem Value="Male">Male</asp:ListItem>
                <asp:ListItem Value="Female">Female</asp:ListItem>
                <asp:ListItem Value="Other">Other</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="form-group">
            <label for="txtAddress">Address</label>
            <asp:TextBox ID="txtAddress" runat="server" placeholder="Enter your address" />
        </div>
        <div class="form-group">
            <label for="txtState">State</label>
            <asp:TextBox ID="txtState" runat="server" placeholder="Enter your state" />
        </div>
        <div class="form-group">
            <label for="txtZIP">ZIP Code</label>
            <asp:TextBox ID="txtZIP" runat="server" placeholder="Enter your ZIP code" />
        </div>
        <div class="form-group">
            <label for="txtReferralCode">Referral Code</label>
            <asp:TextBox ID="txtReferralCode" runat="server" ReadOnly="true" />
        </div>
        <div class="form-group">
            <label for="txtBio">Bio</label>
            <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" placeholder="Tell us about yourself..." />
        </div>
        <div class="form-group">
            <label for="txtNewPassword">New Password (Leave blank to keep current)</label>
            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="Enter new password" />
        </div>
        <div class="form-buttons">
            <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn-save" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="btnCancel_Click" CausesValidation="false" />
        </div>
        <div class="message">
            <asp:Label ID="lblMessage" runat="server" CssClass="message" />
        </div>

        <h3 style="margin-top:40px;">Saved Payment Cards</h3>

        <!-- Button to Add New Card -->
        <asp:Button ID="btnAddNewCard" runat="server" Text="➕ Add New Card" CssClass="btn btn-primary mb-3" OnClientClick="openAddCardModal(); return false;" />

        <!-- Cards GridView -->
        <asp:GridView ID="gvSavedCards" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="CardID" OnRowCommand="gvSavedCards_RowCommand">
            <Columns>
                <asp:BoundField DataField="CardType" HeaderText="Card Type" />
                <asp:BoundField DataField="CardholderName" HeaderText="Cardholder Name" />
                <asp:BoundField DataField="CardNumberLastFour" HeaderText="Last 4 Digits" />
                <asp:BoundField DataField="ExpiryMonth" HeaderText="Expiry Month" />
                <asp:BoundField DataField="ExpiryYear" HeaderText="Expiry Year" />
                <asp:BoundField DataField="CVV" HeaderText="CVV" />
                <asp:BoundField DataField="AddedAt" HeaderText="Added At" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button 
                            ID="btnEdit" 
                            runat="server" 
                            Text="✏️ Edit" 
                            CommandName="EditCard" 
                            CommandArgument='<%# Eval("CardID") %>' 
                            CssClass="btn btn-sm btn-info me-2"
                            CausesValidation="false" 
                            UseSubmitBehavior="false" />
                        <asp:Button 
                            ID="btnDelete" 
                            runat="server" 
                            Text="🗑️ Delete" 
                            CommandName="DeleteCard" 
                            CommandArgument='<%# Eval("CardID") %>' 
                            CssClass="btn btn-sm btn-danger"
                            CausesValidation="false" 
                            UseSubmitBehavior="false" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <asp:Label ID="lblCardMessage" runat="server" CssClass="message" />

        <!-- Add/Edit Card Modal -->
        <div class="modal fade" id="cardModal" tabindex="-1" aria-labelledby="cardModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="cardModalLabel">Add / Edit Card</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">

                    <asp:HiddenField ID="hfCardID" runat="server" />
                    <asp:HiddenField ID="hfFullCardNumber" runat="server" />

                    <div class="mb-3">
                        <label>Cardholder Name</label>
                        <asp:TextBox ID="txtCardholderName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Card Number (Full)</label>
                        <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" MaxLength="19" />
                    </div>
                    <div class="mb-3">
                        <label>CVV</label>
                        <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" MaxLength="3" />
                    </div>
                    <div class="mb-3">
                        <label>Expiry Month (MM)</label>
                        <asp:TextBox ID="txtExpiryMonth" runat="server" CssClass="form-control" MaxLength="2" />
                    </div>
                    <div class="mb-3">
                        <label>Expiry Year (YY)</label>
                        <asp:TextBox ID="txtExpiryYear" runat="server" CssClass="form-control" MaxLength="2" />
                    </div>

                </div>
                <div class="modal-footer">
                  <asp:Button ID="btnSaveCard" runat="server" Text="💾 Save Card" CssClass="btn btn-success" OnClick="btnSaveCard_Click" />
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
          </div>
        </div>

        <!-- Bootstrap 5 Modal Scripts -->
        <script>
            function openAddCardModal() {
                // Clear all fields
                document.getElementById('<%= hfCardID.ClientID %>').value = '';
                document.getElementById('<%= txtCardholderName.ClientID %>').value = '';
                document.getElementById('<%= txtCardNumber.ClientID %>').value = '';
                document.getElementById('<%= txtCVV.ClientID %>').value = '';
                document.getElementById('<%= txtExpiryMonth.ClientID %>').value = '';
                document.getElementById('<%= txtExpiryYear.ClientID %>').value = '';

                // Change Modal Title to "Add New Card"
                document.getElementById('cardModalLabel').innerText = "Add New Card";

                // Open Modal
                var myModal = new bootstrap.Modal(document.getElementById('cardModal'));
                myModal.show();
            }

            function openEditCardModal() {
                // Change Modal Title to "Edit Card"
                document.getElementById('cardModalLabel').innerText = "Edit Card";

                // Open Modal (fields are already filled by server-side LoadCardDetails)
                var myModal = new bootstrap.Modal(document.getElementById('cardModal'));
                myModal.show();
            }
        </script>
    </div>
</asp:Content>

