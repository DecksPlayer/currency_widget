import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/assets/currencies_names/currencies_names.dart';
import 'package:currency_widget/src/assets/supported_currencies.dart';
import 'package:currency_widget/src/utils/common_currencies.dart';
import 'package:currency_widget/src/utils/masked_text_editing_controller.dart';
import 'package:flutter/material.dart';

class CurrencyPicker extends StatefulWidget {
  final CurrencyController currencyController;
  const CurrencyPicker({super.key, required this.currencyController});

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
    widget.currencyController.currency = _currencies[0];

    // Initialize controller with current value
    controller = TextEditingController(
      text: widget.currencyController.mount.value != null &&
              widget.currencyController.mount.value! > 0
          ? widget.currencyController.mount.value.toString()
          : '',
    );

    // Listen to mount changes to update TextField
    widget.currencyController.mount.addListener(_onMountChanged);
  }

  void _onMountChanged() {
    final mount = widget.currencyController.mount.value;
    if (mount != null && mount > 0) {
      final formatted = mount.toStringAsFixed(
        widget.currencyController.currency.decimalDigits,
      );
      if (controller.text != formatted) {
        // Remover listener temporalmente para evitar loops
        widget.currencyController.mount.removeListener(_onMountChanged);
        
        controller.text = formatted;
        // Poner cursor al final para evitar auto-selección
        controller.selection = TextSelection.collapsed(offset: formatted.length);
        
        // Re-agregar listener
        widget.currencyController.mount.addListener(_onMountChanged);
      }
    }
  }

  void _updateCurrencyList() {
    if (_showOnlyCommon) {
      _currencies = supportedCurrencies
          .where((currency) =>
              commonCurrencyCodes.contains(currency.code.toUpperCase()))
          .toList();
    } else {
      _currencies = supportedCurrencies;
    }
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
                try {
                  // Usar str en lugar de controller.text para evitar conflictos
                  String value = str.replaceAll(',', '');
                  widget.currencyController.mount.value = double.parse(value);
                } catch (e) {
                  // Invalid input, ignore
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
              child: Text(currency.getDefaultView())),
        );
      }).toList(),
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
        controller.text = mount.toStringAsFixed(selected.decimalDigits);
      }
    });
  }

  @override
  void dispose() {
    widget.currencyController.mount.removeListener(_onMountChanged);
    controller.dispose();
    super.dispose();
  }

  String _getTooltipText() {
    final lang = widget.currencyController.lang.toLowerCase();
    final isCommon = _showOnlyCommon;

    // Translations for tooltip using the same locale system as countryNames
    final Map<String, Map<String, String>> translations = {
      'en': {'common': 'Most used', 'all': 'All currencies'},
      'es': {'common': 'Más usadas', 'all': 'Todas'},
      'pt': {'common': 'Mais usadas', 'all': 'Todas'},
      'fr': {'common': 'Plus utilisées', 'all': 'Toutes'},
      'de': {'common': 'Meist genutzt', 'all': 'Alle'},
      'it': {'common': 'Più usate', 'all': 'Tutte'},
      'ru': {'common': 'Популярные', 'all': 'Все'},
      'zh': {'common': '常用', 'all': '全部'},
      'ja': {'common': 'よく使われる', 'all': 'すべて'},
      'ko': {'common': '자주 사용됨', 'all': '모두'},
      'ar': {'common': 'الأكثر استخداماً', 'all': 'الكل'},
      'hi': {'common': 'अधिक उपयोग', 'all': 'सभी'},
      'id': {'common': 'Paling banyak digunakan', 'all': 'Semua'},
      'ur': {'common': 'سب سے زیادہ استعمال', 'all': 'تمام'},
    };

    final langTranslations = translations[lang] ?? translations['en']!;
    return isCommon ? langTranslations['common']! : langTranslations['all']!;
  }
}
