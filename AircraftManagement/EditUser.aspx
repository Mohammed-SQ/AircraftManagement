<%@ Page Title="Edit User" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="EditUser.aspx.cs" Inherits="AircraftManagement.EditUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4"><i class="fas fa-user-edit"></i> Edit User</h2>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-lg p-4">
                    <div class="mb-3">
                        <label for="txtFullName" class="form-label"><i class="fas fa-user"></i> Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtEmail" class="form-label"><i class="fas fa-envelope"></i> Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="ddlRole" class="form-label"><i class="fas fa-user-tag"></i> Role</label>
                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Customer" Value="Customer"></asp:ListItem>
                            <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3 text-center">
                        <asp:Label ID="lblError" runat="server" ForeColor="Red"></asp:Label>
                    </div>
                    <asp:Button ID="BtnUpdateUser" runat="server" CssClass="btn btn-success w-100" 
                                Text="Update User" OnClick="btnUpdateUser_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
