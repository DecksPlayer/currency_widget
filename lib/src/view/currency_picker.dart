import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/Controller/currency_controller.dart';
import 'package:currency_widget/src/assets/supported_currencies.dart';
import 'package:flutter/material.dart';

class CurrencyPicker extends StatefulWidget{
  CurrencyController currencyController;
  CurrencyPicker({super.key, required this.currencyController});

  @override
  State<CurrencyPicker> createState() => _CurrencyPicker();
}

class _CurrencyPicker extends State<CurrencyPicker>{
  List<Currency> _currencies  = supportedCurrencies;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        getCountryDropdown()
      ],
    );
  }

  DropdownButton<Currency> getCountryDropdown() {
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
              child: Text(currency.getDefaultView())),
        );
      }).toList(),
    );
  }

  Future<void> chooseCurrency(Currency? selected) async {
    if (selected == null) return;
    setState(() {
      widget.currencyController.currency = selected;
    });
  }

}