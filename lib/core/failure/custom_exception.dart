class PriceDetailsNotFoundException implements Exception {
  final String message;
  final int? priceId;

  // Constructor for the exception, allowing a custom message and optional priceId
  const PriceDetailsNotFoundException([this.message = 'Price details not found', this.priceId]);

  // Override the toString() method to display the exception details
  @override
  String toString() {
    if (priceId != null) {
      return 'PriceDetailsNotFoundException: $message for price ID $priceId';
    }
    return 'PriceDetailsNotFoundException: $message';
  }
}