import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/supported_currencies.dart';
import 'package:currency_widget/src/utils/common_currencies.dart';
import 'package:flutter/material.dart';

/// Returns the filtered list of currencies based on [showOnlyCommon].
List<Currency> filteredCurrencies(bool showOnlyCommon) {
  if (showOnlyCommon) {
    return supportedCurrencies
        .where((c) => commonCurrencyCodes.contains(c.code.toUpperCase()))
        .toList();
  }
  return supportedCurrencies;
}

/// Returns the filtered list of currencies based on a custom list of [codes].
List<Currency> customFilteredCurrencies(List<String> codes) {
  final upperCodes = codes.map((c) => c.toUpperCase()).toList();
  return supportedCurrencies
      .where((c) => upperCodes.contains(c.code.toUpperCase()))
      .toList();
}

/// Returns the localized tooltip text for the common/all toggle button.
String currencyFilterTooltip(String lang, bool showOnlyCommon) {
  const Map<String, Map<String, String>> translations = {
    'en': {'common': 'Most used', 'all': 'All currencies'},
    'es': {'common': 'Más usadas', 'all': 'Todas'},
    'pt': {'common': 'Mais usadas', 'all': 'Todas'},
    'fr': {'common': 'Plus utilisées', 'all': 'Toutes'},
    'de': {'common': 'Meist genutzt', 'all': 'Alle'},
    'it': {'common': 'Più usate', 'all': 'Tutte'},
    'ru': {'common': 'Популярные', 'all': 'Все'},
    'zh': {'common': '常用', 'all': '全部'},
    'ja': {'common': 'よく使われる', 'all': 'すべて'},
    'ko': {'common': '자주 사용됨', 'all': '모두'},
    'ar': {'common': 'الأكثر استخداماً', 'all': 'الكل'},
    'hi': {'common': 'अधिक उपयोग', 'all': 'सभी'},
    'id': {'common': 'Paling banyak digunakan', 'all': 'Semua'},
    'ur': {'common': 'سب سے زیادہ استعمال', 'all': 'تمام'},
  };
  final t = translations[lang.toLowerCase()] ?? translations['en']!;
  return showOnlyCommon ? t['common']! : t['all']!;
}

/// Builds the [DropdownMenuItem] list for a given [currencies] list.
List<DropdownMenuItem<Currency>> currencyDropdownItems(
    List<Currency> currencies) {
  return currencies.map((Currency currency) {
    return DropdownMenuItem<Currency>(
      value: currency,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(currency.getDefaultView()),
      ),
    );
  }).toList();
}
