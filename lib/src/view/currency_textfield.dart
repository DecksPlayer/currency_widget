import 'package:currency_widget/src/utils/currency_decoration.dart';
import 'package:flutter/material.dart';

import '../../currency_widget.dart';
import '../utils/currency_errors.dart';
import '../utils/masked_text_editing_controller.dart';
import '../utils/currency_format_utils.dart';

class CurrencyTextField extends StatefulWidget {
  final String currencyCode;
  final CurrencyController? currencyController;
  final double? defaultAmount;

  const CurrencyTextField({
    super.key,
    required this.currencyCode,
    required this.currencyController,
    this.defaultAmount,
  });

  @override
  State<CurrencyTextField> createState() => _CurrencyTextFieldState();
}

class _CurrencyTextFieldState extends State<CurrencyTextField> {
  late TextEditingController controller;
  Currency? currency;

  @override
  void initState() {
    super.initState();
    _updateCurrency();

    if (widget.defaultAmount != null &&
        (widget.currencyController?.mount.value == null ||
            widget.currencyController?.mount.value == 0)) {
      widget.currencyController?.mount.value = widget.defaultAmount;
    }

    final initialMount = widget.currencyController?.mount.value;
    controller = TextEditingController(
      text: initialMount != null && initialMount > 0 && currency != null
          ? CurrencyFormatUtils.formatAmount(initialMount, currency!)
          : '',
    );
  }

  void _updateCurrency() {
    currency =
        widget.currencyController?.getCurrencyByCode(widget.currencyCode);
  }

  @override
  void didUpdateWidget(covariant CurrencyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currencyCode != oldWidget.currencyCode) {
      setState(() {
        _updateCurrency();
        final mount = widget.currencyController?.mount.value;
        if (mount != null && mount > 0 && currency != null) {
          controller.text = CurrencyFormatUtils.formatAmount(mount, currency!);
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the currency is null, which indicates an error in loading or an invalid currency code.
    if (currency == null) {
      // Display an error message if the currency is not found.
      // The message is localized based on the currencyController's language.
      return Text(empty_currency_messages[widget.currencyController!.lang] ??
          'Error loading currency');
    }
    // Return a Row widget containing the TextField.
    return Row(children: [
      Flexible(
        // Use Flexible to allow the TextField to take up available space.
        child: Padding(
            // Add padding around the TextField.
            padding: const EdgeInsets.all(7),
            child: TextField(
                enabled: true,
                // Set readOnly to false to allow user input.
                readOnly: false,
                enableInteractiveSelection: true,
                textAlign: currency!.position == 'first'
                    ? TextAlign.start
                    : currency!.position == 'last'
                        ? TextAlign.end
                        : TextAlign.center,
                decoration: getCurrencyDecoration(
                    currency!, widget.currencyController!),
                controller: controller,
                onChanged: (str) {
                  // Usar str en lugar de controller.text para evitar conflictos
                  // Remover separador de miles y reemplazar separador decimal por punto para parsear
                  String value = str
                      .replaceAll(currency!.thousandSeparator, '')
                      .replaceAll(currency!.decimalSeparator, '.');
                  try {
                    widget.currencyController!.mount.value =
                        double.parse(value);
                  } catch (e) {
                    // Invalid input, set to 0
                    widget.currencyController!.mount.value = 0;
                  }
                },
                inputFormatters: [
                  AutoDecimalNumberFormatter(
                    decimalDigits: currency!.decimalDigits,
                    thousandSeparator: currency!.thousandSeparator,
                    decimalSeparator: currency!.decimalSeparator,
                  ),
                ])),
      )
    ]);
  }
}