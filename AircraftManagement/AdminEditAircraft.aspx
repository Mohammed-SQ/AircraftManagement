<%@ Page Title="Admin - Edit Aircraft" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="AdminEditAircraft.aspx.cs" Inherits="AircraftManagement.AdminEditAircraft" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <div class="container my-5">
        <h2 class="mb-4 text-center"><i class="fas fa-plane me-2"></i>Edit Aircraft Details (Admin)</h2>

        <div class="card shadow-lg">
            <div class="card-body p-5">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Aircraft Model <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtModel" runat="server" CssClass="form-control" placeholder="Enter aircraft model" />
                        <asp:RequiredFieldValidator ID="rfvModel" runat="server" ControlToValidate="txtModel" ErrorMessage="Aircraft model is required." CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Capacity <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control" TextMode="Number" placeholder="Enter capacity" />
                        <asp:RequiredFieldValidator ID="rfvCapacity" runat="server" ControlToValidate="txtCapacity" ErrorMessage="Capacity is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RangeValidator ID="rvCapacity" runat="server" ControlToValidate="txtCapacity" MinimumValue="1" MaximumValue="1000" Type="Integer" ErrorMessage="Enter a valid capacity (1-1000)." CssClass="text-danger" Display="Dynamic" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Rental Price (Currency) <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtRentalPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="Enter rental price" />
                        <asp:RequiredFieldValidator ID="rfvRentalPrice" runat="server" ControlToValidate="txtRentalPrice" ErrorMessage="Rental price is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RangeValidator ID="rvRentalPrice" runat="server" ControlToValidate="txtRentalPrice" MinimumValue="0.01" MaximumValue="9999999.99" Type="Double" ErrorMessage="Enter a valid price (0.01-9,999,999.99)." CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Purchase Price (Currency) <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtPurchasePrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="Enter purchase price" />
                        <asp:RequiredFieldValidator ID="rfvPurchasePrice" runat="server" ControlToValidate="txtPurchasePrice" ErrorMessage="Purchase price is required." CssClass="text-danger" Display="Dynamic" />
                        <asp:RangeValidator ID="rvPurchasePrice" runat="server" ControlToValidate="txtPurchasePrice" MinimumValue="0.01" MaximumValue="9999999.99" Type="Double" ErrorMessage="Enter a valid price (0.01-9,999,999.99)." CssClass="text-danger" Display="Dynamic" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Status <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Select Status" Value="" />
                            <asp:ListItem Text="Available" Value="Available" />
                            <asp:ListItem Text="Rented" Value="Rented" />
                            <asp:ListItem Text="Sold" Value="Sold" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvStatus" runat="server" ControlToValidate="ddlStatus" InitialValue="" ErrorMessage="Status is required." CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Image URL</label>
                        <asp:TextBox ID="txtImageUrl" runat="server" CssClass="form-control" placeholder="Enter image URL (or upload below)" />
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Upload Image (JPG/PNG)</label>
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png" onchange="previewImage(this);" />
                    <asp:CustomValidator ID="cvFileUpload" runat="server" ErrorMessage="File size must be less than 5MB." CssClass="text-danger" Display="Dynamic" ClientValidationFunction="validateFileSize" OnServerValidate="cvFileUpload_ServerValidate" />
                </div>
                <div class="text-center mb-3">
                    <asp:Image ID="imgAircraft" runat="server" CssClass="img-thumbnail" Width="200" Height="200" Style="object-fit: cover;" Visible="true" />
                </div>

                <!-- Anti-CSRF Token -->
                <asp:HiddenField ID="hfAntiCsrfToken" runat="server" />

                <div class="text-center mt-5">
                    <asp:Button ID="BtnUpdate" runat="server" CssClass="btn btn-primary btn-lg" Text="Update Aircraft" OnClick="BtnUpdate_Click" />
                    <asp:Button ID="BtnCancel" runat="server" CssClass="btn btn-secondary btn-lg ms-3" Text="Cancel" OnClick="BtnCancel_Click" CausesValidation="false" />
                </div>

                <asp:Label ID="lblFeedbackMessage" runat="server" CssClass="alert d-block text-center mt-4" Visible="false"></asp:Label>
            </div>
        </div>
    </div>

    <!-- Custom Styles -->
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
            min-height: 100vh;
        }

        h2 {
            color: #1e3c72;
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
            color: #333;
        }

        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #1e3c72;
            box-shadow: 0 0 5px rgba(30, 60, 114, 0.3);
        }

        .btn-primary, .btn-secondary {
            border-radius: 8px;
            padding: 12px 30px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: #2a5298;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .text-danger {
            font-size: 0.9rem;
        }
    </style>

    <!-- Client-Side Scripts -->
    <script type="text/javascript">
        function previewImage(input) {
            var imgPreview = document.getElementById('<%= imgAircraft.ClientID %>');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    imgPreview.src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function validateFileSize(source, args) {
            var fileUpload = document.getElementById('<%= fileUpload.ClientID %>');
            if (fileUpload.files.length > 0) {
                var fileSize = fileUpload.files[0].size; // in bytes
                var maxSize = 5 * 1024 * 1024; // 5MB in bytes
                args.IsValid = fileSize <= maxSize;
            } else {
                args.IsValid = true; // No file uploaded, validation passes
            }
        }
    </script>
</asp:Content>