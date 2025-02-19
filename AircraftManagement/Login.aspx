<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="AircraftManagement.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-lg p-4">
                    <div class="text-center">
                        <i class="fas fa-user-lock fa-3x text-primary"></i>
                        <h2 class="fw-bold mt-3">Login to Your Account</h2>
                        <p class="text-muted">Access your aircraft rental dashboard.</p>
                    </div>

                    <div class="mb-3">
                        <label for="txtEmail" class="form-label">
                            <i class="fas fa-envelope"></i> Email
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter your email"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="txtPassword" class="form-label">
                            <i class="fas fa-key"></i> Password
                        </label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3 text-center">
                        <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
                    </div>

                    <asp:Button ID="BtnLogin" runat="server" CssClass="btn btn-primary w-100 fw-bold" 
                                Text="Login" OnClick="btnLogin_Click" />

                    <div class="text-center mt-3">
                        <a href="ForgotPassword.aspx" class="text-decoration-none text-primary">
                            <i class="fas fa-lock"></i> Forgot Password?
                        </a>
                    </div>

                    <hr class="mt-4"/>
                    <div class="text-center">
                        <p class="text-muted">Don't have an account?</p>
                        <a href="Register.aspx" class="btn btn-outline-primary w-100">
                            <i class="fas fa-user-plus"></i> Create an Account
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
