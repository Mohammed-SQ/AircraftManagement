<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Security.aspx.cs" Inherits="AircraftManagement.Security" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="security-container container my-5">
        <h1 class="text-center mb-4"><i class="fas fa-lock"></i> Security Settings</h1>

        <!-- 2FA Setup -->
        <div class="card p-4 mb-4">
            <h2><i class="fas fa-key"></i> Two-Factor Authentication 🔐</h2>
            <asp:CheckBox ID="chk2FA" runat="server" Text="Enable 2FA" />
            <asp:DropDownList ID="ddl2FAMethod" runat="server" CssClass="form-select mt-2">
                <asp:ListItem Text="Select Method" Value="" />
                <asp:ListItem Text="Email" Value="Email" />
                <asp:ListItem Text="SMS" Value="SMS" />
            </asp:DropDownList>
            <asp:Button ID="btnSave2FA" runat="server" Text="Save ✅" CssClass="btn btn-light mt-2" OnClick="btnSave2FA_Click" />
        </div>

        <!-- Change Password -->
        <div class="card p-4 mb-4">
            <h2><i class="fas fa-lock"></i> Change Password 🔒</h2>
            <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-control mb-2" Placeholder="Current Password" />
            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control mb-2" Placeholder="New Password" />
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control mb-2" Placeholder="Confirm New Password" />
            <asp:Label ID="lblPasswordStrength" runat="server" CssClass="text-muted mb-2"></asp:Label>
            <asp:Button ID="btnChangePassword" runat="server" Text="Change ✅" CssClass="btn btn-light" OnClick="btnChangePassword_Click" />
        </div>

        <!-- Recent Activity -->
        <div class="card p-4">
            <h2><i class="fas fa-history"></i> Recent Activity 📜</h2>
            <asp:GridView ID="gvAuditLog" runat="server" AutoGenerateColumns="False" CssClass="table table-dark">
                <Columns>
                    <asp:BoundField DataField="Action" HeaderText="Action" />
                    <asp:BoundField DataField="Timestamp" HeaderText="Timestamp" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <script>
        document.getElementById('<%= txtNewPassword.ClientID %>').addEventListener('input', function () {
            const password = this.value;
            const strengthLabel = document.getElementById('<%= lblPasswordStrength.ClientID %>');
            if (password.length < 6) {
                strengthLabel.innerText = 'Weak ⚠️';
                strengthLabel.className = 'text-danger';
            } else if (password.length < 10) {
                strengthLabel.innerText = 'Moderate 🟡';
                strengthLabel.className = 'text-warning';
            } else {
                strengthLabel.innerText = 'Strong ✅';
                strengthLabel.className = 'text-success';
            }
        });
    </script>
</asp:Content>