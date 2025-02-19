<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="AboutUs.aspx.cs" Inherits="AircraftManagement.AboutUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .content-section {
            padding-top: 20px;
            padding-bottom: 40px;
        }

        .card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card:hover {
            transform: scale(1.05);
            box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.2);
        }
    </style>

    <div class="container mt-3">
        <h1 class="text-center"><i class="fas fa-plane"></i> About Us</h1>
    </div>

    <div class="container content-section">
        <h2 class="text-center"><i class="fas fa-history"></i> Our Story</h2>
        <p class="text-center">
            <span class="fw-bold text-primary">Founded in 2025</span>, Aircraft Management started as a small initiative to connect aircraft buyers and sellers seamlessly.
            With a passion for aviation and technology, we built a **smart, secure, and efficient** marketplace for aircraft transactions.
        </p>

        <div class="row text-center mt-4">
            <div class="col-md-6">
                <div class="card shadow p-4 bg-primary text-white">
                    <h3><i class="fas fa-bullseye"></i> Our Mission</h3>
                    <p>To redefine the aviation industry with **innovative, tech-driven solutions** for aircraft transactions.</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card shadow p-4 bg-warning text-dark">
                    <h3><i class="fas fa-lightbulb"></i> Our Vision</h3>
                    <p>To be the **world’s most trusted platform** for aircraft rental and sales.</p>
                </div>
            </div>
        </div>

        <h2 class="text-center mt-5"><i class="fas fa-users"></i> Meet Our Team</h2>
        <div class="row text-center">
            <div class="col-md-3">
                <div class="card shadow p-3 bg-light">
                    <h5><i class="fas fa-user-tie"></i> Fehaid Alsubaie</h5>
                    <p>Project Lead & Backend Developer</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow p-3 bg-light">
                    <h5><i class="fas fa-laptop-code"></i> Mohammed Alluqman</h5>
                    <p>Backend Developer</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow p-3 bg-light">
                    <h5><i class="fas fa-paint-brush"></i> Mohammed Nashir</h5>
                    <p>Frontend & UI Designer</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow p-3 bg-light">
                    <h5><i class="fas fa-database"></i> Suliman Alotaibi</h5>
                    <p>Database Architect</p>
                </div>
            </div>
        </div>

        <h2 class="text-center mt-5"><i class="fas fa-code"></i> Technologies We Use</h2>
        <div class="row text-center">
            <div class="col-md-4">
                <div class="card shadow p-4 bg-success text-white">
                    <h4><i class="fas fa-globe"></i> Web Development</h4>
                    <p>ASP.NET, C#, JavaScript, HTML5, CSS3, Bootstrap</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow p-4 bg-info text-white">
                    <h4><i class="fas fa-mobile-alt"></i> Mobile Development</h4>
                    <p>Flutter, React Native, Kotlin, Swift</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card shadow p-4 bg-danger text-white">
                    <h4><i class="fas fa-server"></i> Cloud & Database</h4>
                    <p>SQL Server, Firebase, AWS, Azure</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
