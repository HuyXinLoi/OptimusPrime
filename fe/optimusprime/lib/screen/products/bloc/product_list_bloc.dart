import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimusprime/screen/home/models/product.dart';
import 'package:optimusprime/services/api_services.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ApiService _apiService;

  ProductListBloc({required ApiService apiService})
      : _apiService = apiService,
        super(const ProductListState()) {
    on<LoadProductList>(_onLoadProductList);
    on<RefreshProductList>(_onRefreshProductList);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByPriceRange>(_onFilterByPriceRange);
    on<SortProducts>(_onSortProducts);
    on<ResetFilters>(_onResetFilters);
    on<ApplyFilters>(_onApplyFilters);
  }

  Future<void> _onLoadProductList(
    LoadProductList event,
    Emitter<ProductListState> emit,
  ) async {
    if (state.status == ProductListStatus.loading) return;

    emit(state.copyWith(status: ProductListStatus.loading));

    try {
      // Tải tất cả sản phẩm ban đầu không có bộ lọc
      final products = await _apiService.getAllProducts();
      final categories = await _apiService.getCategories();

      // Tìm giá thấp nhất và cao nhất trong danh sách sản phẩm
      double minPrice = double.infinity;
      double maxPrice = 0;

      for (final product in products) {
        final price = product.discountedPrice;
        if (price < minPrice) minPrice = price;
        if (price > maxPrice) maxPrice = price;
      }

      // Làm tròn giá trị để dễ hiển thị
      minPrice = (minPrice / 1000).floor() * 1000;
      maxPrice =
          ((maxPrice / 1000).ceil() * 1000) + 1000; // Thêm một chút buffer

      emit(state.copyWith(
        status: ProductListStatus.success,
        allProducts: products,
        filteredProducts: products,
        categories: categories,
        minPrice: minPrice,
        maxPrice: maxPrice,
        currentMinPrice: minPrice,
        currentMaxPrice: maxPrice,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductListStatus.failure,
        errorMessage: 'Đã xảy ra lỗi khi tải danh sách sản phẩm: $e',
      ));
    }
  }

  Future<void> _onRefreshProductList(
    RefreshProductList event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(status: ProductListStatus.loading));

    try {
      // Nếu đang có bộ lọc, áp dụng lại bộ lọc khi làm mới
      List<Product> products;
      if (state.isFilterActive) {
        products = await _apiService.filterProducts(
          category: state.selectedCategory?.name,
          minPrice: state.currentMinPrice,
          maxPrice: state.currentMaxPrice,
          sort: _getSortString(state.sortOption),
        );
      } else {
        // Nếu không có bộ lọc, tải tất cả sản phẩm
        products = await _apiService.getAllProducts();
      }

      final categories = await _apiService.getCategories();

      emit(state.copyWith(
        status: ProductListStatus.success,
        allProducts: products,
        filteredProducts: products,
        categories: categories,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductListStatus.failure,
        errorMessage: 'Đã xảy ra lỗi khi tải lại danh sách sản phẩm: $e',
      ));
    }
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductListState> emit,
  ) {
    emit(state.copyWith(
      selectedCategory: event.category,
      isFilterActive: event.category != null ||
          state.currentMinPrice > state.minPrice ||
          state.currentMaxPrice < state.maxPrice,
    ));
  }

  void _onFilterByPriceRange(
    FilterByPriceRange event,
    Emitter<ProductListState> emit,
  ) {
    emit(state.copyWith(
      currentMinPrice: event.minPrice,
      currentMaxPrice: event.maxPrice,
      isFilterActive: state.selectedCategory != null ||
          event.minPrice > state.minPrice ||
          event.maxPrice < state.maxPrice,
    ));
  }

  void _onSortProducts(
    SortProducts event,
    Emitter<ProductListState> emit,
  ) {
    emit(state.copyWith(
      sortOption: event.sortOption,
    ));
  }

  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(status: ProductListStatus.loading));

    try {
      final products = await _apiService.filterProducts(
        category: state.selectedCategory?.name,
        minPrice: state.currentMinPrice,
        maxPrice: state.currentMaxPrice,
        sort: _getSortString(state.sortOption),
      );

      emit(state.copyWith(
        status: ProductListStatus.success,
        filteredProducts: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductListStatus.failure,
        errorMessage: 'Đã xảy ra lỗi khi áp dụng bộ lọc: $e',
      ));
    }
  }

  Future<void> _onResetFilters(
    ResetFilters event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(
      status: ProductListStatus.loading,
      selectedCategory: null,
      currentMinPrice: state.minPrice,
      currentMaxPrice: state.maxPrice,
      sortOption: SortOption.priceAsc,
      isFilterActive: false,
    ));

    try {
      final products = await _apiService.filterProducts();

      emit(state.copyWith(
        status: ProductListStatus.success,
        filteredProducts: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductListStatus.failure,
        errorMessage: 'Đã xảy ra lỗi khi đặt lại bộ lọc: $e',
      ));
    }
  }

  // Hàm chuyển đổi SortOption thành chuỗi sort cho API
  String _getSortString(SortOption sortOption) {
    switch (sortOption) {
      case SortOption.priceAsc:
        return 'asc';
      case SortOption.priceDesc:
        return 'desc';
      case SortOption.newest:
        // API của bạn có thể không hỗ trợ sắp xếp theo mới nhất
        // Nếu có, hãy thay đổi giá trị này
        return 'newest';
      case SortOption.popularity:
        // API của bạn có thể không hỗ trợ sắp xếp theo phổ biến
        // Nếu có, hãy thay đổi giá trị này
        return 'popularity';
      default:
        return 'asc';
    }
  }
}
