import 'dart:collection';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class VNPayService {
  static const String vnpTmnCode = 'X5BG0WSF';
  static const String vnpHashSecret = 'G8XA3RGTZGCKYUSZLU0PSILKY5BV48O8';
  static const String vnpUrl =
      'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
  static const String vnpVersion = '2.1.0';
  static const String vnpCommand = 'pay';
  static const String vnpCurrCode = 'VND';
  static const String vnpLocale = 'vn';
  static const String vnpReturnUrl = 'motomarket://payment-callback';
  static String createPaymentUrl({
    required String orderId,
    required double amount,
    required String orderInfo,
    String? bankCode,
  }) {
    final params = <String, String>{
      'vnp_Version': vnpVersion,
      'vnp_Command': vnpCommand,
      'vnp_TmnCode': vnpTmnCode,
      'vnp_Locale': vnpLocale,
      'vnp_CurrCode': vnpCurrCode,
      'vnp_TxnRef': orderId,
      'vnp_OrderInfo': orderInfo,
      'vnp_OrderType': 'other',
      'vnp_Amount': (amount * 100).round().toString(),
      'vnp_ReturnUrl': vnpReturnUrl,
      'vnp_IpAddr': '10.0.2.2',
      'vnp_CreateDate': DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
    };
    print('this is params $params');

    if (bankCode != null && bankCode.isNotEmpty) {
      params['vnp_BankCode'] = bankCode;
    }

    final sortedParams = <String, String>{};
    final keys = params.keys.toList()..sort();
    for (final key in keys) {
      sortedParams[key] = params[key]!;
    }

    final signData = sortedParams.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    print('this is signdata $signData');

    final hmacSha512 = Hmac(sha512, utf8.encode(vnpHashSecret));
    final hash = hmacSha512.convert(utf8.encode(signData));
    final hashValue = hash.toString();

    final queryString = sortedParams.entries
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
        .join('&');

    final paymentUrl = '$vnpUrl?$queryString&vnp_SecureHash=$hashValue';

    // print('VNPay URL: $paymentUrl');
    return paymentUrl;
  }

  static String generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomPart = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    return 'DH$timestamp$randomPart';
  }

  static bool verifyPaymentResponse(Map<String, String> responseParams) {
    try {
      final secureHash = responseParams['vnp_SecureHash'];
      if (secureHash == null) return false;

      final params = SplayTreeMap<String, String>.of(responseParams);
      params.remove('vnp_SecureHash');
      params.remove('vnp_SecureHashType');

      final signData = params.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('&');

      final hmacSha512 = Hmac(sha512, utf8.encode(vnpHashSecret));
      final hash = hmacSha512.convert(utf8.encode(signData)).toString();

      print('Original hash: $secureHash');
      print('Calculated hash: $hash');

      return hash == secureHash;
    } catch (e) {
      print('Error verifying VNPAY response: $e');
      return false;
    }
  }
}
