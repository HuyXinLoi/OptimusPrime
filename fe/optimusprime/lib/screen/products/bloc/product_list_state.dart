import 'package:equatable/equatable.dart';
import 'package:optimusprime/screen/home/models/category.dart';
import 'package:optimusprime/screen/home/models/product.dart';
import 'package:optimusprime/screen/products/bloc/product_list_event.dart';

enum ProductListStatus { initial, loading, success, failure }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final List<Category> categories;
  final Category? selectedCategory;
  final double minPrice;
  final double maxPrice;
  final double currentMinPrice;
  final double currentMaxPrice;
  final SortOption sortOption;
  final String? errorMessage;
  final bool isFilterActive;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.categories = const [],
    this.selectedCategory,
    this.minPrice = 0.0,
    this.maxPrice = 10000000.0, // Giá trị mặc định cao
    this.currentMinPrice = 0.0,
    this.currentMaxPrice = 10000000.0,
    this.sortOption = SortOption.priceAsc,
    this.errorMessage,
    this.isFilterActive = false,
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    List<Category>? categories,
    Category? selectedCategory,
    double? minPrice,
    double? maxPrice,
    double? currentMinPrice,
    double? currentMaxPrice,
    SortOption? sortOption,
    String? errorMessage,
    bool? isFilterActive,
  }) {
    return ProductListState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      currentMinPrice: currentMinPrice ?? this.currentMinPrice,
      currentMaxPrice: currentMaxPrice ?? this.currentMaxPrice,
      sortOption: sortOption ?? this.sortOption,
      errorMessage: errorMessage,
      isFilterActive: isFilterActive ?? this.isFilterActive,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allProducts,
        filteredProducts,
        categories,
        selectedCategory,
        minPrice,
        maxPrice,
        currentMinPrice,
        currentMaxPrice,
        sortOption,
        errorMessage,
        isFilterActive,
      ];
}
