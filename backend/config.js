// Configuration for Backend Services
// REPLACE THESE WITH YOUR ACTUAL KEYS

module.exports = {
    razorpay: {
        key_id: process.env.RAZORPAY_KEY_ID || 'rzp_test_RkrGSzXx0GtFhx',
        key_secret: process.env.RAZORPAY_KEY_SECRET || 'bNWPSH1bJUvQnVKJ2objk355'
    },
    supabase: {
        url: process.env.SUPABASE_URL || 'YOUR_SUPABASE_URL',
        key: process.env.SUPABASE_KEY || 'YOUR_SUPABASE_ANON_KEY'
    }
};
