import 'package:currency_widget/src/utils/currency_decoration.dart';
import 'package:flutter/material.dart';

import '../../currency_widget.dart';
import '../utils/currency_errors.dart';
import '../utils/masked_text_editing_controller.dart';

class CurrencyTextField extends StatefulWidget {
  final String currencyCode;
  final CurrencyController? currencyController;

  const CurrencyTextField({
    super.key,
    required this.currencyCode,
    required this.currencyController,
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
    controller = TextEditingController();
    currency = widget.currencyController!.getCurrencyByCode(widget.currencyCode);
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
                  String value = str.replaceAll(',', '');
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
                  ),
                ])),
      )
    ]);
  }
}