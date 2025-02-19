<%@ Page Title="Services" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Services.aspx.cs" Inherits="AircraftManagement.Services" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4"><i class="fas fa-cogs"></i> Our Services</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="card text-center">
                    <i class="fas fa-plane card-img-top fa-5x mt-4 text-primary"></i>
                    <div class="card-body">
                        <h5 class="card-title">Aircraft Rental</h5>
                        <p class="card-text">Rent aircraft for short or long-term use at competitive prices.</p>
                        <a href="PurchaseRental.aspx" class="btn btn-primary"><i class="fas fa-info-circle"></i> Learn More</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card text-center">
                    <i class="fas fa-shopping-cart card-img-top fa-5x mt-4 text-success"></i>
                    <div class="card-body">
                        <h5 class="card-title">Aircraft Purchase</h5>
                        <p class="card-text">Buy pre-owned or new aircraft with flexible payment options.</p>
                        <a href="PurchaseRental.aspx" class="btn btn-success"><i class="fas fa-money-check-alt"></i> Learn More</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card text-center">
                    <i class="fas fa-handshake card-img-top fa-5x mt-4 text-warning"></i>
                    <div class="card-body">
                        <h5 class="card-title">Sell Your Aircraft</h5>
                        <p class="card-text">List your aircraft for sale or rent and connect with buyers instantly.</p>
                        <a href="SellAircraft.aspx" class="btn btn-warning"><i class="fas fa-plane-departure"></i> Sell Now</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card text-center">
                    <i class="fas fa-wrench card-img-top fa-5x mt-4 text-danger"></i>
                    <div class="card-body">
                        <h5 class="card-title">Aircraft Maintenance</h5>
                        <p class="card-text">Ensure top performance with our professional maintenance services.</p>
                        <a href="Maintenance.aspx" class="btn btn-danger"><i class="fas fa-tools"></i> Learn More</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card text-center">
                    <i class="fas fa-paint-brush card-img-top fa-5x mt-4 text-info"></i>
                    <div class="card-body">
                        <h5 class="card-title">Aircraft Customization</h5>
                        <p class="card-text">Upgrade your aircraft with personalized design and technology.</p>
                        <a href="Customization.aspx" class="btn btn-info"><i class="fas fa-palette"></i> Learn More</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card text-center">
                    <i class="fas fa-dollar-sign card-img-top fa-5x mt-4 text-dark"></i>
                    <div class="card-body">
                        <h5 class="card-title">Aircraft Financing</h5>
                        <p class="card-text">Flexible financing options available for aircraft buyers.</p>
                        <a href="Financing.aspx" class="btn btn-dark"><i class="fas fa-hand-holding-usd"></i> Learn More</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
