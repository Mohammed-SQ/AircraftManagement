<%@ Page Title="Error" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ErrorPage.aspx.cs" Inherits="AircraftManagement.ErrorPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5 text-center">
        <h2 class="text-danger">Oops! Something went wrong.</h2>
        <p>We apologize for the inconvenience. Please try again later or contact support.</p>
        <a href="Home.aspx" class="btn btn-primary">Return to Home</a>
    </div>
</asp:Content>