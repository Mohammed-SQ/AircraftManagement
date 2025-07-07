<%@ Page Title="Community" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Community.aspx.cs" Inherits="AircraftManagement.Community" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            background: url('images/CommunityBG.jpg') no-repeat center center fixed !important;
            background-size: cover !important;
            padding-top: 100px;
        }
        .community-container {
            max-width: 900px;
            margin: 30px auto;
            padding: 25px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
            color: white;
            backdrop-filter: blur(10px);
        }

        .post-box {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 16px;
            background: #3a3a3a;
            color: white;
        }

        .post-box:focus {
            outline: none;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
            border: 1px solid #007bff;
        }

        .btn-post {
            background-color: #1abc9c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .btn-post:hover {
            background-color: #16a085;
            transform: translateY(-3px);
            box-shadow: 0 7px 20px rgba(26, 188, 156, 0.4);
        }

        .btn-reply {
            background-color: #f39c12;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            font-size: 13px;
            cursor: pointer;
            margin-top: 8px;
            transition: all 0.3s ease;
        }

        .btn-reply:hover {
            background-color: #e67e22;
        }

        .btn-delete {
            background-color: transparent;
            border: none;
            color: #e74c3c;
            font-size: 18px;
            font-weight: bold;
            float: right;
            cursor: pointer;
        }

        .message {
            font-weight: bold;
            margin-bottom: 10px;
        }

        .post {
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 6px;
            position: relative;
            background: rgba(255, 255, 255, 0.05);
        }

        .post .meta {
            font-size: 14px;
            color: #d0d0d0;
            margin-bottom: 5px;
        }

        .reply {
            margin-left: 30px;
            border-left: 3px solid rgba(255, 255, 255, 0.2);
            padding-left: 15px;
            margin-top: 10px;
            position: relative;
        }

        .role-badge {
            background-color: #3498db;
            color: white;
            padding: 2px 8px;
            font-size: 12px;
            border-radius: 4px;
            margin-left: 10px;
        }

        .deleted-message {
            font-style: italic;
            color: #888;
        }

        .login-prompt {
            margin-bottom: 20px;
            font-size: 16px;
        }
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
    </style>

    <div class="community-container">
    <h2 class="mb-3 text-white"><i class="bi bi-people-fill"></i> Community</h2>
    <p>Welcome to the Community! Connect, share, and engage with fellow aviation enthusiasts. Post your thoughts, ask questions, and collaborate with others.</p>
</div>

    <div class="community-container">
        <h2><i class="fas fa-comments"></i> Community Posts</h2>

        <% if (Session["Username"] != null && Session["Username"].ToString() != "Guest") { %>
<asp:TextBox ID="txtPost" runat="server" CssClass="form-control" TextMode="MultiLine" Placeholder="Write something..." />
            <asp:Button ID="btnPost" runat="server" Text="Post" CssClass="btn-post" OnClick="btnPost_Click" />
        <% } else { %>
            <div class="login-prompt">
                <p>Please <a href="#" onclick="showLoginModal(); return false;" style="color: #007bff;">log in</a> to post or reply to messages.</p>
            </div>
        <% } %>
        <asp:Label ID="lblMessage" runat="server" CssClass="message" />

        <asp:Repeater ID="rptPosts" runat="server" OnItemDataBound="rptPosts_ItemDataBound" OnItemCommand="rptPosts_ItemCommand">
            <ItemTemplate>
                <div class="post">
                    <%-- Admin Delete Button for Post --%>
                    <asp:LinkButton ID="btnDeletePost" runat="server" CssClass="btn-delete"
                        CommandName="DeletePost" CommandArgument='<%# Eval("Id") %>'
                        Visible='<%# Session["Role"] != null && Session["Role"].ToString() == "Admin" %>'
                        OnClientClick="return confirm('Are you sure you want to delete this post?');">✖</asp:LinkButton>

                    <div class="meta">
                        <i class="fas fa-user-circle"></i>
                        <strong><%# Eval("Username") %></strong>
                        <span class="role-badge"><%# Eval("Role") %></span>
                        · <%# Eval("PostDate", "{0:g}") %>
                    </div>

                    <div class="content">
                        <%# Convert.ToBoolean(Eval("IsDeleted")) ? "<i class='deleted-message'>Post got deleted</i>" : Eval("Message") %>
                    </div>

                    <asp:Button ID="btnReply" runat="server" Text="Reply" CssClass="btn-reply"
                        CommandName="Reply" CommandArgument='<%# Eval("Id") %>'
                        Visible='<%# !Convert.ToBoolean(Eval("IsDeleted")) && Session["Username"] != null && Session["Username"].ToString() != "Guest" %>' />

                    <asp:Repeater ID="rptReplies" runat="server" OnItemCommand="rptReplies_ItemCommand">
                        <ItemTemplate>
                            <div class="reply">
                                <%-- Admin Delete Button for Reply --%>
                                <asp:LinkButton ID="btnDeleteReply" runat="server" CssClass="btn-delete"
                                    CommandName="DeleteReply" CommandArgument='<%# Eval("Id") %>'
                                    Visible='<%# Session["Role"] != null && Session["Role"].ToString() == "Admin" %>'
                                    OnClientClick="return confirm('Are you sure you want to delete this reply?');">✖</asp:LinkButton>

                                <div class="meta">
                                    ↳ <strong><%# Eval("Username") %></strong>
                                    <span class="role-badge"><%# Eval("Role") %></span>
                                    · <%# Eval("PostDate", "{0:g}") %>
                                </div>
                                <div class="content">
                                    <%# Convert.ToBoolean(Eval("IsDeleted")) ? "<i class='deleted-message'>This message no longer exists</i>" : Eval("Message") %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>