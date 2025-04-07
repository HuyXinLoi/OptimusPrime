import 'package:equatable/equatable.dart';
import 'package:optimusprime/screen/home/models/product.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final String query;
  final List<Product> results;
  final SearchStatus status;
  final String? errorMessage;
  final bool hasSearched;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.status = SearchStatus.initial,
    this.errorMessage,
    this.hasSearched = false,
  });

  SearchState copyWith({
    String? query,
    List<Product>? results,
    SearchStatus? status,
    String? errorMessage,
    bool? hasSearched,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      status: status ?? this.status,
      errorMessage: errorMessage,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }

  @override
  List<Object?> get props =>
      [query, results, status, errorMessage, hasSearched];
}
