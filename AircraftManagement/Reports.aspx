<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="AircraftManagement.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Reports</h2>
        <canvas id="transactionChart" width="400" height="200"></canvas>
    </div>
</asp:Content>