import 'package:equatable/equatable.dart';
import 'package:optimusprime/screen/home/models/category.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductList extends ProductListEvent {}

class RefreshProductList extends ProductListEvent {}

class FilterByCategory extends ProductListEvent {
  final Category? category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class FilterByPriceRange extends ProductListEvent {
  final double minPrice;
  final double maxPrice;

  const FilterByPriceRange(this.minPrice, this.maxPrice);

  @override
  List<Object> get props => [minPrice, maxPrice];
}

class SortProducts extends ProductListEvent {
  final SortOption sortOption;

  const SortProducts(this.sortOption);

  @override
  List<Object> get props => [sortOption];
}

class ApplyFilters extends ProductListEvent {}

class ResetFilters extends ProductListEvent {}

enum SortOption { priceAsc, priceDesc, newest, popularity }
