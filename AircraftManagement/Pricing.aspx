<%@ Page Title="Pricing" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Pricing.aspx.cs" Inherits="AircraftManagement.Pricing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Pricing</h2>
        <asp:GridView ID="gvPricing" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:BoundField DataField="Model" HeaderText="Model" />
                <asp:BoundField DataField="Capacity" HeaderText="Capacity" />
                <asp:BoundField DataField="RentalPrice" HeaderText="Rental Price (﷼)" DataFormatString="{0:C}" />
                <asp:BoundField DataField="PurchasePrice" HeaderText="Purchase Price (﷼)" DataFormatString="{0:C}" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>