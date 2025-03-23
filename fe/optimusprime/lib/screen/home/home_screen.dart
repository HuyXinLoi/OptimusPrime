import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/screen/home/bloc/home_bloc.dart';
import 'package:optimusprime/screen/home/bloc/home_event.dart';
import 'package:optimusprime/screen/home/bloc/home_state.dart';
import 'package:optimusprime/screen/search/search_screen.dart';
import 'package:optimusprime/services/api_services.dart';
import 'models/category.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Thiết lập status bar trong suốt
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return BlocProvider(
      create: (context) => HomeBloc(
        apiService: ApiService(),
      )..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshHomeData());
              },
              child: SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // App Bar với thanh tìm kiếm và avatar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    context.push('/search');
                                  },
                                  child: AbsorbPointer(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Tìm kiếm xe...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_rounded,
                                          color: Colors.blue[700],
                                          size: 20,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[600]!,
                                    Colors.blue[800]!
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Hiển thị lỗi nếu có
                    if (state.status == HomeStatus.failure)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[700],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.errorMessage ??
                                        'Đã xảy ra lỗi khi tải dữ liệu',
                                    style: TextStyle(
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<HomeBloc>()
                                        .add(LoadHomeData());
                                  },
                                  child: const Text('Thử lại'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Banner quảng cáo
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Colors.blue[700]!, Colors.blue[900]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                bottom: -20,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -30,
                                top: -30,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Khuyến mãi tháng 3',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Giảm giá đến 30% cho các dòng xe',
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'Xem ngay',
                                              style: TextStyle(
                                                color: Colors.blue[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Image.asset(
                                      'assets/img/motorbike_logo.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Danh mục và thương hiệu
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Danh mục & Thương hiệu',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                state.status == HomeStatus.loading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: _buildCategoryItems(
                                            state.categories),
                                      ),
                                const SizedBox(height: 16),
                                state.status == HomeStatus.loading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children:
                                            _buildBrandItems(state.brands),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bán chạy nhất
                    SliverToBoxAdapter(
                      child: _buildSectionHeader('Bán chạy nhất'),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 260,
                        child: state.status == HomeStatus.loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: state.bestSellers.isEmpty
                                    ? 0
                                    : state.bestSellers.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final product = state.bestSellers[index];
                                  return ProductCard(
                                    product: product,
                                    onTap: () {
                                      // Xử lý khi nhấn vào sản phẩm
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(
                                      //   SnackBar(
                                      //     content:
                                      //         Text('Đã chọn: ${product.name}'),
                                      //     duration: const Duration(seconds: 1),
                                      //   ),
                                      // );
                                      context.push(
                                          '/product_detail/${product.id}');
                                    },
                                    onFavoriteToggle: () {
                                      // Xử lý khi nhấn vào nút yêu thích
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                    ),

                    // Sản phẩm mới
                    SliverToBoxAdapter(
                      child: _buildSectionHeader('Sản phẩm mới'),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 260,
                        child: state.status == HomeStatus.loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: state.newProducts.isEmpty
                                    ? 0
                                    : state.newProducts.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final product = state.newProducts[index];
                                  return ProductCard(
                                    product: product,
                                    onTap: () {
                                      // Xử lý khi nhấn vào sản phẩm
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Đã chọn: ${product.name}'),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    onFavoriteToggle: () {
                                      // Xử lý khi nhấn vào nút yêu thích
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                    ),

                    // Khoảng cách cuối cùng
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 30),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Bottom Navigation Bar
        // bottomNavigationBar: Container(
        //   height: 70,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.05),
        //         blurRadius: 10,
        //         spreadRadius: 0,
        //         offset: const Offset(0, -5),
        //       ),
        //     ],
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       _buildNavItem(Icons.home_rounded, 'Trang chủ', true),
        //       _buildNavItem(Icons.category_rounded, 'Danh mục', false),
        //       _buildNavItem(Icons.shopping_cart_rounded, 'Giỏ hàng', false),
        //       _buildNavItem(Icons.favorite_rounded, 'Yêu thích', false),
        //       _buildNavItem(Icons.person_rounded, 'Tài khoản', false),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryItems(List<Category> categories) {
    if (categories.isEmpty) {
      return [
        _buildCategoryItem(
          icon: Icons.electric_bike,
          label: 'Xe điện',
          color: Colors.blue[700]!,
        ),
        _buildCategoryItem(
          icon: Icons.motorcycle,
          label: 'Xe máy',
          color: Colors.orange[700]!,
        ),
        _buildCategoryItem(
          icon: Icons.pedal_bike,
          label: 'Xe đạp',
          color: Colors.green[700]!,
        ),
        _buildCategoryItem(
          icon: Icons.grid_view_rounded,
          label: 'Xem thêm',
          color: Colors.purple[700]!,
        ),
      ];
    }

    // Lọc danh mục theo loại xe
    final vehicleTypes = categories
        .where((category) => category.type == 'loai_xe')
        .take(3)
        .toList();

    List<Widget> items = vehicleTypes
        .map((category) => _buildCategoryItem(
              icon: _getCategoryIcon(category.name),
              label: category.name,
              color: _getCategoryColor(category.name),
            ))
        .toList();

    // Thêm nút "Xem thêm"
    items.add(_buildCategoryItem(
      icon: Icons.grid_view_rounded,
      label: 'Xem thêm',
      color: Colors.purple[700]!,
    ));

    return items;
  }

  List<Widget> _buildBrandItems(List<Category> brands) {
    if (brands.isEmpty) {
      return [
        _buildBrandItem(label: 'Honda'),
        _buildBrandItem(label: 'Yamaha'),
        _buildBrandItem(label: 'Suzuki'),
        _buildBrandItem(label: 'Vinfast'),
      ];
    }

    // Lọc thương hiệu
    final brandItems = brands
        .where((category) => category.type == 'hang')
        .take(4)
        .map((brand) => _buildBrandItem(label: brand.name))
        .toList();

    return brandItems;
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBrandItem({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.blue[700] : Colors.grey[400],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.blue[700] : Colors.grey[400],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Hàm lấy icon cho danh mục
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'SUV':
        return Icons.directions_car;
      case 'Sedan':
        return Icons.directions_car;
      case 'Xe máy':
        return Icons.motorcycle;
      case 'Xe điện':
        return Icons.electric_bike;
      case 'Xe đạp':
        return Icons.pedal_bike;
      default:
        return Icons.category;
    }
  }

  // Hàm lấy màu cho danh mục
  Color _getCategoryColor(String categoryName) {
    switch (categoryName) {
      case 'SUV':
        return Colors.blue[700]!;
      case 'Sedan':
        return Colors.green[700]!;
      case 'Xe máy':
        return Colors.orange[700]!;
      case 'Xe điện':
        return Colors.purple[700]!;
      case 'Xe đạp':
        return Colors.teal[700]!;
      default:
        return Colors.blue[700]!;
    }
  }
}
