import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimusprime/services/api_services.dart';
import 'package:rxdart/rxdart.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService _apiService;

  SearchBloc({required ApiService apiService})
      : _apiService = apiService,
        super(const SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged,
        transformer: debounce(const Duration(milliseconds: 500)));
    on<SearchSubmitted>(_onSearchSubmitted);
    on<ClearSearch>(_onClearSearch);
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) =>
        events.debounceTime(duration).flatMap((event) => mapper(event));
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(state.copyWith(
        query: query,
        results: [],
        status: SearchStatus.initial,
        hasSearched: false,
      ));
      return;
    }

    if (query.length < 2) {
      emit(state.copyWith(query: query));
      return;
    }

    emit(state.copyWith(
      query: query,
      status: SearchStatus.loading,
    ));

    try {
      final results = await _apiService.searchProducts(query);
      emit(state.copyWith(
        results: results,
        status: SearchStatus.success,
        hasSearched: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Đã xảy ra lỗi khi tìm kiếm: $e',
        hasSearched: true,
      ));
    }
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      return;
    }

    emit(state.copyWith(
      query: query,
      status: SearchStatus.loading,
    ));

    try {
      final results = await _apiService.searchProducts(query);
      emit(state.copyWith(
        results: results,
        status: SearchStatus.success,
        hasSearched: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Đã xảy ra lỗi khi tìm kiếm: $e',
        hasSearched: true,
      ));
    }
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchState());
  }
}
