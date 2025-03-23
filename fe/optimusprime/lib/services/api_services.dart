import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optimusprime/screen/home/models/api_response.dart';
import 'package:optimusprime/screen/home/models/category.dart';
import 'package:optimusprime/screen/home/models/product.dart';
import 'package:optimusprime/screen/product_detail/models/product_detail.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:9000/api';

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_API_TOKEN',
      };

  Future<List<Product>> getBestSellers() async {
    try {
      print('Fetching best sellers from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/products?sort=sales&limit=10'),
      );

      print('API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final productsResponse = ProductsResponse.fromJson(responseData);

        if (productsResponse.success) {
          return productsResponse.data;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load best sellers: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching best sellers: $e');

      throw Exception('Failed to load best sellers: ');
    }
  }

  // Lấy danh sách sản phẩm mới
  Future<List<Product>> getNewProducts() async {
    try {
      print('Fetching new products from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/products?sort=createdAt&order=desc&limit=10'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final productsResponse = ProductsResponse.fromJson(responseData);

        if (productsResponse.success) {
          return productsResponse.data;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load new products: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching new products: $e');
      throw Exception('Failed to load best sellers: }');
    }
  }

  // Lấy danh sách danh mục
  Future<List<Category>> getCategories() async {
    try {
      print('Fetching categories from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching categories: $e');
      throw Exception('Failed to load best sellers: }');
    }
  }

  // Lấy danh sách thương hiệu
  Future<List<Category>> getBrands() async {
    try {
      print('Fetching categories from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching categories: $e');
      throw Exception('Failed to load best sellers: ');
    }
  }

  // Đăng ký tài khoản mới
  // Future<RegisterResponse> register(String name, String email, String password, String? phone) async {
  //   try {
  //     print('Registering new user...');
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/auth/register'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'name': name,
  //         'email': email,
  //         'password': password,
  //         if (phone != null) 'phone': phone,
  //       }),
  //     );

  //     print('API Response status: ${response.statusCode}');

  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     return RegisterResponse.fromJson(responseData);
  //   } catch (e) {
  //     print('Exception when registering: $e');
  //     return RegisterResponse(
  //       success: false,
  //       message: 'Đã xảy ra lỗi khi đăng ký: $e',
  //     );
  //   }
  // }

  // Lấy chi tiết sản phẩm
  Future<ProductDetail?> getProductDetail(String productId) async {
    try {
      print('Fetching product detail for ID: $productId');
      final response = await http.get(
        Uri.parse('$baseUrl/products/$productId'),
        headers: headers,
      );

      print('API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return ProductDetail.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to load product detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching product detail: $e');
      return null;
    }
  }

  // Lấy chi tiết nhãn hàng
  // Future<BrandDetail?> getBrandDetail(String brandId) async {
  //   try {
  //     print('Fetching brand detail for ID: $brandId');
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/categories/$brandId'),
  //       headers: headers,
  //     );

  //     print('API Response status: ${response.statusCode}');

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       final brandDetailResponse = BrandDetailResponse.fromJson(responseData);

  //       if (brandDetailResponse.success && brandDetailResponse.data != null) {
  //         return brandDetailResponse.data;
  //       } else {
  //         throw Exception(brandDetailResponse.message ?? 'API returned success: false');
  //       }
  //     } else {
  //       throw Exception('Failed to load brand detail: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception when fetching brand detail: $e');
  //     return null;
  //   }
  // }

  // Lấy sản phẩm theo nhãn hàng
  Future<List<Product>> getProductsByBrand(String brandId,
      {int page = 1, int limit = 10}) async {
    try {
      print('Fetching products for brand ID: $brandId');
      final response = await http.get(
        Uri.parse(
            '$baseUrl/products?category=$brandId&page=$page&limit=$limit'),
        headers: headers,
      );

      print('API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final productsResponse = ProductsResponse.fromJson(responseData);

        if (productsResponse.success) {
          return productsResponse.data;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception(
            'Failed to load products by brand: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching products by brand: $e');
      return [];
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      print('Searching products with query: $query');
      final response = await http.get(
        Uri.parse('$baseUrl/products?q=$query'),
        headers: headers,
      );

      print('API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final productsResponse = ProductsResponse.fromJson(responseData);

        if (productsResponse.success) {
          return productsResponse.data;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when searching products: $e');
      return [];
    }
  }

  Future<List<Product>> filterProducts({
    String? category,
    double minPrice = 0.0,
    double maxPrice = 10000000.0,
    String sort = 'asc',
  }) async {
    try {
      print('🔍 Filtering products with API...');

      // Xây dựng query parameters
      final Map<String, String> queryParams = {
        'minPrice': minPrice.toInt().toString(),
        'maxPrice': maxPrice.toInt().toString(),
        'sort': sort,
      };

      if (category != null && category.isNotEmpty) {
        queryParams['value'] = category;
      }

      final Uri uri = Uri.parse('$baseUrl/products/filter').replace(
        queryParameters: queryParams,
      );

      print('🌍 Filter API URL: $uri');

      final response = await http.get(
        uri,
        headers: headers,
      );

      print('📥 API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        // ✅ Chuyển từng item trong list thành Product
        final List<Product> products =
            responseData.map((json) => Product.fromJson(json)).toList();

        return products;
      } else {
        print('❌ Error Response: ${response.body}');
        throw Exception('Failed to filter products: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Exception when filtering products: $e');
      throw Exception('Failed to filter products: $e');
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      print('Fetching all products from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: headers,
      );

      print('API Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final productsResponse = ProductsResponse.fromJson(responseData);

        if (productsResponse.success) {
          return productsResponse.data;
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching all products: $e');
      throw Exception('Failed to load products:');
    }
  }

//   // Dữ liệu mẫu cho sản phẩm (sử dụng khi API không hoạt động)
//   List<Product> _getMockProducts() {
//     return [
//       Product(
//         id: '67cc3959cf5038c8e362d338',
//         name: 'Truck-kun 3',
//         price: 99.99,
//         description:
//             'High quality wireless headphones with noise cancellation.',
//         quantity: 5033,
//         image:
//             'https://res.cloudinary.com/djg7zqlus/image/upload/v1741437273/products/fjbr6tsalbbswtaijpx0.jpg',
//         categories: [
//           Category(
//             id: '67cbb636780da46e7a25ae28',
//             name: 'Mazda',
//             type: 'hang',
//             description: 'Hãng xe Mazda',
//             createdAt: DateTime.parse('2025-03-08T03:15:02.909Z'),
//             updatedAt: DateTime.parse('2025-03-08T03:15:02.909Z'),
//           ),
//           Category(
//             id: '67cbb5cc780da46e7a25ae08',
//             name: 'SUV',
//             type: 'loai_xe',
//             description: 'Dòng xe thể thao',
//             createdAt: DateTime.parse('2025-03-08T03:13:16.059Z'),
//             updatedAt: DateTime.parse('2025-03-08T03:13:16.059Z'),
//           ),
//         ],
//         categoryId: null,
//         discount: 10,
//         createdAt: DateTime.parse('2025-03-08T12:34:33.675Z'),
//         updatedAt: DateTime.parse('2025-03-08T12:35:14.623Z'),
//       ),
//       Product(
//         id: '67cc38d0cf5038c8e362d323',
//         name: 'Truck-kun 2',
//         price: 99.99,
//         description:
//             'High quality wireless headphones with noise cancellation.',
//         quantity: 5033,
//         image:
//             'https://res.cloudinary.com/djg7zqlus/image/upload/v1741437135/products/lmoceemeyunapbnvryo6.jpg',
//         categories: [
//           Category(
//             id: '67cbb5fb780da46e7a25ae0c',
//             name: 'Ford',
//             type: 'hang',
//             description: 'Hãng xe Ford',
//             createdAt: DateTime.parse('2025-03-08T03:14:03.117Z'),
//             updatedAt: DateTime.parse('2025-03-08T03:14:03.117Z'),
//           ),
//           Category(
//             id: '67cbb5cc780da46e7a25ae08',
//             name: 'SUV',
//             type: 'loai_xe',
//             description: 'Dòng xe thể thao',
//             createdAt: DateTime.parse('2025-03-08T03:13:16.059Z'),
//             updatedAt: DateTime.parse('2025-03-08T03:13:16.059Z'),
//           ),
//         ],
//         categoryId: null,
//         discount: 10,
//         createdAt: DateTime.parse('2025-03-08T12:32:16.082Z'),
//         updatedAt: DateTime.parse('2025-03-08T12:34:02.435Z'),
//       ),
//       // Thêm một sản phẩm với categories rỗng để kiểm tra
//       Product(
//         id: '67ba00ec57f1aa846cb1627f',
//         name: 'Wireless Bluetooth Headphones a1',
//         price: 99.99,
//         description:
//             'High quality wireless headphones with noise cancellation.',
//         quantity: 5033,
//         image:
//             'https://res.cloudinary.com/djg7zqlus/image/upload/v1740243183/products/glsytv7asmmxk2nrviwf.png',
//         categories: [], // Categories rỗng
//         categoryId: '67b980a8ba780b2585053961',
//         discount: 10,
//         createdAt: DateTime.parse('2025-02-22T16:53:00.892Z'),
//         updatedAt: DateTime.parse('2025-02-22T16:53:00.892Z'),
//       ),
//     ];
//   }

//   // Dữ liệu mẫu cho danh mục (sử dụng khi API không hoạt động)
//   List<Category> _getMockCategories() {
//     return [
//       Category(
//         id: '67cbb5cc780da46e7a25ae08',
//         name: 'SUV',
//         type: 'loai_xe',
//         description: 'Dòng xe thể thao',
//         createdAt: DateTime.parse('2025-03-08T03:13:16.059Z'),
//         updatedAt: DateTime.parse('2025-03-08T03:13:16.059Z'),
//       ),
//       Category(
//         id: '67cbb66a780da46e7a25ae30',
//         name: 'Dầu',
//         type: 'loai_nhienlieu',
//         description: 'Xe sử dụng Dầu',
//         createdAt: DateTime.parse('2025-03-08T03:15:54.524Z'),
//         updatedAt: DateTime.parse('2025-03-08T03:15:54.524Z'),
//       ),
//       Category(
//         id: '67cbb701780da46e7a25ae38',
//         name: 'Động cơ I',
//         type: 'loai_dongco',
//         description: 'Động cơ chữ I (Inline Engine)',
//         createdAt: DateTime.parse('2025-03-08T03:18:25.087Z'),
//         updatedAt: DateTime.parse('2025-03-08T03:18:25.087Z'),
//       ),
//     ];
//   }

//   // Dữ liệu mẫu cho thương hiệu (sử dụng khi API không hoạt động)
//   List<Category> _getMockBrands() {
//     return [
//       Category(
//         id: '67cbb636780da46e7a25ae28',
//         name: 'Mazda',
//         type: 'hang',
//         description: 'Hãng xe Mazda',
//         createdAt: DateTime.parse('2025-03-08T03:15:02.909Z'),
//         updatedAt: DateTime.parse('2025-03-08T03:15:02.909Z'),
//       ),
//       Category(
//         id: '67cbb5fb780da46e7a25ae0c',
//         name: 'Ford',
//         type: 'hang',
//         description: 'Hãng xe Ford',
//         createdAt: DateTime.parse('2025-03-08T03:14:03.117Z'),
//         updatedAt: DateTime.parse('2025-03-08T03:14:03.117Z'),
//       ),
//       Category(
//         id: '67cb09e7aeb0c4f554475f85',
//         name: 'Toyota',
//         type: 'hang',
//         description: 'Hãng xe 4 chỗ gầm thấp',
//         createdAt: DateTime.parse('2025-03-07T14:59:51.888Z'),
//         updatedAt: DateTime.parse('2025-03-07T14:59:51.888Z'),
//       ),
//       Category(
//         id: '67cbb636780da46e7a25ae29',
//         name: 'Honda',
//         type: 'hang',
//         description: 'Hãng xe Honda',
//         createdAt: DateTime.parse('2025-03-08T03:15:02.909Z'),
//         updatedAt: DateTime.parse('2025-03-08T03:15:02.909Z'),
//       ),
//     ];
//   }
}
