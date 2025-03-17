import 'package:flutter/material.dart';
import 'package:optimusprime/screen/products/product_model.dart';
import 'package:provider/provider.dart';
import 'package:optimusprime/screen/shopping_cart/cart_model.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Consumer<Cart>(
          builder: (context, cart, child) {
            if (cart.items.isEmpty) {
              return const Center(
                child: Text(
                  'Giỏ hàng trống',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      final Product product = cartItem.product;

                      double originalPrice = product.price;
                      double discountPercentage = product.discount / 100;
                      double currentPrice =
                          originalPrice * (1 - discountPercentage);

                      return Dismissible(
                        key: Key(product.id),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          cart.removeItem(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} đã bị xóa'),
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          color: Colors.white,
                          child: ListTile(
                            leading: Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error,
                                    color: Colors.red);
                              },
                            ),
                            title: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Giá: ${currentPrice.toStringAsFixed(2)} USD',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove,
                                      color: Colors.blue),
                                  onPressed: () {
                                    cart.updateQuantity(
                                        product.id, cartItem.quantity - 1);
                                  },
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.add, color: Colors.blue),
                                  onPressed: () {
                                    cart.updateQuantity(
                                        product.id, cartItem.quantity + 1);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${cart.totalAmount.toStringAsFixed(2)} USD',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Thanh toán thành công với tổng ${cart.totalAmount.toStringAsFixed(2)} USD'),
                          ),
                        );

                        cart.clearCart();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Thanh toán',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
