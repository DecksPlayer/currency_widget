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
      return newValue.copyWith(
          selection: const TextSelection.collapsed(offset: 0));
    }

    // Solo permitir dígitos
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Guardar la posición del cursor original
    // Si hay una selección (rango), usar el final de la selección
    final oldCursorPosition = newValue.selection.isCollapsed
        ? newValue.selection.baseOffset
        : newValue.selection.end;

    // Contar cuántos dígitos hay DESPUÉS del cursor en el texto sin formatear
    // Esto mantiene la posición relativa desde el final
    int digitsAfterCursor = 0;
    for (int i = oldCursorPosition; i < newValue.text.length; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitsAfterCursor++;
      }
    }

    // Separar parte entera y decimal
    String integerPart;
    String decimalPart = '';

    // Caso especial: 0 decimales (JPY, IDR, HUF, TWD, etc.)
    if (decimalDigits == 0) {
      integerPart = digitsOnly;
    } else {
      if (digitsOnly.length <= decimalDigits) {
        integerPart = '0';
        decimalPart = digitsOnly.padLeft(decimalDigits, '0');
      } else {
        final splitIndex = digitsOnly.length - decimalDigits;
        integerPart = digitsOnly.substring(0, splitIndex);
        decimalPart = digitsOnly.substring(splitIndex);
      }
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

    // Construir texto formateado (sin decimales si decimalDigits = 0)
    final formatted = decimalDigits == 0
        ? formattedInt
        : '$formattedInt$decimalSeparator$decimalPart';

    // Calcular nueva posición del cursor
    int newCursorPosition;

    // Caso especial: si no hay dígitos después del cursor, poner al final
    if (digitsAfterCursor == 0) {
      newCursorPosition = formatted.length;
    } else {
      // Contar dígitos desde el final para encontrar la posición correcta
      int digitCount = 0;
      newCursorPosition = formatted.length;

      for (int i = formatted.length - 1; i >= 0; i--) {
        if (RegExp(r'\d').hasMatch(formatted[i])) {
          digitCount++;
          if (digitCount == digitsAfterCursor) {
            // El cursor debe ir ANTES de este dígito
            newCursorPosition = i;
            break;
          }
        }
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
