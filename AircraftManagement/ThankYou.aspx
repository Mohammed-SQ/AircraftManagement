<%@ Page Title="Thank You" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ThankYou.aspx.cs" Inherits="AircraftManagement.ThankYou" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5 text-center">
        <h2 class="text-success">Thank You!</h2>
        <p>Your inquiry has been submitted successfully. We will get back to you soon.</p>
        <a href="Home.aspx" class="btn btn-primary">Return to Home</a>
    </div>
</asp:Content>