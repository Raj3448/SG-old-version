import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/feature/genie/store/product_listing_store.dart';

enum PaymentStatus { success, failure, pending }

class PaymentService {
  PaymentService({
    required this.productListingStore,
    required this.httpClient,
  }) {
    initRazorpay();
  }
  final Razorpay _razorpay = Razorpay();
  final ProductListingStore productListingStore;
  final HttpClient httpClient;

  void initRazorpay() {
    _razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required String orderId,
    required String razorpayApiKey,
    bool isSubscription = false,
  }) async {
    late Map<String, dynamic> options;

    if (isSubscription) {
      options = {
        'key': razorpayApiKey,
        'description': 'Payment for the order',
        'subscription_id': orderId,
        'external': {
          'wallets': ['paytm'],
        },
      };
    } else {
      options = {
        'key': razorpayApiKey,
        'description': 'Payment for the order',
        'order_id': orderId,
        'external': {
          'wallets': ['paytm'],
        },
      };
    }

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
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
