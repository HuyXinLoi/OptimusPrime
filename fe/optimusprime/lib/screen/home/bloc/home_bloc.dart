import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimusprime/screen/home/models/category.dart';
import 'package:optimusprime/screen/home/models/product.dart';
import 'package:optimusprime/services/api_services.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiService _apiService;

  HomeBloc({required ApiService apiService})
      : _apiService = apiService,
        super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    if (state.status == HomeStatus.loading) return;

    print('HomeBloc: Loading home data...');
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Tải dữ liệu song song để tăng tốc độ
      print('HomeBloc: Fetching data from API...');
      final bestSellersResult = _apiService.getBestSellers();
      final newProductsResult = _apiService.getNewProducts();
      final categoriesResult = _apiService.getCategories();
      final brandsResult = _apiService.getBrands();

      // Đợi tất cả các request hoàn thành
      final results = await Future.wait([
        bestSellersResult,
        newProductsResult,
        categoriesResult,
        brandsResult,
      ]);

      print('HomeBloc: Data fetched successfully!');
      print('HomeBloc: Best sellers count: ${results[0].length}');
      print('HomeBloc: New products count: ${results[1].length}');
      print('HomeBloc: Categories count: ${results[2].length}');
      print('HomeBloc: Brands count: ${results[3].length}');

      emit(state.copyWith(
        status: HomeStatus.success,
        bestSellers: results[0] as List<Product>,
        newProducts: results[1] as List<Product>,
        categories: results[2] as List<Category>,
        brands: results[3] as List<Category>,
        errorMessage: null,
      ));
    } catch (e) {
      print('HomeBloc: Error loading data: $e');
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: 'Không thể tải dữ liệu: $e',
      ));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    print('HomeBloc: Refreshing home data...');
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Tải dữ liệu song song để tăng tốc độ
      print('HomeBloc: Fetching fresh data from API...');
      final bestSellersResult = _apiService.getBestSellers();
      final newProductsResult = _apiService.getNewProducts();
      final categoriesResult = _apiService.getCategories();
      final brandsResult = _apiService.getBrands();

      // Đợi tất cả các request hoàn thành
      final results = await Future.wait([
        bestSellersResult,
        newProductsResult,
        categoriesResult,
        brandsResult,
      ]);

      print('HomeBloc: Data refreshed successfully!');

      emit(state.copyWith(
        status: HomeStatus.success,
        bestSellers: results[0] as List<Product>,
        newProducts: results[1] as List<Product>,
        categories: results[2] as List<Category>,
        brands: results[3] as List<Category>,
        errorMessage: null,
      ));
    } catch (e) {
      print('HomeBloc: Error refreshing data: $e');
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: 'Không thể tải dữ liệu: $e',
      ));
    }
  }
}
