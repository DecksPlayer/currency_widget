import '../models/currency.dart';

class CurrencyFormatUtils {
  /// Formats a [double] amount into a string using the [Currency] object's separators.
  static String formatAmount(double amount, Currency currency) {
    String integerPart;
    String decimalPart = '';

    final decimalDigits = currency.decimalDigits;
    final decimalSeparator = currency.decimalSeparator;
    final thousandSeparator = currency.thousandSeparator;

    // Convert to fixed string with proper decimal digits
    String fixedString = amount.toStringAsFixed(decimalDigits);
    
    List<String> parts = fixedString.split('.');
    integerPart = parts[0];
    if (parts.length > 1) {
      decimalPart = parts[1];
    }

    // Apply thousands separator
    String formattedInt = '';
    for (int i = 0; i < integerPart.length; i++) {
      final reversedIndex = integerPart.length - i - 1;
      formattedInt = integerPart[reversedIndex] + formattedInt;
      if ((i + 1) % 3 == 0 && reversedIndex != 0 && integerPart[reversedIndex - 1] != '-') {
        formattedInt = thousandSeparator + formattedInt;
      }
    }

    if (decimalDigits == 0) {
      return formattedInt;
    } else {
      return '$formattedInt$decimalSeparator$decimalPart';
    }
  }
}
