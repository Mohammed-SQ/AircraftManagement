<%@ Page Title="FAQ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="FAQ.aspx.cs" Inherits="AircraftManagement.FAQ" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="text-center">
            <h2 class="mb-3"><i class="fas fa-question-circle"></i> Frequently Asked Questions</h2>
            <p class="text-muted">Find answers to common questions about renting, buying, selling, and more.</p>
            <input type="text" id="faqSearch" class="form-control w-50 mx-auto mt-3" placeholder="🔍 Search for an answer..."/>
        </div>

        <div class="accordion mt-4" id="faqAccordion">

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button fw-bold text-dark bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCategoryRentBuy">
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
                    <button class="accordion-button fw-bold text-dark bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCategorySell">
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
                    <button class="accordion-button fw-bold text-dark bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePayment">
                        <i class="fas fa-credit-card"></i> Payment & Transactions
                    </button>
                </h2>
                <div id="collapsePayment" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        <p><b>What payment methods are accepted?</b></p>
                        <p>We accept credit cards, wire transfers, and crypto payments.</p>

                        <p><b>Is my payment secure?</b></p>
                        <p>Yes, all transactions are secured using industry-standard encryption.</p>
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header">
                    <button class="accordion-button fw-bold text-dark bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCategorySupport">
                        <i class="fas fa-headset"></i> Support & Contact
                    </button>
                </h2>
                <div id="collapseCategorySupport" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        <p><b>How can I contact support?</b></p>
                        <p>Email: <a href="mailto:support@aircraftmanagement.com" class="text-primary fw-bold">support@aircraftmanagement.com</a></p>
                        <p>Phone: <b>+1 234 567 890</b></p>
                        <p>Or visit our <a href="Contact.aspx" class="text-primary fw-bold">Contact Page</a></p>
                    </div>
                </div>
            </div>

        </div>
    </div>

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
