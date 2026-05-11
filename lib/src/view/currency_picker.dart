import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names.dart';
import 'package:currency_widget/src/utils/currency_format_utils.dart';
import 'package:currency_widget/src/utils/currency_picker_utils.dart';
import 'package:currency_widget/src/utils/masked_text_editing_controller.dart';
import 'package:flutter/material.dart';

class CurrencyPicker extends StatefulWidget {
  final CurrencyController currencyController;
  final String? defaultCurrencyCode;
  const CurrencyPicker({super.key, required this.currencyController, this.defaultCurrencyCode});

  @override
  State<CurrencyPicker> createState() => _CurrencyPicker();
}

class _CurrencyPicker extends State<CurrencyPicker> {
  List<Currency> _currencies = [];
  bool _showOnlyCommon = true;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    _updateCurrencyList();

    if (widget.defaultCurrencyCode != null) {
      final defaultCurrency = _currencies.firstWhere(
        (c) =>
            c.code.toLowerCase() == widget.defaultCurrencyCode!.toLowerCase(),
        orElse: () => _currencies[0],
      );
      widget.currencyController.currency = defaultCurrency;
    } else if (widget.currencyController.currencyNotifier.value == null) {
      widget.currencyController.currency = _currencies[0];
    }

    // Initialize controller with current value
    final mount = widget.currencyController.mount.value;
    controller = TextEditingController(
      text: mount != null && mount > 0
          ? CurrencyFormatUtils.formatAmount(
              mount, widget.currencyController.currency)
          : '',
    );

  }

  void _updateCurrencyList() {
    _currencies = filteredCurrencies(_showOnlyCommon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(child: getCurrenciesDropdown()),
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
            subtitle: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              enableInteractiveSelection: true,
              decoration: InputDecoration(
                hintText: 0.toStringAsFixed(
                    widget.currencyController.currency.decimalDigits),
                labelText: countryNames(widget.currencyController.lang,
                    widget.currencyController.currency.code),
                prefixText:
                    widget.currencyController.currency.position == 'first'
                        ? widget.currencyController.currency.symbol
                        : null,
                suffixText:
                    widget.currencyController.currency.position == 'last'
                        ? widget.currencyController.currency.symbol
                        : null,
              ),
              onChanged: (str) {
                if (str.isEmpty) {
                  widget.currencyController.mount.value = 0;
                  return;
                }
                final currency = widget.currencyController.currency;
                try {
                  // Usar str en lugar de controller.text para evitar conflictos
                  String value = str
                      .replaceAll(currency.thousandSeparator, '')
                      .replaceAll(currency.decimalSeparator, '.');
                  widget.currencyController.mount.value = double.parse(value);
                } catch (e) {
                  // Invalid input, ignore
                  widget.currencyController.mount.value = 0;
                }
              },
              inputFormatters: [
                AutoDecimalNumberFormatter(
                  decimalDigits:
                      widget.currencyController.currency.decimalDigits,
                  thousandSeparator:
                      widget.currencyController.currency.thousandSeparator,
                  decimalSeparator:
                      widget.currencyController.currency.decimalSeparator,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Returns a DropdownButton widget for selecting currencies.
  DropdownButton<Currency> getCurrenciesDropdown() {
    return DropdownButton<Currency>(
      value: widget.currencyController.currency,
      onChanged: (Currency? newValue) async {
        chooseCurrency(newValue!);
      },
      items: currencyDropdownItems(_currencies),
    );
  }

  // Handles the selection of a new currency.
  Future<void> chooseCurrency(Currency? selected) async {
    if (selected == null) return;
    setState(() {
      widget.currencyController.currency = selected;
      // Update TextField formatting when currency changes
      final mount = widget.currencyController.mount.value;
      if (mount != null && mount > 0) {
        controller.text = CurrencyFormatUtils.formatAmount(mount, selected);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _getTooltipText() {
    return currencyFilterTooltip(widget.currencyController.lang, _showOnlyCommon);
  }
}
