// Initialize form state from localStorage or set defaults
var formState = {
    startDate: '',
    endDate: '',
    customerType: 'Individual',
    numberOfPassengers: '1',
    companyName: '',
    companyRepresentative: '',
    purposeOfUse: '',
    totalAmount: '0.00',
    chkMeals: false,
    chkWiFi: false,
    chkBoarding: false,
    chkInsurance: true, // Default to true as per the UI
    chkConcierge: false,
    chkCatering: false,
    chkAttendant: false,
    chkNavigation: true, // Default to true as per the UI
    chkEntertainment: false,
    chkClimateControl: false
};

// Load form state from localStorage if available
try {
    var storedState = localStorage.getItem('formState');
    if (storedState) {
        formState = JSON.parse(storedState);
    }
} catch (e) {
    console.warn("Failed to load formState from localStorage:", e);
}

document.addEventListener('DOMContentLoaded', function () {
    // Initialize Flatpickr for date inputs
    flatpickr("#txtStartDate", {
        minDate: "today",
        defaultDate: formState.startDate || "today",
        dateFormat: "Y-m-d",
        onChange: function (selectedDates, dateStr) {
            flatpickr("#txtEndDate").set('minDate', dateStr);
            formState.startDate = dateStr;
            updatePrice();
        }
    });

    flatpickr("#txtEndDate", {
        minDate: "today",
        defaultDate: formState.endDate || null,
        dateFormat: "Y-m-d",
        onChange: function (selectedDates, dateStr) {
            formState.endDate = dateStr;
            updatePrice();
        }
    });

    // Restore form state
    var ddlCustomerType = document.getElementById('ddlCustomerType');
    if (ddlCustomerType) {
        ddlCustomerType.value = formState.customerType;
    }

    // Restore checkbox states
    const checkboxIds = [
        'chkMeals', 'chkWiFi', 'chkBoarding', 'chkInsurance',
        'chkConcierge', 'chkCatering', 'chkAttendant',
        'chkNavigation', 'chkEntertainment', 'chkClimateControl'
    ];
    checkboxIds.forEach(id => {
        const checkbox = document.getElementById(id);
        if (checkbox) {
            checkbox.checked = formState[id];
        }
    });

    // Restore text inputs
    const txtPurposeOfUse = document.getElementById('txtPurposeOfUse');
    if (txtPurposeOfUse) txtPurposeOfUse.value = formState.purposeOfUse;
    const txtCompanyName = document.getElementById('txtCompanyName');
    if (txtCompanyName) txtCompanyName.value = formState.companyName;
    const txtCompanyRepresentative = document.getElementById('txtCompanyRepresentative');
    if (txtCompanyRepresentative) txtCompanyRepresentative.value = formState.companyRepresentative;

    // Initialize UI
    updateCompanyOptions();
    updatePassengerOptions();
    updatePrice();
    updateSelectionStyles();
});

function updateCompanyOptions() {
    var isCompany = document.getElementById('ddlCustomerType').value === 'Company';
    var companyOptions = document.getElementById('companyOptions');
    if (companyOptions) {
        companyOptions.style.display = isCompany ? 'flex' : 'none';
    }
    formState.customerType = document.getElementById('ddlCustomerType').value;

    // Enable/disable validators
    var rfvCompanyName = document.getElementById('rfvCompanyName');
    var rfvCompanyRepresentative = document.getElementById('rfvCompanyRepresentative');
    if (rfvCompanyName) rfvCompanyName.disabled = !isCompany;
    if (rfvCompanyRepresentative) rfvCompanyRepresentative.disabled = !isCompany;
}

function updatePassengerOptions() {
    var capacity = parseInt(document.getElementById('hdnCapacity').value) || 4;
    var ddl = document.getElementById('ddlNumberOfPassengers');
    if (!ddl) {
        console.error('ddlNumberOfPassengers element not found');
        return;
    }

    ddl.innerHTML = '';
    for (var i = 1; i <= capacity; i++) {
        var cost = formState.customerType === 'Individual' && i > 1 ? (i - 1) * 188 : 0;
        var text = cost > 0 ? `${i} (+${cost} SR)` : i.toString();
        ddl.options.add(new Option(text, i));
    }
    ddl.value = formState.numberOfPassengers || '1';
}

