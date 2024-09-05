class PriceDetailsNotFoundException implements Exception {
  final String message;
  final int? priceId;

  const PriceDetailsNotFoundException({this.message = 'Price details not found', this.priceId});

  @override
  String toString() {
    if (priceId != null) {
      return 'PriceDetailsNotFoundException: $message for price ID $priceId';
    }
    return 'PriceDetailsNotFoundException: $message';
  }
}