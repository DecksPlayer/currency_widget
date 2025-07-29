import 'dart:io';

import './currency.dart';

void main() async {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED FILE - DO NOT MODIFY BY HAND');
  buffer.writeln('// ignore_for_file: prefer_const_constructors');
  buffer.writeln('');

  buffer.writeln('import \'package:currency_widget/currency_widget.dart\';');
  buffer.writeln('');
  buffer.writeln('final supportedCurrencies = <Currency>[');

  for (final currency in currencies) {
    buffer.writeln('  Currency(');
    buffer.writeln('    code: "${currency['code']}",');
    buffer.writeln('    name: "${currency['name']}",');
    buffer.writeln('    symbol: "${cleanSymbol(currency['symbol'])}",');
    buffer.writeln('    emoji: "${currency['emoji']}",');
    buffer.writeln('    decimal_digits: ${currency['decimal_digits']},');
    buffer.writeln('    position: "${currency['position']}",');
    buffer.writeln('  ),');
  }


  buffer.writeln('];');

  final outputFile = File('lib/src/assets/supported_currencies.dart');
  await outputFile.writeAsString(buffer.toString());

  print('✅ supported_countries.dart generated successfully.');
}

String cleanSymbol(String? symbol) {
  if (symbol == null) return '';
  if (symbol.contains("\$") ) {
    return symbol.replaceAll('\$', '\\\$');
  }
  return symbol;
}
