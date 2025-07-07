<%@ Page Title="Edit Aircraft" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="EditAircraft.aspx.cs" Inherits="AircraftManagement.EditAircraft" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <div class="container my-5">
        <h2 class="mb-4 text-center"><i class="fas fa-plane me-2"></i>Edit Aircraft</h2>
        <p class="text-center mb-5">Update the details of your aircraft listing in the Saudi Aviation Market.</p>

        <asp:Label ID="lblFeedbackMessage" runat="server" CssClass="alert d-block text-center mb-4" Visible="false"></asp:Label>

        <div class="card shadow-lg">
            <div class="card-body p-5">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtModel" class="form-label">Model</label>
                        <asp:TextBox ID="txtModel" runat="server" CssClass="form-control" placeholder="Enter aircraft model"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtYearManufactured" class="form-label">Year Manufactured</label>
                        <asp:TextBox ID="txtYearManufactured" runat="server" CssClass="form-control" placeholder="Enter manufacturing year" TextMode="Number"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtEngineHours" class="form-label">Engine Hours</label>
                        <asp:TextBox ID="txtEngineHours" runat="server" CssClass="form-control" placeholder="Enter engine hours" TextMode="Number"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtRegistrationNumber" class="form-label">Registration Number</label>
                        <asp:TextBox ID="txtRegistrationNumber" runat="server" CssClass="form-control" placeholder="Enter registration number"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtCapacity" class="form-label">Capacity</label>
                        <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" placeholder="Enter seating capacity" TextMode="Number"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtRentalPrice" class="form-label">Rental Price (﷼/day)</label>
                        <asp:TextBox ID="txtRentalPrice" runat="server" CssClass="form-control" placeholder="Enter rental price" TextMode="Number" step="0.01"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtPurchasePrice" class="form-label">Purchase Price (﷼)</label>
                        <asp:TextBox ID="txtPurchasePrice" runat="server" CssClass="form-control" placeholder="Enter purchase price" TextMode="Number" step="0.01"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="ddlStatus" class="form-label">Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Available" Value="Available"></asp:ListItem>
                            <asp:ListItem Text="Rented" Value="Rented"></asp:ListItem>
                            <asp:ListItem Text="Sold" Value="Sold"></asp:ListItem>
                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtImageURL" class="form-label">Image URL</label>
                        <asp:TextBox ID="txtImageURL" runat="server" CssClass="form-control" placeholder="Enter image URL (e.g., /Images/Aircraft/photo.jpg)"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtManufacturer" class="form-label">Manufacturer</label>
                        <asp:TextBox ID="txtManufacturer" runat="server" CssClass="form-control" placeholder="Enter manufacturer name"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtFuelType" class="form-label">Fuel Type</label>
                        <asp:TextBox ID="txtFuelType" runat="server" CssClass="form-control" placeholder="Enter fuel type"></asp:TextBox>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtAircraftCondition" class="form-label">Aircraft Condition</label>
                        <asp:TextBox ID="txtAircraftCondition" runat="server" CssClass="form-control" placeholder="Enter aircraft condition"></asp:TextBox>
                    </div>
                </div>
                <div class="text-center">
                    <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn btn-success btn-lg me-3" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary btn-lg" OnClick="btnCancel_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
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

        .form-label {
            font-weight: 500;
            color: #1b5e20;
        }

        .form-control {
            border-radius: 5px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #1b5e20;
            box-shadow: 0 0 5px rgba(27, 94, 32, 0.3);
        }

        .btn-success, .btn-secondary {
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .btn-success:hover {
            background: #2e7d32;
            transform: translateY(-2px);
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
    </style>
</asp:Content>