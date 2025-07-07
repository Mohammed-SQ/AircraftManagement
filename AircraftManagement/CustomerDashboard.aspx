<%@ Page Title="Customer Dashboard" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CustomerDashboard.aspx.cs" Inherits="AircraftManagement.CustomerDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

        <link href="css/CustomerDashboard.css" rel="stylesheet" />

    <div class="dashboard-container">
        <h2 class="text-center mb-5">My Flights Dashboard</h2>

        <!-- Invitations Section (For Invited Users) -->
        <div class="invitations-section">
            <h3>My Invitations</h3>
            <div class="enter-code-container">
                <asp:Button ID="btnEnterCode" runat="server" CssClass="btn btn-primary btn-action" Text="Enter Code" OnClientClick="openCodeModal(); return false;" />
            </div>
            <asp:Repeater ID="rptInvitations" runat="server" OnItemCommand="rptInvitations_ItemCommand">
                <ItemTemplate>
                    <div class="invitation-card">
                        <h5>Invitation for Flight #<%# Eval("BookingID") %></h5>
                        <p><strong>Aircraft:</strong> <%# Eval("AircraftModel") %></p>
                        <p><strong>Start Date:</strong> <%# Eval("StartDate", "{0:MMM dd, yyyy HH:mm}") %></p>
                        <p><strong>Status:</strong> <%# Eval("Status") %></p>
                        <asp:Button ID="btnAccept" runat="server" CommandName="AcceptInvite" CommandArgument='<%# Eval("InvitationID") %>' CssClass="btn btn-success btn-action" Text="Accept Invitation" Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                        <asp:Button ID="btnDecline" runat="server" CommandName="DeclineInvite" CommandArgument='<%# Eval("InvitationID") %>' CssClass="btn btn-danger btn-action" Text="Decline Invitation" Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                        <!-- Show Flight Details if Accepted -->
                        <div class="flight-details" id="flightDetails_<%# Eval("InvitationID") %>" style='<%# Eval("Status").ToString() == "Accepted" ? "display: block;" : "display: none;" %>'>
                            <h6>Flight Details</h6>
                            <p><strong>Aircraft Model:</strong> <%# Eval("AircraftModel") %></p>
                            <p><strong>Manufacturer:</strong> <%# Eval("Manufacturer") %></p>
                            <p><strong>Start Date:</strong> <%# Eval("StartDate", "{0:MMM dd, yyyy HH:mm}") %></p>
                            <p><strong>End Date:</strong> <%# Eval("EndDate", "{0:MMM dd, yyyy HH:mm}") %></p>
                            <p><strong>Total Amount:</strong> <%# Eval("TotalAmount", "{0:C}") %></p>
                            <p><strong>Extras:</strong>
                                Meals: <%# Convert.ToBoolean(Eval("chkMeals")) ? "Yes" : "No" %>,
                                WiFi: <%# Convert.ToBoolean(Eval("chkWIFI")) ? "Yes" : "No" %>,
                                Catering: <%# Convert.ToBoolean(Eval("chkCatering")) ? "Yes" : "No" %>
                            </p>
                            <p><strong>Seller Email:</strong> <%# Eval("SellerEmail") %></p>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Label ID="lblNoInvitations" runat="server" Text="You have no pending invitations." Visible="false" CssClass="text-center d-block" />
        </div>

        <!-- My Bookings Section -->
        <asp:Repeater ID="rptBookings" runat="server" OnItemCommand="rptBookings_ItemCommand">
            <ItemTemplate>
                <div class="booking-card accordion" id="accordion_<%# Eval("BookingID") %>">
                    <div class="booking-header" data-bs-toggle="collapse" data-bs-target="#collapse_<%# Eval("BookingID") %>" aria-expanded="true" aria-controls="collapse_<%# Eval("BookingID") %>">
                        <h4>Flight Booking #<%# Eval("BookingID") %> - <%# Eval("AircraftModel") %></h4>
                        <span class="flight-status">Status: <span class="status-text"><%# Eval("BookingStatus") %></span></span>
                    </div>
                    <div id="collapse_<%# Eval("BookingID") %>" class="collapse show" aria-labelledby="heading_<%# Eval("BookingID") %>" data-bs-parent="#accordion_<%# Eval("BookingID") %>">
                        <div class="booking-body">
                            <!-- Aircraft Image -->
                            <img src='<%# Eval("ImageURL") ?? "/images/default-aircraft.jpg" %>' alt="Aircraft Image" class="aircraft-image" />

                            <!-- Flight Details -->
                            <div class="row">
                                <div class="col-md-6">
                                    <h5>Flight Details</h5>
                                    <p><strong>Aircraft Model:</strong> <%# Eval("AircraftModel") %></p>
                                    <p><strong>Manufacturer:</strong> <%# Eval("Manufacturer") %></p>
                                    <p><strong>Start Date:</strong> <%# Eval("StartDate", "{0:MMM dd, yyyy HH:mm}") %></p>
                                    <p><strong>End Date:</strong> <%# Eval("EndDate", "{0:MMM dd, yyyy HH:mm}") %></p>
                                    <p><strong>Total Amount:</strong> <%# Eval("TotalAmount", "{0:C}") %></p>
                                    <p><strong>Extras:</strong>
                                        Meals: <%# Convert.ToBoolean(Eval("chkMeals")) ? "Yes" : "No" %>,
                                        WiFi: <%# Convert.ToBoolean(Eval("chkWIFI")) ? "Yes" : "No" %>,
                                        Catering: <%# Convert.ToBoolean(Eval("chkCatering")) ? "Yes" : "No" %>
                                    </p>
                                    <p><strong>Seller Email:</strong> <%# Eval("SellerEmail") %></p>
                                </div>
                                <div class="col-md-6">
                                    <!-- Countdown Timer -->
                                    <div class="countdown-timer" data-start='<%# Eval("StartDate") %>' data-end='<%# Eval("EndDate") %>'>
                                        <i class="fas fa-clock"></i> Time to Flight: <span class="time-left"></span>
                                    </div>
                                    <!-- Flight Progress -->
                                    <div class="progress-bar-container">
                                        <label>Flight Progress:</label>
                                        <div class="progress invite-progress">
                                            <div class="progress-bar bg-success" role="progressbar" style="width: <%# CalculateProgress(Eval("StartDate"), Eval("EndDate")) %>%" aria-valuenow="<%# CalculateProgress(Eval("StartDate"), Eval("EndDate")) %>" aria-valuemin="0" aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                    <!-- Weather Forecast -->
                                    <div class="weather-info">
                                        <i class="fas fa-cloud-sun"></i>
                                        <p><strong>Weather Forecast for Flight Date:</strong> <span class="weather-text">Sunny, 28°C, 10% chance of rain</span></p>
                                    </div>
                                    <!-- Live Flight Status -->
                                    <div class="live-status">
                                        <p><strong>Live Flight Status:</strong> <span class="live-status-text">On Time</span></p>
                                    </div>
                                </div>
                            </div>

                            <!-- Google Map -->
                            <h5>Flight Route</h5>
                            <div class="map-container" id="map_<%# Eval("BookingID") %>" data-lat="24.7136" data-lng="46.6753"></div>

                            <!-- Invited People -->
                            <div class="invited-people">
                                <h5>Invited People</h5>
                                <div class="invite-counter">
                                    <asp:Literal ID="litInviteCounter" runat="server" />
                                </div>
                                <div class="invite-progress">
                                    <div class="progress">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: <%# CalculateInviteProgress(Eval("BookingID")) %>%" aria-valuenow="<%# CalculateInviteProgress(Eval("BookingID")) %>" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                </div>
                                <asp:Repeater ID="rptInvitedPeople" runat="server">
                                    <ItemTemplate>
                                        <div class="invited-user">
                                            <img src='<%# Eval("ProfilePicture") ?? "/images/default-profile.jpg" %>' alt="Profile Picture" />
                                            <span><%# Eval("Username") ?? Eval("InvitedEmail") %> (Status: <%# Eval("Status") %>)</span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <button type="button" class="btn btn-primary btn-action" data-bs-toggle="modal" data-bs-target="#inviteModal_<%# Eval("BookingID") %>">
                                    Invite People
                                </button>
                            </div>

                            <!-- Flight Options -->
                            <div class="flight-options">
                                <h5>Flight Options</h5>
                                <asp:Button ID="btnCancel" runat="server" CommandName="CancelBooking" CommandArgument='<%# Eval("BookingID") %>' CssClass="btn btn-danger btn-action" Text="Cancel Booking" OnClientClick="return confirm('Are you sure you want to cancel this booking?');" />
                                <button type="button" class="btn btn-info btn-action" data-bs-toggle="modal" data-bs-target="#extrasModal_<%# Eval("BookingID") %>">
                                    Request Extras
                                </button>
                                <button type="button" class="btn btn-warning btn-action" data-bs-toggle="modal" data-bs-target="#reminderModal_<%# Eval("BookingID") %>">
                                    Set Reminder
                                </button>
                                <!-- Moved Chat with Seller Here and Redirect to Chats.aspx -->
                                <asp:Button ID="btnChatWithSeller" runat="server" CommandName="ChatWithSeller" CommandArgument='<%# Eval("BookingID") %>' CssClass="btn btn-primary btn-action" Text="Chat with Seller" />
                                <button type="button" class="btn btn-secondary btn-action" onclick="downloadItinerary(<%# Eval("BookingID") %>)">
                                    Download Itinerary
                                </button>
                                <button type="button" class="btn btn-success btn-action" onclick="shareFlight(<%# Eval("BookingID") %>)">
                                    Share Flight
                                </button>
                                <button type="button" class="btn btn-primary btn-action" data-bs-toggle="modal" data-bs-target="#itineraryModal_<%# Eval("BookingID") %>">
                                    Preview Itinerary
                                </button>
                                <%# Convert.ToDateTime(Eval("EndDate")) < DateTime.Now ? "<button type='button' class='btn btn-primary btn-action' onclick='showRating(" + Eval("BookingID") + ")'>Rate Flight</button>" : "" %>
                            </div>

                            <!-- Rating Section (Hidden by Default) -->
                            <div class="rating-section" id="rating_<%# Eval("BookingID") %>" style="display: none;">
                                <h5>Rate Your Flight</h5>
                                <div class="rating-stars" id="stars_<%# Eval("BookingID") %>">
                                    <i class="fas fa-star" data-value="1"></i>
                                    <i class="fas fa-star" data-value="2"></i>
                                    <i class="fas fa-star" data-value="3"></i>
                                    <i class="fas fa-star" data-value="4"></i>
                                    <i class="fas fa-star" data-value="5"></i>
                                </div>
                                <asp:Button ID="btnRate" runat="server" CommandName="RateFlight" CommandArgument='<%# Eval("BookingID") %>' CssClass="btn btn-primary btn-action" Text="Submit Rating" />
                                <asp:HiddenField ID="hdnRating" runat="server" Value="0" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Invite People Modal -->
                <div class="modal fade" id="inviteModal_<%# Eval("BookingID") %>" tabindex="-1" aria-labelledby="inviteModalLabel_<%# Eval("BookingID") %>" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="inviteModalLabel_<%# Eval("BookingID") %>">Invite People to Flight #<%# Eval("BookingID") %></h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <asp:HiddenField ID="hdnBookingID" runat="server" Value='<%# Eval("BookingID") %>' />
                                <div class="mb-3">
                                    <label for="ddlUsers_<%# Eval("BookingID") %>" class="form-label">Select Registered User (Optional)</label>
                                    <asp:DropDownList ID="ddlUsers" runat="server" CssClass="form-select" AppendDataBoundItems="true">
                                        <asp:ListItem Text="-- Select User --" Value="" />
                                    </asp:DropDownList>
                                </div>
                                <div class="mb-3">
                                    <label for="txtEmail_<%# Eval("BookingID") %>" class="form-label">Or Enter Email</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter email address" />
                                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" 
                                        ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Invalid email format" 
                                        CssClass="text-danger" Display="Dynamic" />
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary btn-action" data-bs-dismiss="modal">Close</button>
                                <asp:Button ID="btnInvite" runat="server" CommandName="InvitePerson" CommandArgument='<%# Eval("BookingID") %>' CssClass="btn btn-primary btn-action" Text="Send Invitation" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Request Extras Modal -->
                <div class="modal fade" id="extrasModal_<%# Eval("BookingID") %>" tabindex="-1" aria-labelledby="extrasModalLabel_<%# Eval("BookingID") %>" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="extrasModalLabel_<%# Eval("BookingID") %>">Request Extras for Flight #<%# Eval("BookingID") %></h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <asp:HiddenField ID="hdnExtrasBookingID" runat="server" Value='<%# Eval("BookingID") %>' />
                                <div class="form-check">
                                    <asp:CheckBox ID="chkMeals" runat="server" CssClass="form-check-input" />
                                    <label class="form-check-label" for="chkMeals">Meals (+$50)</label>
                                </div>
                                <div class="form-check">
                                    <asp:CheckBox ID="chkWIFI" runat="server" CssClass="form-check-input" />
                                    <label class="form-check-label" for="chkWIFI">WiFi (+$20)</label>
                                </div>
                                <div class="form-check">
                                    <asp:CheckBox ID="chkCatering" runat="server" CssClass="form-check-input" />
                                    <label class="form-check-label" for="chkCatering">Catering (+$100)</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary btn-action" data-bs-dismiss="modal">Close</button>
                                <asp:Button ID="btnUpdateExtras" runat="server" CommandName="UpdateExtras" CommandArgument='<%# Eval("BookingID") %>' CssClass="btn btn-primary btn-action" Text="Update Extras" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Set Reminder Modal -->
                <div class="modal fade" id="reminderModal_<%# Eval("BookingID") %>" tabindex="-1" aria-labelledby="reminderModalLabel_<%# Eval("BookingID") %>" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="reminderModalLabel_<%# Eval("BookingID") %>">Set Reminder for Flight #<%# Eval("BookingID") %></h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <asp:HiddenField ID="hdnReminderBookingID" runat="server" Value='<%# Eval("BookingID") %>' />
                                <div class="mb-3">
                                    <label for="ddlReminder_<%# Eval("BookingID") %>" class="form-label">Remind Me</label>
                                    <asp:DropDownList ID="ddlReminder" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="1 Day Before" Value="1" />
                                        <asp:ListItem Text="12 Hours Before" Value="12" />
                                        <asp:ListItem Text="1 Hour Before" Value="1h" />
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary btn-action" data-bs-dismiss="modal">Close</button>
                                <asp:Button ID="btnSetReminder" runat="server" CommandName="SetReminder" CommandArgument='<%# Eval("BookingID") %>' CssClass="btn btn-primary btn-action" Text="Set Reminder" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Itinerary Preview Modal -->
                <div class="modal fade" id="itineraryModal_<%# Eval("BookingID") %>" tabindex="-1" aria-labelledby="itineraryModalLabel_<%# Eval("BookingID") %>" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="itineraryModalLabel_<%# Eval("BookingID") %>">Flight Itinerary #<%# Eval("BookingID") %></h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <h6>Flight Details</h6>
                                <p><strong>Aircraft Model:</strong> <%# Eval("AircraftModel") %></p>
                                <p><strong>Manufacturer:</strong> <%# Eval("Manufacturer") %></p>
                                <p><strong>Start Date:</strong> <%# Eval("StartDate", "{0:MMM dd, yyyy HH:mm}") %></p>
                                <p><strong>End Date:</strong> <%# Eval("EndDate", "{0:MMM dd, yyyy HH:mm}") %></p>
                                <p><strong>Total Amount:</strong> <%# Eval("TotalAmount", "{0:C}") %></p>
                                <p><strong>Extras:</strong>
                                    Meals: <%# Convert.ToBoolean(Eval("chkMeals")) ? "Yes" : "No" %>,
                                    WiFi: <%# Convert.ToBoolean(Eval("chkWIFI")) ? "Yes" : "No" %>,
                                    Catering: <%# Convert.ToBoolean(Eval("chkCatering")) ? "Yes" : "No" %>
                                </p>
                                <p><strong>Seller Email:</strong> <%# Eval("SellerEmail") %></p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary btn-action" data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary btn-action" onclick="downloadItinerary(<%# Eval("BookingID") %>)">Download PDF</button>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- Enter Code Modal -->
        <div class="modal fade" id="codeModal" tabindex="-1" aria-labelledby="codeModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="codeModalLabel">Enter Invitation Code</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="txtInviteCode" class="form-label">Invitation Code</label>
                            <asp:TextBox ID="txtInviteCode" runat="server" CssClass="form-control" placeholder="e.g., LG2EA1" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-action" data-bs-dismiss="modal">Close</button>
                        <asp:Button ID="btnSubmitCode" runat="server" OnClick="btnSubmitCode_Click" CssClass="btn btn-primary btn-action" Text="Submit Code" />
                    </div>
                </div>
            </div>
        </div>

        <asp:Label ID="lblNoBookings" runat="server" Text="You have no bookings." Visible="false" CssClass="text-center d-block" />
    </div>

    <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_ACTUAL_API_KEY&callback=initMaps" async defer></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script>
        function initMaps() {
            document.querySelectorAll('.map-container').forEach(mapDiv => {
                const lat = parseFloat(mapDiv.getAttribute('data-lat'));
                const lng = parseFloat(mapDiv.getAttribute('data-lng'));
                const map = new google.maps.Map(mapDiv, {
                    center: { lat: lat, lng: lng },
                    zoom: 8,
                    styles: [
                        { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
                        { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
                        { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
                        {
                            featureType: "administrative.locality",
                            elementType: "labels.text.fill",
                            stylers: [{ color: "#d59563" }],
                        },
                        {
                            featureType: "poi",
                            elementType: "labels.text.fill",
                            stylers: [{ color: "#d59563" }],
                        },
                        {
                            featureType: "poi.park",
                            elementType: "geometry",
                            stylers: [{ color: "#263c3f" }],
                        },
                        {
                            featureType: "poi.park",
                            elementType: "labels.text.fill",
                            stylers: [{ color: "#6b9a76" }],
                        },
                        {
                            featureType: "road",
                            elementType: "geometry",
                            stylers: [{ color: "#38414e" }],
                        },
                        {
                            featureType: "road",
                            elementType: "geometry.stroke",
                            stylers: [{ color: "#212a37" }],
                        },
                        {
                            featureType: "road",
                            elementType: "labels.text.fill",
                            stylers: [{ color: "#9ca5b3" }],
                        },
                        {
                            featureType: "road.highway",
                            elementType: "geometry",
                            stylers: [{ color: "#746855" }],
                        },
                        {
                            featureType: "road.highway",
                            elementType: "geometry.stroke",
                            stylers: [{ color: "#1f2835" }],
                        },
                        {
                            featureType: "road.highway",
                            elementType: "labels.text.fill",
                            stylers: [{ color: "#f3d19c" }],
                        },
                        {
                            featureType: "transit",
                            elementType: "geometry",
                            stylers: [{ color: "#2f3948" }],
                        },
                        {
                            featureType: "transit.station",
                            elementType: "labels.text.fill",
                            stylers: [{ color: "#d59563" }],
                        },
                        {
                            featureType: "water",
                            elementType: "geometry",
                            stylers: [{ color: "#17263c" }],
                        },
                        {
                            featureType: "water",
                            elementType: "labels.text.fill",
                            stylers: [{ color: "#515c6d" }],
                        },
                        {
                            featureType: "water",
                            elementType: "labels.text.stroke",
                            stylers: [{ color: "#17263c" }],
                        },
                    ]
                });
                new google.maps.Marker({
                    position: { lat: lat, lng: lng },
                    map: map,
                    title: "Flight Location",
                    icon: {
                        url: "https://maps.google.com/mapfiles/ms/icons/yellow-dot.png"
                    }
                });
                const flightPath = new google.maps.Polyline({
                    path: [
                        { lat: lat, lng: lng },
                        { lat: lat + 5, lng: lng + 5 }
                    ],
                    geodesic: true,
                    strokeColor: "#FF0000",
                    strokeOpacity: 1.0,
                    strokeWeight: 3
                });
                flightPath.setMap(map);
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            // Countdown Timer
            document.querySelectorAll('.countdown-timer').forEach(timer => {
                const startDate = new Date(timer.getAttribute('data-start')).getTime();
                const endDate = new Date(timer.getAttribute('data-end')).getTime();
                const now = new Date().getTime();

                const updateTimer = setInterval(function () {
                    const now = new Date().getTime();
                    const timeLeft = startDate - now;

                    if (now > endDate) {
                        clearInterval(updateTimer);
                        timer.querySelector('.time-left').innerText = "Flight Finished!";
                        return;
                    } else if (timeLeft < 0) {
                        clearInterval(updateTimer);
                        timer.querySelector('.time-left').innerText = "Flight Started!";
                        return;
                    } else {
                        timer.querySelector('.time-left').innerText = "Flight Will Start Soon!";
                        const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24));
                        const hours = Math.floor((timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                        const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
                        const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);
                        timer.querySelector('.time-left').innerText += " (" + days + "d " + hours + "h " + minutes + "m " + seconds + "s)";
                    }
                }, 1000);
            });

            // Flight Status Update
            document.querySelectorAll('.flight-status .status-text').forEach(status => {
                const updateStatus = setInterval(() => {
                    const now = new Date();
                    const startDate = new Date(status.closest('.countdown-timer').getAttribute('data-start'));
                    if (now < startDate) {
                        status.innerText = "Scheduled";
                    } else if (now >= startDate) {
                        status.innerText = "Departed";
                    }
                }, 60000);
            });

            // Live Flight Status Simulation
            document.querySelectorAll('.live-status-text').forEach(status => {
                const statuses = ["On Time", "Delayed", "Boarding", "Departed"];
                setInterval(() => {
                    status.innerText = statuses[Math.floor(Math.random() * statuses.length)];
                }, 300000);
            });

            // Weather Update
            document.querySelectorAll('.weather-text').forEach(weather => {
                setInterval(() => {
                    const conditions = [
                        "Sunny, 28°C, 10% chance of rain",
                        "Cloudy, 25°C, 30% chance of rain",
                        "Rainy, 22°C, 70% chance of rain",
                        "Thunderstorms, 20°C, 90% chance of rain"
                    ];
                    weather.innerText = conditions[Math.floor(Math.random() * conditions.length)];
                }, 300000);
            });

            // Fix modal freezing issue for all modals
            document.querySelectorAll('.modal').forEach(modal => {
                modal.addEventListener('hidden.bs.modal', function () {
                    // Remove modal-open class and backdrop
                    document.body.classList.remove('modal-open');
                    const backdrop = document.querySelector('.modal-backdrop');
                    if (backdrop) {
                        backdrop.remove();
                    }
                    // Restore body scroll and padding
                    document.body.style.overflow = 'auto';
                    document.body.style.paddingRight = '0px';
                });

                modal.addEventListener('shown.bs.modal', function () {
                    document.body.classList.add('modal-open');
                    // Prevent scrolling on the body while modal is open
                    document.body.style.overflow = 'hidden';
                    // Adjust padding to prevent page shift due to scrollbar
                    const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth;
                    document.body.style.paddingRight = scrollbarWidth + 'px';
                });
            });

            // Remove modal backdrop on page load if any modal was closed improperly
            window.addEventListener('load', function () {
                document.body.classList.remove('modal-open');
                const backdrop = document.querySelector('.modal-backdrop');
                if (backdrop) {
                    backdrop.remove();
                }
                document.body.style.overflow = 'auto';
                document.body.style.paddingRight = '0px';
            });
        });

        function downloadItinerary(bookingID) {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF();
            const bookingCard = document.querySelector("#collapse_" + bookingID + " .booking-body");
            doc.setFontSize(16);
            doc.text("Flight Itinerary - Booking #" + bookingID, 10, 10);
            doc.setFontSize(12);
            const text = bookingCard.innerText.split('\n').filter(line => line.trim() !== '');
            let y = 20;
            text.forEach(line => {
                doc.text(line, 10, y);
                y += 10;
            });
            doc.save("Flight_Itinerary_" + bookingID + ".pdf");
        }

        function shareFlight(bookingID) {
            const subject = "Check out my flight booking #" + bookingID;
            const body = "I have booked a flight! Here are the details: [Flight Details]";
            const mailtoLink = "mailto:?subject=" + encodeURIComponent(subject) + "&body=" + encodeURIComponent(body);
            window.location.href = mailtoLink;
        }

        function showRating(bookingID) {
            document.getElementById("rating_" + bookingID).style.display = 'block';
            const stars = document.querySelectorAll("#stars_" + bookingID + " i");
            stars.forEach(star => {
                star.addEventListener('click', () => {
                    const rating = star.getAttribute('data-value');
                    document.querySelector("#collapse_" + bookingID + " input[name$='hdnRating']").value = rating;
                    stars.forEach(s => s.classList.remove('active'));
                    for (let i = 0; i < rating; i++) {
                        stars[i].classList.add('active');
                    }
                });
            });
        }

        function openCodeModal() {
            const modal = new bootstrap.Modal(document.getElementById('codeModal'), {});
            modal.show();
        }
    </script>
</asp:Content>