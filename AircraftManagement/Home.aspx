<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="AircraftManagement.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    body {
        margin: 0;
        padding: 0;
        background: url('images/HomeBG2.jpg') no-repeat center center fixed !important;
        background-size: cover !important;
        color: white; /* Set default text color to white */
    }

    .container, .mt-5, .text-center {
        background: transparent !important;
    }

    .hero-section {
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        position: relative;
        margin-top: -80px;
    }

    .hero-overlay {
        background: rgba(0, 0, 0, 0);
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 0 10%;
        position: absolute;
        top: 0;
        left: 0;
    }

    .card {
        background: rgba(255, 255, 255, 0.1) !important;
        backdrop-filter: blur(10px);
        transition: transform 0.3s ease-in-out;
        color: white; /* Set text color to white */
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0px 6px 15px rgba(0, 0, 0, 0.2);
    }

    .rating-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        color: gold;
        font-size: 18px;
        font-weight: bold;
        padding: 8px 12px;
        border-radius: 20px;
        transform: scale(0);
        opacity: 0;
        transition: transform 0.5s ease, opacity 0.5s ease;
        background: rgba(0, 0, 0, 0.5);
        backdrop-filter: blur(5px);
    }

    .card:hover .rating-badge {
        transform: scale(1.2);
        opacity: 1;
    }

    .review-carousel {
        overflow: hidden;
        width: 100%;
        display: flex;
        justify-content: center;
        position: relative;
        margin-top: 30px;
    }

    .review-wrapper {
        display: flex;
        transition: transform 0.6s ease-in-out;
        width: 300%;
    }

    .review-card {
        background: rgba(255, 255, 255, 0.1) !important;
        color: white; /* Set text color to white */
        padding: 20px;
        border-radius: 10px;
        text-align: center;
        box-shadow: 0px 6px 15px rgba(0, 0, 0, 0.2);
        min-width: 100%;
        transform: scale(0.9);
        opacity: 0.7;
        transition: all 0.5s ease-in-out;
    }

    .review-card.active {
        transform: scale(1);
        opacity: 1;
    }

    .review-avatar {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        border: 2px solid white; /* Change border color to white */
    }

    .review-stars {
        font-size: 20px;
        color: gold;
    }

    .animated {
        opacity: 0;
        transform: translateY(30px);
        animation-fill-mode: forwards;
    }

    .fadeInUp {
        animation: fadeInUp 1s ease-in-out forwards;
    }

    .delay-1s { animation-delay: 1s; }
    .delay-2s { animation-delay: 2s; }
    .delay-3s { animation-delay: 3s; }

    @keyframes fadeInUp {
        0% { opacity: 0; transform: translateY(30px); }
        100% { opacity: 1; transform: translateY(0); }
    }

    .btn-primary {
        background: rgba(255, 255, 255, 0.1) !important;
        border: 1px solid rgba(255, 255, 255, 0.2) !important;
        backdrop-filter: blur(10px);
        color: white !important;
    }

    .btn-primary:hover {
        background: rgba(255, 255, 255, 0.2) !important;
        transform: translateY(-2px);
    }

    .btn-outline-primary {
        border: 2px solid rgba(255, 255, 255, 0.2) !important;
        color: white !important;
        backdrop-filter: blur(10px);
    }

    .btn-outline-primary:hover {
        background: rgba(255, 255, 255, 0.1) !important;
        color: white !important;
    }

.location-map-container {
    position: relative;
    width: auto; /* Reduced width to make it smaller */
    height: 300px; /* Reduced height to make it smaller */
    margin: 0 auto; /* Center the container horizontally */
    cursor: pointer; /* Looks clickable */
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); /* Add shadow behind the container */
    border-radius: 10px; /* Optional: Add rounded corners for a smoother look */
    overflow: hidden; /* Ensure the shadow doesn't affect the iframe */
    padding-bottom: 40px;
    padding-left: 40px;
    padding-right: 40px;
}

.location-map {
    width: 100%;
    height: 100%;
    border: none;
    pointer-events: none; /* Disables iframe interaction */
    border-radius: 10px; /* Match the container's rounded corners */
}


