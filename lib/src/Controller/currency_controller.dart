import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/supported_currencies.dart';
import 'package:flutter/material.dart';
/// The `CurrencyController` class is responsible for managing the currency and amount data.
class CurrencyController{
  /// The language code for localization.
  String lang;
  /// Creates a new `CurrencyController` instance.
  /// The `lang` parameter is required and specifies the language code for localization.
  /// The `initialCurrencyCode` parameter is optional and sets the initial currency.
  CurrencyController({required this.lang, String? initialCurrencyCode}) {
    if (initialCurrencyCode != null) {
      currency = getCurrencyByCode(initialCurrencyCode);
    }
  }

  ValueNotifier<double?> mount = ValueNotifier<double?>(0);
  ValueNotifier<Currency?> _currency = ValueNotifier<Currency?>(null);
  ValueNotifier<Currency?> get currencyNotifier => _currency;
  Currency get currency => _currency.value??supportedCurrencies[0];
  void set currency(Currency? currency){
    _currency.value = currency;
  }

  void setMount(double? amount){
    mount.value = amount;
  }

 Currency? getCurrencyByCode(String code){
    if(code.isEmpty) return null;
    final lowercaseCode = code.toLowerCase();
    try{
      return supportedCurrencies.firstWhere((element) => element.code.toLowerCase() == lowercaseCode);
    }catch(e){
      return null;
    }
  }


}