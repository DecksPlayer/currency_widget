import 'package:flutter/material.dart';

import '../../currency_widget.dart';

class CurrencyCardReport extends StatelessWidget{

  final Text title;
  final String currencyCode;
  ///The mount of the currency to display.
  final double mount;

  ///The controller used to customize the currency display.
  final CurrencyController? currencyController;

  final Icon icon;

  CurrencyCardReport({super.key, required this.currencyCode, required this.mount, required this.currencyController, required this.title, required this.icon});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding:EdgeInsets.all(10) , child:
          icon),
          ListTile(title:  title,
            subtitle: CurrencyTextView(currencyCode: currencyCode, mount: mount, currencyController: currencyController,),
          )
        ],
      ),
    );
  }

}