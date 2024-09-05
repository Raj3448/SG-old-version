class PriceDetailsNotFoundException implements Exception {

  const PriceDetailsNotFoundException([this.message = 'Price details not found', this.priceId]);
  final String message;
  final int? priceId;

  @override
  String toString() {
    if (priceId != null) {
      return 'PriceDetailsNotFoundException: $message for price ID $priceId';
    }
    return 'PriceDetailsNotFoundException: $message';
  }
}