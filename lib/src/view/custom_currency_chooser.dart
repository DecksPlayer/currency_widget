import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names.dart';
import 'package:currency_widget/src/utils/currency_picker_utils.dart';
import 'package:flutter/material.dart';

/// A widget that allows the user to select a currency from a custom list.
///
/// Use [CustomCurrencyChooser] when you want to restrict the selectable
/// currencies to a specific list of currency codes (e.g., `['USD', 'EUR']`).
class CustomCurrencyChooser extends StatefulWidget {
  final CurrencyController currencyController;
  final List<String> currencyCodes;

  const CustomCurrencyChooser({
    super.key,
    required this.currencyController,
    required this.currencyCodes,
  });

  @override
  State<CustomCurrencyChooser> createState() => _CustomCurrencyChooserState();
}

class _CustomCurrencyChooserState extends State<CustomCurrencyChooser> {
  List<Currency> _currencies = [];

  @override
  void initState() {
    super.initState();
    _updateCurrencyList();
    if (_currencies.isNotEmpty) {
      widget.currencyController.currency = _currencies[0];
    }
  }

  void _updateCurrencyList() {
    _currencies = customFilteredCurrencies(widget.currencyCodes);
  }

  @override
  void didUpdateWidget(covariant CustomCurrencyChooser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currencyCodes != oldWidget.currencyCodes) {
      setState(() {
        _updateCurrencyList();
        if (_currencies.isNotEmpty && !_currencies.contains(widget.currencyController.currency)) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _currencies.map((currency) {
              final isSelected = widget.currencyController.currency == currency;
              return ChoiceChip(
                label: Text(currency.getDefaultView()),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      widget.currencyController.currency = currency;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            countryNames(
              widget.currencyController.lang,
              widget.currencyController.currency.code,
            ),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
