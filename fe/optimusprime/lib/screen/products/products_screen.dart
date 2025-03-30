import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/screen/home/models/category.dart';
import 'package:optimusprime/screen/home/widgets/product_card.dart';
import 'package:optimusprime/screen/product_detail/product_detail_screen.dart';
import 'package:optimusprime/screen/products/bloc/product_list_bloc.dart';
import 'package:optimusprime/screen/products/bloc/product_list_event.dart';
import 'package:optimusprime/screen/products/bloc/product_list_state.dart';
import 'package:optimusprime/services/api_services.dart';
import 'package:optimusprime/untils/format_utils.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollController = ScrollController();
  bool _isFilterDrawerOpen = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductListBloc(
        apiService: ApiService(),
      )..add(LoadProductList()),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Tất cả sản phẩm',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                context.go('/');
              },
            ),
            actions: [
              BlocBuilder<ProductListBloc, ProductListState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.filter_list, color: Colors.black87),
                        if (state.isFilterActive)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _isFilterDrawerOpen = true;
                      });
                      _showFilterBottomSheet(context);
                    },
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state.status == ProductListStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.status == ProductListStatus.loading &&
                  state.allProducts.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.status == ProductListStatus.failure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[700],
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ??
                            'Đã xảy ra lỗi khi tải danh sách sản phẩm',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<ProductListBloc>()
                              .add(RefreshProductList());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        color: Colors.grey[500],
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Không tìm thấy sản phẩm nào',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hãy thử điều chỉnh bộ lọc của bạn',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<ProductListBloc>().add(ResetFilters());
                        },
                        icon: const Icon(Icons.filter_alt_off),
                        label: const Text('Xóa bộ lọc'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductListBloc>().add(RefreshProductList());
                },
                child: Column(
                  children: [
                    // Hiển thị thông tin lọc và sắp xếp
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            'Hiển thị ${state.filteredProducts.length} sản phẩm',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          // Dropdown sắp xếp
                          DropdownButton<SortOption>(
                            value: state.sortOption,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down),
                            items: [
                              DropdownMenuItem(
                                value: SortOption.priceAsc,
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_upward,
                                        size: 16, color: Colors.blue[700]),
                                    const SizedBox(width: 4),
                                    const Text('Giá: Thấp đến cao'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: SortOption.priceDesc,
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_downward,
                                        size: 16, color: Colors.blue[700]),
                                    const SizedBox(width: 4),
                                    const Text('Giá: Cao đến thấp'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: SortOption.newest,
                                child: Row(
                                  children: [
                                    Icon(Icons.new_releases,
                                        size: 16, color: Colors.blue[700]),
                                    const SizedBox(width: 4),
                                    const Text('Mới nhất'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: SortOption.popularity,
                                child: Row(
                                  children: [
                                    Icon(Icons.trending_up,
                                        size: 16, color: Colors.blue[700]),
                                    const SizedBox(width: 4),
                                    const Text('Phổ biến'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<ProductListBloc>()
                                    .add(SortProducts(value));
                                // Không áp dụng bộ lọc ngay lập tức, chờ người dùng nhấn nút "Áp dụng"
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Hiển thị bộ lọc đã chọn
                    if (state.isFilterActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        color: Colors.blue[50],
                        child: Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (state.selectedCategory != null)
                                    _buildFilterChip(
                                      label: state.selectedCategory!.name,
                                      onRemove: () {
                                        context
                                            .read<ProductListBloc>()
                                            .add(const FilterByCategory(null));
                                        context
                                            .read<ProductListBloc>()
                                            .add(ApplyFilters());
                                      },
                                    ),
                                  if (state.currentMinPrice > state.minPrice ||
                                      state.currentMaxPrice < state.maxPrice)
                                    _buildFilterChip(
                                      label:
                                          'Giá: ${FormatUtils.formatCurrency(state.currentMinPrice)} - ${FormatUtils.formatCurrency(state.currentMaxPrice)}',
                                      onRemove: () {
                                        context.read<ProductListBloc>().add(
                                            FilterByPriceRange(state.minPrice,
                                                state.maxPrice));
                                        context
                                            .read<ProductListBloc>()
                                            .add(ApplyFilters());
                                      },
                                    ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<ProductListBloc>()
                                    .add(ResetFilters());
                              },
                              child: const Text('Xóa tất cả'),
                            ),
                          ],
                        ),
                      ),

                    // Hiển thị loading indicator khi đang lọc
                    if (state.status == ProductListStatus.loading &&
                        state.allProducts.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),

                    // Danh sách sản phẩm
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = state.filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productId: product.id,
                                  ),
                                ),
                              );
                            },
                            onFavoriteToggle: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Đã thêm ${product.name} vào danh sách yêu thích'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildFilterChip(
      {required String label, required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 16,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    // Lấy bloc từ context hiện tại
    final bloc = context.read<ProductListBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: bloc, // Truyền bloc vào bottom sheet
        child: _FilterBottomSheet(),
      ),
    ).then((_) {
      setState(() {
        _isFilterDrawerOpen = false;
      });
    });
  }
}