function confirmAndMoveToStep(step) {
    var isValid = true;
    var transactionType = '<%= Session["TransactionType"] %>';
    if (transactionType === 'Rent') {
        if (!document.getElementById('txtStartDate').value) {
            isValid = false;
            var rfvStartDate = document.getElementById('rfvStartDate');
            if (rfvStartDate) rfvStartDate.style.display = 'block';
        }
        if (!document.getElementById('txtEndDate').value) {
            isValid = false;
            var rfvEndDate = document.getElementById('rfvEndDate');
            if (rfvEndDate) rfvEndDate.style.display = 'block';
        }
    }
    if (!document.getElementById('txtPurposeOfUse').value) {
        isValid = false;
        var rfvPurposeOfUse = document.getElementById('rfvPurposeOfUse');
        if (rfvPurposeOfUse) rfvPurposeOfUse.style.display = 'block';
    }
    if (formState.customerType === 'Company') {
        var companyName = document.getElementById('txtCompanyName').value;
        var companyRep = document.getElementById('txtCompanyRepresentative').value;
        if (!companyName) {
            isValid = false;
            var rfvCompanyName = document.getElementById('rfvCompanyName');
            if (rfvCompanyName) rfvCompanyName.style.display = 'block';
        }
        if (!companyRep) {
            isValid = false;
            var rfvCompanyRepresentative = document.getElementById('rfvCompanyRepresentative');
            if (rfvCompanyRepresentative) rfvCompanyRepresentative.style.display = 'block';
        }
        if (companyName && !/^[a-zA-Z0-9\s&.,'-]{2,50}$/.test(companyName)) {
            isValid = false;
            alert("Company name must be 2-50 characters and contain only letters, numbers, and basic punctuation.");
        }
        if (companyRep && !/^[a-zA-Z\s'-]{2,50}$/.test(companyRep)) {
            isValid = false;
            alert("Company representative must be 2-50 characters and contain only letters and basic punctuation.");
        }
    }
    if (isValid) {
        // Update formState with current text inputs
        formState.purposeOfUse = document.getElementById('txtPurposeOfUse').value;
        formState.companyName = document.getElementById('txtCompanyName').value;
        formState.companyRepresentative = document.getElementById('txtCompanyRepresentative').value;
        try {
            localStorage.setItem('formState', JSON.stringify(formState));
        } catch (e) {
            console.warn("Failed to save formState to localStorage:", e);
        }
    }
    return isValid;
}

function updateSelectionStyles() {
    const checkboxIds = [
        'chkMeals', 'chkWiFi', 'chkBoarding', 'chkInsurance',
        'chkConcierge', 'chkCatering', 'chkAttendant',
        'chkNavigation', 'chkEntertainment', 'chkClimateControl'
    ];

    checkboxIds.forEach(id => {
        const checkbox = document.getElementById(id);
        if (checkbox) {
            const featureOption = checkbox.closest('.feature-option');
            if (featureOption) {
                if (checkbox.checked) {
                    featureOption.classList.add('selected');
                } else {
                    featureOption.classList.remove('selected');
                }
            }
        }
    });
}

function updatePrice() {
    try {
        var transactionType = '<%= Session["TransactionType"] %>';
        console.log('Transaction Type:', transactionType);

        // Get base price from hidden fields
        var basePrice = transactionType === 'Purchase' ?
            parseFloat(document.getElementById('hdnPurchasePrice').value) :
            parseFloat(document.getElementById('hdnRentalPrice').value);
        if (isNaN(basePrice)) {
            console.error('Base price is not a number:', basePrice);
            basePrice = 0;
        }
        console.log('Base Price:', basePrice);

        // Calculate rental days for 'Rent' transaction type
        if (transactionType === 'Rent' && formState.startDate && formState.endDate) {
            var startDate = new Date(formState.startDate);
            var endDate = new Date(formState.endDate);
            var rentalDays = Math.max((endDate - startDate) / (1000 * 60 * 60 * 24), 1);
            basePrice *= rentalDays;
            if (rentalDays > 14) basePrice *= 1.2; // 20% surcharge for long-term rentals
            console.log('Rental Days:', rentalDays, 'Adjusted Base Price:', basePrice);
        }

        // Update formState with current checkbox states
        formState.chkMeals = document.getElementById('chkMeals').checked;
        formState.chkWiFi = document.getElementById('chkWiFi').checked;
        formState.chkBoarding = document.getElementById('chkBoarding').checked;
        formState.chkInsurance = document.getElementById('chkInsurance').checked;
        formState.chkConcierge = document.getElementById('chkConcierge').checked;
        formState.chkCatering = document.getElementById('chkCatering').checked;
        formState.chkAttendant = document.getElementById('chkAttendant').checked;
        formState.chkNavigation = document.getElementById('chkNavigation').checked;
        formState.chkEntertainment = document.getElementById('chkEntertainment').checked;
        formState.chkClimateControl = document.getElementById('chkClimateControl').checked;

        console.log('Checkbox States:', formState);

        // Calculate extra costs based on selections
        var extraCost = (formState.chkMeals ? 375 : 0) +
            (formState.chkWiFi ? 188 : 0) +
            (formState.chkBoarding ? 281 : 0) +
            (formState.chkInsurance ? 300 : 0) +
            (formState.chkEntertainment ? 750 : 0) +
            (formState.chkClimateControl ? 563 : 0) +
            (formState.chkConcierge ? 750 : 0) +
            (formState.chkCatering ? 563 : 0) +
            (formState.chkAttendant ? 938 : 0);
        console.log('Extra Cost:', extraCost);

        // Calculate passenger cost
        var ddlNumberOfPassengers = document.getElementById('ddlNumberOfPassengers');
        if (!ddlNumberOfPassengers) {
            console.error('ddlNumberOfPassengers element not found');
            return;
        }
        formState.numberOfPassengers = ddlNumberOfPassengers.value;
        var passengerCost = formState.customerType === 'Individual' && parseInt(formState.numberOfPassengers) > 1 ? (parseInt(formState.numberOfPassengers) - 1) * 188 : 0;
        console.log('Passenger Cost:', passengerCost);

        // Calculate total
        var total = basePrice + extraCost + passengerCost;
        var hdnTotalAmount = document.getElementById('hdnTotalAmount');
        if (hdnTotalAmount) {
            hdnTotalAmount.value = total.toFixed(2);
        } else {
            console.error('hdnTotalAmount element not found');
        }
        formState.totalAmount = total.toFixed(2);

        // Update UI to display total
        var totalDisplay = document.getElementById('totalAmountDisplay');
        if (totalDisplay) {
            totalDisplay.innerText = 'Total: ' + total.toFixed(2) + ' SR';
        } else {
            console.error('totalAmountDisplay element not found');
        }

        // Update selection styles
        updateSelectionStyles();

        // Debug: Log the total for verification
        console.log('Total Amount:', total.toFixed(2));
    } catch (error) {
        console.error('Error in updatePrice:', error);
    }
}