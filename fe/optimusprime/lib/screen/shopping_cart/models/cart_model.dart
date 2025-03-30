class CartItem {
  final String id;
  final String productId;
  final String name;
  final String image;
  final double price;
  final double originalPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.originalPrice,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'] ?? '',
      productId: json['product']['_id'] ?? '',
      name: json['product']['name'] ?? '',
      image: json['product']['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['product']['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }
}

class Cart {
  final String id;
  final List<CartItem> items;
  final double totalPrice;

  Cart({
    required this.id,
    required this.items,
    required this.totalPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<CartItem> items = [];
    if (json['items'] != null) {
      items = (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
    }

    return Cart(
      id: json['_id'] ?? '',
      items: items,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  factory Cart.empty() {
    return Cart(
      id: '',
      items: [],
      totalPrice: 0,
    );
  }
}
