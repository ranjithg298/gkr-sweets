const config = require('./config');
const Razorpay = require('razorpay');
const { createClient } = require('@supabase/supabase-js');

// Initialize Supabase
const supabase = createClient(config.supabase.url, config.supabase.key);

// Initialize Razorpay
const razorpay = new Razorpay({
    key_id: config.razorpay.key_id,
    key_secret: config.razorpay.key_secret
});

async function createOrder(amount, currency = 'INR', receipt) {
    try {
        const options = {
            amount: amount * 100, // amount in smallest currency unit
            currency,
            receipt,
            payment_capture: 1
        };
        const order = await razorpay.orders.create(options);
        return order;
    } catch (error) {
        console.error('Error creating Razorpay order:', error);
        throw error;
    }
}

async function verifyPayment(paymentId, orderId, signature) {
    const crypto = require('crypto');
    const generated_signature = crypto.createHmac('sha256', config.razorpay.key_secret)
        .update(orderId + "|" + paymentId)
        .digest('hex');

    if (generated_signature === signature) {
        return true;
    }
    return false;
}

async function saveOrderToSupabase(orderDetails) {
    const { data, error } = await supabase
        .from('orders')
        .insert([orderDetails]);

    if (error) {
        console.error('Error saving order to Supabase:', error);
        throw error;
    }
    return data;
}

module.exports = {
    createOrder,
    verifyPayment,
    saveOrderToSupabase
};
