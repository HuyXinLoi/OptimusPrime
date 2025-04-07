import 'product.dart';
import 'pagination.dart';

class ProductsResponse {
  final bool success;
  final List<Product> data;
  final Pagination pagination;

  ProductsResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    List<Product> productList = [];

    if (json['data'] != null && json['data'] is List) {
      productList = (json['data'] as List)
          .map((product) => Product.fromJson(product))
          .toList();
    }

    return ProductsResponse(
      success: json['success'] ?? true,
      data: productList,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}
