<%@ Page Title="FAQ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="FAQ.aspx.cs" Inherits="AircraftManagement.FAQ" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="text-center">
            <h2 class="mb-3 text-white">Frequently Asked Questions <i class="bi bi-patch-question-fill"></i></h2>
            <p class="text-white">Find answers to common questions about renting, buying, selling, and more.</p>
            <input type="text" id="faqSearch" class="form-control w-50 mx-auto mt-3 text-white" placeholder="Search for an answer..."/>
        </div>

        <div class="accordion mt-4" id="faqAccordion">

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button fw-bold text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCategoryRentBuy">
                        <i class="fas fa-plane me-2"></i> Renting & Buying Aircraft
                    </button>
                </h2>
                <div id="collapseCategoryRentBuy" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseRent">
                                    <i class="fas fa-calendar-alt"></i> Can I rent an aircraft for long-term use?
                                </button>
                            </h2>
                            <div id="collapseRent" class="accordion-collapse collapse" data-bs-parent="#collapseCategoryRentBuy">
                                <div class="accordion-body">
                                    Yes, we offer flexible rental options. <a href="PurchaseRental.aspx" class="text-primary fw-bold">Click here</a> to view available rentals.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePurchase">
                                    <i class="fas fa-shopping-cart"></i> How do I purchase an aircraft?
                                </button>
                            </h2>
                            <div id="collapsePurchase" class="accordion-collapse collapse" data-bs-parent="#collapseCategoryRentBuy">
                                <div class="accordion-body">
                                    Browse our aircraft, select the one you want, and proceed to checkout. Need financing? <a href="Financing.aspx" class="text-primary fw-bold">Click here</a>.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button fw-bold text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCategorySell">
                        <i class="fas fa-handshake"></i> Selling Aircraft
                    </button>
                </h2>
                <div id="collapseCategorySell" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSell">
                                    <i class="fas fa-store"></i> How can I sell my aircraft?
                                </button>
                            </h2>
                            <div id="collapseSell" class="accordion-collapse collapse" data-bs-parent="#collapseCategorySell">
                                <div class="accordion-body">
                                    Visit the <a href="SellAircraft.aspx" class="text-primary fw-bold">Sell Aircraft</a> page, complete the form, and submit your listing.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button fw-bold text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePayment">
                        <i class="fas fa-credit-card"></i> Payment & Transactions
                    </button>
                </h2>
                <div id="collapsePayment" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        <p class="text-white"><b>What payment methods are accepted?</b></p>
                        <p class="text-white">We accept credit cards, wire transfers, and crypto payments.</p>

                        <p class="text-white"><b>Is my payment secure?</b></p>
                        <p class="text-white">Yes, all transactions are secured using industry-standard encryption.</p>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button fw-bold text-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCategorySupport">
                        <i class="fas fa-headset"></i> Support & Contact
                    </button>
                </h2>
                <div id="collapseCategorySupport" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        <p class="text-white"><b>How can I contact support?</b></p>
                        <p class="text-white">Email: <a href="mailto:support@aircraftmanagement.com" class="text-primary fw-bold">support@aircraftmanagement.com</a></p>
                        <p class="text-white">Phone: <b>+1 234 567 890</b></p>
                        <p class="text-white">Or visit our <a href="Contact.aspx" class="text-primary fw-bold">Contact Page</a></p>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <style>
body {
    background: url('/images/FAQBG.jpg') no-repeat center center fixed;
    background-size: cover;
    backdrop-filter: blur(3px);
}

.accordion-item, .accordion-button, .accordion-body {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    margin-bottom: 1rem;
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
    color: white; /* Set text color to white */
}

.accordion-button:not(.collapsed) {
    color: white; /* Set text color to white */
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
}

.accordion-item:hover, .accordion-button:hover {
    transform: translateY(-5px);
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.3);
}

.btn-primary, .btn-success, .btn-warning, .btn-danger, .btn-info, .btn-dark {
    background: rgba(255, 255, 255, 0.1) !important;
    border: 1px solid rgba(255, 255, 255, 0.2) !important;
    backdrop-filter: blur(10px);
    color: white !important; /* Set text color to white */
}

.btn-primary:hover, .btn-success:hover, .btn-warning:hover, .btn-danger:hover, .btn-info:hover, .btn-dark:hover {
    background: rgba(255, 255, 255, 0.2) !important;
}

.form-control, .form-select {
    border-radius: 10px;
    color: white !important; /* Set text color to white */
    backdrop-filter: blur(10px);
}

#faqSearch {
    background: rgba(255, 255, 255, 0.1); /* Semi-transparent background */
    backdrop-filter: blur(10px); /* Apply blur effect */
    border: 1px solid rgba(255, 255, 255, 0.2); /* Add a subtle border */
    color: white; /* Set text color to white when unselected */
    border-radius: 10px; /* Rounded corners */
    padding: 10px; /* Add padding for better appearance */
    transition: all 0.3s ease-in-out; /* Smooth transition for hover and focus effects */
}

#faqSearch::placeholder {
    color: rgba(255, 255, 255, 0.5); /* Placeholder text color set to a lighter white */
}

#faqSearch:focus {
    background: white; /* Change background to white on focus */
    color: black; /* Change text color to black when focused */
    outline: none; /* Remove default focus outline */
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2); /* Add a subtle shadow effect */
}

#faqSearch:focus::placeholder {
    color: rgba(0, 0, 0, 0.5); /* Keep placeholder text color lighter black on focus */
}

    </style>

    <script>
        document.getElementById("faqSearch").addEventListener("input", function () {
            let filter = this.value.toLowerCase();
            document.querySelectorAll(".accordion-item").forEach(item => {
                let question = item.textContent.toLowerCase();
                item.style.display = question.includes(filter) ? "block" : "none";
            });
        });
    </script>
</asp:Content>
