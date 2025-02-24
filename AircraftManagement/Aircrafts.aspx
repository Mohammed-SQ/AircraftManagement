<%@ Page Title="Luxury Aircraft Rentals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Aircrafts.aspx.cs" Inherits="AircraftManagement.Aircrafts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4"><i class="fas fa-plane"></i> Explore Our Luxury Aircraft</h2>

        <!-- Search & Sort Section -->
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by model, type, or features..."></asp:TextBox>
                </div>
            </div>
            <div class="col-md-2">
                <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Sort by" Value="" />
                    <asp:ListItem Text="Price (Low to High)" Value="PriceAsc" />
                    <asp:ListItem Text="Price (High to Low)" Value="PriceDesc" />
                    <asp:ListItem Text="Capacity (Largest First)" Value="CapacityDesc" />
                </asp:DropDownList>
            </div>
            <div class="col-md-2">
                <asp:Button ID="BtnFilter" runat="server" CssClass="btn btn-primary w-100 fw-bold" 
                            Text="Apply" OnClick="btnFilter_Click" /> <!-- Correctly set to btnFilter_Click -->
            </div>
        </div>
        <div class="mb-3 text-center">
            <asp:Label ID="lblError" runat="server" ForeColor="Red" CssClass="fw-bold"></asp:Label>
        </div>

        <!-- Aircraft Listings -->
        <div class="row">
            <asp:Repeater ID="rptAircrafts" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                        <div class="card shadow-lg border-0 aircraft-card">
                            <img src='<%# ResolveUrl(Eval("ImageUrl").ToString()) %>' class="card-img-top" alt='<%# Eval("Model") %>' onerror="this.src='/images/default-aircraft.jpg';" />
                            <div class="card-body">
                                <h5 class="card-title text-dark"><i class="fas fa-plane"></i> <%# Eval("Model") %></h5>
                                <p class="text-muted"><%# Eval("Description") %></p>

                                <p class="card-text">
                                    <i class="fas fa-users"></i> <strong>Capacity:</strong> <%# Eval("Capacity") %> seats<br>
                                    <i class="fas fa-dollar-sign"></i> <strong>Rental:</strong> $<%# Eval("RentalPrice") %>/day<br>
                                    <i class="fas fa-industry"></i> <strong>Manufacturer:</strong> <%# Eval("Manufacturer") %>
                                </p>

                                <a href="PurchaseRental.aspx?AircraftID=<%# Eval("AircraftID") %>"
                                   class="btn btn-success w-100 book-btn">
                                    <i class="fas fa-calendar-check"></i> Rent or Buy Now
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <style>
        .aircraft-card {
            border-radius: 15px;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }
        .aircraft-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.3);
        }
        .book-btn {
            font-size: 18px;
            font-weight: bold;
            background: linear-gradient(to right, #28a745, #218838);
            border: none;
            transition: 0.3s ease-in-out;
        }
        .book-btn:hover {
            background: linear-gradient(to right, #218838, #28a745);
            transform: scale(1.05);
        }
        .form-control, .form-select {
            border-radius: 10px;
        }
    </style>
</asp:Content>