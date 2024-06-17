import 'package:dio/dio.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

enum PaymentStatus { success, failure, pending }

class PaymentService {
  final Razorpay _razorpay = Razorpay();
  final ProductListingStore productListingStore;
  final HttpClient httpClient;
  PaymentService({required this.productListingStore,
    required this.httpClient,
  }) {
    initRazorpay();
  }

  void initRazorpay() {
    _razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({required double amount, required String receipt}) async {
    //final orderId = await _createOrder(amount, receipt);
    var options = {
      'key': 'rzp_test_iSQwvN7ULfCVtv',
      'amount': amount * 100,
      'currency': 'INR',
      'name': 'Rajkumar Chavan',
      'description': 'Payment for the order',
      //'order_id': orderId,
      'prefill': {
        'contact': '+91 9156313158',
        'email': 'example@example.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> _createOrder(double amount, String receipt) async {
    final response = await httpClient.post(
      'api/payment',
      data: {'amount': amount, 'currency': 'INR', 'receipt': receipt},
      options: Options(headers: {
        'Content-Type': 'application/json',
      }),
    );

    if (response.statusCode == 200) {
      final orderData = response.data;
      return orderData['id'].toString();
    } else {
      throw Exception('Failed to create order');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Successful: ${response.paymentId}');
    productListingStore.paymentStatus = PaymentStatus.success;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.message}');
    productListingStore.paymentStatus = PaymentStatus.failure;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    productListingStore.paymentStatus = PaymentStatus.pending;
  }

  void dispose() {
    _razorpay.clear();
  }
}
