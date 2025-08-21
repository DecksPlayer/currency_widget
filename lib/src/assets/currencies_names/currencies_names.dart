// Import statements for currency names in different languages
import 'package:currency_widget/src/assets/currencies_names/currencies_names_ar.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_de.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_en.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_es.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_fr.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_hi.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_id.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_it.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_ja.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_ko.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_pt.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_ru.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_ur.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names_zh.dart';

/// Retrieves the currency name based on the language and currency code.
///
/// [lang] The language code (e.g., 'en', 'es').
/// [code] The currency code (e.g., 'USD', 'EUR').
String countryNames(String lang,String code){
  // Switch statement to select the appropriate currency list based on the language
  switch(lang.toLowerCase()){
    case 'es':
      return _getName(currenciesES, code);
    case 'en':
      return _getName(currenciesEN, code);
    case 'pt':
      return _getName(currenciesPT, code);
    case 'fr':
      return _getName(currenciesFR, code);
    case 'de':
      return _getName(currenciesDE, code);
    case 'it':
      return _getName(currenciesIT, code);
    case 'ru':
      return _getName(currenciesRU, code);
    case 'zh':
      return _getName(currenciesZH, code);
    case 'ja':
      return _getName(currenciesJA, code);
    case 'ko':
      return _getName(currenciesKO, code);
    case 'ar':
      return _getName(currenciesAR, code);
    case 'id':
      return _getName(currenciesID, code);
    case 'hi':
      return _getName(currenciesHI, code);
    case 'ur':
      return _getName(currenciesUR, code);
    default:
      return _getName(currenciesEN,code);
  }
}

/// Helper function to get the currency name from a list of currencies.
///
/// [currencies] A list of maps, where each map contains 'code' and 'name' keys.
/// [code] The currency code to search for.
String _getName(List<Map<String,dynamic>> currencies,String code){
  return currencies.where((element) => element['code'] == code).first['name']??'';
}