import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  
  Cart get cart => Cart(items: _items);

  int get itemCount => cart.itemCount;
  
  double get total => cart.total;

  void addItem(Product product, {int quantity = 1}) {
    final existingItem = _items.cast<CartItem?>().firstWhere(
      (item) => item?.product.id == product.id,
      orElse: () => null,
    );

    if (existingItem != null) {
      existingItem.quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final item = _items.cast<CartItem?>().firstWhere(
      (item) => item?.product.id == productId,
      orElse: () => null,
    );

    if (item != null) {
      item.quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity(int productId) {
    final item = _items.cast<CartItem?>().firstWhere(
      (item) => item?.product.id == productId,
      orElse: () => null,
    );

    if (item != null) {
      item.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    final item = _items.cast<CartItem?>().firstWhere(
      (item) => item?.product.id == productId,
      orElse: () => null,
    );

    if (item != null) {
      if (item.quantity > 1) {
        item.quantity--;
        notifyListeners();
      } else {
        removeItem(productId);
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool hasProduct(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int getProductQuantity(int productId) {
    final item = _items.cast<CartItem?>().firstWhere(
      (item) => item?.product.id == productId,
      orElse: () => null,
    );
    return item?.quantity ?? 0;
  }
}
