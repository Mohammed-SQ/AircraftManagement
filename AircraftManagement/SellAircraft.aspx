<%@ Page Title="Sell Your Aircraft" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="SellAircraft.aspx.cs" Inherits="SellAircraft" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2 class="text-center"><i class="fas fa-plane"></i> List Your Aircraft</h2>

        <div class="progress mt-3">
            <div id="progressBar" class="progress-bar bg-success" role="progressbar" style="width: 0%">0%</div>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-plane"></i> Aircraft Model</label>
                    <asp:TextBox ID="txtModel" runat="server" CssClass="form-control" placeholder="Enter aircraft model" onkeyup="updateProgress()"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-exchange-alt"></i> Transaction Type</label>
                    <asp:DropDownList ID="ddlTransactionType" runat="server" CssClass="form-select" onchange="toggleTransactionFields()">
                        <asp:ListItem Text="Select Type" Value=""></asp:ListItem>
                        <asp:ListItem Text="Rent" Value="Rent"></asp:ListItem>
                        <asp:ListItem Text="Purchase" Value="Purchase"></asp:ListItem>
                        <asp:ListItem Text="Both" Value="Both"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-users"></i> Capacity</label>
                    <asp:DropDownList ID="ddlCapacityRange" runat="server" CssClass="form-select" onchange="toggleCustomCapacity()">
                        <asp:ListItem Text="Select Capacity Range" Value=""></asp:ListItem>
                        <asp:ListItem Text="1-5" Value="1-5"></asp:ListItem>
                        <asp:ListItem Text="6-20" Value="6-20"></asp:ListItem>
                        <asp:ListItem Text="21-50" Value="21-50"></asp:ListItem>
                        <asp:ListItem Text="51-200" Value="51-200"></asp:ListItem>
                        <asp:ListItem Text="200+" Value="200+"></asp:ListItem>
                    </asp:DropDownList>

                    <input type="number" id="customCapacity" class="form-control mt-2" placeholder="Enter exact capacity" min="1" oninput="updateProgress()" style="display: none;" />
                    <small id="capacityLabel" class="form-text text-muted mt-1" style="display: none;"></small>
                </div>
            </div>

            <div class="col-md-6">
                <div class="mb-3" id="purchasePriceContainer" style="display: none;">
                    <label class="form-label"><i class="fas fa-tag"></i> Purchase Price ($)</label>
                    <asp:TextBox ID="txtPurchasePrice" runat="server" CssClass="form-control" type="number" step="0.01" placeholder="Enter purchase price" onkeyup="updateProgress()"></asp:TextBox>
                </div>

                <div class="mb-3" id="rentalPriceContainer" style="display: none;">
                    <label class="form-label"><i class="fas fa-dollar-sign"></i> Rental Price ($/day)</label>
                    <asp:TextBox ID="txtRentalPrice" runat="server" CssClass="form-control" type="number" step="0.01" placeholder="Enter rental price" onkeyup="updateProgress()"></asp:TextBox>
                </div>

                <div class="mb-3">
                    <label class="form-label"><i class="fas fa-upload"></i> Upload Image</label>
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" onchange="previewImage(this); updateProgress();" />
                </div>
                <div class="text-center">
                    <img id="imagePreview" class="img-thumbnail mt-2" style="max-width: 300px; display: none;" src="#" />
                </div>
            </div>
        </div>

        <div class="text-center mt-4">
            <asp:Button ID="BtnSubmit" runat="server" CssClass="btn btn-success w-50 fw-bold" Text="Submit Aircraft" OnClientClick="return confirmSubmission();" Enabled="false" />
        </div>
    </div>

    <script>
        function toggleTransactionFields() {
            var type = document.getElementById('<%= ddlTransactionType.ClientID %>').value;
            document.getElementById("rentalPriceContainer").style.display = (type === "Rent" || type === "Both") ? "block" : "none";
            document.getElementById("purchasePriceContainer").style.display = (type === "Purchase" || type === "Both") ? "block" : "none";
            updateProgress();
        }

        function toggleCustomCapacity() {
            var range = document.getElementById('<%= ddlCapacityRange.ClientID %>').value;
            var capacityLabel = document.getElementById("capacityLabel");
            var customCapacity = document.getElementById("customCapacity");

            if (range) {
                customCapacity.style.display = "block";
                capacityLabel.style.display = "block";
                capacityLabel.innerText = "Enter an exact capacity within the range: " + range;
            } else {
                customCapacity.style.display = "none";
                capacityLabel.style.display = "none";
            }
            updateProgress();
        }

        function previewImage(input) {
            var file = input.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    var imagePreview = document.getElementById("imagePreview");
                    imagePreview.src = e.target.result;
                    imagePreview.style.display = "block";
                    updateProgress();
                };
                reader.readAsDataURL(file);
            }
        }

        function updateProgress() {
            var totalFields = 6;
            var completedFields = 0;
            var transactionType = document.getElementById('<%= ddlTransactionType.ClientID %>').value;

            if (document.getElementById('<%= txtModel.ClientID %>').value.trim() !== "") completedFields++;
            if (transactionType !== "") completedFields++;
            if (document.getElementById('<%= ddlCapacityRange.ClientID %>').value.trim() !== "") completedFields++;
            if (document.getElementById("customCapacity").style.display !== "none" && document.getElementById("customCapacity").value.trim() !== "") completedFields++;

            if (transactionType === "Both") {
                if (document.getElementById('<%= txtRentalPrice.ClientID %>').value.trim() !== "" && 
                    document.getElementById('<%= txtPurchasePrice.ClientID %>').value.trim() !== "") {
                    completedFields++;
                }
            } else {
                if (document.getElementById("rentalPriceContainer").style.display !== "none" && document.getElementById('<%= txtRentalPrice.ClientID %>').value.trim() !== "") completedFields++;
                if (document.getElementById("purchasePriceContainer").style.display !== "none" && document.getElementById('<%= txtPurchasePrice.ClientID %>').value.trim() !== "") completedFields++;
            }

            if (document.getElementById("imagePreview").style.display !== "none") completedFields++;

            var percent = (completedFields / totalFields) * 100;
            document.getElementById("progressBar").style.width = percent + "%";
            document.getElementById("progressBar").textContent = Math.round(percent) + "%";

            document.getElementById('<%= btnSubmit.ClientID %>').disabled = percent < 100;
        }
    </script>
</asp:Content>
