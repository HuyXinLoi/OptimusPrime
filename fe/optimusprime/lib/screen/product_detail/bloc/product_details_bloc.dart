import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimusprime/screen/product_detail/bloc/product_details_event.dart';
import 'package:optimusprime/screen/product_detail/bloc/product_details_state.dart';
import 'package:optimusprime/services/api_services.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ApiService _apiService;

  ProductDetailBloc({required ApiService apiService})
      : _apiService = apiService,
        super(const ProductDetailState()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<RefreshProductDetail>(_onRefreshProductDetail);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state.status == ProductDetailStatus.loading) return;

    emit(state.copyWith(status: ProductDetailStatus.loading));

    try {
      final product = await _apiService.getProductDetail(event.productId);

      if (product != null) {
        emit(state.copyWith(
          status: ProductDetailStatus.success,
          product: product,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          status: ProductDetailStatus.failure,
          errorMessage: 'Không tìm thấy thông tin sản phẩm',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductDetailStatus.failure,
        errorMessage: 'Đã xảy ra lỗi: $e',
      ));
    }
  }

  Future<void> _onRefreshProductDetail(
    RefreshProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    try {
      final product = await _apiService.getProductDetail(event.productId);

      if (product != null) {
        emit(state.copyWith(
          status: ProductDetailStatus.success,
          product: product,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          status: ProductDetailStatus.failure,
          errorMessage: 'Không tìm thấy thông tin sản phẩm',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductDetailStatus.failure,
        errorMessage: 'Đã xảy ra lỗi: $e',
      ));
    }
  }
}