.col-md-3.animated.fadeInUp.delay-3s i {
    font-size: 3em; /* Set the font size to 4em */
}

</style>

<section class="hero-section">
    <div class="hero-overlay">
        <h1 class="display-1 fw-bold text-white animated fadeInUp">Experience The Magic of Flight!</h1>
        <p class="lead text-white fs-3 animated fadeInUp delay-1s">Luxury, Private, & Commercial Aircraft Rentals</p>
<a href="#" class="btn btn-primary btn-lg mt-3 animated fadeInUp delay-2s" onclick="handleProtectedAction('PurchaseRental.aspx')">
    <i class="fas fa-plane"></i> Rent a Plane Now
</a>

    </div>
</section>

<section class="container mt-5 text-center">
    <h2 class="fw-bold text-white">Most Rated Aircraft</h2>
    <div class="row mt-3">
        <div class="col-md-4">
            <div class="card shadow-lg rating-card animated fadeInUp">
                <div class="rating-badge pop-out">★ 4.9</div>
                <img src="images/plane4.jpg" class="card-img-top" alt="Boeing 737"/>
                <div class="card-body">
                    <h5 class="card-title">Boeing 737</h5>
                    <p class="card-text">Capacity: 150 | Rental Price: <img src="Symbols/Saudi_Riyal_Symbol-white.ico" alt="SAR" style="height: 16px; width: 16px;"/> 5,000/day</p>
                    <a href="#" 
                      class="btn btn-primary w-100 book-btn-home" 
                      data-aircraftid="5">
                      Book Now
                     </a>

                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-lg rating-card animated fadeInUp delay-1s">
                <div class="rating-badge pop-out">★ 4.4</div>
                <img src="images/plane5.jpg" class="card-img-top" alt="Airbus A320"/>
                <div class="card-body">
                    <h5 class="card-title">Airbus A320</h5>
                    <p class="card-text">Capacity: 180 | Rental Price: <img src="Symbols/Saudi_Riyal_Symbol-white.ico" alt="SAR" style="height: 16px; width: 16px;"/> 5,500/day</p>
                    <a href="#" 
                      class="btn btn-primary w-100 book-btn-home" 
                      data-aircraftid="6">
                      Book Now
                     </a>        
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-lg rating-card animated fadeInUp delay-2s">
                <div class="rating-badge pop-out">★ 4.0</div>
                <img src="images/plane3.jpg" class="card-img-top" alt="Cessna 172"/>
                <div class="card-body">
                    <h5 class="card-title">Cessna 172</h5>
                    <p class="card-text">Capacity: 4 | Rental Price: <img src="Symbols/Saudi_Riyal_Symbol-white.ico" alt="SAR" style="height: 16px; width: 16px;"/> 300/day</p>
                    <a href="#" 
                      class="btn btn-primary w-100 book-btn-home" 
                      data-aircraftid="7">
                      Book Now
                     </a>    
                </div>
            </div>
        </div>
    </div>

    <div class="show-more-container mt-4">
        <a href="Aircrafts.aspx" class="btn btn-outline-primary btn-lg shadow-sm">
            <i class="fas fa-plane"></i> Explore More Aircraft
        </a>
    </div>
</section>

<section class="mt-5 text-center">
    <h2 class="fw-bold text-white">Why Choose Us?</h2>
    <div class="row mt-4">
        <div class="col-md-3 animated fadeInUp">
            <i class="fas fa-plane fa-3x text-white"></i>
            <h4 class="mt-2 text-white">Premium Aircraft Selection</h4>
            <p class="text-white">Choose from a wide variety of private, commercial, and luxury aircraft.</p>
        </div>
        <div class="col-md-3 animated fadeInUp delay-1s">
            <i class="fas fa-credit-card fa-3x text-white"></i>
            <h4 class="mt-2 text-white">Flexible Payment Options</h4>
            <p class="text-white">We offer competitive pricing with multiple payment methods.</p>
        </div>
        <div class="col-md-3 animated fadeInUp delay-2s">
            <i class="fas fa-headset fa-3x text-white"></i>
            <h4 class="mt-2 text-white">24/7 Customer Support</h4>
            <p class="text-white">Our team is available round the clock to assist you with your booking theeds.</p>
        </div>
        <div class="col-md-3 animated fadeInUp delay-3s">
            <i class="fas fa-check-circle fa-5x text-white"></i>
            <h4 class="mt-2 text-white">Ready to Fly?</h4>
            <p class="text-white">Rent or purchase your next aircraft today with ease.</p>
        </div>
    </div>
