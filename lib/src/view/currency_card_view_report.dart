import 'package:flutter/material.dart';

import '../../currency_widget.dart';

class CurrencyCardReport extends StatelessWidget {
  final String title;

  final TextStyle? style;

  ///The mount of the currency to display.

  ///The controller used to customize the currency display.

  final Icon icon;

  final double mount;
  final String currencyCode;
  final String lang;

  CurrencyCardReport(
      {required this.title,
      required this.icon,
      required this.mount,
      required this.currencyCode,
      required this.lang,
      this.style});
  @override
  Widget build(BuildContext context) {
    final currencyController = CurrencyController(lang: lang);
    final Currency? currency =
        currencyController.getCurrencyByCode(currencyCode);
    currencyController.setMount(mount);
    currencyController.currency = currency;
    final controller = TextEditingController(
        text: currencyController.mount.value
            ?.toStringAsFixed(currency?.decimalDigits ?? 0));

    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: currency == null
                ? [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        )),
                    ListTile(
                      title: Text(
                        title,
                        style: style,
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text('Currency not found'),
                    )
                  ]
                : [
                    Padding(padding: EdgeInsets.all(10), child: icon),
                     Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Text(
                            title,
                            style: style,
                            textAlign: TextAlign.center,
                          )),
                   Padding(
                     padding: EdgeInsets.all(10),
                     child:
                   TextField(
                          controller: controller,
                          enabled: true,
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText:
                                  '${currencyController!.currency.emoji} ${currencyController!.currency.code}'))),

                  ]));
    // TODO: implement build
  }
}
