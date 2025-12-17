import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../core/constants.dart';

class PaymentService {
  late Razorpay _razorpay;
  Function(Map<String, dynamic>)? onSuccess;
  Function(Map<String, dynamic>)? onFailure;

  PaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (onSuccess != null) {
      onSuccess!({
        'payment_id': response.paymentId,
        'order_id': response.orderId,
        'signature': response.signature,
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (onFailure != null) {
      onFailure!({
        'code': response.code,
        'message': response.message,
      });
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  void startPayment({
    required double amount,
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required Function(Map<String, dynamic>) onPaymentSuccess,
    required Function(Map<String, dynamic>) onPaymentFailure,
  }) {
    onSuccess = onPaymentSuccess;
    onFailure = onPaymentFailure;

    var options = {
      'key': AppConstants.razorpayKeyId,
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': AppConstants.appName,
      'order_id': orderId,
      'description': 'Order Payment',
      'prefill': {
        'contact': customerPhone,
        'email': customerEmail,
        'name': customerName,
      },
      'theme': {
        'color': '#D4AF37', // Gold color from AppColors
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error starting payment: $e');
      onPaymentFailure(
          {'message': 'Failed to start payment', 'error': e.toString()});
    }
  }

  void dispose() {
    _razorpay.clear();
  }

  String generateUpiString({
    required String upiId,
    required String name,
    required double amount,
    required String orderId,
  }) {
    return 'upi://pay?pa=$upiId&pn=$name&am=$amount&tr=$orderId&cu=INR';
  }
}
