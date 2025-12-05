import 'package:flutter/material.dart';

import '../../currency_widget.dart';

class CurrencyCardReport extends StatefulWidget {
  final String title;
  final TextStyle? style;
  final Icon icon;
  final double mount;
  final String currencyCode;
  final String lang;

  const CurrencyCardReport({
    super.key,
    required this.title,
    required this.icon,
    required this.mount,
    required this.currencyCode,
    required this.lang,
    this.style,
  });

  @override
  State<CurrencyCardReport> createState() => _CurrencyCardReportState();
}

class _CurrencyCardReportState extends State<CurrencyCardReport> {
  late CurrencyController currencyController;
  late TextEditingController textController;
  Currency? currency;

  @override
  void initState() {
    super.initState();
    currencyController = CurrencyController(lang: widget.lang);
    currency = currencyController.getCurrencyByCode(widget.currencyCode);
    currencyController.setMount(widget.mount);
    currencyController.currency = currency;
    
    textController = TextEditingController(
      text: currencyController.mount.value
          ?.toStringAsFixed(currency?.decimalDigits ?? 0),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: currency == null
            ? [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
                ListTile(
                  title: Text(
                    widget.title,
                    style: widget.style,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: const Text('Currency not found'),
                )
              ]
            : [
                Padding(padding: const EdgeInsets.all(10), child: widget.icon),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    widget.title,
                    style: widget.style,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: textController,
                    enabled: true,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText:
                          '${currencyController.currency.emoji} ${currencyController.currency.code}',
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
