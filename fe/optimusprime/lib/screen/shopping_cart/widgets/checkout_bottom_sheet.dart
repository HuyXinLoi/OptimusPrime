import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/untils/format_utils.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CheckoutBottomSheet extends StatefulWidget {
  const CheckoutBottomSheet({Key? key}) : super(key: key);

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedPaymentMethod = 'COD';

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Thông tin thanh toán',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Address
                      const Text(
                        'Địa chỉ giao hàng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: 'Nhập địa chỉ giao hàng',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập địa chỉ giao hàng';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      const Text(
                        'Số điện thoại',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: 'Nhập số điện thoại',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Payment method
                      const Text(
                        'Phương thức thanh toán',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPaymentMethodOption(
                        title: 'Thanh toán khi nhận hàng (COD)',
                        value: 'COD',
                        icon: Icons.money,
                      ),
                      const SizedBox(height: 8),
                      _buildPaymentMethodOption(
                        title: 'Chuyển khoản ngân hàng',
                        value: 'Bank',
                        icon: Icons.account_balance,
                      ),
                      const SizedBox(height: 8),
                      _buildPaymentMethodOption(
                        title: 'Ví điện tử (MoMo, ZaloPay...)',
                        value: 'EWallet',
                        icon: Icons.account_balance_wallet,
                      ),
                      const SizedBox(height: 32),

                      // Order summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tóm tắt đơn hàng',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<CartBloc, CartState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    _buildSummaryRow(
                                      'Tổng tiền hàng',
                                      '${FormatUtils.formatCurrency(state.cart.totalPrice)}',
                                    ),
                                    const SizedBox(height: 8),
                                    _buildSummaryRow(
                                      'Phí vận chuyển',
                                      'Miễn phí',
                                      valueColor: Colors.green[700],
                                    ),
                                    const Divider(height: 24),
                                    _buildSummaryRow(
                                      'Tổng thanh toán',
                                      '${FormatUtils.formatCurrency(state.cart.totalPrice)}',
                                      titleStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      valueStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Submit button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: BlocConsumer<CartBloc, CartState>(
                  listener: (context, state) {
                    if (state.status == CartStatus.success &&
                        state.cart.items.isEmpty) {
                      Navigator.pop(context);
                      context.go('/order-success');
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isCheckingOut
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<CartBloc>().add(
                                        ProceedToCheckout(
                                          address: _addressController.text,
                                          phone: _phoneController.text,
                                          paymentMethod: _selectedPaymentMethod,
                                        ),
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: state.isCheckingOut
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Đặt hàng',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodOption({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _selectedPaymentMethod == value
              ? Colors.blue[50]
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedPaymentMethod == value
                ? Colors.blue[700]!
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedPaymentMethod == value
                  ? Colors.blue[700]
                  : Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: _selectedPaymentMethod == value
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            Radio(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue.toString();
                });
              },
              activeColor: Colors.blue[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value, {
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ?? const TextStyle(color: Colors.black87),
        ),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
        ),
      ],
    );
  }
}
