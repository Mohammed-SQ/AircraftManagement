// WhatsApp (UltraMsg) Configuration
var ultraMsgPhoneNumber = "+966530280722";
var ultraMsgToken = "th7yaknochdm6lkc";
var ultraMsgInstanceId = "instance112181";
var ultraMsgBaseUrl = "https://api.ultramsg.com/";
var ultrasendUrl = ultraMsgBaseUrl + ultraMsgInstanceId + "/messages/chat";

// Email (SMTP) Configuration
var smtpUsername = "aircraftmanagementofficial@gmail.com";
var smtpPassword = "ecfvuvienrhfkcob";

function getUltraMsgUrl(phoneNumber, messageBody) {
    var formattedPhone = phoneNumber.startsWith("+") ? phoneNumber.substring(1) : phoneNumber;
    var encodedMessage = encodeURIComponent(messageBody);
    var queryParams = "token=" + ultraMsgToken + "&to=" + formattedPhone + "&body=" + encodedMessage + "&priority=1";
    return ultrasendUrl + "?" + queryParams;
}

async function sendWhatsAppMessage(phoneNumber, messageBody) {
    var formattedPhone = phoneNumber.startsWith("+") ? phoneNumber.substring(1) : phoneNumber;
    var formData = new URLSearchParams({
        token: ultraMsgToken,
        to: formattedPhone,
        body: messageBody,
        priority: "1"
    });

    try {
        var response = await fetch(ultrasendUrl, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        });
        var result = await response.text();
        console.log("WhatsApp response:", result);
        return result.includes("sent") ? "Message sent successfully" : "Failed to send message: " + result;
    } catch (error) {
        console.error("WhatsApp error:", error);
        return "Error sending message: " + error.message;
    }
}

function getEmailConfig() {
    return {
        username: smtpUsername,
        password: smtpPassword
    };
}

window.Authentication = {
    getUltraMsgUrl: getUltraMsgUrl,
    sendWhatsAppMessage: sendWhatsAppMessage,
    getEmailConfig: getEmailConfig,
    getUltraMsgToken: function () { return ultraMsgToken; },
    getUltraMsgInstanceId: function () { return ultraMsgInstanceId; },
    getUltraMsgBaseUrl: function () { return ultraMsgBaseUrl; }
};