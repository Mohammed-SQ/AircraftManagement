<%@ Page Title="Rent or Purchase Aircraft" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="PurchaseRental.aspx.cs" Inherits="AircraftManagement.PurchaseRental" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4">
            <i class="fas fa-plane"></i> Rent or Purchase Aircraft
        </h2>

        <div class="row">
            <div class="col-md-6 text-center">
                <asp:Image ID="imgAircraft" runat="server" CssClass="img-fluid shadow-lg" Width="100%" />
            </div>

            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-exchange-alt"></i> Transaction Type</label>
                    <asp:DropDownList ID="ddlTransactionType" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTransactionType_SelectedIndexChanged">
                        <asp:ListItem Text="Rent" Value="Rent" />
                        <asp:ListItem Text="Purchase" Value="Purchase" />
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-plane"></i> Selected Aircraft</label>
                    <asp:DropDownList ID="ddlAircrafts" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlAircrafts_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>

                <asp:Panel ID="pnlRentalOptions" runat="server" Visible="true">
                    <div class="mb-3">
                        <label class="form-label"><i class="far fa-calendar-alt"></i> Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><i class="far fa-calendar-alt"></i> End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-calendar-week"></i> Rental Duration</label>
                        <asp:DropDownList ID="ddlRentalPeriod" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlRentalPeriod_SelectedIndexChanged">
                            <asp:ListItem Text="Select Duration" Value="" />
                            <asp:ListItem Text="1 Week" Value="7" />
                            <asp:ListItem Text="2 Weeks" Value="14" />
                            <asp:ListItem Text="1 Month" Value="30" />
                            <asp:ListItem Text="6 Months" Value="180" />
                            <asp:ListItem Text="1 Year" Value="365" />
                        </asp:DropDownList>
                    </div>
                </asp:Panel>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-dollar-sign"></i> Total Amount ($)</label>
                    <asp:TextBox ID="txtTotalAmount" runat="server" CssClass="form-control fw-bold text-success" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="text-center">
                    <asp:Button ID="BtnConfirmTransaction" runat="server" CssClass="btn btn-success btn-lg fw-bold" Text="Confirm Transaction" OnClick="btnConfirmTransaction_Click" />
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmTransaction() {
            return confirm('Are you sure you want to proceed with this transaction?');
        }
    </script>
</asp:Content>
