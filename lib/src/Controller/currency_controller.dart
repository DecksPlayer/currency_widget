import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/supported_currencies.dart';

class CurrencyController{
  double? _mount;
  Currency? _currency;
  Currency get currency => _currency??supportedCurrencies[0];
  void set currency(Currency currency){
    _currency = currency;
  }

  set double (double mount){
    _mount = mount;
  }
  double get mount  => _mount;
}