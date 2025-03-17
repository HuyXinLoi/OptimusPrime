import 'package:optimusprime/screen/products/category_model.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final int quantity;
  final String image;
  final Category category;
  final int discount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.image,
    required this.category,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      description: json["description"] ?? "",
      quantity: json["quantity"] ?? 0,
      image: json["image"] ?? "",
      category: json["category"] != null
          ? Category.fromJson(json["category"])
          : Category(id: "", name: "Unknown", type: "", description: ""),
      discount: json["discount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "price": price,
      "description": description,
      "quantity": quantity,
      "image": image,
      "discount": discount,
    };
  }
}
