$(document).ready(function () {
    function initializeSelections() {
        var sellerType = $('#' + hfSellerTypeClientID).val();
        if (sellerType) {
            $('.seller-type-box').removeClass('selected');
            $('.seller-type-box[data-type="' + sellerType + '"]').addClass('selected');
            $('.seller-panel').hide();
            if (sellerType === 'Individual') {
                $('#' + pnlIndividualClientID).show();
            } else if (sellerType === 'Company') {
                $('#' + pnlCompanyClientID).show();
            }
        }

        var paymentMethods = $('#' + hfPaymentMethodsClientID).val();
        if (paymentMethods) {
            var methods = paymentMethods.split(',');
            $('.payment-method-box').removeClass('selected');
            methods.forEach(function (method) {
                $('.payment-method-box[data-method="' + method + '"]').addClass('selected');
            });
        }

        var aircraftTypes = $('#' + hfAircraftTypesClientID).val();
        if (aircraftTypes) {
            var types = aircraftTypes.split(',');
            $('.aircraft-type-box').removeClass('selected');
            types.forEach(function (type) {
                $('.aircraft-type-box[data-type="' + type + '"]').addClass('selected');
            });
        }

        var transactionType = $('#' + hfTransactionTypeClientID).val();
        if (transactionType) {
            $('.price-field').hide();
            if (transactionType === 'Buy') {
                $('#buyPricePanel').show();
            } else if (transactionType === 'Rent') {
                $('#rentPricePanel').show();
            }
        }

        var aircraftModel = $('#' + ddlAircraftModelClientID).val();
        if (aircraftModel === 'Other') {
            $('#' + customModelPanelClientID).show();
        }

        var manufacturer = $('#' + ddlManufacturerClientID).val();
        if (manufacturer === 'Other') {
            $('#' + customManufacturerPanelClientID).show();
        }

        updateDescriptionCounter();
    }

    initializeSelections();

    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        initializeSelections();
        bindEventHandlers();
    });

    function bindEventHandlers() {
        $('.seller-type-box').off('click').on('click', function () {
            $('.seller-type-box').removeClass('selected');
            $(this).addClass('selected');
            var sellerType = $(this).data('type');
            $('#' + hfSellerTypeClientID).val(sellerType);

            $('.seller-panel').hide();
            if (sellerType === 'Individual') {
                $('#' + pnlIndividualClientID).show();
                $('#' + pnlCompanyClientID).hide();
                resetValidators('CompanyValidation');
            } else if (sellerType === 'Company') {
                $('#' + pnlCompanyClientID).show();
                $('#' + pnlIndividualClientID).hide();
                resetValidators('IndividualValidation');
            }

            if (typeof (Page_Validators) !== 'undefined') {
                for (var i = 0; i < Page_Validators.length; i++) {
                    var validator = Page_Validators[i];
                    if (validator.id === cvSellerTypeClientID) {
                        validator.isvalid = true;
                        ValidatorUpdateDisplay(validator);
                    }
                    if (validator.id === cvLicenseClientID) {
                        ValidatorEnable(validator, sellerType === 'Individual');
                    }
                }
            }
        });

        $('.payment-method-box').off('click').on('click', function () {
            $(this).toggleClass('selected');
            updatePaymentMethods();
        });

        $('.aircraft-type-box').off('click').on('click', function () {
            $(this).toggleClass('selected');
            updateAircraftTypes();
        });

        $('#' + ddlContactMethodClientID).off('change').on('change', function () {
            var method = $(this).val();
            var $contactInfo = $('#' + txtContactInfoClientID);
            var $revEmail = document.getElementById(revEmailClientID);
            var $revPhone = document.getElementById(revPhoneClientID);
            var $phonePrefix = $('#' + phonePrefixID);

            $phonePrefix.hide();
            $contactInfo.removeAttr('maxlength');
            $contactInfo.attr('placeholder', '');
            $contactInfo.val('');

            if (typeof (Page_Validators) !== 'undefined') {
                for (var i = 0; i < Page_Validators.length; i++) {
                    var validator = Page_Validators[i];
                    if (validator.id === revEmailClientID || validator.id === revPhoneClientID) {
                        validator.isvalid = true;
                        ValidatorUpdateDisplay(validator);
                    }
                }
            }

            if ($revEmail && typeof (ValidatorEnable) === 'function') {
                ValidatorEnable($revEmail, false);
            }
            if ($revPhone && typeof (ValidatorEnable) === 'function') {
                ValidatorEnable($revPhone, false);
            }

            if (method === 'Email') {
                if ($revEmail && typeof (ValidatorEnable) === 'function') {
                    ValidatorEnable($revEmail, true);
                }
                $contactInfo.attr('placeholder', 'example@domain.com');
            } else if (method === 'Phone' || method === 'WhatsApp') {
                if ($revPhone && typeof (ValidatorEnable) === 'function') {
                    ValidatorEnable($revPhone, true);
                }
                $phonePrefix.show();
                $contactInfo.attr('maxlength', '9');
                $contactInfo.attr('placeholder', '5XXXXXXXX');
            }
        });

        $('#' + ddlAircraftModelClientID).off('change').on('change', function () {
            var aircraftModel = $(this).val();
            $('#' + customModelPanelClientID).hide();
            if (typeof (ValidatorEnable) === 'function') {
                ValidatorEnable(document.getElementById(rfvCustomAircraftModelClientID), false);
                var rfvCustom = document.getElementById(rfvCustomAircraftModelClientID);
                if (rfvCustom) {
                    rfvCustom.isvalid = true;
                    ValidatorUpdateDisplay(rfvCustom);
                }
            }
            if (aircraftModel === 'Other') {
                $('#' + customModelPanelClientID).show();
                if (typeof (ValidatorEnable) === 'function') {
                    ValidatorEnable(document.getElementById(rfvCustomAircraftModelClientID), true);
                }
            }
        });

        $('#' + ddlManufacturerClientID).off('change').on('change', function () {
            var manufacturer = $(this).val();
            $('#' + customManufacturerPanelClientID).hide();
            if (typeof (ValidatorEnable) === 'function') {
                ValidatorEnable(document.getElementById(rfvCustomManufacturerClientID), false);
                var rfvCustomManufacturer = document.getElementById(rfvCustomManufacturerClientID);
                if (rfvCustomManufacturer) {
                    rfvCustomManufacturer.isvalid = true;
                    ValidatorUpdateDisplay(rfvCustomManufacturer);
                }
            }
            if (manufacturer === 'Other') {
                $('#' + customManufacturerPanelClientID).show();
                if (typeof (ValidatorEnable) === 'function') {
                    ValidatorEnable(document.getElementById(rfvCustomManufacturerClientID), true);
                }
            }

            var $rfvManufacturer = document.getElementById(rfvManufacturerClientID);
            if ($rfvManufacturer && typeof (ValidatorEnable) === 'function') {
                ValidatorEnable($rfvManufacturer, true);
            }
        });

        $('#' + ddlTransactionTypeClientID).off('change').on('change', function () {
            var transactionType = $(this).val();
            $('#' + hfTransactionTypeClientID).val(transactionType);

            $('.price-field').hide();
            if (transactionType === 'Buy') {
                $('#buyPricePanel').show();
                $('#rentPricePanel').hide();
                if (typeof (ValidatorEnable) === 'function') {
                    ValidatorEnable(document.getElementById(rfvPurchasePriceClientID), true);
                    ValidatorEnable(document.getElementById(rvPurchasePriceClientID), true);
                    ValidatorEnable(document.getElementById(rfvRentalPriceClientID), false);
                    ValidatorEnable(document.getElementById(rvRentalPriceClientID), false);

                    var rfvRental = document.getElementById(rfvRentalPriceClientID);
                    var rvRental = document.getElementById(rvRentalPriceClientID);
                    if (rfvRental) {
                        rfvRental.isvalid = true;
                        ValidatorUpdateDisplay(rfvRental);
                    }
                    if (rvRental) {
                        rvRental.isvalid = true;
                        ValidatorUpdateDisplay(rvRental);
                    }
                }
                $('#' + txtRentalPriceClientID).val('');
            } else if (transactionType === 'Rent') {
                $('#rentPricePanel').show();
                $('#buyPricePanel').hide();
                if (typeof (ValidatorEnable) === 'function') {
                    ValidatorEnable(document.getElementById(rfvRentalPriceClientID), true);
                    ValidatorEnable(document.getElementById(rvRentalPriceClientID), true);
                    ValidatorEnable(document.getElementById(rfvPurchasePriceClientID), false);
                    ValidatorEnable(document.getElementById(rvPurchasePriceClientID), false);

                    var rfvPurchase = document.getElementById(rfvPurchasePriceClientID);
                    var rvPurchase = document.getElementById(rvPurchasePriceClientID);
                    if (rfvPurchase) {
                        rfvPurchase.isvalid = true;
                        ValidatorUpdateDisplay(rfvPurchase);
                    }
                    if (rvPurchase) {
                        rvPurchase.isvalid = true;
                        ValidatorUpdateDisplay(rvPurchase);
                    }
                }
                $('#' + txtPurchasePriceClientID).val('');
            }
        });

        $('#' + fuPhotosClientID).off('change').on('change', function () {
            var $preview = $('#' + photoPreviewID);
            $preview.empty();
            var file = this.files[0];

            if (!file || (!file.type.match('image/jpeg') && !file.type.match('image/png'))) {
                return;
            }

            var reader = new FileReader();
            reader.onload = function (e) {
                var $imgContainer = $('<div class="photo-container"></div>');
                var $img = $('<img src="' + e.target.result + '" alt="' + file.name + '" />');
                var $deleteBtn = $('<span class="delete-photo">×</span>');
                $imgContainer.append($img).append($deleteBtn);
                $preview.append($imgContainer);

                $deleteBtn.click(function () {
                    $(this).parent().remove();
                    $('#' + fuPhotosClientID).val('');
                });
            };
            reader.readAsDataURL(file);
        });

        $('#' + txtDescriptionClientID).off('input').on('input', function () {
            updateDescriptionCounter();
        });

        $('#' + btnSubmitClientID).off('click').on('click', function (e) {
            $('#' + lblMessageClientID).text('').removeClass('text-danger text-success');

            var sellerType = $('#' + hfSellerTypeClientID).val();
            var validationGroups = ['SellerTypeValidation'];

            if (sellerType === 'Individual') {
                validationGroups.push('IndividualValidation');
                resetValidators('CompanyValidation');
                var contactMethod = $('#' + ddlContactMethodClientID).val();
                if (contactMethod === 'Email') {
                    validationGroups.push('EmailValidation');
                } else if (contactMethod === 'Phone' || contactMethod === 'WhatsApp') {
                    validationGroups.push('PhoneValidation');
                }
            } else if (sellerType === 'Company') {
                validationGroups.push('CompanyValidation');
                resetValidators('IndividualValidation');
            }

            var transactionType = $('#' + hfTransactionTypeClientID).val();
            if (transactionType === 'Buy') {
                ValidatorEnable(document.getElementById(rfvPurchasePriceClientID), true);
                ValidatorEnable(document.getElementById(rvPurchasePriceClientID), true);
                ValidatorEnable(document.getElementById(rfvRentalPriceClientID), false);
                ValidatorEnable(document.getElementById(rvRentalPriceClientID), false);
                var rfvRental = document.getElementById(rfvRentalPriceClientID);
                var rvRental = document.getElementById(rvRentalPriceClientID);
                if (rfvRental) {
                    rfvRental.isvalid = true;
                    ValidatorUpdateDisplay(rfvRental);
                }
                if (rvRental) {
                    rvRental.isvalid = true;
                    ValidatorUpdateDisplay(rvRental);
                }
            } else if (transactionType === 'Rent') {
                ValidatorEnable(document.getElementById(rfvRentalPriceClientID), true);
                ValidatorEnable(document.getElementById(rvRentalPriceClientID), true);
                ValidatorEnable(document.getElementById(rfvPurchasePriceClientID), false);
                ValidatorEnable(document.getElementById(rvPurchasePriceClientID), false);
                var rfvPurchase = document.getElementById(rfvPurchasePriceClientID);
                var rvPurchase = document.getElementById(rvPurchasePriceClientID);
                if (rfvPurchase) {
                    rfvPurchase.isvalid = true;
                    ValidatorUpdateDisplay(rfvPurchase);
                }
                if (rvPurchase) {
                    rvPurchase.isvalid = true;
                    ValidatorUpdateDisplay(rvPurchase);
                }
            }

            validationGroups.push('CommonValidation');

            var isValid = true;
            validationGroups.forEach(function (group) {
                if (typeof (Page_ClientValidate) === 'function') {
                    Page_ClientValidate(group);
                    if (!Page_IsValid) {
                        isValid = false;
                    }
                }
            });

            if (!isValid) {
                scrollToFirstError();
                return false;
            }

            if (!confirm('Are you sure you want to submit the application?')) {
                return false;
            }

            return true;
        });
    }

    bindEventHandlers();

    function resetValidators(validationGroup) {
        if (typeof (Page_Validators) !== 'undefined') {
            for (var i = 0; i < Page_Validators.length; i++) {
                var validator = Page_Validators[i];
                if (validator.validationGroup === validationGroup) {
                    validator.isvalid = true;
                    ValidatorUpdateDisplay(validator);
                }
            }
        }
    }

    function updatePaymentMethods() {
        var selectedMethods = [];
        $('.payment-method-box.selected').each(function () {
            selectedMethods.push($(this).data('method'));
        });
        $('#' + hfPaymentMethodsClientID).val(selectedMethods.join(','));
    }

    function updateAircraftTypes() {
        var selectedTypes = [];
        $('.aircraft-type-box.selected').each(function () {
            selectedTypes.push($(this).data('type'));
        });
        $('#' + hfAircraftTypesClientID).val(selectedTypes.join(','));
    }

    function updateDescriptionCounter() {
        var description = $('#' + txtDescriptionClientID).val();
        var charCount = description ? description.length : 0;
        var $counter = $('#' + descriptionCounterID);
        $counter.text(charCount + '/30');
        if (charCount >= 30) {
            $counter.removeClass('text-danger').addClass('text-success');
        } else {
            $counter.removeClass('text-success').addClass('text-danger');
        }

        if (typeof (Page_Validators) !== 'undefined') {
            for (var i = 0; i < Page_Validators.length; i++) {
                var validator = Page_Validators[i];
                if (validator.id === cvDescriptionLengthClientID) {
                    validator.isvalid = charCount >= 30;
                    ValidatorUpdateDisplay(validator);
                }
            }
        }
    }

    function scrollToFirstError() {
        var $firstError = $('.text-danger:visible').first();
        if ($firstError.length > 0) {
            $('html, body').animate({
                scrollTop: $firstError.offset().top - 100
            }, 500);
        }
    }

    window.validateSellerType = function (source, args) {
        args.IsValid = $('#' + hfSellerTypeClientID).val() !== '';
    };

    window.validatePaymentMethods = function (source, args) {
        var selectedMethods = $('#' + hfPaymentMethodsClientID).val();
        args.IsValid = selectedMethods !== '';
    };

    window.validateAircraftTypes = function (source, args) {
        var selectedTypes = $('#' + hfAircraftTypesClientID).val();
        args.IsValid = selectedTypes !== '';
    };

    window.validatePhotos = function (source, args) {
        var fileUpload = document.getElementById(fuPhotosClientID);
        if (!fileUpload || !fileUpload.files || fileUpload.files.length === 0) {
            source.errormessage = "Please upload one photo.";
            args.IsValid = false;
            return;
        }

        var file = fileUpload.files[0];
        var maxFileSize = 5 * 1024 * 1024;
        var allowedExtensions = ['jpg', 'jpeg', 'png'];

        var extension = file.name.split('.').pop().toLowerCase();
        if (!allowedExtensions.includes(extension)) {
            source.errormessage = "Only JPG/PNG files are allowed.";
            args.IsValid = false;
            return;
        }
        if (file.size > maxFileSize) {
            source.errormessage = "The file must be less than 5MB.";
            args.IsValid = false;
            return;
        }

        args.IsValid = true;
    };

    window.validateLicense = function (source, args) {
        var sellerType = $('#' + hfSellerTypeClientID).val();
        if (sellerType === 'Company') {
            args.IsValid = true;
            return;
        }

        var fileUpload = document.getElementById(fuLicenseClientID);
        if (!fileUpload || !fileUpload.files || fileUpload.files.length === 0) {
            source.errormessage = "Please upload a license file (PDF/Word).";
            args.IsValid = false;
            return;
        }

        var file = fileUpload.files[0];
        var allowedExtensions = ['pdf', 'doc', 'docx'];
        var extension = file.name.split('.').pop().toLowerCase();
        if (!allowedExtensions.includes(extension)) {
            source.errormessage = "Only PDF or Word files are allowed.";
            args.IsValid = false;
            return;
        }

        args.IsValid = true;
    };

    window.validateDescriptionLength = function (source, args) {
        var description = $('#' + txtDescriptionClientID).val();
        var charCount = description ? description.length : 0;
        args.IsValid = charCount >= 30;
        if (!args.IsValid) {
            source.errormessage = "Description must be at least 30 characters.";
        }
    };
});