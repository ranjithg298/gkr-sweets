import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  
  String get formattedTotal => '₹${totalPrice.toStringAsFixed(0)}';

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'quantity': quantity,
      'price': product.price,
    };
  }
}

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  
  double get deliveryCharge => subtotal > 500 ? 0 : 40;
  
  double get total => subtotal + deliveryCharge;
  
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(0)}';
  String get formattedDelivery => deliveryCharge == 0 ? 'FREE' : '₹${deliveryCharge.toStringAsFixed(0)}';
  String get formattedTotal => '₹${total.toStringAsFixed(0)}';

  bool get isEmpty => items.isEmpty;
  
  bool get isNotEmpty => items.isNotEmpty;

  CartItem? findItem(int productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  bool hasProduct(int productId) {
    return findItem(productId) != null;
  }
}
