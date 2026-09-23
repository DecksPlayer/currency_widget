import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names.dart';
import 'package:currency_widget/src/utils/common_currencies.dart';
import 'package:currency_widget/src/utils/currency_picker_utils.dart';
import 'package:flutter/material.dart';

/// A widget that allows the user to select a currency from a list of
/// favorite currencies using a dropdown.
///
/// Use [CustomCurrencyDropdown] when you want to show a curated list of
/// favorite currency codes (e.g., `['USD', 'EUR', 'ARS']`) in a compact
/// dropdown. If [favoriteCurrencyCodes] is not provided, it defaults to
/// the package's list of most commonly used currencies.
class CustomCurrencyDropdown extends StatefulWidget {
  final CurrencyController currencyController;
  final List<String> favoriteCurrencyCodes;
  final String? defaultCurrencyCode;

  const CustomCurrencyDropdown({
    super.key,
    required this.currencyController,
    this.favoriteCurrencyCodes = commonCurrencyCodes,
    this.defaultCurrencyCode,
  });

  @override
  State<CustomCurrencyDropdown> createState() =>
      _CustomCurrencyDropdownState();
}

class _CustomCurrencyDropdownState extends State<CustomCurrencyDropdown> {
  List<Currency> _currencies = [];

  @override
  void initState() {
    super.initState();
    _updateCurrencyList();

    if (widget.defaultCurrencyCode != null) {
      final defaultCurrency = _currencies.firstWhere(
        (c) =>
            c.code.toLowerCase() == widget.defaultCurrencyCode!.toLowerCase(),
        orElse: () => _currencies.isNotEmpty ? _currencies[0] : _currencies[0],
      );
      widget.currencyController.currency = defaultCurrency;
    } else if (widget.currencyController.currencyNotifier.value == null &&
        _currencies.isNotEmpty) {
      widget.currencyController.currency = _currencies[0];
    }

    // Ensure the selected currency is within the favorite list
    if (_currencies.isNotEmpty &&
        !_currencies.contains(widget.currencyController.currency)) {
      widget.currencyController.currency = _currencies[0];
    }
  }

  void _updateCurrencyList() {
    _currencies = customFilteredCurrencies(widget.favoriteCurrencyCodes);
  }

  @override
  void didUpdateWidget(covariant CustomCurrencyDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.favoriteCurrencyCodes != oldWidget.favoriteCurrencyCodes) {
      setState(() {
        _updateCurrencyList();
        if (_currencies.isNotEmpty &&
            !_currencies.contains(widget.currencyController.currency)) {
          widget.currencyController.currency = _currencies[0];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currencies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: _buildDropdown(),
        subtitle: Text(
          countryNames(
            widget.currencyController.lang,
            widget.currencyController.currency.code,
          ),
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  DropdownButton<Currency> _buildDropdown() {
    return DropdownButton<Currency>(
      value: widget.currencyController.currency,
      isExpanded: true,
      onChanged: (Currency? newValue) {
        if (newValue == null) return;
        setState(() {
          widget.currencyController.currency = newValue;
        });
      },
      items: currencyDropdownItems(_currencies),
    );
  }
}
