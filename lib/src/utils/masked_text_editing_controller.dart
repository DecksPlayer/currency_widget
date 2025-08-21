import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A [TextInputFormatter] that automatically formats the input as a decimal number.
class AutoDecimalNumberFormatter extends TextInputFormatter {
  /// The number of decimal digits to allow.
  final int decimalDigits;

  /// The character to use as a decimal separator.
  final String decimalSeparator;

  /// The character to use as a thousand separator.
  final String thousandSeparator;

  /// Creates an [AutoDecimalNumberFormatter].
  ///
  /// Defaults:
  ///   - `decimalDigits`: 2
  ///   - `decimalSeparator`: '.'
  ///   - `thousandSeparator`: ','
  AutoDecimalNumberFormatter({
    this.decimalDigits = 2,
    this.decimalSeparator = '.',
    this.thousandSeparator = ',',
  });
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Permitir borrado completo
    if (newValue.text.isEmpty) {
      return newValue.copyWith(selection: const TextSelection.collapsed(offset: 0));
    }

    // Solo permitir dígitos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Calcular posición del cursor
    final cursorPosition = newValue.selection.baseOffset ?? newValue.text.length;

    // Separar parte entera y decimal
    String integerPart;
    String decimalPart;

    if (digitsOnly.length <= decimalDigits) {
      integerPart = '0';
      decimalPart = digitsOnly.padLeft(decimalDigits, '0');
    } else {
      final splitIndex = digitsOnly.length - decimalDigits;
      integerPart = digitsOnly.substring(0, splitIndex);
      decimalPart = digitsOnly.substring(splitIndex);
    }

    // Eliminar ceros a la izquierda
    integerPart = integerPart.replaceFirst(RegExp(r'^0+'), '');
    if (integerPart.isEmpty) integerPart = '0';

    // Aplicar separador de miles
    String formattedInt = '';
    for (int i = 0; i < integerPart.length; i++) {
      final reversedIndex = integerPart.length - i - 1;
      formattedInt = integerPart[reversedIndex] + formattedInt;
      if ((i + 1) % 3 == 0 && reversedIndex != 0) {
        formattedInt = thousandSeparator + formattedInt;
      }
    }

    final formatted = '$formattedInt$decimalSeparator$decimalPart';

    // Calcular nueva posición del cursor
    int newCursorPosition = formatted.length;
    if (cursorPosition > 0 && cursorPosition <= newValue.text.length) {
      // Lógica para mantener el cursor en una posición relativa
      final relativePosition = cursorPosition / newValue.text.length;
      newCursorPosition = (formatted.length * relativePosition).round();
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}