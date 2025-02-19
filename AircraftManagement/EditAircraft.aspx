<%@ Page Title="Edit Aircraft" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="EditAircraft.aspx.cs" Inherits="AircraftManagement.EditAircraft" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4"><i class="fas fa-edit"></i> Edit Aircraft Details</h2>

        <div class="row">
            <div class="col-md-6">
                <div class="mb-3">
                    <label for="txtModel" class="form-label"><i class="fas fa-plane"></i> Aircraft Model</label>
                    <asp:TextBox ID="txtModel" runat="server" CssClass="form-control" placeholder="Enter aircraft model"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="txtCapacity" class="form-label"><i class="fas fa-users"></i> Capacity</label>
                    <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" placeholder="Enter capacity"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="txtRentalPrice" class="form-label"><i class="fas fa-dollar-sign"></i> Rental Price ($)</label>
                    <asp:TextBox ID="txtRentalPrice" runat="server" CssClass="form-control" placeholder="Enter rental price"></asp:TextBox>
                </div>
            </div>

            <div class="col-md-6">
                <div class="mb-3">
                    <label for="txtPurchasePrice" class="form-label"><i class="fas fa-shopping-cart"></i> Purchase Price ($)</label>
                    <asp:TextBox ID="txtPurchasePrice" runat="server" CssClass="form-control" placeholder="Enter purchase price"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="ddlStatus" class="form-label"><i class="fas fa-check-circle"></i> Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Available" Value="Available"></asp:ListItem>
                        <asp:ListItem Text="Rented" Value="Rented"></asp:ListItem>
                        <asp:ListItem Text="Sold" Value="Sold"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label for="txtImageUrl" class="form-label"><i class="fas fa-image"></i> Image URL</label>
                    <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control" placeholder="Enter image URL (or upload below)"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-upload"></i> Upload Image</label>
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" />
                </div>

                <div class="text-center mb-3">
                    <asp:Image ID="imgAircraft" runat="server" CssClass="img-thumbnail" Width="200" Visible="false"/>
                </div>
            </div>
        </div>

        <div class="mb-3 text-center">
            <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
        </div>

        <asp:Button ID="BtnUpdate" runat="server" CssClass="btn btn-success w-100 fw-bold" Text="Update Aircraft" OnClick="btnUpdate_Click" />
    </div>
</asp:Content>
