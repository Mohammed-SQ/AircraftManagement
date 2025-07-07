<%@ Page Title="Transaction History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="TransactionHistory.aspx.cs" Inherits="AircraftManagement.TransactionHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Transaction History</h2>
        <div class="mb-3">
            <label for="ddlFilter" class="form-label">Filter by Type</label>
            <asp:DropDownList ID="ddlFilter" runat="server" CssClass="form-select">
                <asp:ListItem Text="All" Value="All"></asp:ListItem>
                <asp:ListItem Text="Rental" Value="Rental"></asp:ListItem>
                <asp:ListItem Text="Purchase" Value="Purchase"></asp:ListItem>
            </asp:DropDownList>
        </div>
        <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:BoundField DataField="TransactionID" HeaderText="ID" />
                <asp:BoundField DataField="AircraftModel" HeaderText="Aircraft Model" />
                <asp:BoundField DataField="TransactionType" HeaderText="Type" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Amount (﷼)" DataFormatString="{0:C}" />
                <asp:BoundField DataField="TransactionDate" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy}" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>