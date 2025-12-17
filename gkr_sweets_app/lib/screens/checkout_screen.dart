import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/constants.dart';
import '../providers/cart_provider.dart';
import '../services/payment_service.dart';
import '../services/supabase_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  final PaymentService _paymentService = PaymentService();
  final SupabaseService _supabaseService = SupabaseService();
  
  String _paymentMethod = 'razorpay';
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _paymentService.dispose();
    super.dispose();
  }

  Future<void> _processOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final cart = context.read<CartProvider>().cart;
    
    // Create order in database
    final order = await _supabaseService.createOrder(
      customerName: _nameController.text,
      customerEmail: _emailController.text,
      customerPhone: _phoneController.text,
      address: _addressController.text,
      items: cart.items.map((item) => item.toJson()).toList(),
      totalAmount: cart.total,
      paymentMethod: _paymentMethod,
    );

    if (order == null) {
      setState(() => _isProcessing = false);
      _showError('Failed to create order');
      return;
    }

    if (_paymentMethod == 'razorpay') {
      _paymentService.startPayment(
        amount: cart.total,
        orderId: order['id'].toString(),
        customerName: _nameController.text,
        customerEmail: _emailController.text,
        customerPhone: _phoneController.text,
        onPaymentSuccess: (response) async {
          await _supabaseService.updateOrderStatus(order['id'], 'paid');
          context.read<CartProvider>().clearCart();
          _showSuccess();
        },
        onPaymentFailure: (response) {
          setState(() => _isProcessing = false);
          _showError(response['message'] ?? 'Payment failed');
        },
      );
    } else {
      // UPI QR Code payment
      _showQRCodeDialog(cart.total, order['id'].toString());
    }
  }

  void _showQRCodeDialog(double amount, String orderId) {
    final upiString = _paymentService.generateUpiString(
      upiId: 'gkrsweets@upi', // Replace with actual UPI ID
      name: 'GKR Sweets',
      amount: amount,
      orderId: orderId,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Scan QR Code to Pay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: upiString,
              version: QrVersions.auto,
              size: 250,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text('Amount: ₹${amount.toStringAsFixed(0)}', style: AppTextStyles.heading3),
            const SizedBox(height: AppDimensions.paddingSmall),
            const Text(
              'Scan with any UPI app to complete payment',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isProcessing = false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _supabaseService.updateOrderStatus(int.parse(orderId), 'paid');
              context.read<CartProvider>().clearCart();
              _showSuccess();
            },
            child: const Text('I have paid'),
          ),
        ],
      ),
    );
  }

  void _showSuccess() {
    setState(() => _isProcessing = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: 8),
            Text('Order Placed!'),
          ],
        ),
        content: const Text('Your order has been placed successfully. We will deliver it soon!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          children: [
            const Text('Delivery Details', style: AppTextStyles.heading2),
            const SizedBox(height: AppDimensions.paddingMedium),
            
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Delivery Address'),
              maxLines: 3,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            
            const SizedBox(height: AppDimensions.paddingLarge),
            const Text('Payment Method', style: AppTextStyles.heading2),
            const SizedBox(height: AppDimensions.paddingSmall),
            
            RadioListTile(
              title: const Text('Razorpay (Card/UPI/Wallet)'),
              value: 'razorpay',
              groupValue: _paymentMethod,
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            RadioListTile(
              title: const Text('UPI QR Code'),
              value: 'upi_qr',
              groupValue: _paymentMethod,
              onChanged: (v) => setState(() => _paymentMethod = v!),
            ),
            
            const SizedBox(height: AppDimensions.paddingLarge),
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Items', style: AppTextStyles.bodyLarge),
                      Text('${cart.itemCount}', style: AppTextStyles.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: AppTextStyles.bodyLarge),
                      Text(cart.formattedSubtotal, style: AppTextStyles.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery', style: AppTextStyles.bodyLarge),
                      Text(cart.formattedDelivery, style: AppTextStyles.bodyLarge),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: AppTextStyles.heading3),
                      Text(cart.formattedTotal, style: AppTextStyles.price),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingLarge),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processOrder,
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
