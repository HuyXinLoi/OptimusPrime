import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final String productId;

  const LoadProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}

class RefreshProductDetail extends ProductDetailEvent {
  final String productId;

  const RefreshProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}
