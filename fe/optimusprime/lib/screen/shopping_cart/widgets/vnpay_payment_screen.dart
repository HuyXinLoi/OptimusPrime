import 'package:flutter/material.dart';
import 'package:optimusprime/services/vnpay_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayPaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const VNPayPaymentScreen({
    Key? key,
    required this.paymentUrl,
    required this.orderId,
  }) : super(key: key);

  @override
  State<VNPayPaymentScreen> createState() => _VNPayPaymentScreenState();
}

class _VNPayPaymentScreenState extends State<VNPayPaymentScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Kiểm tra URL callback
            if (request.url.contains('motomarket://payment-callback') ||
                request.url.contains('success.motomarket.app') ||
                request.url.contains('payment-callback')) {
              _handlePaymentCallback(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentCallback(String url) {
    final uri = Uri.parse(url);
    final params = uri.queryParameters;

    // Chuyển đổi Map<String, String?> sang Map<String, String>
    final responseParams = <String, String>{};
    params.forEach((key, value) {
      if (value != null) {
        responseParams[key] = value;
      }
    });

    // Kiểm tra kết quả thanh toán
    final isValid = VNPayService.verifyPaymentResponse(responseParams);
    final responseCode = params['vnp_ResponseCode'];

    if (isValid && responseCode == '00') {
      // Thanh toán thành công
      _showPaymentResult(true, 'Thanh toán thành công!');
    } else {
      // Thanh toán thất bại
      _showPaymentResult(false, 'Thanh toán thất bại. Mã lỗi: $responseCode');
    }
  }

  void _showPaymentResult(bool isSuccess, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title:
            Text(isSuccess ? 'Thanh toán thành công' : 'Thanh toán thất bại'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (isSuccess) ...[
              const SizedBox(height: 8),
              Text(
                'Mã đơn hàng: ${widget.orderId}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
              Navigator.of(context)
                  .pop(); // Quay lại màn hình phương thức thanh toán
              if (isSuccess) {
                Navigator.of(context)
                    .pop(); // Quay lại màn hình chi tiết sản phẩm
              }
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thanh toán VNPay',
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
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
