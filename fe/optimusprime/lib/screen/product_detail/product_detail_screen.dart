import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/screen/products/product_model.dart';
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
    double originalPrice = widget.product.price;
    double discountPercentage = widget.product.discount / 100;
    double currentPrice = originalPrice * (1 - discountPercentage);

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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.product.image),
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
                      SizedBox(height: 10),
                      Text(
                        '${originalPrice.toStringAsFixed(2)} USD',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '${currentPrice.toStringAsFixed(2)} USD',
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
                            '• Danh mục: ${widget.product.category.name.isNotEmpty ? widget.product.category.name : 'null'}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            '• Tồn kho: ${widget.product.quantity}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            'Chính hãng',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• Mô tả: ${widget.product.category.description.isNotEmpty ? widget.product.category.description : 'Không có mô tả'}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Row(
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
                        style: TextStyle(fontSize: 18, color: Colors.black),
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
                          final cartProduct = Product(
                            id: widget.product.id,
                            name: widget.product.name,
                            price: currentPrice,
                            description: widget.product.description,
                            quantity: widget.product.quantity,
                            image: widget.product.image,
                            category: widget.product.category,
                            discount: widget.product.discount,
                          );

                          cart.addItem(cartProduct, _quantity);
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
