import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/screen/products/products_screen.dart';
import 'package:optimusprime/screen/shopping_cart/cart_model.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) _quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              GoRouter.of(context).push('/shoppingcart');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.product.images.isNotEmpty
                        ? widget.product.images[0]
                        : widget.product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.product.brand,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.product.price,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Danh mục: ${widget.product.category}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          '• Tồn kho: ${widget.product.stock}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          '• Giảm giá: ${widget.product.discount}%',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          '• Đánh giá: ${widget.product.rating}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          'Chính hãng',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Màu sắc: ${widget.product.color}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.blue),
                              onPressed: _decrementQuantity,
                            ),
                            Text(
                              '$_quantity',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.blue),
                              onPressed: _incrementQuantity,
                            ),
                          ],
                        ),
                        Consumer<Cart>(
                          builder: (context, cart, child) {
                            return ElevatedButton(
                              onPressed: () {
                                final cartItem = CartItem(
                                    product: widget.product,
                                    quantity: _quantity);
                                cart.addItem(cartItem.product, _quantity);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Đã thêm ${widget.product.name} x$_quantity vào giỏ hàng'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Thêm vào giỏ hàng',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
