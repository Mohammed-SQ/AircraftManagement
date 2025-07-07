<%@ Page Title="Marketplace" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Marketplace.aspx.cs" Inherits="AircraftManagement.Marketplace" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Pre-Owned Aircraft Marketplace</h2>
        <asp:GridView ID="gvMarketplace" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:BoundField DataField="Model" HeaderText="Model" />
                <asp:BoundField DataField="Year" HeaderText="Year" />
                <asp:BoundField DataField="Price" HeaderText="Price (﷼)" DataFormatString="{0:C}" />
                <asp:BoundField DataField="Condition" HeaderText="Condition" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <a href='ViewDetails.aspx?AircraftID=<%# Eval("AircraftID") %>' class="btn btn-sm btn-primary">View Details</a>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>