import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names.dart';
import 'package:currency_widget/src/utils/currency_picker_utils.dart';
import 'package:flutter/material.dart';

/// A widget that allows the user to select a currency without requiring an amount.
///
/// Use [CurrencyChooser] when you only need the user to pick a currency,
/// without any amount input. The selected [Currency] is exposed through
/// the [currencyController].
///
/// Example:
/// ```dart
/// CurrencyChooser(currencyController: CurrencyController(lang: 'en'))
/// ```
class CurrencyChooser extends StatefulWidget {
  final CurrencyController currencyController;

  const CurrencyChooser({super.key, required this.currencyController});

  @override
  State<CurrencyChooser> createState() => _CurrencyChooserState();
}

class _CurrencyChooserState extends State<CurrencyChooser> {
  List<Currency> _currencies = [];
  bool _showOnlyCommon = true;

  @override
  void initState() {
    super.initState();
    _updateCurrencyList();
    widget.currencyController.currency = _currencies[0];
  }

  void _updateCurrencyList() {
    _currencies = filteredCurrencies(_showOnlyCommon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Row(
          children: [
            Expanded(child: _buildDropdown()),
            Tooltip(
              message: _getTooltipText(),
              child: IconButton(
                icon: Icon(
                  _showOnlyCommon ? Icons.star : Icons.public,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _showOnlyCommon = !_showOnlyCommon;
                    _updateCurrencyList();
                    if (!_currencies
                        .contains(widget.currencyController.currency)) {
                      widget.currencyController.currency = _currencies[0];
                    }
                  });
                },
              ),
            ),
          ],
        ),
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
      onChanged: (Currency? newValue) {
        if (newValue == null) return;
        setState(() {
          widget.currencyController.currency = newValue;
        });
      },
      items: currencyDropdownItems(_currencies),
    );
  }

  String _getTooltipText() {
    return currencyFilterTooltip(widget.currencyController.lang, _showOnlyCommon);
  }
}
