import 'package:currency_widget/currency_widget.dart';
import 'package:flutter/material.dart';

import '../assets/currencies_names/currencies_names.dart';

// Function to create an InputDecoration for a currency input field.
InputDecoration getCurrencyDecoration(Currency currency,CurrencyController currencyController){
  return InputDecoration(
    // Set the label text with the currency emoji and its name.
    labelText: currency.emoji +
        ' ' +
        countryNames(
            currencyController.lang, currency.code),
    // Set the prefix text based on the currency symbol position.
    // If the symbol position is 'first', use the symbol; otherwise, use the currency code.
    prefixText: currency.position == 'first'
        ? currency.symbol
        : currency.code,
    // Set the suffix text based on the currency symbol position.
    // If the symbol position is 'last', use the symbol; otherwise, use the currency code.
    suffixText: currency.position == 'last'
        ? currency.symbol
        : currency.code,
  );
}