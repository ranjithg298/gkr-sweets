// Supported Wallets and their Razorpay Codes

module.exports = {
    wallets: {
        'gpay': 'google_pay',
        'phonepe': 'phonepe',
        'paytm': 'paytm',
        'amazonpay': 'amazon_pay',
        'freecharge': 'freecharge',
        'mobikwik': 'mobikwik',
        'airtelmoney': 'airtel_money',
        'jio': 'jiomoney',
        'ola': 'olamoney'
    },

    getWalletCode: function (walletName) {
        return this.wallets[walletName.toLowerCase()] || null;
    }
};
