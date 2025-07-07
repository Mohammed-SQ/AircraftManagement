<%@ Page Title="Profile - Aircraft Rental Platform" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="AircraftManagement.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }

        .profile-container {
            max-width: 900px;
            margin: 40px auto;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            border: 1px solid #e0e0e0;
            overflow: hidden;
        }

        .profile-header {
            background: linear-gradient(90deg, #1abc9c 0%, #16a085 100%);
            padding: 20px;
            text-align: center;
            color: white;
            position: relative;
        }

        .profile-picture {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: #e0e0e0;
            margin: 0 auto 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: #666;
            border: 4px solid white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        .profile-header h2 {
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }

        .profile-header p {
            margin: 5px 0 0;
            font-size: 14px;
            opacity: 0.8;
        }

        .edit-profile-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #ffffff;
            color: #1abc9c;
            padding: 8px 16px;
            border: 2px solid #1abc9c;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .edit-profile-btn:hover {
            background-color: #1abc9c;
            color: white;
        }

        .profile-completion {
            padding: 20px;
            background: #f9f9f9;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
        }

        .profile-completion h3 {
            margin: 0 0 10px;
            font-size: 18px;
            color: #1e3c72;
        }

        .progress-bar {
            width: 100%;
            height: 10px;
            background: #e0e0e0;
            border-radius: 5px;
            overflow: hidden;
        }

        .progress {
            height: 100%;
            background: #1abc9c;
            border-radius: 5px;
            transition: width 0.3s ease;
        }

        .profile-details, .additional-info, .booking-history, .referral-info, .audit-logs, .saved-cards {
            padding: 20px;
            border-bottom: 1px solid #e0e0e0;
        }

        .profile-details h3, .additional-info h3, .booking-history h3, .referral-info h3, .audit-logs h3, .saved-cards h3 {
            margin: 0 0 15px;
            font-size: 20px;
            color: #1e3c72;
            display: flex;
            align-items: center;
        }

        .profile-details h3 i, .additional-info h3 i, .booking-history h3 i, .referral-info h3 i, .audit-logs h3 i, .saved-cards h3 i {
            margin-right: 10px;
            color: #1abc9c;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 10px;
            font-size: 14px;
        }

        .info-grid div {
            padding: 10px;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-grid div.label {
            font-weight: 500;
            color: #444;
            background: #f9f9f9;
        }

        .info-grid div.value {
            color: #333;
        }

        .referral-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .referral-table th {
            background: #1e3c72;
            color: white;
            padding: 10px;
            text-align: left;
        }

        .referral-table td {
            padding: 10px;
            border-bottom: 1px solid #e0e0e0;
        }

        .referral-table tr:nth-child(even) {
            background: #f9f9f9;
        }

        .btn-cancel {
            background: #e74c3c;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .btn-cancel:hover {
            background: #c0392b;
        }

        .btn-view {
            background: #1abc9c;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .btn-view:hover {
            background: #16a085;
        }
    </style>

    <div class="profile-container">
        <div class="profile-header">
            <div class="profile-picture">
                <i class="fas fa-user"></i>
            </div>
            <h2><asp:Label ID="lblUsername" runat="server" Text="Username"></asp:Label></h2>
            <p>Customer | Joined: <asp:Label ID="lblJoinedDate" runat="server" Text="Not provided"></asp:Label></p>
            <asp:Button ID="btnEditProfile" runat="server" Text="Edit Profile" CssClass="edit-profile-btn" OnClick="btnEditProfile_Click" />
        </div>

        <div class="profile-completion">
            <h3>Profile Completion</h3>
            <div class="progress-bar">
                <div class="progress" style='width: <%# Eval("ProfileCompletionPercentage") %>%;'></div>
            </div>
            <asp:Label ID="lblProfileCompletion" runat="server" Text="0%"></asp:Label>
        </div>

        <div class="profile-details">
            <h3><i class="fas fa-user-circle"></i> Profile Details</h3>
            <div class="info-grid">
                <div class="label">Username</div>
                <div class="value"><asp:Label ID="lblUsernameDetail" runat="server" Text="Not provided"></asp:Label></div>
                <div class="label">Email</div>
                <div class="value"><asp:Label ID="lblEmail" runat="server" Text="Not provided"></asp:Label></div>
                <div class="label">Phone</div>
                <div class="value"><asp:Label ID="lblPhone" runat="server" Text="Not provided"></asp:Label></div>
                <div class="label">Date of Birth</div>
                <div class="value"><asp:Label ID="lblDateOfBirth" runat="server" Text="Not provided"></asp:Label></div>
                <div class="label">Gender</div>
                <div class="value"><asp:Label ID="lblGender" runat="server" Text="Not provided"></asp:Label></div>
                <div class="label">Bio</div>
                <div class="value"><asp:Label ID="lblBio" runat="server" Text="Not provided"></asp:Label></div>
            </div>
        </div>

        <div class="additional-info">
            <h3><i class="fas fa-info-circle"></i> Additional Information</h3>
            <div class="info-grid">
                <div class="label">Address</div>
                <div class="value"><asp:Label ID="lblAddress" runat="server" Text="Not provided"></asp:Label></div>
                <div class="label">State</div>
                <div class="value"><asp:Label ID="lblState" runat="server" Text="Not provided"></asp:Label></div>
                <div class="label">ZIP</div>
                <div class="value"><asp:Label ID="lblZIP" runat="server" Text="Not provided"></asp:Label></div>
                <div class="label">Referral Code</div>
                <div class="value"><asp:Label ID="lblReferralCode" runat="server" Text="Not provided"></asp:Label></div>
            </div>
        </div>

        <div class="saved-cards">
            <h3><i class="fas fa-credit-card"></i> Saved Cards</h3>
            <asp:GridView ID="gvSavedCards" runat="server" CssClass="referral-table" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="CardType" HeaderText="Card Type" />
                    <asp:BoundField DataField="CardholderName" HeaderText="Cardholder Name" />
                    <asp:BoundField DataField="CardNumberLastFour" HeaderText="Card Number" />
                    <asp:BoundField DataField="ExpiryMonth" HeaderText="Expiry Month" />
                    <asp:BoundField DataField="ExpiryYear" HeaderText="Expiry Year" />
                </Columns>
            </asp:GridView>
        </div>

        <div class="referral-info">
            <h3><i class="fas fa-gift"></i> Referral Information</h3>
            <asp:GridView ID="gvReferralInfo" runat="server" CssClass="referral-table" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="ReferredUser" HeaderText="Referred User" />
                    <asp:BoundField DataField="ReferralDate" HeaderText="Referral Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                </Columns>
            </asp:GridView>
        </div>

        <div class="audit-logs">
            <h3><i class="fas fa-history"></i> Recent Activity</h3>
            <asp:GridView ID="gvAuditLogs" runat="server" CssClass="audit-table" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="Action" HeaderText="Action" />
                    <asp:BoundField DataField="Details" HeaderText="Details" />
                    <asp:BoundField DataField="Timestamp" HeaderText="Timestamp" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
