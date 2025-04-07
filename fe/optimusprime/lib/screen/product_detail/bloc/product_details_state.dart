import 'package:equatable/equatable.dart';
import 'package:optimusprime/screen/product_detail/models/product_detail.dart';

enum ProductDetailStatus { initial, loading, success, failure }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final ProductDetail? product;
  final String? errorMessage;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductDetail? product,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage];
}
