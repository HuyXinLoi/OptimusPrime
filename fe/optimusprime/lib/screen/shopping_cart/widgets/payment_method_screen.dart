import 'package:flutter/material.dart';
import 'package:optimusprime/screen/home/models/product.dart';
import 'package:optimusprime/services/vnpay_service.dart';
import 'package:optimusprime/untils/format_utils.dart';
import 'vnpay_payment_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  final Product product;
  final int quantity;

  const PaymentMethodScreen({
    Key? key,
    required this.product,
    this.quantity = 1,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _selectedPaymentMethod = 0;
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 0,
      'name': 'Thanh toán khi nhận hàng (COD)',
      'icon': Icons.money,
      'color': Colors.green,
    },
    {
      'id': 1,
      'name': 'Thanh toán qua VNPay',
      'icon': Icons.payment,
      'color': Colors.blue,
    },
    {
      'id': 2,
      'name': 'Chuyển khoản ngân hàng',
      'icon': Icons.account_balance,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final quantity = widget.quantity;
    final totalPrice = product.discountedPrice * quantity;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Phương thức thanh toán',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Thông tin sản phẩm
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Số lượng: $quantity',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        FormatUtils.formatCurrency(product.discountedPrice),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Phương thức thanh toán
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn phương thức thanh toán',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ..._paymentMethods
                    .map((method) => _buildPaymentMethodItem(method)),
              ],
            ),
          ),

          const Spacer(),

          // Tổng tiền và nút thanh toán
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      FormatUtils.formatCurrency(totalPrice),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _processPayment(context, totalPrice),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildPaymentMethodItem(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method['id'];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: method['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                method['icon'],
                color: method['color'],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method['name'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            Radio(
              value: method['id'],
              groupValue: _selectedPaymentMethod,
              activeColor: Colors.blue[700],
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value as int;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, double totalAmount) async {
    switch (_selectedPaymentMethod) {
      case 0: // COD
        _showPaymentSuccessDialog(context, 'Thanh toán khi nhận hàng (COD)');
        break;
      case 1: // VNPay
        final orderId = VNPayService.generateOrderId();
        final orderInfo = 'Thanh toan don hang #$orderId';

        // Tạo URL thanh toán VNPay
        final paymentUrl = VNPayService.createPaymentUrl(
          orderId: orderId,
          amount: totalAmount,
          orderInfo: orderInfo,
        );

        // Mở màn hình WebView để thanh toán
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VNPayPaymentScreen(
              paymentUrl: paymentUrl,
              orderId: orderId,
            ),
          ),
        );
        break;
      case 2: // Chuyển khoản ngân hàng
        _showBankTransferDialog(context);
        break;
    }
  }

  void _showPaymentSuccessDialog(BuildContext context, String paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đặt hàng thành công'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Cảm ơn bạn đã đặt hàng!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phương thức thanh toán: $paymentMethod',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showBankTransferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông tin chuyển khoản'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ngân hàng: Vietcombank'),
            const Text('Số tài khoản: 1234567890'),
            const Text('Chủ tài khoản: CÔNG TY TNHH MOTOMARKET'),
            const SizedBox(height: 8),
            const Text(
              'Nội dung chuyển khoản: [Tên của bạn] - [Số điện thoại]',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Vui lòng chuyển khoản và chụp màn hình gửi qua Zalo: 0987654321',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showPaymentSuccessDialog(context, 'Chuyển khoản ngân hàng');
            },
            child: const Text('Đã chuyển khoản'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
