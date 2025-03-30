import 'package:optimusprime/screen/home/models/category.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final int quantity;
  final String image;
  final List<Category> categories;
  final String?
      categoryId; // Thêm trường categoryId để xử lý trường hợp có category nhưng không có categories
  final double discount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.image,
    required this.categories,
    this.categoryId,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
  });

  // Cập nhật phương thức fromJson để xử lý cấu trúc mới
  factory Product.fromJson(Map<String, dynamic> json) {
    List<Category> categoryList = [];
    if (json['categories'] != null &&
        json['categories'] is List &&
        (json['categories'] as List).isNotEmpty) {
      categoryList = (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList();
    }

    return Product(
      id: json['_id'],
      name: json['name'],
      price: json['price'] is int
          ? (json['price'] as int).toDouble()
          : json['price'],
      description: json['description'],
      quantity: json['quantity'],
      image: json['image'],
      categories: categoryList,
      categoryId: json['category']?.toString(),
      discount: json['discount'] is int
          ? (json['discount'] as int).toDouble()
          : (json['discount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Cập nhật getter brand để xử lý trường hợp categories rỗng
  String get brand {
    if (categories.isEmpty) {
      return 'Không xác định';
    }

    final brandCategory = categories.firstWhere(
      (category) => category.type == 'hang',
      orElse: () => Category(
        id: '',
        name: 'Không xác định',
        type: 'hang',
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return brandCategory.name;
  }

  // Cập nhật getter vehicleType để xử lý trường hợp categories rỗng
  String get vehicleType {
    if (categories.isEmpty) {
      return 'Không xác định';
    }

    final typeCategory = categories.firstWhere(
      (category) => category.type == 'loai_xe',
      orElse: () => Category(
        id: '',
        name: 'Không xác định',
        type: 'loai_xe',
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return typeCategory.name;
  }

  // Kiểm tra xem sản phẩm có phải là mới không (dựa vào thời gian tạo)
  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays <
        30; // Sản phẩm được coi là mới nếu tạo trong vòng 30 ngày
  }

  // Tính giá sau khi giảm giá
  double get discountedPrice {
    return price - (price * discount / 100);
  }
}
