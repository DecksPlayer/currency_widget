import 'package:currency_widget/src/utils/currency_decoration.dart';
import 'package:flutter/material.dart';

import '../../currency_widget.dart';
import '../utils/currency_errors.dart';
import '../utils/masked_text_editing_controller.dart';

class CurrencyTextField extends StatelessWidget {
  String currencyCode;

  CurrencyController? currencyController;

  // The currency object associated with the currencyCode.
  Currency? currency;

  TextEditingController controller = TextEditingController();


  CurrencyTextField({super.key,required this.currencyCode,
    required this.currencyController});

  @override
  Widget build(BuildContext context) {
    currency = currencyController!.getCurrencyByCode(currencyCode);
    // Check if the currency is null, which indicates an error in loading or an invalid currency code.
    if (currency == null) {
      // Display an error message if the currency is not found.
      // The message is localized based on the currencyController's language.
      return Text(empty_currency_messages[currencyController!.lang] ??
          'Error loading currency');
    }
    // Return a Row widget containing the TextField.
    return Row(children: [
      Flexible(
        // Use Flexible to allow the TextField to take up available space.
        child: Padding(
            // Add padding around the TextField.
            padding: EdgeInsets.all(7),
            child: TextField(
                enabled: true,
                // Set readOnly to false to allow user input.
                readOnly: false,
                textAlign: currency!.position == 'first'
                    ? TextAlign.start
                    : currency!.position == 'last' ? TextAlign.end : TextAlign
                    .center,
                decoration:  getCurrencyDecoration(currency!, currencyController!),
                controller: controller,
                onChanged: (str){
                  String value = controller.text.replaceAll(',','');
                  currencyController!.mount.value = double.parse(value);
                },
                inputFormatters: [
                  AutoDecimalNumberFormatter(
                      decimalDigits: currency!.decimal_digits
                  ),
                ]
            )),
      )
    ]);

  }
}