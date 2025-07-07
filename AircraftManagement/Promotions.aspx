<%@ Page Title="Promotions" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Promotions.aspx.cs" Inherits="AircraftManagement.Promotions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .promo-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 30px;
            border-radius: 20px;
        }

        h2 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #ffeb3b;
            text-shadow: 0 0 15px rgba(255, 235, 59, 0.6);
            margin-bottom: 10px;
            display: inline-block;
        }

        h2 i {
            margin-right: 15px;
        }

        .table {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            overflow: hidden;
            border: none;
        }

        .table th {
            background: rgba(255, 235, 59, 0.3);
            color: #ffeb3b;
            font-weight: 600;
            padding: 20px;
            border: none;
        }

        .table td {
            color: #fff;
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .loyalty-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .tier-status {
            font-size: 2rem;
            color: #ffeb3b;
            text-shadow: 0 0 10px rgba(255, 235, 59, 0.5);
            margin-left: 20px;
            display: inline-block;
        }

        .loyalty-box {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(8px);
            margin-bottom: 60px; /* Increased space below the box */
        }

        .loyalty-content {
            text-align: left;
        }

        .loyalty-content p {
            font-size: 1.2rem;
            color: #fff;
            margin: 10px 0;
        }

        .loyalty-content .reward {
            font-size: 1.3rem;
            color: #ffeb3b;
            font-weight: 600;
            margin: 10px 0;
        }

        .reward-item {
            font-size: 1.4rem;
            font-weight: bold;
            color: #fff;
            margin: 15px 0;
        }

        .progress-bar-container {
            width: 100%;
            margin: 20px 0;
            position: relative;
        }

        .progress {
            height: 30px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            overflow: visible;
        }

        .progress-bar {
            background: linear-gradient(90deg, #ff5722, #ffeb3b);
            border-radius: 15px;
            transition: width 0.5s ease-in-out;
            position: relative;
        }

        .tier-label {
            position: absolute;
            top: -25px;
            color: #ffeb3b;
            font-weight: bold;
            font-size: 1rem;
        }

        .tier-label.pilot { left: 0; }
        .tier-label.captain { left: 50%; transform: translateX(-50%); }
        .tier-label.ace { right: 0; }

        .claim-btn {
            background-color: #28a745;
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 5px;
            margin: 5px;
            transition: background-color 0.3s ease;
        }

        .claim-btn:hover {
            background-color: #218838;
        }

        .claim-btn:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }

        .text-warning {
            color: #ffeb3b !important;
            font-size: 1.2rem;
        }
    </style>

    <div class="promo-container">
        <div class="loyalty-header">
            <h2><i class="fas fa-star"></i> Your Loyalty Points</h2>
            <p class="tier-status">Tier: <asp:Label ID="lblTier" runat="server" Text="Pilot"></asp:Label></p>
        </div>
        <div class="loyalty-box">
            <div class="loyalty-content">
                <p>You have <asp:Label ID="lblLoyaltyPoints" runat="server" Text="0"></asp:Label> points!</p>
                <asp:Label ID="lblRewardMessage" runat="server" CssClass="reward" Visible="false"></asp:Label>
                <p class="reward-item">🛠️ 150 points: 1 Free Maintenance
                    <asp:Button ID="btnClaimMaintenance" runat="server" CssClass="claim-btn" Text="Claim" OnClick="btnClaimMaintenance_Click" />
                </p>
                <p class="reward-item">💸 300 points: 30% Discount
                    <asp:Button ID="btnClaimDiscount" runat="server" CssClass="claim-btn" Text="Claim" OnClick="btnClaimDiscount_Click" />
                </p>
                <p class="reward-item">✈️ 1000 points: 1 Day Free Aircraft Rent
                    <asp:Button ID="btnClaimRent" runat="server" CssClass="claim-btn" Text="Claim" OnClick="btnClaimRent_Click" />
                </p>

                <div class="progress-bar-container">
                    <div class="tier-label pilot">Pilot (0)</div>
                    <div class="tier-label captain">Captain (500)</div>
                    <div class="tier-label ace">Ace (1000)</div>
                    <div class="progress">
                        <div id="loyaltyProgressBar" runat="server" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="1000"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="claimed-offers-section">
            <h2><i class="fas fa-trophy"></i> Your Claimed Offers</h2>
            <asp:GridView ID="gvClaimedOffers" runat="server" AutoGenerateColumns="False" CssClass="table">
                <Columns>
                    <asp:BoundField DataField="Title" HeaderText="Offer Title 🎁" />
                    <asp:BoundField DataField="Description" HeaderText="Description 📝" />
                    <asp:BoundField DataField="ExpiryDate" HeaderText="Expiry Date ⏳" DataFormatString="{0:dd/MM/yyyy HH:mm:ss}" />
                    <asp:BoundField DataField="ClaimedDate" HeaderText="Claimed On 📅" DataFormatString="{0:dd/MM/yyyy HH:mm:ss}" />
                    <asp:TemplateField HeaderText="Status 📊">
                        <ItemTemplate>
                            <%# DateTime.Parse(Eval("ExpiryDate").ToString()) > DateTime.Now ? "Active ✅" : "Expired ⏲️" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Label ID="lblNoOffers" runat="server" Text="You haven't claimed any offers yet. Check out the available promotions in your navigation bar! 🎉" CssClass="text-warning" Visible="false"></asp:Label>
        </div>
    </div>
</asp:Content>