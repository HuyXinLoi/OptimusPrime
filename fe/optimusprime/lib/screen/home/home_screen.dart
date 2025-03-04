import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _bestSellingScrollController = ScrollController();
  final ScrollController _newProductScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _startAutoScrolling(_bestSellingScrollController);
    _startAutoScrolling(_newProductScrollController);
  }

  void _startAutoScrolling(ScrollController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) return;
      void scroll() {
        if (!controller.hasClients) return;
        if (controller.position.maxScrollExtent <= 0) return;
        controller
            .animateTo(
          controller.position.maxScrollExtent,
          duration: Duration(
              seconds: (controller.position.maxScrollExtent / 50).toInt()),
          curve: Curves.linear,
        )
            .then((_) {
          if (!controller.hasClients) return;
          controller
              .animateTo(
            controller.position.minScrollExtent,
            duration: Duration(
                seconds: (controller.position.maxScrollExtent / 50).toInt()),
            curve: Curves.linear,
          )
              .then((_) {
            scroll(); 
          });
        });
      }
      scroll(); 
    });
  }

  @override
  void dispose() {
    _bestSellingScrollController.dispose();
    _newProductScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
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
                    SizedBox(width: 16.0),
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade200,
                      radius: 25.0,
                    ),
                  ],
                ),
              ),
              // Bán chạy nhất
              SectionHeader(title: 'Bán chạy nhất'),
              SingleChildScrollView(
                controller: _bestSellingScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    ProductCard(
                      imageUrl:
                          'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
                      name: '"Bike name"',
                      price: '"Price"',
                    ),
                    SizedBox(width: 16),
                    ProductCard(
                      imageUrl:
                          'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
                      name: '"Bike name"',
                      price: '"Price"',
                    ),
                    SizedBox(width: 16),
                    ProductCard(
                      imageUrl:
                          'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
                      name: '"Bike name"',
                      price: '"Price"',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Sản phẩm mới
              SectionHeader(title: 'Sản phẩm mới'),
              SingleChildScrollView(
                controller: _newProductScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    ProductCard(
                      imageUrl:
                          'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
                      name: '"Bike name"',
                      price: '"Price"',
                    ),
                    SizedBox(width: 16),
                    ProductCard(
                      imageUrl:
                          'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
                      name: '"Bike name"',
                      price: '"Price"',
                    ),
                    SizedBox(width: 16),
                    ProductCard(
                      imageUrl:
                          'https://thegioixedien.com.vn/datafiles/setone/1736940388_daidien-mxs.jpg',
                      name: '"Bike name"',
                      price: '"Price"',
                    ),
                  ],
                ),
              ),
              // Danh mục và thương hiệu
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CategoryBrandItem(label: 'Brand'),
                            CategoryBrandItem(label: 'Brand'),
                            CategoryBrandItem(label: 'Brand'),
                            CategoryBrandItem(label: 'Brand'),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: CategoryBrandItem(label: 'category'),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: CategoryBrandItem(label: 'category'),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: CategoryBrandItem(label: 'category'),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: CategoryBrandItem(
                                  label: 'Xem thêm', icon: Icons.grid_view),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

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

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
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
              imageUrl,
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
                  name,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900),
                ),
                SizedBox(height: 4.0),
                Text(
                  price,
                  style: TextStyle(fontSize: 14.0, color: Colors.blue.shade700),
                ),
                SizedBox(height: 8.0),
                Container(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBrandItem extends StatelessWidget {
  final String label;
  final IconData? icon;

  const CategoryBrandItem({
    super.key,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(icon),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
