import 'package:flutter/material.dart';
import 'package:currency_widget/currency_widget.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CurrencyController controller = CurrencyController(
    lang: 'es',
  );

  final String currencyCode = 'usd';
  final CurrencyController currencyController = CurrencyController(
    lang: 'es',
  );
  final CurrencyController currencyControllerEn = CurrencyController(
    lang: 'en',
  );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          CurrencyPicker(currencyController: currencyControllerEn),
            CurrencyTextView(currencyCode: 'usd',mount: 250.24,currencyController:currencyControllerEn),
            ListenableBuilder(listenable: currencyControllerEn.mount, builder: (context,child){
              return  CurrencyTextView(currencyCode: currencyControllerEn.currency.code,mount: currencyControllerEn.mount.value??0,currencyController:currencyControllerEn);
            }),
            CurrencyTextView(currencyCode: 'usa',mount: 250.24,currencyController:CurrencyController(lang: 'es')),
            CurrencyTextField(currencyCode: currencyCode, currencyController: currencyController),
            SizedBox(
              width: 200,
              child:
            CurrencyCardReport(currencyCode: 'ars', mount: 200, currencyController: currencyController, title: Text('Currency Report'), icon: Icon(Icons.currency_exchange))
            )

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}