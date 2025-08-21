import 'package:currency_widget/src/utils/currency_decoration.dart';
import 'package:flutter/material.dart';

import '../../currency_widget.dart';
import '../utils/currency_errors.dart';
///[CurrencyTextView]
///
///This widget is used to display a currency value in a text field.
///It takes a [currencyCode] and a [mount] as input.
///It also takes an optional [currencyController] to customize the currency display.
class CurrencyTextView extends StatelessWidget {
  ///The currency code of the currency to display.
  final String currencyCode;
  ///The mount of the currency to display.
  final double mount;

  ///The controller used to customize the currency display.
  final CurrencyController? currencyController;

  ///Creates a new [CurrencyTextView] widget.
  ///
  ///The [currencyCode] and [mount] arguments must not be null.
  CurrencyTextView(
      {super.key,
      required this.currencyCode,
      required this.mount,
      required this.currencyController});
  @override
  Widget build(BuildContext context) {
    final currency = currencyController?.getCurrencyByCode(currencyCode);

    return loadWidget(currency);
  }

  Widget loadWidget(Currency? currency) {
    if (currency == null)
      return ListTile(
          trailing: Icon(Icons.error_outline, color: Colors.red),
          title: Text(empty_currency_messages[currencyController!.lang] ??
              'Error loading currency'));

    final controller = TextEditingController(
        text: mount.toStringAsFixed(currency.decimal_digits));

    return Padding(
        padding: EdgeInsets.all(7),
        child: TextField(
            enabled: true,
            readOnly: true,
            controller: controller,
            decoration: getCurrencyDecoration(currency, currencyController!)));
  }
}
