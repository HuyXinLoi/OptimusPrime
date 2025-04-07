import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optimusprime/models/cart_model.dart';

class CartRepository {
  final String baseUrl =
      'http://10.0.2.2:9000/api'; // Replace with your actual API URL

  Future<CartModel> getCart(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart/$userId'),
      headers: {
        'Content-Type': 'application/json',
        // Add your authentication token here
        'Authorization': 'Bearer YOUR_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      return CartModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<CartModel> addToCart(String productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_TOKEN',
      },
      body: json.encode({
        'productId': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      return CartModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add item to cart');
    }
  }

  Future<CartModel> removeFromCart(String productId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/remove'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_TOKEN',
      },
      body: json.encode({
        'productId': productId,
      }),
    );

    if (response.statusCode == 200) {
      return CartModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to remove item from cart');
    }
  }

  Future<void> checkout(
      String address, String phone, String paymentMethod) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/checkout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_TOKEN',
      },
      body: json.encode({
        'address': address,
        'phone': phone,
        'paymentMethod': paymentMethod,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to checkout');
    }
  }
}
