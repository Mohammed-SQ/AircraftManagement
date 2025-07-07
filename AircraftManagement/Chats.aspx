<%@ Page Title="Chat - Saudi Aviation Market" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Chats.aspx.cs" Inherits="AircraftManagement.Chats" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- External Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <div class="container my-5">
        <!-- Header -->
        <h2 class="text-center mb-4"><i class="fas fa-comments me-2 text-primary"></i>Chat with <asp:Label ID="lblChatUser" runat="server" Text=""></asp:Label></h2>
        <asp:HiddenField ID="hfReceiverID" runat="server" />

        <!-- Feedback Message -->
        <asp:Label ID="lblFeedbackMessage" runat="server" CssClass="alert d-block text-center mb-4" Visible="false"></asp:Label>

        <!-- Chat Area -->
        <div class="card shadow-lg mb-4">
            <div class="card-body p-4" style="max-height: 500px; overflow-y: auto;" id="chatArea">
                <asp:Repeater ID="rptMessages" runat="server">
                    <ItemTemplate>
                        <div class='<%# Convert.ToString(Eval("SenderID")) == Session["UserID"].ToString() ? "d-flex justify-content-end mb-3" : "d-flex justify-content-start mb-3" %>'>
                            <div class='<%# Convert.ToString(Eval("SenderID")) == Session["UserID"].ToString() ? "alert alert-primary p-3 rounded" : "alert alert-secondary p-3 rounded" %>' style="max-width: 70%;">
                                <p class="mb-1"><%# Eval("MessageContent") %></p>
                                <small class="text-muted"><%# Eval("SentAt", "{0:dd/MM/yyyy HH:mm}") %></small>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- Message Input -->
        <div class="card shadow-lg">
            <div class="card-body p-4">
                <div class="row">
                    <div class="col-md-10">
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" Placeholder="Type your message..."></asp:TextBox>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <asp:Button ID="btnSend" runat="server" Text="Send" CssClass="btn btn-primary w-100" OnClick="btnSend_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Back to Dashboard -->
        <div class="text-center mt-4">
            <a href="SellerDashboard.aspx" class="btn btn-secondary"><i class="fas fa-arrow-left me-2"></i>Back to Dashboard</a>
        </div>
    </div>

    <!-- Custom Styles -->
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #e6f0fa, #b0c4de);
            min-height: 100vh;
        }

        h2 {
            color: #1b5e20;
            font-weight: 700;
        }

        .card {
            border-radius: 15px;
            border: none;
            background: #fff;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .btn-primary, .btn-secondary {
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: #2e7d32;
            transform: translateY(-2px);
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .alert-primary, .alert-secondary {
            border-radius: 10px;
        }

        .form-control {
            border-radius: 5px;
        }
    </style>

    <!-- JavaScript to Auto-Scroll Chat Area -->
    <script type="text/javascript">
        $(document).ready(function () {
            // Auto-scroll to the bottom of the chat area
            var chatArea = document.getElementById('chatArea');
            chatArea.scrollTop = chatArea.scrollHeight;
        });
    </script>
</asp:Content>