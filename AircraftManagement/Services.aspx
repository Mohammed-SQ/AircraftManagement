<%@ Page Title="Services" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Services.aspx.cs" Inherits="AircraftManagement.Services" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="text-center mb-5">
            <h2 class="mb-3 text-white">Our Services <i class="bi bi-gear-wide-connected"></i></h2>
            <p>We offer a wide range of services to meet all your aircraft needs, from rentals and purchases to maintenance and customization.</p>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card service-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Aircraft Rental</h5>
                        <p class="card-text">Flexible rental options for short or long-term use at competitive rates.</p>
<a href="#" class="btn btn-primary" onclick="handleProtectedAction('PurchaseRental.aspx')">
    <i class="fas fa-info-circle"></i> Learn More
</a>

                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card service-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Aircraft Purchase</h5>
                        <p class="card-text">Purchase new or pre-owned aircraft with flexible financing options.</p>
<a href="#" class="btn btn-primary" onclick="handleProtectedAction('PurchaseRental.aspx')">
    <i class="fas fa-info-circle"></i> Learn More
</a>

                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card service-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Sell Your Aircraft</h5>
                        <p class="card-text">Easily list your aircraft for sale or rent and connect with potential buyers.</p>
<a href="#" class="btn btn-warning" onclick="handleProtectedAction('SellAircraft.aspx')">
    <i class="fas fa-plane-departure"></i> Sell Now
</a>

                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card service-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Aircraft Maintenance</h5>
                        <p class="card-text">Professional maintenance services to keep your aircraft in top condition.</p>
<a href="#" class="btn btn-danger" onclick="handleProtectedAction('Maintenance.aspx')">
    <i class="fas fa-tools"></i> Learn More
</a>
                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card service-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Aircraft Customization</h5>
                        <p class="card-text">Personalize your aircraft with custom designs and advanced technology.</p>
<a href="#" class="btn btn-info" onclick="handleProtectedAction('Customization.aspx')">
    <i class="fas fa-palette"></i> Learn More
</a>                

                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="card service-card">
                    <div class="card-body text-center">
                        <h5 class="card-title">Aircraft Financing</h5>
                        <p class="card-text">Flexible financing solutions to help you purchase your dream aircraft.</p>
<a href="#" class="btn btn-dark" onclick="handleProtectedAction('Financing.aspx')">
    <i class="fas fa-hand-holding-usd"></i> Learn More
</a>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
function handleProtectedAction(targetUrl) {
    if (window.isLoggedIn === 'true') {
        window.location.href = targetUrl;
    } else {
        showLoginModal();
    }
}
    </script>

    <style>
        body {
            background: url('/images/ServicesBG.jpg') no-repeat center center fixed;
            background-size: cover;
            backdrop-filter: blur(3px);
        }

        .service-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.3);
        }

        .btn-primary, .btn-success, .btn-warning, .btn-danger, .btn-info, .btn-dark {
            background: rgba(255, 255, 255, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            backdrop-filter: blur(10px);
            color: white !important;
        }

        .btn-primary:hover, .btn-success:hover, .btn-warning:hover, .btn-danger:hover, .btn-info:hover, .btn-dark:hover {
            background: rgba(255, 255, 255, 0.2) !important;
        }
    </style>
</asp:Content>
