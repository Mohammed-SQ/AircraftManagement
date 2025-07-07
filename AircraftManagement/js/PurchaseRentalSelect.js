var formState = { aircraftId: '' };

document.addEventListener('DOMContentLoaded', function () {
    // Removed updateTransactionType call since transaction type is now fetched from the database
});

function changeAircraft(dropdown) {
    var aircraftId = dropdown.value;
    if (aircraftId) {
        window.location.href = 'PurchaseRentalSelect.aspx?AircraftID=' + encodeURIComponent(aircraftId);
    }
}

function confirmAndMoveToStep(step) {
    var aircraft = document.getElementById('ddlAircrafts').value;
    if (!aircraft) {
        document.getElementById('MainContent_rfvAircraft').style.display = 'block';
        return false;
    }
    return true;
}