<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="AircraftManagement.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4"><i class="fas fa-user-shield"></i> Admin Dashboard</h2>

        <!-- Aircraft Management -->
        <div class="card mb-4 shadow-lg">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <div><i class="fas fa-plane"></i> Aircraft Management</div>
                <a href="AddAircraft.aspx" class="btn btn-success btn-sm"><i class="fas fa-plus"></i> Add New Aircraft</a>
            </div>
            <div class="card-body">
                <asp:GridView ID="gvAircrafts" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="AircraftID">
                    <Columns>
                        <asp:BoundField DataField="Model" HeaderText="Model" />
                        <asp:BoundField DataField="Capacity" HeaderText="Capacity" />
                        <asp:BoundField DataField="RentalPrice" HeaderText="Rental Price ($)" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="PurchasePrice" HeaderText="Purchase Price ($)" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <a href='EditAircraft.aspx?AircraftID=<%# Eval("AircraftID") %>' class="btn btn-warning btn-sm"><i class="fas fa-edit"></i> Edit</a>
                                <asp:Button ID="BtnDeleteAircraft" runat="server" Text="Delete" CssClass="btn btn-danger btn-sm"
                                    OnClientClick='<%# "return confirm(\"Are you sure you want to delete " + Eval("Model") + "?\");" %>'
                                    OnClick="BtnDeleteAircraft_Click" CommandArgument='<%# Eval("AircraftID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- User Management -->
        <div class="card mb-4 shadow-lg">
            <div class="card-header bg-dark text-white">
                <i class="fas fa-users"></i> User Management
            </div>
            <div class="card-body">
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="UserID">
                    <Columns>
                        <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Role" HeaderText="Role" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <a href='EditUser.aspx?UserID=<%# Eval("UserID") %>' class="btn btn-warning btn-sm"><i class="fas fa-edit"></i> Edit</a>
                                <asp:Button ID="BtnDeleteUser" runat="server" Text="Delete" CssClass="btn btn-danger btn-sm"
                                    OnClientClick='<%# "return confirm(\"Are you sure you want to delete " + Eval("FullName") + "?\");" %>'
                                    OnClick="BtnDeleteUser_Click" CommandArgument='<%# Eval("UserID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Booking Management -->
        <div class="card mb-4 shadow-lg">
            <div class="card-header bg-success text-white">
                <i class="fas fa-calendar-check"></i> Booking Management
            </div>
            <div class="card-body">
                <asp:GridView ID="gvBookings" runat="server" AutoGenerateColumns="False" CssClass="table table-striped" DataKeyNames="BookingID">
                    <Columns>
                        <asp:BoundField DataField="BookingID" HeaderText="Booking ID" />
                        <asp:BoundField DataField="UserID" HeaderText="User ID" />
                        <asp:BoundField DataField="AircraftID" HeaderText="Aircraft ID" />
                        <asp:BoundField DataField="BookingStatus" HeaderText="Status" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount ($)" DataFormatString="{0:C}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
