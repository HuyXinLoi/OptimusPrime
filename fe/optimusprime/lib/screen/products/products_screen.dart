import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/screen/products/bloc/product_bloc.dart';
import 'package:optimusprime/screen/products/bloc/product_event.dart';
import 'package:optimusprime/screen/products/bloc/product_state.dart';
import 'package:optimusprime/screen/products/product_model.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(FetchProducts());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            GoRouter.of(context).go('/search');
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Thương hiệu phổ biến'),
                  SizedBox(
                    height: 100,
                    child: AnimatedBrandCarousel(
                      brands: [
                        BrandItem(
                            imgUrl:
                                'https://inkythuatso.com/uploads/images/2021/10/logo-vinfast-inkythuatso-21-11-08-55.jpg'),
                        BrandItem(
                            imgUrl:
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Yadea_Logo.svg/2048px-Yadea_Logo.svg.png'),
                        BrandItem(
                            imgUrl:
                                'https://banner2.cleanpng.com/20180713/qus/aawxuwwfd.webp'),
                        BrandItem(
                            imgUrl:
                                'https://e7.pngegg.com/pngimages/551/66/png-clipart-honda-logo-honda-motor-company-motorcycle-honda-angle-text.png'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SectionHeader(title: 'Sản phẩm'),
                  SizedBox(
                    height: 60,
                    child: AnimatedTypeCarousel(
                      types: [
                        TypeItem(text: 'Xe điện'),
                        TypeItem(text: 'Tai nghe'),
                        TypeItem(text: 'Xe côn tay'),
                        TypeItem(text: 'Điện thoại'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is ProductError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('Lỗi: ${state.message}')),
                  );
                } else if (state is ProductLoaded) {
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(product: state.products[index]);
                      },
                      childCount: state.products.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                  );
                } else {
                  return SliverFillRemaining(
                    child: Center(child: Text('Không có sản phẩm nào')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, top: 16.0, right: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BrandItem extends StatelessWidget {
  final String imgUrl;

  const BrandItem({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.network(
          imgUrl,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error, size: 40, color: Colors.red);
          },
        ),
      ),
    );
  }
}

class TypeItem extends StatelessWidget {
  final String text;

  const TypeItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 2),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            fontFamily: 'Roboto',
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AnimatedBrandCarousel extends StatefulWidget {
  final List<BrandItem> brands;

  const AnimatedBrandCarousel({super.key, required this.brands});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedBrandCarouselState createState() => _AnimatedBrandCarouselState();
}

class _AnimatedBrandCarouselState extends State<AnimatedBrandCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = 88.0;
    return SizedBox(
      height: 100,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Flow(
            delegate: CarouselFlowDelegate(
              animationValue: _animation.value,
              itemCount: widget.brands.length,
              itemWidth: itemWidth,
            ),
            children: [
              ...widget.brands,
              ...widget.brands,
            ]
                .map((brand) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: brand,
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class AnimatedTypeCarousel extends StatefulWidget {
  final List<TypeItem> types;

  const AnimatedTypeCarousel({super.key, required this.types});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedTypeCarouselState createState() => _AnimatedTypeCarouselState();
}

class _AnimatedTypeCarouselState extends State<AnimatedTypeCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = 130.0;
    return SizedBox(
      height: 100,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Flow(
            delegate: CarouselFlowDelegate(
              animationValue: _animation.value,
              itemCount: widget.types.length,
              itemWidth: itemWidth,
            ),
            children: [
              ...widget.types,
              ...widget.types,
            ]
                .map((type) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: type,
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class CarouselFlowDelegate extends FlowDelegate {
  final double animationValue;
  final int itemCount;
  final double itemWidth;

  CarouselFlowDelegate({
    required this.animationValue,
    required this.itemCount,
    required this.itemWidth,
  }) : super(repaint: null);

  @override
  void paintChildren(FlowPaintingContext context) {
    final double totalWidth = itemWidth * itemCount;
    final double offset = animationValue * totalWidth;

    for (int i = 0; i < context.childCount; i++) {
      double xPosition = (i * itemWidth) - offset;
      if (xPosition < -itemWidth) {
        xPosition += totalWidth * 2;
      }
      context.paintChild(
        i,
        transform: Matrix4.translationValues(xPosition, 0, 0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        itemCount != oldDelegate.itemCount ||
        itemWidth != oldDelegate.itemWidth;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(itemWidth * itemCount * 2, constraints.maxHeight);
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.blue.shade100],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image.network(
              product.image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/default_image.png',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        '${product.price} USD',
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.blue.shade700),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push(
                        '/product-detail',
                        extra: product,
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Mua ngay',
                        style: TextStyle(fontSize: 12.0, color: Colors.white),
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
}
