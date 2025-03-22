import 'package:optimusprime/screen/home/models/category.dart';

class ProductDetail {
  final String id;
  final String name;
  final double price;
  final String description;
  final int quantity;
  final String image;
  final List<String> images; // Thêm danh sách hình ảnh
  final List<Category> categories;
  final String? categoryId;
  final double discount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> specifications; // Thêm thông số kỹ thuật

  ProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.image,
    required this.images,
    required this.categories,
    this.categoryId,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
    required this.specifications,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    List<Category> categoryList = [];
    if (json['categories'] != null &&
        json['categories'] is List &&
        (json['categories'] as List).isNotEmpty) {
      categoryList = (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList();
    }

    List<String> imagesList = [];
    if (json['images'] != null && json['images'] is List) {
      imagesList =
          (json['images'] as List).map((img) => img.toString()).toList();
    }

    // Nếu không có danh sách hình ảnh, sử dụng hình ảnh chính
    if (imagesList.isEmpty && json['image'] != null) {
      imagesList.add(json['image']);
    }

    // Vì API không trả về specifications, tạo map rỗng
    Map<String, dynamic> specs = {};
    if (json['specifications'] != null && json['specifications'] is Map) {
      specs = json['specifications'];
    }

    return ProductDetail(
      id: json['_id'],
      name: json['name'],
      price: json['price'] is int
          ? (json['price'] as int).toDouble()
          : json['price'],
      description: json['description'],
      quantity: json['quantity'],
      image: json['image'],
      images: imagesList,
      categories: categoryList,
      categoryId: json['category']?.toString(),
      discount: json['discount'] is int
          ? (json['discount'] as int).toDouble()
          : (json['discount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      specifications: specs,
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

  // Thêm getter cho loại nhiên liệu
  String get fuelType {
    if (categories.isEmpty) {
      return 'Không xác định';
    }

    final fuelCategory = categories.firstWhere(
      (category) => category.type == 'loai_nhienlieu',
      orElse: () => Category(
        id: '',
        name: 'Không xác định',
        type: 'loai_nhienlieu',
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return fuelCategory.name;
  }

  // Thêm getter cho loại động cơ
  String get engineType {
    if (categories.isEmpty) {
      return 'Không xác định';
    }

    final engineCategory = categories.firstWhere(
      (category) => category.type == 'loai_dongco',
      orElse: () => Category(
        id: '',
        name: 'Không xác định',
        type: 'loai_dongco',
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return engineCategory.name;
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
