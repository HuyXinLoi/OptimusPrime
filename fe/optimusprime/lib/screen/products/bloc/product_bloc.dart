import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:optimusprime/screen/products/bloc/product_event.dart';
import 'package:optimusprime/screen/products/bloc/product_state.dart';
import 'package:optimusprime/screen/products/product_model.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final response =
            await http.get(Uri.parse('http://10.0.2.2:9000/api/products'));
        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = jsonDecode(response.body);
          final products = jsonResponse
              .map((json) => Product.fromJson(json as Map<String, dynamic>))
              .toList();

          emit(ProductLoaded(products));
        } else {
          emit(ProductError(
              'Failed to load products: ${response.statusCode} - ${response.body}'));
        }
      } on SocketException {
        emit(ProductError('No Internet connection'));
      } catch (e) {
        emit(ProductError('Error fetching products: $e'));
      }
    });
  }
}