</section>

<section class="mt-5 text-center">
    <h2 class="fw-bold text-white">What Our Customers Say</h2>
    <div class="container">
        <div class="review-carousel">
            <div class="review-wrapper" id="reviewWrapper">
                <div class="review-card">
                    <img src="images/Customer.png" class="review-avatar" alt="User"/>
                    <h4>John Doe</h4>
                    <div class="review-stars">★★★★★</div>
                    <p>Amazing experience! The aircraft was in perfect condition.</p>
                </div>
                <div class="review-card">
                    <img src="images/Customer.png" class="review-avatar" alt="User"/>
                    <h4>Jane Smith</h4>
                    <div class="review-stars">★★★★☆</div>
                    <p>Great service and quick booking process.</p>
                </div>
                <div class="review-card">
                    <img src="images/Customer.png" class="review-avatar" alt="User"/>
                    <h4>Michael Johnson</h4>
                    <div class="review-stars">★★★★★</div>
                    <p>Highly recommended! Best rental experience.</p>
                </div>
                <div class="review-card">
                    <img src="images/Customer.png" class="review-avatar" alt="User"/>
                    <h4>Saudi Customer</h4>
                    <div class="review-stars">★★★★★</div>
                    <p>Excellent service near Dammam Community College - KFUPM<br>
                    <small>Location: <a href="https://maps.app.goo.gl/R6jAA88VioWVbfW27" target="_blank" style="color: gold;">26.3953027, 50.1212234</a></small></p>
                </div>
            </div>
        </div>
    </div>
</section>


<section class="mt-5 text-center location-section">
    <h2 class="fw-bold text-white">Where Are We?</h2> 
    
    <div class="mt-4 location-map-container" onclick="window.open('https://maps.app.goo.gl/R6jAA88VioWVbfW27', '_blank')">
        <iframe 
            class="location-map animated fadeInUp"
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3578.3126274221355!2d50.11864887611545!3d26.395302888556963!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3e49e4b61bfff93f%3A0x5bbfdcf8e0cd960f!2sDammam%20Community%20College%20-%20King%20Fahd%20University%20of%20Petroleum%20and%20Minerals!5e0!3m2!1sen!2sus!4v1698771234567!5m2!1sen!2sus"
            allowfullscreen="" 
            loading="lazy" 
            referrerpolicy="no-referrer-when-downgrade">
        </iframe>
    </div>
</section>


    <script>
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.book-btn-home').forEach(function (btn) {
                btn.addEventListener('click', function (e) {
                    e.preventDefault();
                    const aircraftId = btn.getAttribute('data-aircraftid');

                    if (window.isLoggedIn === "true") {
                        // ✅ Logged in → redirect to rental
                        window.location.href = "PurchaseRentalSelect.aspx?AircraftID=" + aircraftId;
                    } else {
                        // ❌ Not logged in → open login modal
                        showLoginModal();
                    }
                });
            });
        });
        function handleProtectedAction(url) {
            if (window.isLoggedIn === "true") {
                // User is logged in, go to the page
                window.location.href = url;
            } else {
                // User is not logged in, show login modal
                showLoginModal();
            }
        }
    let currentIndex = 0;
    function showReview(index) {
        const reviewWrapper = document.getElementById("reviewWrapper");
        const totalReviews = document.querySelectorAll(".review-card").length;
        if (index >= totalReviews) currentIndex = 0;
        else currentIndex = index;

        let offset = -currentIndex * 100;
        reviewWrapper.style.transform = `translateX(${offset}%)`;
    }
    setInterval(() => { showReview(currentIndex + 1); }, 4000);
    </script>

</asp:Content>