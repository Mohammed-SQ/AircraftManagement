<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="AircraftManagement.UserProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4">My Profile</h2>

        <div id="profileContainer">
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="txtFullName" class="form-label">Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtEmail" class="form-label">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="txtPassword" class="form-label">New Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtConfirmPassword" class="form-label">Confirm Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="mb-3">
                <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
                <asp:Label ID="lblSuccess" runat="server" ForeColor="Green"></asp:Label>
            </div>
            <asp:Button ID="BtnSaveChanges" runat="server" CssClass="btn btn-success w-100" 
                        Text="Save Changes" OnClick="btnSaveChanges_Click" />
        </div>

        <h4 class="mt-5">Booking History</h4>
        <asp:GridView ID="gvBookings" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:BoundField DataField="TransactionType" HeaderText="Type" />
                <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:MM/dd/yyyy}" />
                <asp:BoundField DataField="EndDate" HeaderText="End Date" DataFormatString="{0:MM/dd/yyyy}" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Amount ($)" DataFormatString="{0:C}" />
                <asp:BoundField DataField="PaymentStatus" HeaderText="Status" />
            </Columns>
        </asp:GridView>

        <h4 class="mt-5">Wishlist</h4>
        <asp:GridView ID="gvWishlist" runat="server" AutoGenerateColumns="False" CssClass="table table-striped">
            <Columns>
                <asp:BoundField DataField="AircraftModel" HeaderText="Aircraft Model" />
                <asp:BoundField DataField="AddedAt" HeaderText="Added On" DataFormatString="{0:MM/dd/yyyy}" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
