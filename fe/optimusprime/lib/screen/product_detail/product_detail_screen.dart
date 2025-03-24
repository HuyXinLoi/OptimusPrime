import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:optimusprime/screen/home/models/product.dart';
import 'package:optimusprime/screen/product_detail/bloc/product_details_bloc.dart';
import 'package:optimusprime/screen/product_detail/bloc/product_details_event.dart';
import 'package:optimusprime/screen/product_detail/bloc/product_details_state.dart';
import 'package:optimusprime/screen/product_detail/models/product_detail.dart';
import 'package:optimusprime/screen/shopping_cart/widgets/payment_method_screen.dart';
import 'package:optimusprime/services/api_services.dart';
import 'package:optimusprime/untils/format_utils.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailBloc(
        apiService: ApiService(),
      )..add(LoadProductDetail(productId)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state.status == ProductDetailStatus.initial ||
                state.status == ProductDetailStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == ProductDetailStatus.failure) {
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
                          'Đã xảy ra lỗi khi tải thông tin sản phẩm',
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
                            .read<ProductDetailBloc>()
                            .add(RefreshProductDetail(productId));
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

            final product = state.product!;
            return _buildProductDetail(context, product);
          },
        ),
      ),
    );
  }

  Widget _buildProductDetail(BuildContext context, ProductDetail product) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductDetailBloc>().add(RefreshProductDetail(productId));
      },
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageGallery(product),
                ),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.blue[700],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.red[400],
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Đã thêm ${product.name} vào danh sách yêu thích'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      color: Colors.blue[700],
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Chia sẻ ${product.name}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Thông tin sản phẩm
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên sản phẩm
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Thương hiệu và loại xe
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.brand,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product.vehicleType,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                          if (product.isNew)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Mới',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Giá và đánh giá
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.discount > 0)
                                Text(
                                  FormatUtils.formatCurrency(product.price),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                product.discount > 0
                                    ? FormatUtils.formatCurrency(
                                        product.discountedPrice)
                                    : FormatUtils.formatCurrency(product.price),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Mô tả sản phẩm
                      const Text(
                        'Mô tả sản phẩm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Thông số kỹ thuật
                      const Text(
                        'Thông số kỹ thuật',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSpecifications(product),
                      const SizedBox(height: 24),

                      // Đánh giá sản phẩm
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Đánh giá sản phẩm',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Chuyển đến trang đánh giá đầy đủ
                            },
                            child: Text(
                              'Xem tất cả',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // _buildReviews(product),
                      const SizedBox(height: 100), // Khoảng cách cho bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.blue[700],
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã thêm vào giỏ hàng'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentMethodScreen(
                                product: Product(
                                  id: product.id,
                                  name: product.name,
                                  price: product.price,
                                  description: product.description,
                                  quantity: product.quantity,
                                  image: product.image,
                                  categories: product.categories,
                                  discount: product.discount,
                                  createdAt: product.createdAt,
                                  updatedAt: product.updatedAt,
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Mua ngay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(ProductDetail product) {
    return PageView.builder(
      itemCount: product.images.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: product.images[index],
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.error, color: Colors.red),
          ),
        );
      },
    );
  }

  Widget _buildSpecifications(ProductDetail product) {
    // Tạo danh sách thông số kỹ thuật từ categories
    Map<String, String> specs = {
      'Thương hiệu': product.brand,
      'Loại xe': product.vehicleType,
      'Nhiên liệu': product.fuelType,
      'Động cơ': product.engineType,
    };

    // Thêm các thông số khác từ specifications nếu có
    if (product.specifications.isNotEmpty) {
      product.specifications.forEach((key, value) {
        specs[key] = value.toString();
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: specs.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[300],
          height: 1,
        ),
        itemBuilder: (context, index) {
          final entry = specs.entries.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildReviews(ProductDetail product) {
  //   // Nếu không có đánh giá, hiển thị thông báo
  //   if (3 == 3) {
  //     return Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[100],
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: const Center(
  //         child: Text(
  //           'Chưa có đánh giá nào cho sản phẩm này',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey,
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  // // Hiển thị 3 đánh giá đầu tiên
  // return ListView.builder(
  //   shrinkWrap: true,
  //   physics: const NeverScrollableScrollPhysics(),
  //   itemCount: product.reviews.length > 3 ? 3 : product.reviews.length,
  //   itemBuilder: (context, index) {
  //     final review = product.reviews[index];
  //     return Container(
  //       margin: const EdgeInsets.only(bottom: 16),
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[100],
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               CircleAvatar(
  //                 radius: 20,
  //                 backgroundColor: Colors.blue[100],
  //                 backgroundImage: review.userAvatar != null
  //                     ? NetworkImage(review.userAvatar!)
  //                     : null,
  //                 child: review.userAvatar == null
  //                     ? Text(
  //                         review.userName.substring(0, 1).toUpperCase(),
  //                         style: TextStyle(
  //                           color: Colors.blue[700],
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       )
  //                     : null,
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       review.userName,
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black87,
  //                       ),
  //                     ),
  //                     Text(
  //                       '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.grey[600],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.star,
  //                     color: Colors.amber[700],
  //                     size: 16,
  //                   ),
  //                   const SizedBox(width: 4),
  //                   Text(
  //                     review.rating.toString(),
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.grey[700],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 12),
  //           Text(
  //             review.comment,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: Colors.grey[700],
  //               height: 1.5,
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   },
  // );
  // }
}
