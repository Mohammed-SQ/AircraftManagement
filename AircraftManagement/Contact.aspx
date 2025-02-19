<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Contact.aspx.cs" Inherits="AircraftManagement.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4"><i class="fas fa-envelope"></i> Contact Us</h2>
        <p class="text-center text-muted">Have questions? We're here to help. Fill out the form below, and we’abcdq get back to you as soon as possible.</p>

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card p-4 shadow">
                    <div class="mb-3">
                        <label for="txtName" class="form-label"><i class="fas fa-user"></i> Full Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" Placeholder="Enter your full name" ReadOnly="false"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtEmail" class="form-label"><i class="fas fa-envelope"></i> Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Placeholder="Enter your email" ReadOnly="false"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtSubject" class="form-label"><i class="fas fa-comment"></i> Subject</label>
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" Placeholder="Enter subject"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label for="txtMessage" class="form-label"><i class="fas fa-comments"></i> Message</label>
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" Placeholder="Enter your message"></asp:TextBox>
                    </div>

                    <asp:Label ID="lblMessage" runat="server" ForeColor="Red" CssClass="fw-bold"></asp:Label>

                    <asp:Button ID="BtnSubmit" runat="server" CssClass="btn btn-success w-100 fw-bold" 
                                Text="📩 Submit Inquiry" OnClick="btnSubmit_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
