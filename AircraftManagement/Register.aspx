<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="AirAircraftManagement.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card p-4 shadow-lg">
                    <div class="text-center">
                        <i class="fas fa-user-plus fa-3x text-primary"></i>
                        <h2 class="fw-bold mt-3">Create an Account</h2>
                        <p class="text-muted">Sign up to start booking flights today.</p>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="txtFullName" class="form-label"><i class="fas fa-user"></i> Full Name</label>
                            <asp:TextBox ID="txtFullName" CssClass="form-control" runat="server" placeholder="Enter full name"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="txtEmail" class="form-label"><i class="fas fa-envelope"></i> Email</label>
                            <asp:TextBox ID="txtEmail" CssClass="form-control" runat="server" placeholder="Enter your email"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="txtPassword" class="form-label"><i class="fas fa-lock"></i> Password</label>
                            <asp:TextBox ID="txtPassword" CssClass="form-control" runat="server" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="txtConfirmPassword" class="form-label"><i class="fas fa-lock"></i> Confirm Password</label>
                            <asp:TextBox ID="txtConfirmPassword" CssClass="form-control" runat="server" TextMode="Password" placeholder="Confirm password"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="txtPhoneNumber" class="form-label"><i class="fas fa-phone"></i> Phone Number</label>
                            <asp:TextBox ID="txtPhoneNumber" CssClass="form-control" runat="server" MaxLength="10" placeholder="Enter 10-digit number"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="txtZip" class="form-label"><i class="fas fa-map-pin"></i> ZIP Code</label>
                            <asp:TextBox ID="txtZip" CssClass="form-control" runat="server" MaxLength="6" placeholder="Enter ZIP code"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="txtAddress" class="form-label"><i class="fas fa-map-marker-alt"></i> Address</label>
                            <asp:TextBox ID="txtAddress" CssClass="form-control" runat="server" placeholder="Enter Street, City"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="ddlState" class="form-label"><i class="fas fa-flag"></i> State</label>
                            <asp:DropDownList ID="ddlState" CssClass="form-control" runat="server">
                                <asp:ListItem Text="Select State" Value="" />
                                <asp:ListItem Text="California" Value="California" />
                                <asp:ListItem Text="Texas" Value="Texas" />
                                <asp:ListItem Text="New York" Value="New York" />
                                <asp:ListItem Text="Florida" Value="Florida" />
                                <asp:ListItem Text="Illinois" Value="Illinois" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="mb-3">
                        <asp:Button ID="BtnRegister" CssClass="btn btn-primary w-100 fw-bold" runat="server" Text="Register" OnClick="btnRegister_Click" />
                        <asp:Label ID="lblMessage" runat="server" CssClass="text-center mt-3 text-danger fw-bold d-block"></asp:Label>
                    </div>

                    <div class="text-center mt-3">
                        <p class="text-muted">Already have an account?</p>
                        <a href="Login.aspx" class="btn btn-outline-primary w-100">
                            <i class="fas fa-sign-in-alt"></i> Login Here
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
