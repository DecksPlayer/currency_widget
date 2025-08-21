import 'package:currency_widget/src/assets/supported_currencies.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_widget/currency_widget.dart';

void main() {
  test('chooses a currency using supported currencies and currency controller', () {
    // Arrange
    final currencyController = CurrencyController(lang: 'es');
    final List<Currency> _supportedCurrencies = supportedCurrencies;
    for(Currency currency in _supportedCurrencies){
      currencyController.currency =currency;
      print(currencyController.currency.toString());
      expect(currencyController.currency, currency);    }

  });
  test('set currency value',(){
    final currencyController = CurrencyController(lang:'es');
    currencyController!.mount.value =300;
    expect(currencyController.mount.value, 300);
  });
}

