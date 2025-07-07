<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddAircraft.aspx.cs" Inherits="AircraftManagement.AddAircraft" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4"><i class="fas fa-plane"></i> Add New Aircraft</h2>

        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-lg p-4">
                    <div class="mb-3">
                        <label for="txtModel" class="form-label"><i class="fas fa-plane"></i> Model</label>
                        <asp:TextBox ID="txtModel" runat="server" CssClass="form-control" placeholder="Enter aircraft model"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtCapacity" class="form-label"><i class="fas fa-users"></i> Capacity</label>
                        <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" placeholder="Enter seating capacity"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtRentalPrice" class="form-label"><i class="fas fa-dollar-sign"></i> Rental Price (﷼/day)</label>
                        <asp:TextBox ID="txtRentalPrice" runat="server" CssClass="form-control" placeholder="Enter rental price"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtPurchasePrice" class="form-label"><i class="fas fa-money-bill-wave"></i> Purchase Price (﷼)</label>
                        <asp:TextBox ID="txtPurchasePrice" runat="server" CssClass="form-control" placeholder="Enter purchase price"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtManufacturer" class="form-label"><i class="fas fa-industry"></i> Manufacturer</label>
                        <asp:TextBox ID="txtManufacturer" runat="server" CssClass="form-control" placeholder="Enter manufacturer name"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtYearManufactured" class="form-label"><i class="fas fa-calendar-alt"></i> Year Manufactured</label>
                        <asp:TextBox ID="txtYearManufactured" runat="server" CssClass="form-control" placeholder="Enter year of manufacture"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtDescription" class="form-label"><i class="fas fa-info-circle"></i> Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Enter aircraft description"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="fileUpload" class="form-label"><i class="fas fa-upload"></i> Upload Image</label>
                        <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label for="ddlStatus" class="form-label"><i class="fas fa-check-circle"></i> Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Available" Value="Available"></asp:ListItem>
                            <asp:ListItem Text="Rented" Value="Rented"></asp:ListItem>
                            <asp:ListItem Text="Sold" Value="Sold"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3 text-center">
                        <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold"></asp:Label>
                    </div>
                    <asp:Button ID="BtnAddAircraft" runat="server" CssClass="btn btn-success w-100" 
                                Text="Add Aircraft" OnClick="BtnAddAircraft_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>