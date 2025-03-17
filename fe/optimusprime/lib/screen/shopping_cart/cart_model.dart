import 'package:flutter/material.dart';
import 'package:optimusprime/screen/products/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  double get totalAmount {
    return _items.values
        .fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void addItem(Product product, int quantity) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: quantity),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId) && newQuantity > 0) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: newQuantity,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
