import 'package:equatable/equatable.dart';
import 'package:optimusprime/screen/home/models/category.dart';
import 'package:optimusprime/screen/home/models/product.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Product> bestSellers;
  final List<Product> newProducts;
  final List<Category> categories;
  final List<Category> brands;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.bestSellers = const [],
    this.newProducts = const [],
    this.categories = const [],
    this.brands = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Product>? bestSellers,
    List<Product>? newProducts,
    List<Category>? categories,
    List<Category>? brands,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      bestSellers: bestSellers ?? this.bestSellers,
      newProducts: newProducts ?? this.newProducts,
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, bestSellers, newProducts, categories, brands, errorMessage];
}
