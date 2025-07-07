<%@ Page Title="Aircraft Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="AircraftDetails.aspx.cs" Inherits="AircraftManagement.AircraftDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-6">
            <img src="images/boeing737.jpg" class="img-fluid" alt="Boeing 737"/>
        </div>
        <div class="col-md-6">
            <h2>Boeing 737</h2>
            <p><strong>Capacity:</strong> 150 passengers</p>
            <p><strong>Rental Price:</strong> $5000/day</p>
            <p><strong>Purchase Price:</strong> $5,000,000</p>
            <p><strong>Status:</strong> Available</p>
            <a href="PurchaseRental.aspx?AircraftID=1" class="btn btn-success">Rent Now</a>
            <a href="PurchaseRental.aspx?AircraftID=1" class="btn btn-primary">Purchase Now</a>
        </div>
    </div>
</asp:Content>