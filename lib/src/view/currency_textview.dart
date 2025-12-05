import 'package:currency_widget/src/utils/currency_decoration.dart';
import 'package:flutter/material.dart';

import '../../currency_widget.dart';
import '../utils/currency_errors.dart';

///[CurrencyTextView]
///
///This widget is used to display a currency value in a text field.
///It takes a [currencyCode] and a [mount] as input.
///It also takes an optional [currencyController] to customize the currency display.
class CurrencyTextView extends StatefulWidget {
  ///The currency code of the currency to display.
  final String currencyCode;

  ///The mount of the currency to display.
  final double mount;

  ///The controller used to customize the currency display.
  final CurrencyController? currencyController;

  ///Creates a new [CurrencyTextView] widget.
  ///
  ///The [currencyCode] and [mount] arguments must not be null.
  const CurrencyTextView({
    super.key,
    required this.currencyCode,
    required this.mount,
    required this.currencyController,
  });

  @override
  State<CurrencyTextView> createState() => _CurrencyTextViewState();
}

class _CurrencyTextViewState extends State<CurrencyTextView> {
  late TextEditingController controller;
  Currency? currency;

  @override
  void initState() {
    super.initState();
    _updateCurrency();
    _updateController();
  }

  @override
  void didUpdateWidget(CurrencyTextView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió el código de moneda, actualizar la moneda
    if (oldWidget.currencyCode != widget.currencyCode) {
      _updateCurrency();
    }
    // Si cambió el monto o la moneda, actualizar el controller
    if (oldWidget.mount != widget.mount || oldWidget.currencyCode != widget.currencyCode) {
      _updateController();
    }
  }

  void _updateCurrency() {
    currency = widget.currencyController?.getCurrencyByCode(widget.currencyCode);
  }

  void _updateController() {
    controller.text = widget.mount.toStringAsFixed(currency?.decimalDigits ?? 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loadWidget(currency);
  }

  Widget loadWidget(Currency? currency) {
    if (currency == null) {
      return ListTile(
        trailing: const Icon(Icons.error_outline, color: Colors.red),
        title: Text(
          empty_currency_messages[widget.currencyController!.lang] ??
              'Error loading currency',
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(7),
      child: TextField(
        enabled: true,
        readOnly: true,
        controller: controller,
        decoration: getCurrencyDecoration(currency, widget.currencyController!),
      ),
    );
  }
}
