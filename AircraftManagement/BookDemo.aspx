<%@ Page Title="Book Demo" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="BookDemo.aspx.cs" Inherits="AircraftManagement.BookDemo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Book a Demo</h2>
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="mb-3">
                    <label for="txtFullName" class="form-label">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="txtEmail" class="form-label">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="txtPhoneNumber" class="form-label">Phone Number</label>
                    <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="txtStartDate" class="form-label">Start Date</label>
                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="txtEndDate" class="form-label">End Date</label>
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label for="ddlAircraft" class="form-label">Select Aircraft</label>
                    <asp:DropDownList ID="ddlAircraft" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>
                <div class="mb-3">
                    <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
                </div>
                <asp:Button ID="BtnBookDemo" runat="server" CssClass="btn btn-success w-100" 
                            Text="Confirm Booking" OnClick="btnBookDemo_Click" />
            </div>
        </div>
    </div>
</asp:Content>
