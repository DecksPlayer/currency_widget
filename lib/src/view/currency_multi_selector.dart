import 'package:currency_widget/currency_widget.dart';
import 'package:currency_widget/src/utils/currency_picker_utils.dart';
import 'package:flutter/material.dart';

/// A widget that displays currencies as actionable chips in a Wrap layout,
/// allowing the user to select multiple currencies.
class CurrencyMultiSelector extends StatefulWidget {
  /// Callback fired when the selection changes.
  final ValueChanged<List<Currency>> onChanged;

  /// The initially selected currencies.
  final List<Currency> initialSelected;

  /// If true, shows only the most common currencies. If false, shows all supported currencies.
  final bool showOnlyCommon;

  /// The language code for tooltips (e.g., 'en', 'es').
  final String lang;

  const CurrencyMultiSelector({
    super.key,
    required this.onChanged,
    this.initialSelected = const [],
    this.showOnlyCommon = true,
    this.lang = 'en',
  });

  @override
  State<CurrencyMultiSelector> createState() => _CurrencyMultiSelectorState();
}

class _CurrencyMultiSelectorState extends State<CurrencyMultiSelector> {
  late List<Currency> _availableCurrencies;
  late Set<Currency> _selectedCurrencies;

  late bool _showOnlyCommon;

  @override
  void initState() {
    super.initState();
    _showOnlyCommon = widget.showOnlyCommon;
    _selectedCurrencies = Set.from(widget.initialSelected);
    _availableCurrencies = filteredCurrencies(_showOnlyCommon);
  }

  @override
  void didUpdateWidget(covariant CurrencyMultiSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showOnlyCommon != oldWidget.showOnlyCommon) {
      _showOnlyCommon = widget.showOnlyCommon;
      _availableCurrencies = filteredCurrencies(_showOnlyCommon);
    }
  }

  void _toggleSelection(Currency currency) {
    setState(() {
      if (_selectedCurrencies.contains(currency)) {
        _selectedCurrencies.remove(currency);
      } else {
        _selectedCurrencies.add(currency);
      }
    });
    widget.onChanged(_selectedCurrencies.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Tooltip(
              message: currencyFilterTooltip(widget.lang, _showOnlyCommon),
              child: IconButton(
                icon: Icon(
                  _showOnlyCommon ? Icons.star : Icons.public,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _showOnlyCommon = !_showOnlyCommon;
                    _availableCurrencies = filteredCurrencies(_showOnlyCommon);
                  });
                },
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _availableCurrencies.map((currency) {
            final isSelected = _selectedCurrencies.contains(currency);
            return FilterChip(
              label: Text(currency.getDefaultView()),
              selected: isSelected,
              onSelected: (_) => _toggleSelection(currency),
            );
          }).toList(),
        ),
      ],
    );
  }
}
