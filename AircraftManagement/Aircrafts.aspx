<%@ Page Title="Luxury Aircraft Listings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Aircrafts.aspx.cs" Inherits="AircraftManagement.Aircrafts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center mb-4 text-white">Explore Our Luxury Aircraft <i class="bi bi-airplane-engines-fill"></i></h2>

        <!-- Search & Filter Section -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text text-white"><i class="fas fa-search"></i></span>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control text-black" ClientIDMode="Static" placeholder="Search by model, manufacturer..."></asp:TextBox>
                </div>
            </div>
            <div class="col-md-3">
                <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select text-black" ClientIDMode="Static">
                    <asp:ListItem Text="Sort by" Value="" />
                    <asp:ListItem Text="Year (Newest First)" Value="YearDesc" />
                    <asp:ListItem Text="Year (Oldest First)" Value="YearAsc" />
                    <asp:ListItem Text="Capacity (Largest First)" Value="CapacityDesc" />
                    <asp:ListItem Text="Capacity (Smallest First)" Value="CapacityAsc" />
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <asp:DropDownList ID="ddlSellerType" runat="server" CssClass="form-select text-black" ClientIDMode="Static">
                    <asp:ListItem Text="All" Value="" />
                    <asp:ListItem Text="Buy" Value="SELLER" />
                    <asp:ListItem Text="Rent" Value="RENT" />
                </asp:DropDownList>
            </div>
        </div>
        <div class="mb-3 text-center">
            <asp:Label ID="lblError" runat="server" ForeColor="Red" CssClass="fw-bold text-white"></asp:Label>
        </div>

        <!-- Aircraft Listings -->
        <div class="row" id="aircraftContainer">
            <!-- Aircraft cards will be dynamically added here -->
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const searchInput = document.getElementById('txtSearch');
            const sortDropdown = document.getElementById('ddlSort');
            const sellerTypeDropdown = document.getElementById('ddlSellerType');
            let allAircraft = []; // Store all aircraft data

            // Fetch all aircraft data on page load
            function fetchAircrafts() {
                fetch('Aircrafts.aspx/LoadAircrafts', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    body: JSON.stringify({})
                })
                    .then(response => response.json())
                    .then(data => {
                        const result = data.d;
                        if (result.success) {
                            allAircraft = result.aircrafts;
                            updateAircrafts();
                        } else {
                            document.querySelector('#aircraftContainer').innerHTML = '';
                            document.getElementById('lblError').innerText = result.message;
                        }
                    })
                    .catch(error => {
                        document.getElementById('lblError').innerText = 'Error loading aircrafts: ' + error.message;
                    });
            }

            // Update the displayed aircraft based on search, sort, and seller type
            function updateAircrafts() {
                const searchQuery = searchInput.value.trim().toLowerCase();
                const sortOption = sortDropdown.value;
                const sellerType = sellerTypeDropdown.value;

                // Filter aircraft based on search query and seller type
                let filteredAircraft = allAircraft.filter(aircraft => {
                    const matchesSearch = aircraft.AircraftModel.toLowerCase().includes(searchQuery) ||
                        aircraft.Manufacturer.toLowerCase().includes(searchQuery);
                    const matchesSellerType = !sellerType || aircraft.SellerType === sellerType;
                    return matchesSearch && matchesSellerType;
                });

                // Sort aircraft
                filteredAircraft.sort((a, b) => {
                    if (sortOption === 'YearDesc') {
                        return b.YearManufactured - a.YearManufactured;
                    } else if (sortOption === 'YearAsc') {
                        return a.YearManufactured - b.YearManufactured;
                    } else if (sortOption === 'CapacityDesc') {
                        return b.Capacity - a.Capacity;
                    } else if (sortOption === 'CapacityAsc') {
                        return a.Capacity - b.Capacity;
                    } else {
                        return a.AircraftModel.localeCompare(b.AircraftModel);
                    }
                });

                // Render all filtered aircraft
                const container = document.querySelector('#aircraftContainer');
                container.innerHTML = '';
                if (filteredAircraft.length === 0) {
                    container.innerHTML = '<p class="text-white text-center">No aircraft found matching your criteria.</p>';
                } else {
                    filteredAircraft.forEach(aircraft => {
                        const cardHtml = `
                            <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                                <div class="card shadow-lg border-0 aircraft-card position-relative">
                                    <span class="seller-badge position-absolute top-0 end-0 m-2 text-white">
                                        ${aircraft.SellerType}
                                    </span>
                                    <img src="${aircraft.ImageURL || 'https://via.placeholder.com/300x200.png?text=Aircraft'}" 
                                         class="card-img-top" 
                                         alt="${aircraft.AircraftModel}" />
                                    <div class="card-body">
                                        <h5 class="card-title text-white"><i class="fas fa-plane"></i> ${aircraft.AircraftModel}</h5>
                                        <p class="text-white">${aircraft.Description}</p>
                                        <p class="card-text text-white">
                                            <i class="fas fa-users"></i> <strong>Capacity:</strong> ${aircraft.Capacity} seats<br>
                                            <i class="fas fa-tachometer-alt"></i> <strong>Engine Hours:</strong> ${aircraft.EngineHours}<br>
                                            <i class="fas fa-gas-pump"></i> <strong>Fuel Type:</strong> ${aircraft.FuelType}<br>
                                            <i class="fas fa-tools"></i> <strong>Condition:</strong> ${aircraft.AircraftCondition}<br>
                                            <i class="fas fa-industry"></i> <strong>Manufacturer:</strong> ${aircraft.Manufacturer}<br>
                                            <i class="fas fa-calendar"></i> <strong>Year:</strong> ${aircraft.YearManufactured}
                                        </p>
                                        <a href="#" 
                                           class="btn btn-success w-100 book-btn text-white rent-or-buy-btn" 
                                           data-aircraftid="${aircraft.AircraftID}">
                                           <i class="fas fa-eye"></i> View Details
                                        </a>
                                    </div>
                                </div>
                            </div>`;
                        container.innerHTML += cardHtml;
                    });
                }

                // Re-attach event listeners for "View Details" buttons
                attachViewDetailsListeners();
            }

            function attachViewDetailsListeners() {
                document.querySelectorAll('.rent-or-buy-btn').forEach(function (btn) {
                    btn.addEventListener('click', function (e) {
                        e.preventDefault();
                        const aircraftId = btn.getAttribute('data-aircraftid');
                        if (window.isLoggedIn === "true") {
                            window.location.href = "PurchaseRentalSelect.aspx?AircraftID=" + aircraftId;
                        } else {
                            showLoginModal();
                            window.onLoginSuccess = function () {
                                window.location.href = "PurchaseRentalSelect.aspx?AircraftID=" + aircraftId;
                            };
                        }
                    });
                });
            }

            function debounce(func, wait) {
                let timeout;
                return function executedFunction(...args) {
                    const later = () => {
                        clearTimeout(timeout);
                        func(...args);
                    };
                    clearTimeout(timeout);
                    timeout = setTimeout(later, wait);
                };
            }

            const debouncedUpdate = debounce(updateAircrafts, 300);

            searchInput.addEventListener('input', debouncedUpdate);
            sortDropdown.addEventListener('change', updateAircrafts);
            sellerTypeDropdown.addEventListener('change', updateAircrafts);

            // Initial load
            fetchAircrafts();
        });

        function handleLoginSuccess() {
            window.isLoggedIn = "true";
            if (typeof window.onLoginSuccess === "function") {
                window.onLoginSuccess();
                window.onLoginSuccess = null;
            } else {
                window.location.reload();
            }
        }
    </script>

    <style>
        h2.text-center.text-white {
            color: white !important;
        }
        .form-control, .form-select {
            background: white !important;
            border: 1px solid rgba(0, 0, 0, 0.2);
            color: black !important;
            border-radius: 10px;
            padding: 10px;
            transition: all 0.3s ease-in-out;
        }

        .form-select {
            color: black !important;
        }

        .form-control::placeholder {
            color: black !important;
        }

        .form-control:focus, .form-select:focus {
            background: white !important;
            color: black !important;
            outline: none;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }

        .form-control:focus::placeholder {
            color: rgba(0, 0, 0, 0.5) !important;
        }

        body {
            background: url('/images/AircraftsBG.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        .aircraft-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
            height: 100%; /* Ensure all cards stretch to the same height */
            display: flex;
            flex-direction: column;
        }

        .aircraft-card:hover {
            transform: translateY(-5px);
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.3);
        }

        .card-img-top {
            width: 100%;
            height: 200px; /* Fixed height for all images */
            object-fit: cover; /* Ensures the image scales properly without distortion */
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }

        .card-body {
            flex-grow: 1; /* Allows the card body to take up remaining space */
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* Ensures buttons are at the bottom */
        }

        .seller-badge {
            background: linear-gradient(135deg, #1e90ff, #00ced1);
            color: white;
            font-size: 1rem;
            font-weight: bold;
            padding: 8px 16px;
            border-radius: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
            transform: rotate(5deg);
            z-index: 1;
            transition: transform 0.3s ease-in-out;
        }

        .seller-badge:hover {
            transform: rotate(0deg) scale(1.1);
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

        .book-btn {
            font-size: 18px;
            font-weight: bold;
            background: rgba(255, 255, 253, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            backdrop-filter: blur(10px);
            color: white !important;
            transition: 0.3s ease-in-out;
        }

        .book-btn:hover {
            background: rgba(255, 255, 255, 0.2) !important;
            transform: scale(1.05);
        }

        .card-title, .card-text {
            color: white !important;
            font-size: 1.1rem;
        }

        .card-text strong {
            font-weight: 600;
        }

        @media (max-width: 576px) {
            .card-body {
                padding: 10px;
            }
            .card-title {
                font-size: 1.2rem;
            }
            .card-text {
                font-size: 0.95rem;
            }
            .book-btn {
                font-size: 16px;
            }
            .seller-badge {
                font-size: 0.9rem;
                padding: 6px 12px;
            }
        }

        .input-group-text i {
            color: black;
        }

        .text-white {
            color: white !important;
        }

        .fw-bold {
            color: white !important;
        }
    </style>
</asp:Content>