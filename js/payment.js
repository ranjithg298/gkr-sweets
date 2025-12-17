// payment.js – Razorpay integration for UPI, Wallets, and Cards

// Load Razorpay script dynamically
function loadRazorpayScript() {
    return new Promise((resolve) => {
        if (window.Razorpay) {
            resolve(true);
            return;
        }
        const script = document.createElement('script');
        script.src = 'https://checkout.razorpay.com/v1/checkout.js';
        script.onload = () => resolve(true);
    }

    return new Promise((resolve, reject) => {
        const options = {
            "key": RAZORPAY_KEY_ID,
            "amount": Math.round(amount * 100), // Amount in paise
            "currency": "INR",
            "name": "GKR Sweets",
            "description": "Payment for " + productDetails.name,
            "image": "https://via.placeholder.com/150?text=GKR", // Replace with actual logo
            "handler": function (response) {
                // Payment Success
                console.log("Payment Successful:", response);

                // Here we would call our backend to verify and save the order
                // For this static demo, we'll simulate a save to Supabase directly if configured
                // or just alert success.

                alert("Payment Successful! Payment ID: " + response.razorpay_payment_id);
                resolve(response);
            },
            "prefill": {
                "name": "", // Should come from form
                "email": "",
                "contact": ""
            },
            "notes": {
                "address": "Customer Address"
            },
            "theme": {
                "color": "#F37254"
            },
            "modal": {
                "ondismiss": function () {
                    console.log('Checkout form closed');
                    reject(new Error('Payment cancelled by user'));
                }
            }
        };

        const rzp1 = new Razorpay(options);

        // Handle payment failure
        rzp1.on('payment.failed', function (response) {
            console.error("Payment Failed:", response.error);
            alert("Payment Failed: " + response.error.description);
            reject(response.error);
        });

        rzp1.open();
    });
}

// Expose to global scope
window.initiatePayment = initiatePayment;
