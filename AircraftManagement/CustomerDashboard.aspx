<%@ Page Title="Customer Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="CustomerDashboard.aspx.cs" Inherits="AircraftManagement.CustomerDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Welcome, <%# Session["FullName"] %>!</h2>
        
        <h4>Upcoming Bookings</h4>
        <asp:GridView ID="gvBookings" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:BoundField DataField="BookingType" HeaderText="Type" />
                <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:MM/dd/yyyy}" />
                <asp:BoundField DataField="EndDate" HeaderText="End Date" DataFormatString="{0:MM/dd/yyyy}" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Amount ($)" DataFormatString="{0:C}" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>

        <h4>Transaction History</h4>
        <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:BoundField DataField="TransactionType" HeaderText="Type" />
                <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:MM/dd/yyyy}" />
                <asp:BoundField DataField="EndDate" HeaderText="End Date" DataFormatString="{0:MM/dd/yyyy}" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Amount ($)" DataFormatString="{0:C}" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>

        <h4>Wishlist</h4>
        <asp:GridView ID="gvWishlist" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:BoundField DataField="Model" HeaderText="Aircraft Model" />
                <asp:BoundField DataField="AddedAt" HeaderText="Added On" DataFormatString="{0:MM/dd/yyyy}" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>