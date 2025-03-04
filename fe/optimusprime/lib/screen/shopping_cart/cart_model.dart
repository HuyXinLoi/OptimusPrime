import 'package:flutter/material.dart';
import 'package:optimusprime/screen/products/products_screen.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get totalPrice {
    final priceString =
        product.price.replaceAll(' VNĐ', '').replaceAll(',', '');
    return (double.tryParse(priceString) ?? 0.0) * quantity;
  }
}

class Cart with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  void addItem(Product product, int quantity) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (_items.contains(existingItem)) {
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

  void updateQuantity(int productId, int newQuantity) {
    final item = _items.firstWhere((item) => item.product.id == productId);
    if (newQuantity <= 0) {
      removeItem(productId);
    } else {
      item.quantity = newQuantity;
      notifyListeners();
    }
  }

  double get totalAmount {
    return _items.fold(0.0, (total, item) => total + item.totalPrice);
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
