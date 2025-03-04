import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String price;
  final String description;
  final String brand;
  final String category;
  final String color;
  final int stock;
  final double discount;
  final double rating;
  final List<String> images;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.brand,
    required this.color,
    required this.category,
    required this.stock,
    required this.discount,
    required this.rating,
    required this.images,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? 'Unknown',
      imageUrl: map['imageUrl'] as String? ?? '',
      price: map['price'] as String? ?? '0 VNĐ',
      description: map['description'] as String? ?? 'No description',
      brand: map['brand'] as String? ?? 'Unknown',
      category: map['category'] as String? ?? 'Unknown',
      color: map['color'] as String? ?? 'Unknown',
      stock: map['stock'] as int? ?? 0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      images: List<String>.from((map['images'] as List<dynamic>?) ?? []),
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, brand: $brand, category: $category, category: $color, stock: $stock, discount: $discount, rating: $rating, images: $images)';
  }
}

class _ProductsScreenState extends State<ProductsScreen> {
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
                hintText: 'Tìm kiếm xe...',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SectionHeader(title: 'Hãng xe phổ biến'),
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
              SizedBox(height: 20),
              SectionHeader(title: 'Loại xe'),
              SizedBox(
                height: 60,
                child: AnimatedTypeCarousel(
                  types: [
                    TypeItem(text: 'Xe xăng'),
                    TypeItem(text: 'Xe tay ga'),
                    TypeItem(text: 'Xe côn tay'),
                    TypeItem(text: 'Xe điện'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ProductGrid(),
            ],
          ),
        ),
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

class StaticTypeCarousel extends StatelessWidget {
  final List<TypeItem> types;

  const StaticTypeCarousel({super.key, required this.types});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: types
              .map((type) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: type,
                  ))
              .toList(),
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

class ProductGrid extends StatelessWidget {
  ProductGrid({super.key});

  final List<Product> products =
      productsData.map((productMap) => Product.fromMap(productMap)).toList();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
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
              product.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900),
                ),
                SizedBox(height: 4.0),
                Text(
                  product.price,
                  style: TextStyle(fontSize: 14.0, color: Colors.blue.shade700),
                ),
                SizedBox(height: 8.0),
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
        ],
      ),
    );
  }
}

final Map<String, dynamic> productData = {
  'id': 1,
  'name': 'Xe Điện MXS',
  'imageUrl':
      'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
  'price': '15,000,000 VNĐ',
  'description':
      'Xe điện cao cấp, tiết kiệm năng lượng, thân thiện môi trường.',
  'brand': 'VinFast',
  'category': 'Xe điện',
  'color': 'Đỏ',
  'stock': 50,
  'discount': 10,
  'images': [
    'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
    'https://example.com/product2.jpg',
    'https://example.com/product3.jpg',
  ],
};

final List<Map<String, dynamic>> productsData = [
  productData,
  {
    'id': 2,
    'name': 'Xe Điện Pro',
    'imageUrl':
        'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
    'price': '20,000,000 VNĐ',
    'description': 'Xe điện mạnh mẽ, tốc độ cao, thiết kế hiện đại.',
    'brand': 'VinFast',
    'category': 'Xe điện',
    'color': 'Đen',
    'stock': 30,
    'discount': 15,
    'rating': 4.7,
    'images': [
      'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
      'https://example.com/product4.jpg',
      'https://example.com/product5.jpg',
    ],
  },
  {
    'id': 3,
    'name': 'Xe Điện Lite',
    'imageUrl':
        'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
    'price': '12,000,000 VNĐ',
    'description': 'Xe điện giá rẻ, phù hợp cho đô thị.',
    'brand': 'Yadea',
    'category': 'Xe điện',
    'color': 'Xanh',
    'stock': 70,
    'discount': 5.0,
    'rating': 4.2,
    'images': [
      'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
      'https://example.com/product6.jpg',
      'https://example.com/product7.jpg',
    ],
  },
  {
    'id': 4,
    'name': 'Xe Điện Premium',
    'imageUrl':
        'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
    'price': '25,000,000 VNĐ',
    'description': 'Xe điện cao cấp, thiết kế sang trọng, hiệu suất mạnh.',
    'brand': 'Honda',
    'category': 'Xe điện',
    'color': 'Tím',
    'stock': 20,
    'discount': 20.0,
    'rating': 4.8,
    'images': [
      'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
      'https://example.com/product8.jpg',
      'https://example.com/product9.jpg',
    ],
  },
  {
    'id': 5,
    'name': 'Xe Điện Basic',
    'imageUrl':
        'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
    'price': '10,000,000 VNĐ',
    'description': 'Xe điện cơ bản, giá rẻ, dễ sử dụng.',
    'brand': 'Yadea',
    'category': 'Xe điện',
    'color': 'Cam',
    'stock': 100,
    'discount': 0.0,
    'rating': 4.0,
    'images': [
      'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
      'https://example.com/product10.jpg',
      'https://example.com/product11.jpg',
    ],
  },
  {
    'id': 6,
    'name': 'Xe Điện Elite',
    'imageUrl':
        'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
    'price': '18,000,000 VNĐ',
    'description':
        'Xe điện trung cấp, thiết kế hiện đại, tiết kiệm năng lượng.',
    'brand': 'VinFast',
    'category': 'Xe điện',
    'color': 'Xanh dương',
    'stock': 40,
    'discount': 12.0,
    'rating': 4.6,
    'images': [
      'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
      'https://example.com/product12.jpg',
      'https://example.com/product13.jpg',
    ],
  },
];
