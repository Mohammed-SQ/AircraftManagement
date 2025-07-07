<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="AircraftManagement.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="text-center">
            <h2 class="mb-3 text-white">Contact Us <i class="bi bi-chat-left-text-fill"></i></h2>
            <p class="text-white">Have questions? We're here to help. Fill out the form below, and we'll get back to you as soon as possible.</p>
        </div>

        <div class="row justify-content-center mt-4">
            <div class="col-md-8">
                <div class="card p-4 shadow contact-card">
                    <div class="mb-3">
                        <label for="txtName" class="form-label text-white"><i class="fas fa-user"></i> Full Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control text-white" Placeholder="Enter your full name" ReadOnly="false"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtEmail" class="form-label text-white"><i class="fas fa-envelope"></i> Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control text-white" Placeholder="Enter your email" ReadOnly="false"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtSubject" class="form-label text-white"><i class="fas fa-comment"></i> Subject</label>
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control text-white" Placeholder="Enter subject"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtMessage" class="form-label text-white"><i class="fas fa-comments"></i> Message</label>
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control text-white" Placeholder="Enter your message"></asp:TextBox>
                    </div>

                    <asp:Label ID="lblMessage" runat="server" ForeColor="Red" CssClass="fw-bold text-white"></asp:Label>

                    <asp:Button ID="BtnSubmit" runat="server" CssClass="btn btn-success w-100 fw-bold" 
                                Text="📩 Submit Inquiry" OnClick="btnSubmit_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
    .form-control, .form-select {
        background: rgba(255, 255, 255, 0.1); /* Semi-transparent background */
        backdrop-filter: blur(10px); /* Apply blur effect */
        border: 1px solid rgba(255, 255, 255, 0.2); /* Add a subtle border */
        color: black; /* Default text color set to black */
        border-radius: 10px; /* Rounded corners */
        padding: 10px; /* Add padding for better appearance */
        transition: all 0.3s ease-in-out; /* Smooth transition for hover and focus effects */
    }

    .form-control::placeholder {
        color: rgba(0, 0, 0, 0.5); /* Placeholder text color set to a lighter black */
    }

    .form-control:focus {
        background: white; /* Change background to white on focus */
        color: black; /* Keep text color black on focus */
        outline: none; /* Remove default focus outline */
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.2); /* Add a subtle shadow effect */
    }

    .form-control:focus::placeholder {
        color: rgba(0, 0, 0, 0.5); /* Keep placeholder text color lighter black on focus */
    }
        body {
            background: url('/images/ContactBG.jpg') no-repeat center center fixed;
            background-size: cover;
            backdrop-filter: blur(3px);
        }

        .contact-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }

        .contact-card:hover {
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