class _FilterBottomSheet extends StatefulWidget {
  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Lọc sản phẩm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),

              // Filter content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Danh mục
                      const Text(
                        'Danh mục',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Danh sách danh mục
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildCategoryFilterChip(
                            context,
                            null,
                            'Tất cả',
                            state.selectedCategory == null,
                          ),
                          ...state.categories
                              .where((category) =>
                                  category.type == 'loai_xe' ||
                                  category.type == 'hang')
                              .map((category) => _buildCategoryFilterChip(
                                    context,
                                    category,
                                    category.name,
                                    state.selectedCategory?.id == category.id,
                                  )),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Khoảng giá
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Khoảng giá',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '${FormatUtils.formatCurrency(state.currentMinPrice)} - ${FormatUtils.formatCurrency(state.currentMaxPrice)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // RangeSlider
                      RangeSlider(
                        values: RangeValues(
                            state.currentMinPrice, state.currentMaxPrice),
                        min: state.minPrice,
                        max: state.maxPrice,
                        divisions: 20,
                        activeColor: Colors.blue[700],
                        inactiveColor: Colors.blue[100],
                        labels: RangeLabels(
                          FormatUtils.formatCurrency(state.currentMinPrice),
                          FormatUtils.formatCurrency(state.currentMaxPrice),
                        ),
                        onChanged: (values) {
                          context.read<ProductListBloc>().add(
                              FilterByPriceRange(values.start, values.end));
                        },
                      ),

                      const SizedBox(height: 24),

                      // Sắp xếp
                      const Text(
                        'Sắp xếp theo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Các tùy chọn sắp xếp
                      _buildSortOption(
                        context,
                        SortOption.priceAsc,
                        'Giá: Thấp đến cao',
                        Icons.arrow_upward,
                        state.sortOption == SortOption.priceAsc,
                      ),
                      _buildSortOption(
                        context,
                        SortOption.priceDesc,
                        'Giá: Cao đến thấp',
                        Icons.arrow_downward,
                        state.sortOption == SortOption.priceDesc,
                      ),
                      _buildSortOption(
                        context,
                        SortOption.newest,
                        'Mới nhất',
                        Icons.new_releases,
                        state.sortOption == SortOption.newest,
                      ),
                      _buildSortOption(
                        context,
                        SortOption.popularity,
                        'Phổ biến',
                        Icons.trending_up,
                        state.sortOption == SortOption.popularity,
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<ProductListBloc>().add(ResetFilters());
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue[700],
                          side: BorderSide(color: Colors.blue[700]!),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Đặt lại'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ProductListBloc>().add(ApplyFilters());
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Áp dụng'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilterChip(
    BuildContext context,
    Category? category,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<ProductListBloc>().add(FilterByCategory(category));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[700] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    SortOption option,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        context.read<ProductListBloc>().add(SortProducts(option));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.blue[700] : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.blue[700],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
