import 'package:decimal/decimal.dart';

/// Helper functions for Decimal JSON serialization
class DecimalJson {
  /// Converts a Decimal to a JSON-serializable string
  static String? toJson(Decimal? decimal) => decimal?.toString();

  /// Converts a JSON value to a Decimal
  static Decimal? fromJson(dynamic value) {
    if (value == null) return null;

    // Handle MongoDB Decimal128 format
    if (value is Map<String, dynamic> && value.containsKey(r'$numberDecimal')) {
      final stringValue = value[r'$numberDecimal'];
      if (stringValue is String) return Decimal.parse(stringValue);
      return null;
    }

    // Handle direct string/number values
    if (value is String) return Decimal.parse(value);
    if (value is num) return Decimal.parse(value.toString());

    return null;
  }
}
