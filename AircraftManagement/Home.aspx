<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="AircraftManagement.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<section class="hero-section">
       <img src="images/plane1.jpeg" class="card-img-top" alt="Boeing 737"/>

    <div class="hero-overlay">
        <h1 class="display-1 fw-bold text-white animated fadeInUp">Experience The Magic of Flight!</h1>
        <p class="lead text-white fs-3 animated fadeInUp delay-1s">Luxury, Private, & Commercial Aircraft Rentals</p>
        <a href="PurchaseRental.aspx" class="btn btn-primary btn-lg mt-3 animated fadeInUp delay-2s">
            <i class="fas fa-plane"></i> Rent a Plane Now
        </a>
    </div>
</section>

<section class="container mt-5 text-center">
    <h2 class="fw-bold">Most Rated Aircraft</h2>
    <div class="row mt-3">
        <div class="col-md-4">
            <div class="card shadow-lg rating-card animated fadeInUp">
                <div class="rating-badge pop-out">★ 4.9</div>
                <img src="images/plane4.jpg" class="card-img-top" alt="Boeing 737"/>
                <div class="card-body">
                    <h5 class="card-title">Boeing 737</h5>
                    <p class="card-text">Capacity: 150 | Rental Price: $5,000/day</p>
                    <a href="PurchaseRental.aspx?AircraftID=1" class="btn btn-primary w-100">Book Now</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-lg rating-card animated fadeInUp delay-1s">
                <div class="rating-badge pop-out">★ 4.4</div>
                <img src="images/plane2.jpg" class="card-img-top" alt="Airbus A320"/>
                <div class="card-body">
                    <h5 class="card-title">Airbus A320</h5>
                    <p class="card-text">Capacity: 180 | Rental Price: $5,500/day</p>
                    <a href="PurchaseRental.aspx?AircraftID=2" class="btn btn-primary w-100">Book Now</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card shadow-lg rating-card animated fadeInUp delay-2s">
                <div class="rating-badge pop-out">★ 4.0</div>
                <img src="images/plane3.jpg" class="card-img-top" alt="Cessna 172"/>
                <div class="card-body">
                    <h5 class="card-title">Cessna 172</h5>
                    <p class="card-text">Capacity: 4 | Rental Price: $300/day</p>
                    <a href="PurchaseRental.aspx?AircraftID=3" class="btn btn-primary w-100">Book Now</a>
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

<section class="mt-5 text-center"/>
    <h2 class="fw-bold">Why Choose Us?</h2>
    <div class="row mt-4">
        <div class="col-md-3 animated fadeInUp">
            <i class="fas fa-plane fa-3x text-primary"></i>
            <h4 class="mt-2">Premium Aircraft Selection</h4>
            <p>Choose from a wide variety of private, commercial, and luxury aircraft.</p>
        </div>
        <div class="col-md-3 animated fadeInUp delay-1s">
            <i class="fas fa-credit-card fa-3x text-primary"></i>
            <h4 class="mt-2">Flexible Payment Options</h4>
            <p>We offer competitive pricing with multiple payment methods.</p>
        </div>
        <div class="col-md-3 animated fadeInUp delay-2s">
            <i class="fas fa-headset fa-3x text-primary"></i>
            <h4 class="mt-2">24/7 Customer Support</h4>
            <p>Our team is available round the clock to assist you with your booking needs.</p>
        </div>
        <div class="col-md-3 animated fadeInUp delay-3s">
            <i class="fas fa-check-circle fa-3x text-primary"></i>
            <h4 class="mt-2">Ready to Fly?</h4>
            <p>Rent or purchase your next aircraft today with ease.</p>
        </div>
    </div>
<section class="mt-5 text-center">
    <h2 class="fw-bold">What Our Customers Say</h2>
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
            </div>
        </div>
    </div>
</section>

<style>
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
        background: white;
        color: black;
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
    }

    .review-stars {
        font-size: 20px;
        color: gold;
    }
    .hero-section {
        background: url('images/plane1.jpg') no-repeat center center;
        background-size: cover;
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        position: relative;
    }

    .hero-overlay {
        background: rgba(0, 0, 0, 0.5);
        width: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 0 10%;
    }

    .rating-card {
        position: relative;
        transition: transform 0.3s ease-in-out;
    }

    .rating-card:hover {
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
    }

    .rating-card:hover .rating-badge {
        transform: scale(1.2);
        opacity: 1;
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
</style>

<script>
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
