double? parseSpanishDecimal(String value) {
  if (value.isEmpty) return null;
  final cleaned = value.replaceAll(',', '.');
  return double.tryParse(cleaned);
}
