<%@ Page Title="Maintenance" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Maintenance.aspx.cs" Inherits="AircraftManagement.Maintenance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/flatpickr@4.6.13/dist/flatpickr.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />

    <!-- Wrap all content in a scoped div -->
    <div class="maintenance-content">
        <div class="container py-5">
            <!-- Page Title -->
            <h1 class="text-primary mb-4"><i class="fas fa-tools me-2"></i>Aircraft Maintenance Dashboard</h1>

            <asp:Label ID="lblEligibilityMessage" runat="server" CssClass="alert d-block text-center mb-4" Visible="false"></asp:Label>

            <!-- Maintenance Options -->
            <asp:Panel ID="maintenanceOptions" runat="server" CssClass="row g-4 mb-5">
                <div class="col-md-4 col-lg-3">
                    <div class="card maintenance-card" data-type="Heavy Maintenance">
                        <div class="card-body text-center">
                            <i class="fas fa-tools fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Heavy Maintenance</h5>
                            <p class="card-text">Comprehensive structural inspections and repairs.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="card maintenance-card" data-type="Shop/Component Maintenance">
                        <div class="card-body text-center">
                            <i class="fas fa-cogs fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Shop/Component Maintenance</h5>
                            <p class="card-text">Specialized maintenance for components.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="card maintenance-card" data-type="Consistent Oil Changes">
                        <div class="card-body text-center">
                            <i class="fas fa-oil-can fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Consistent Oil Changes</h5>
                            <p class="card-text">Regular oil changes for engine performance.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="card maintenance-card" data-type="Failure Rectification">
                        <div class="card-body text-center">
                            <i class="fas fa-wrench fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Failure Rectification</h5>
                            <p class="card-text">Diagnose and fix unexpected failures.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="card maintenance-card" data-type="Avionics Upgrade">
                        <div class="card-body text-center">
                            <i class="fas fa-microchip fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Avionics Upgrade</h5>
                            <p class="card-text">Upgrade navigation and communication systems.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="card maintenance-card" data-type="Engine Overhaul">
                        <div class="card-body text-center">
                            <i class="fas fa-tachometer-alt fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Engine Overhaul</h5>
                            <p class="card-text">Complete engine teardown and rebuild.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="card maintenance-card" data-type="Paint Refinishing">
                        <div class="card-body text-center">
                            <i class="fas fa-paint-roller fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Paint Refinishing</h5>
                            <p class="card-text">Refresh your aircraft's exterior.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-3">
                    <div class="card maintenance-card" data-type="Interior Refurbishment">
                        <div class="card-body text-center">
                            <i class="fas fa-chair fa-3x mb-3 text-primary"></i>
                            <h5 class="card-title">Interior Refurbishment</h5>
                            <p class="card-text">Upgrade the cabin interior.</p>
                        </div>
                    </div>
                </div>
            </asp:Panel>

            <!-- Maintenance Request Form -->
            <asp:Panel ID="maintenanceForm" runat="server" CssClass="card p-4 mb-5 shadow-lg" style="display: none;">
                <h4 class="card-title mb-4 text-primary"><i class="fas fa-plus-circle me-2"></i>Request Maintenance</h4>
                <div class="mb-3">
                    <label class="form-label">Maintenance Type</label>
                    <asp:TextBox ID="txtMaintenanceType" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    <asp:HiddenField ID="hdnMaintenanceType" runat="server" />
                </div>
                <div class="mb-3">
                    <label class="form-label required">Aircraft</label>
                    <asp:DropDownList ID="ddlAircrafts" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Select an Aircraft" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvAircraft" runat="server" ControlToValidate="ddlAircrafts" InitialValue="" ErrorMessage="Please select an aircraft." CssClass="text-danger" Display="Dynamic" />
                </div>
                <!-- Parts Selection -->
                <div class="mb-3">
                    <label class="form-label required">Parts to Repair</label>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="form-check">
                                <asp:CheckBox ID="chkEngine" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="<%= chkEngine.ClientID %>"><i class="fas fa-cogs me-1"></i> Engine</label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check">
                                <asp:CheckBox ID="chkWings" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="<%= chkWings.ClientID %>"><i class="fas fa-plane me-1"></i> Wings</label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check">
                                <asp:CheckBox ID="chkAvionics" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="<%= chkAvionics.ClientID %>"><i class="fas fa-microchip me-1"></i> Avionics</label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check">
                                <asp:CheckBox ID="chkLandingGear" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="<%= chkLandingGear.ClientID %>"><i class="fas fa-plane-arrival me-1"></i> Landing Gear</label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check">
                                <asp:CheckBox ID="chkFuselage" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="<%= chkFuselage.ClientID %>"><i class="fas fa-plane me-1"></i> Fuselage</label>
                            </div>
                        </div>
                    </div>
                    <asp:CustomValidator ID="cvParts" runat="server" ClientValidationFunction="validateParts" ErrorMessage="Please select at least one part to repair." CssClass="text-danger" Display="Dynamic" />
                </div>
                <!-- Additional Options -->
                <div class="mb-3">
                    <label class="form-label">Additional Options</label>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="form-check">
                                <asp:CheckBox ID="chkPriorityService" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="<%= chkPriorityService.ClientID %>"><i class="fas fa-bolt me-1"></i> Priority Service (+SR 2000)</label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check">
                                <asp:CheckBox ID="chkExtendedWarranty" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="<%= chkExtendedWarranty.ClientID %>"><i class="fas fa-shield-alt me-1"></i> Extended Warranty (+SR 1500)</label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check">
                                <asp:CheckBox ID="chkDetailedReport" runat="server" CssClass="form-check-input" />
                                <label class="form-check-label" for="<%= chkDetailedReport.ClientID %>"><i class="fas fa-file-alt me-1"></i> Detailed Report (+SR 500)</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label required">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Describe any specific issues or requirements..."></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription" ErrorMessage="Description is required." CssClass="text-danger" Display="Dynamic" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Scheduled Date and Time</label>
                    <asp:TextBox ID="txtScheduledDate" runat="server" CssClass="form-control flatpickr-input" placeholder="Select date and time"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <asp:Label ID="lblCostMessage" runat="server" CssClass="text-success" Visible="false"></asp:Label>
                    <asp:HiddenField ID="hdnIsFree" runat="server" Value="false" />
                </div>
                <div class="d-flex justify-content-between">
                    <asp:Button ID="btnSubmitRequest" runat="server" CssClass="btn btn-primary" Text="Submit Request" OnClick="btnSubmitRequest_Click" OnClientClick="return validateForm();" />
                    <button type="button" class="btn btn-outline-secondary" onclick="cancelRequest();">Cancel</button>
                </div>
            </asp:Panel>

            <!-- Scheduled Tasks -->
            <div class="mb-5">
                <h4 class="mb-4 text-white"><i class="fas fa-tasks me-2"></i>Scheduled Maintenance Tasks</h4>
                <asp:GridView ID="gvScheduledTasks" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-dark table-hover shadow-sm" OnRowCommand="gvScheduledTasks_RowCommand" DataKeyNames="MaintenanceID">
                    <Columns>
                        <asp:BoundField DataField="AircraftModel" HeaderText="Aircraft Model" />
                        <asp:BoundField DataField="MaintenanceType" HeaderText="Maintenance Type" />
                        <asp:BoundField DataField="PartsRepaired" HeaderText="Parts Repaired" />
                        <asp:BoundField DataField="AdditionalOptions" HeaderText="Additional Options" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="ScheduledDate" HeaderText="Scheduled Date" DataFormatString="{0:MM/dd/yyyy HH:mm}" />
                        <asp:BoundField DataField="Status" HeaderText="Status" />
                        <asp:BoundField DataField="Cost" HeaderText="Cost (SR)" DataFormatString="{0:F2}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:Button ID="btnViewDetails" runat="server" CommandName="ViewDetails" CommandArgument='<%# Container.DataItemIndex %>' Text="View Details" CssClass="btn btn-info btn-sm me-2" />
                                <asp:Button ID="btnCancel" runat="server" CommandName="CancelRequest" CommandArgument='<%# Container.DataItemIndex %>' Text="Cancel" CssClass="btn btn-danger btn-sm" Visible='<%# Eval("Status").ToString() == "Pending" %>' OnClientClick="return confirm('Are you sure you want to cancel this request?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="alert alert-info text-center">No scheduled maintenance tasks available.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Service History -->
            <div class="mb-5">
                <h4 class="mb-4 text-white"><i class="fas fa-history me-2"></i>Service History</h4>
                <asp:GridView ID="gvServiceHistory" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-dark table-hover shadow-sm" DataKeyNames="MaintenanceID" OnRowDataBound="gvServiceHistory_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="CompletedDate" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy}" />
                        <asp:BoundField DataField="MaintenanceType" HeaderText="Service" />
                        <asp:BoundField DataField="PartsRepaired" HeaderText="Parts Repaired" />
                        <asp:BoundField DataField="AdditionalOptions" HeaderText="Additional Options" />
                        <asp:BoundField DataField="Cost" HeaderText="Cost (SR)" DataFormatString="{0:F2}" />
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select form-select-sm" OnSelectedIndexChanged="ddlRating_SelectedIndexChanged" AutoPostBack="true">
                                    <asp:ListItem Text="Rate (1-5)" Value=""></asp:ListItem>
                                    <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                    <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:Label ID="lblRating" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="alert alert-info text-center">No service history available.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- Custom Styles -->
    <style>
        /* Scope all styles to .maintenance-content to avoid affecting the nav */
        .maintenance-content {
            background: linear-gradient(135deg, #1e3c72, #2a5298); /* Reintroduce background gradient */
            min-height: 100vh;
            font-family: 'Roboto', sans-serif;
            color: #333;
        }

        .maintenance-content .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }

        .maintenance-content h1 {
            font-weight: 500;
            font-size: 2.5rem;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .maintenance-content h4 {
            font-weight: 500;
            color: #1e3c72;
            font-size: 1.5rem;
            text-transform: uppercase;
        }

        .maintenance-content .maintenance-card {
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: relative;
        }

        .maintenance-content .maintenance-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, #2a5298, #1e3c72);
        }

        .maintenance-content .maintenance-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            background: linear-gradient(135deg, #f5f7fa, #e4e7eb);
        }

        .maintenance-content .maintenance-card .card-body {
            padding: 25px;
        }

        .maintenance-content .maintenance-card .card-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1e3c72;
            margin-bottom: 10px;
        }

        .maintenance-content .maintenance-card .card-text {
            font-size: 0.95rem;
            color: #666;
            line-height: 1.5;
        }

        .maintenance-content .maintenance-card i {
            transition: transform 0.3s ease;
        }

        .maintenance-content .maintenance-card:hover i {
            transform: scale(1.2);
        }

        .maintenance-content .form-label {
            font-weight: 500;
            color: #1e3c72;
            font-size: 1.1rem;
        }

        .maintenance-content .form-label.required::after {
            content: " *";
            color: #dc3545;
        }

        .maintenance-content .form-control,
        .maintenance-content .form-select {
            border-radius: 8px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
            font-size: 1rem;
            padding: 10px;
        }

        .maintenance-content .form-control:focus,
        .maintenance-content .form-select:focus {
            border-color: #2a5298;
            box-shadow: 0 0 5px rgba(42, 82, 152, 0.3);
        }

        .maintenance-content .form-check-label {
            font-size: 1rem;
            color: #333;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .maintenance-content .form-check-input:checked + .form-check-label {
            color: #2a5298;
            font-weight: 500;
        }

        .maintenance-content .flatpickr-input {
            background: #fff;
            border: 1px solid #ced4da;
            border-radius: 8px;
        }

        .maintenance-content .flatpickr-calendar {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .maintenance-content .flatpickr-day.selected {
            background: #2a5298;
            border-color: #2a5298;
        }

        .maintenance-content .table-dark {
            background: #2a2a2a;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .maintenance-content .table-dark th {
            background: #1e3c72;
            color: #fff;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 15px;
        }

        .maintenance-content .table-dark td {
            color: #ddd;
            padding: 15px;
        }

        .maintenance-content .table-dark tr:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .maintenance-content .btn-primary {
            background: #2a5298;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 1.1rem;
            font-weight: 500;
            text-transform: uppercase;
            transition: all 0.3s ease;
        }

        .maintenance-content .btn-primary:hover {
            background: #1e3c72;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .maintenance-content .btn-outline-secondary {
            border-color: #6c757d;
            color: #6c757d;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 1.1rem;
            font-weight: 500;
            text-transform: uppercase;
            transition: all 0.3s ease;
        }

        .maintenance-content .btn-outline-secondary:hover {
            background: #6c757d;
            color: #fff;
        }

        .maintenance-content .alert {
            border-radius: 10px;
            font-weight: 500;
            font-size: 1.1rem;
            padding: 15px;
        }

        .maintenance-content .shadow-lg {
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2) !important;
            border-radius: 15px;
        }

        @media (max-width: 768px) {
            .maintenance-content .container {
                padding: 20px;
            }

            .maintenance-content h1 {
                font-size: 2rem;
            }

            .maintenance-content h4 {
                font-size: 1.2rem;
            }

            .maintenance-content .maintenance-card .card-title {
                font-size: 1.1rem;
            }

            .maintenance-content .maintenance-card .card-text {
                font-size: 0.85rem;
            }

            .maintenance-content .form-label {
                font-size: 1rem;
            }

            .maintenance-content .form-control,
            .maintenance-content .form-select {
                font-size: 0.95rem;
                padding: 8px;
            }

            .maintenance-content .btn-primary,
            .maintenance-content .btn-outline-secondary {
                font-size: 1rem;
                padding: 10px 20px;
            }
        }
    </style>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr@4.6.13/dist/flatpickr.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr@4.6.13/dist/plugins/confirmDate/confirmDate.js"></script>
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            flatpickr("#<%= txtScheduledDate.ClientID %>", {
                enableTime: true,
                dateFormat: "Y-m-d H:i",
                minDate: "today",
                maxDate: new Date().fp_incr(180),
                disable: [
                    function (date) {
                        return (date.getDay() === 0 || date.getDay() === 6);
                    }
                ],
                time_24hr: true,
                minuteIncrement: 15,
                defaultHour: 9,
                defaultMinute: 0,
                plugins: [
                    new confirmDatePlugin({
                        confirmText: "Select",
                        showAlways: true
                    })
                ]
            });

            var maintenanceCards = document.querySelectorAll('.maintenance-card');
            maintenanceCards.forEach(function (card) {
                card.addEventListener('click', function () {
                    var maintenanceType = this.getAttribute('data-type');
                    document.getElementById('<%= txtMaintenanceType.ClientID %>').value = maintenanceType;
                    document.getElementById('<%= hdnMaintenanceType.ClientID %>').value = maintenanceType;
                    document.getElementById('<%= maintenanceForm.ClientID %>').style.display = 'block';
                    window.scrollTo({ top: document.getElementById('<%= maintenanceForm.ClientID %>').offsetTop - 100, behavior: 'smooth' });
                });
            });
        });

        function validateForm() {
            var aircraft = document.getElementById('<%= ddlAircrafts.ClientID %>').value;
            var description = document.getElementById('<%= txtDescription.ClientID %>').value.trim();

            if (!aircraft) {
                alert('Please select an aircraft.');
                return false;
            }

            if (!description) {
                alert('Please provide a description for the maintenance request.');
                return false;
            }

            return confirm('Are you sure you want to submit this maintenance request?');
        }

        function validateParts(source, args) {
            var chkEngine = document.getElementById('<%= chkEngine.ClientID %>');
            var chkWings = document.getElementById('<%= chkWings.ClientID %>');
            var chkAvionics = document.getElementById('<%= chkAvionics.ClientID %>');
            var chkLandingGear = document.getElementById('<%= chkLandingGear.ClientID %>');
            var chkFuselage = document.getElementById('<%= chkFuselage.ClientID %>');

            args.IsValid = chkEngine.checked || chkWings.checked || chkAvionics.checked || chkLandingGear.checked || chkFuselage.checked;
        }

        function cancelRequest() {
            document.getElementById('<%= maintenanceForm.ClientID %>').style.display = 'none';
            document.getElementById('<%= txtMaintenanceType.ClientID %>').value = '';
            document.getElementById('<%= hdnMaintenanceType.ClientID %>').value = '';
            document.getElementById('<%= txtDescription.ClientID %>').value = '';
            document.getElementById('<%= txtScheduledDate.ClientID %>').value = '';
            document.getElementById('<%= chkEngine.ClientID %>').checked = false;
            document.getElementById('<%= chkWings.ClientID %>').checked = false;
            document.getElementById('<%= chkAvionics.ClientID %>').checked = false;
            document.getElementById('<%= chkLandingGear.ClientID %>').checked = false;
            document.getElementById('<%= chkFuselage.ClientID %>').checked = false;
            document.getElementById('<%= chkPriorityService.ClientID %>').checked = false;
            document.getElementById('<%= chkExtendedWarranty.ClientID %>').checked = false;
            document.getElementById('<%= chkDetailedReport.ClientID %>').checked = false;
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    </script>
</asp:Content>