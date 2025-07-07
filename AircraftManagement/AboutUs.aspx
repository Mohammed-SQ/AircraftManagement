<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="AboutUs.aspx.cs" Inherits="AircraftManagement.AboutUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="text-center">
            <h2 class="mb-3 text-white">About Us <i class="bi bi-info-circle-fill"></i></h2>
            <p class="text-white">
                <span class="fw-bold text-primary">Founded in 2025</span>, Aircraft Management started as a small initiative to connect aircraft buyers and sellers seamlessly.
                With a passion for aviation and technology, we built a <strong>smart, secure, and efficient</strong> marketplace for aircraft transactions.
            </p>
        </div>

<h2 class="text-center mt-4 text-white">Meet Our Team <i class="fas fa-users"></i></h2>
<div class="row justify-content-center mt-3">
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="icon"><i class="fas fa-user-tie"></i></div>
                    <h5>Fehaid Alsubaie</h5>
                    <p>Leader & Backend Developer</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="icon"><i class="fas fa-laptop-code"></i></div>
                    <h5>Mohammed Alluqman</h5>
                    <p>Backend Developer</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="icon"><i class="fas fa-paint-brush"></i></div>
                    <h5>Mohammed Nashir</h5>
                    <p>Frontend & UI Designer</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="icon"><i class="fas fa-database"></i></div>
                    <h5>Suliman Alotaibi</h5>
                    <p>Database Architect</p>
                </div>
            </div>
        </div>

<h2 class="text-center mt-4 text-white">Technologies We Use <i class="fas fa-code"></i></h2>
<div class="row justify-content-center mt-3">
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="icon"><i class="fas fa-globe"></i></div>
                    <h4>Web Development</h4>
                    <p>ASP.NET, C#, JavaScript, HTML5, CSS3, Bootstrap</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="icon"><i class="fas fa-server"></i></div>
                    <h4>Cloud & Database</h4>
                    <p>SQL Server, Firebase, AWS, Azure</p>
                </div>
            </div>
        </div>
    </div>

    <style>
        body {
            background: url('/images/AboutUsBG.jpg') no-repeat center center fixed;
            background-size: cover;
            backdrop-filter: blur(3px);
        }

        .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
            color: white;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.3);
        }

        .icon {
            font-size: 1.5em;
            margin-bottom: 10px;
        }

        .text-white {
            color: white !important;
        }

        .text-primary {
            color: white !important;
        }

        .mt-5 {
            margin-top: 3rem;
        }

        .mt-4 {
            margin-top: 1px;
        }

        .mb-3 {
            margin-bottom: 1rem;
        }
    </style>
</asp:Content>
