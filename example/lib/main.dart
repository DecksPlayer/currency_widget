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
      title: 'Currency Widget Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Currency Widget Demo'),
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
  final CurrencyController controller = CurrencyController(lang: 'es');

  final String currencyCode = 'usd';
  final CurrencyController currencyController = CurrencyController(lang: 'es');
  final CurrencyController currencyControllerEn = CurrencyController(
    lang: 'en',
  );
  final CurrencyController currencyChooserController = CurrencyController(
    lang: 'es',
  );
  
  final CurrencyController customCurrencyController = CurrencyController(
    lang: 'es',
  );
  List<Currency> _selectedCurrencies = [];
  List<String> get _selectedCurrencyCodes =>
      _selectedCurrencies.map((c) => c.code).toList();

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
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            CurrencyPicker(currencyController: currencyControllerEn),
            CurrencyTextView(
              currencyCode: 'usd',
              mount: 250.24,
              currencyController: currencyControllerEn,
            ),
            ListenableBuilder(
              listenable: currencyControllerEn.mount,
              builder: (context, child) {
                return CurrencyTextView(
                  currencyCode: currencyControllerEn.currency.code,
                  mount: currencyControllerEn.mount.value ?? 0,
                  currencyController: currencyControllerEn,
                );
              },
            ),
            CurrencyTextView(
              currencyCode: 'usa',
              mount: 250.24,
              currencyController: CurrencyController(lang: 'es'),
            ),
            CurrencyTextField(
              currencyCode: currencyCode,
              currencyController: currencyController,
            ),
            SizedBox(
              width: 200,
              child: CurrencyCardReport(
                title: 'Currency Report',
                icon: Icon(Icons.currency_exchange),
                mount: 250.24,
                currencyCode: 'eu',
                lang: 'en',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 200,
              child: CurrencyCardReport(
                title: 'Currency Report',
                icon: Icon(Icons.currency_exchange),
                mount: 250.24,
                currencyCode: 'usd',
                lang: 'en',
              ),
            ),
            const Divider(),
            const Text('CurrencyChooser (sin monto)'),
            CurrencyChooser(currencyController: currencyChooserController),
            ListenableBuilder(
              listenable: currencyChooserController.currencyNotifier,
              builder: (context, child) {
                return Text(
                  'Moneda seleccionada: ${currencyChooserController.currency.getDefaultView()}',
                );
              },
            ),
            const Divider(),
            const Text('Multi-Selector & Custom Chooser', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CurrencyMultiSelector(
              showOnlyCommon: true,
              initialSelected: _selectedCurrencies,
              onChanged: (selected) {
                setState(() {
                  _selectedCurrencies = selected;
                });
              },
            ),
            if (_selectedCurrencyCodes.isNotEmpty) ...[
              const SizedBox(height: 10),
              CustomCurrencyChooser(
                currencyController: customCurrencyController,
                currencyCodes: _selectedCurrencyCodes,
              ),
              ListenableBuilder(
                listenable: customCurrencyController.currencyNotifier,
                builder: (context, child) {
                  return Text(
                    'Custom seleccionada: ${customCurrencyController.currency.getDefaultView()}',
                  );
                },
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Selecciona al menos una moneda arriba'),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    ), // closes SingleChildScrollView
  ); // closes Scaffold
  }
}
