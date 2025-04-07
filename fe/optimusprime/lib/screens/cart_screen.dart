import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else if (state is CartLoaded) {
            return _buildCartContent(context, state.cart);
          }
          return const Center(child: Text('Your cart is empty'));
        },
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartModel cart) {
    if (cart.items.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${item.price.toStringAsFixed(2)}'),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<CartBloc>().add(
                                RemoveFromCart(productId: item.productId),
                              );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showCheckoutDialog(context),
                child: const Text('Proceed to Checkout'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedPaymentMethod = 'Cash';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Delivery Address'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPaymentMethod,
              decoration: const InputDecoration(labelText: 'Payment Method'),
              items: const [
                DropdownMenuItem(
                    value: 'Cash', child: Text('Cash on Delivery')),
                DropdownMenuItem(value: 'Card', child: Text('Credit Card')),
              ],
              onChanged: (value) {
                selectedPaymentMethod = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (addressController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                context.read<CartBloc>().add(
                      CheckoutCart(
                        address: addressController.text,
                        phone: phoneController.text,
                        paymentMethod: selectedPaymentMethod,
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
