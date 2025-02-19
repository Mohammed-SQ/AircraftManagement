<%@ Page Title="Unauthorized" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Unauthorized.aspx.cs" Inherits="AircraftManagement.Unauthorized" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5 text-center">
        <h2 class="text-warning">Access Denied</h2>
        <p>You do not have permission to view this page.</p>
        <a href="Login.aspx" class="btn btn-primary">Login</a>
        <a href="Home.aspx" class="btn btn-secondary">Return to Home</a>
    </div>
</asp:Content>