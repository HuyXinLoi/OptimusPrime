class Motorcycle {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? discount;
  final bool isNew;
  final double rating;
  final int reviewCount;
  final String brand;
  final String category;

  Motorcycle({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.discount,
    this.isNew = false,
    required this.rating,
    required this.reviewCount,
    required this.brand,
    required this.category,
  });

  factory Motorcycle.fromJson(Map<String, dynamic> json) {
    return Motorcycle(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      price: json['price'].toDouble(),
      discount: json['discount']?.toDouble(),
      isNew: json['is_new'] ?? false,
      rating: json['rating'].toDouble(),
      reviewCount: json['review_count'],
      brand: json['brand'],
      category: json['category'],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }
}

class Brand {
  final int id;
  final String name;
  final String? logoUrl;

  Brand({
    required this.id,
    required this.name,
    this.logoUrl,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logo_url'],
    );
  }
}
