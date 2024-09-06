extension CapitalizeFirstWord on String {
  String capitalizeFirstWord() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
