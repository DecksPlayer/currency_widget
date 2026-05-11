import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names.dart';
import 'package:currency_widget/src/utils/currency_picker_utils.dart';
import 'package:currency_widget/src/utils/masked_text_editing_controller.dart';
import 'package:flutter/material.dart';

/// A widget that allows the user to select a currency from a custom list and input an amount.
///
/// Use [CustomCurrencyPicker] when you want to restrict the selectable
/// currencies to a specific list of currency codes (e.g., `['USD', 'EUR']`).
class CustomCurrencyPicker extends StatefulWidget {
  final CurrencyController currencyController;
  final List<String> currencyCodes;
  final String? defaultCurrencyCode;

  const CustomCurrencyPicker({
    super.key,
    required this.currencyController,
    required this.currencyCodes,
    this.defaultCurrencyCode,
  });

  @override
  State<CustomCurrencyPicker> createState() => _CustomCurrencyPickerState();
}

class _CustomCurrencyPickerState extends State<CustomCurrencyPicker> {
  List<Currency> _currencies = [];
  late TextEditingController controller;

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

    // Ensure the selected currency is within the allowed list
    if (_currencies.isNotEmpty &&
        !_currencies.contains(widget.currencyController.currency)) {
      widget.currencyController.currency = _currencies[0];
    }

    controller = TextEditingController(
      text: widget.currencyController.mount.value != null &&
              widget.currencyController.mount.value! > 0
          ? widget.currencyController.mount.value.toString()
          : '',
    );
  }

  void _updateCurrencyList() {
    _currencies = customFilteredCurrencies(widget.currencyCodes);
  }

  @override
  void didUpdateWidget(covariant CustomCurrencyPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currencyCodes != oldWidget.currencyCodes) {
      setState(() {
        _updateCurrencyList();
        if (_currencies.isNotEmpty && !_currencies.contains(widget.currencyController.currency)) {
          widget.currencyController.currency = _currencies[0];
          final mount = widget.currencyController.mount.value;
          if (mount != null && mount > 0) {
            controller.text = mount.toStringAsFixed(_currencies[0].decimalDigits);
          }
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
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(child: _buildDropdown()),
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
                labelText: countryNames(
                    widget.currencyController.lang,
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
                try {
                  String value = str.replaceAll(',', '');
                  widget.currencyController.mount.value = double.parse(value);
                } catch (e) {
                  widget.currencyController.mount.value = 0;
                }
              },
              inputFormatters: [
                AutoDecimalNumberFormatter(
                    decimalDigits:
                        widget.currencyController.currency.decimalDigits),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DropdownButton<Currency> _buildDropdown() {
    return DropdownButton<Currency>(
      value: widget.currencyController.currency,
      isExpanded: true,
      onChanged: (Currency? newValue) async {
        chooseCurrency(newValue);
      },
      items: currencyDropdownItems(_currencies),
    );
  }

  void chooseCurrency(Currency? selected) {
    if (selected == null) return;
    setState(() {
      widget.currencyController.currency = selected;
      final mount = widget.currencyController.mount.value;
      if (mount != null && mount > 0) {
        controller.text = mount.toStringAsFixed(selected.decimalDigits);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
