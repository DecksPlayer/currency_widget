import 'dart:io';

import './currency.dart';


enum lang{
  es,en,pt,fr,de,it,ru,zh,ja,ko,ar,id,hi,ur
}

void main() async {
  for(int i=0;i<lang.values.length;i++) {
    final buffer = StringBuffer();

    buffer.writeln('// GENERATED FILE - DO NOT MODIFY BY HAND');
    buffer.writeln('// ignore_for_file: prefer_const_constructors');
    buffer.writeln('');

    buffer.writeln('import \'package:currency_widget/currency_widget.dart\';');
    buffer.writeln('');
    buffer.writeln('final currencies${lang.values.elementAt(i).name.toUpperCase()} = <Map<String,dynamic>>[');
    for (final currency in currencies) {
      buffer.writeln(' {');
      buffer.writeln(' "code":"${currency['code']}",');
      buffer.writeln('  "name": "${currency['name']}",');
      buffer.writeln(' },');
    }
    buffer.writeln('];');

    final outputFile = File('lib/src/assets/currencies_names/currencies_names_${lang.values.elementAt(i).name}.dart');
      if(!await outputFile.exists())
        await outputFile.writeAsString(buffer.toString());
    print('✅ lang_${lang.values.elementAt(i).name}.dart generated successfully.');

  }
}

String cleanSymbol(String? symbol) {
  if (symbol == null) return '';
  if (symbol.contains("\$") ) {
    return symbol.replaceAll('\$', '\\\$');
  }
  return symbol;
}
