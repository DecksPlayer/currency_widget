import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names.dart';
import 'package:currency_widget/src/assets/supported_currencies.dart';
import 'package:currency_widget/src/utils/masked_text_editing_controller.dart';
import 'package:flutter/material.dart';

class CurrencyPicker extends StatefulWidget{
  final CurrencyController currencyController;
  const CurrencyPicker({super.key, required this.currencyController});

  @override
  State<CurrencyPicker> createState() => _CurrencyPicker();
}

class _CurrencyPicker extends State<CurrencyPicker>{
  final List<Currency> _currencies  = supportedCurrencies;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.currencyController.currency = _currencies[0];
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
        Container(
          margin: EdgeInsets.all( 10),
          child:
        ListTile(
            title: getCurrenciesDropdown(),
        subtitle:
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 0.toStringAsFixed(widget.currencyController.currency.decimalDigits),
            labelText: countryNames(widget.currencyController.lang, widget.currencyController.currency.code),
            prefixText:widget.currencyController.currency.position=='first'?widget.currencyController.currency.symbol:null,
            suffixText: widget.currencyController.currency.position=='last'?widget.currencyController.currency.symbol:null
          ),
          onChanged: (str){
            String value = controller.text.replaceAll(',','');
            widget.currencyController.mount.value = double.parse(value);
          },
          inputFormatters: [
            AutoDecimalNumberFormatter(
              decimalDigits: widget.currencyController.currency.decimalDigits
            ),
          ],
        )
    ));
  }

  // Returns a DropdownButton widget for selecting currencies.
  DropdownButton<Currency> getCurrenciesDropdown() {
    return DropdownButton<Currency>(
      value: widget.currencyController.currency,
      onChanged: (Currency? newValue) async {
        chooseCurrency(newValue!);
      },
      items: _currencies.map((Currency currency) {
        return DropdownMenuItem<Currency>(
          value: currency,
          child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Text(
                  currency.getDefaultView())),
        );
      }).toList(),
    );
  }

  // Handles the selection of a new currency.
  Future<void> chooseCurrency(Currency? selected) async {
    if (selected == null) return;
    setState(() {
      widget.currencyController.currency = selected;
    });
  }

}