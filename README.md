# Currency Widget

A flexible Flutter package that provides a collection of widgets for easy currency selection and formatted currency input.

## Overview

This package simplifies the process of handling currency-related UI in your Flutter applications. It includes widgets for picking currencies from a comprehensive list, inputting formatted currency values, and displaying them according to currency-specific rules (like symbol position and decimal digits).

## Features

This package includes the following widgets:

### `CurrencyPicker`
A complete widget for the user to **pick a currency and enter an amount** in that currency. It features:
*   A dropdown menu to select from all supported currencies.
*   A text field for amount input.
*   Automatic formatting of the currency symbol and decimal places based on the selected currency.

### `CurrencyTextField`
A text field for **entering a value in a pre-defined currency**. Its features include:
*   A fixed currency, set by a `currencyCode`.
*   Automatic formatting and decoration for the specified currency.
*   Input validation to ensure the correct number of decimal places.

### `CurrencyTextView`
A read-only widget to **display a formatted currency value**.
*   Displays a non-editable amount.
*   Formats the value with the correct decimal places and currency symbol.
*   Ideal for showing final values or summaries.

### `CurrencyCardReport`
A widget for **displaying a list of currency values in a card format**. This is useful for reports or summaries where multiple currency amounts need to be shown clearly.
*   Presents data in a structured and readable card layout.
*   Each item in the list can represent a different currency or aspect of a report.
*   Customizable to fit various reporting needs.

### `CurrencyChooser`
A lightweight widget to **select a currency without requiring an amount**. Use it when you only need the user to pick a currency, with no amount input involved.
*   Dropdown to select from common or all supported currencies.
*   Toggle button (⭐ / 🌐) to switch between most-used and all currencies.
*   Displays the full localized name of the selected currency.
*   Exposes the selection via `CurrencyController.currency` and `CurrencyController.currencyNotifier`.

### `CustomCurrencyPicker`
Similar to `CurrencyPicker` (includes amount input), but allows you to restrict the selectable currencies to a specific list of currency codes (e.g., `['USD', 'EUR']`).

### `CustomCurrencyChooser`
Similar to `CurrencyChooser` (no amount input), but displays the options as selectable chips (`ChoiceChip`) instead of a dropdown, and restricts the selectable currencies to a specific list.

### `CurrencyMultiSelector`
A widget that allows the user to select multiple currencies at once. It displays currencies as actionable chips (`FilterChip`) in a responsive `Wrap` layout, including a toggle button to switch between favorite and all currencies.

### `CustomCurrencyDropdown`
A lightweight widget to **select a currency from a list of favorite currencies using a dropdown**. It defaults to the package's most-used currencies when no list is provided, but you can pass your own `favoriteCurrencyCodes` (e.g., `['USD', 'EUR', 'ARS']`) to restrict the options shown.

## Supported Languages

The package supports localization for currency names and UI tooltips across **14 languages**. You can pass any of these language codes to `CurrencyController(lang: ...)` or widgets that accept `lang`:

| Code | Language | Native Name |
|:----:|----------|-------------|
| `en` | English *(default)* | English |
| `es` | Spanish | Español |
| `pt` | Portuguese | Português |
| `fr` | French | Français |
| `de` | German | Deutsch |
| `it` | Italian | Italiano |
| `ru` | Russian | Русский |
| `zh` | Chinese | 中文 |
| `ja` | Japanese | 日本語 |
| `ko` | Korean | 한국어 |
| `ar` | Arabic | العربية |
| `hi` | Hindi | हिन्दी |
| `id` | Indonesian | Bahasa Indonesia |
| `ur` | Urdu | اردو |

> **Note:** If an unsupported language code is provided, the package automatically defaults to English (`en`).

## Properties per Widget


| Widget               | Properties                                                                                                                                                                                                                                                         |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `CurrencyPicker`     | `currencyController`: (required) Manages currency state.<br>`defaultCurrencyCode`: (optional) Initial currency to select. |
| `CurrencyTextField`  | `currencyController`: (required) Manages currency state.<br>`currencyCode`: (required) Code of the currency to use.<br>`defaultAmount`: (optional) Initial amount to select. |
| `CurrencyTextView`   | `mount`: (required) Amount to display.<br>`currencyCode`: (required) Code of the currency.<br>`CurrencyControler` : (required)Manages currency state                                                                                                               |
| `CurrencyCardReport` | `title`: (required) Title widget for the card.<br>`icon`: (required) Icon widget for the card.<br>`mount`: (required) Amount to display.<br>`currencyCode`: (required) Code of the currency.<br>`lang`: (required) Language for formatting.<br>`style`: Text Style |
| `CurrencyChooser`    | `currencyController`: (required) Manages currency state and exposes the selected currency via `controller.currency` and `controller.currencyNotifier`. |
| `CustomCurrencyPicker`| `currencyController`: (required) Manages currency state.<br>`currencyCodes`: (required) List of currency codes to allow.<br>`defaultCurrencyCode`: (optional) Initial currency to select. |
| `CustomCurrencyChooser`| `currencyController`: (required) Manages currency state.<br>`currencyCodes`: (required) List of currency codes to allow.<br>`defaultCurrencyCode`: (optional) Initial currency to select. |
| `CurrencyMultiSelector`| `onChanged`: (required) Callback fired when selection changes.<br>`initialSelected`: List of initially selected currencies.<br>`showOnlyCommon`: Toggle between common or all currencies.<br> |
| `CustomCurrencyDropdown`| `currencyController`: (required) Manages currency state.<br>`favoriteCurrencyCodes`: List of favorite currency codes to show (defaults to the package's most-used currencies).<br>`defaultCurrencyCode`: (optional) Initial currency to select. |

**Note**: All widgets also accept standard Flutter widget properties like `key`, `padding`, `margin`, etc.

## Screenshots

Here are some visual examples of the widgets in action:

### Example 1: All Widgets
![All Widgets Example](https://raw.githubusercontent.com/DecksPlayer/currency_widget/main/assets/image.png)

### Example 2: Currency Picker Favourites currencies
![Currency Picker Favourites currencies](https://raw.githubusercontent.com/DecksPlayer/currency_widget/main/assets/image_2.png)

### Example 3: Currency Picker all currencies
![Currency Picker all currencies](https://raw.githubusercontent.com/DecksPlayer/currency_widget/main/assets/image_3.png)






## Getting Started

To use this package, add `currency_widget` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  currency_widget: ^latest_version # Replace with the latest version
```

Or run this command in your terminal:

```bash
flutter pub add currency_widget
```

Then, import the package in your Dart code:
```dart
import 'package:currency_widget/currency_widget.dart';
```

## Usage

Here is a basic example of how to use the `CurrencyPicker` widget. You'll need to provide a `CurrencyController` to manage the state.

```dart
import 'package:flutter/material.dart';
import 'package:currency_widget/currency_widget.dart';

class MyCurrencyScreen extends StatefulWidget {
  const MyCurrencyScreen({super.key});

  @override
  State<MyCurrencyScreen> createState() => _MyCurrencyScreenState();
}

class _MyCurrencyScreenState extends State<MyCurrencyScreen> {
  final CurrencyController _controller = CurrencyController(lang: 'es', initialCurrencyCode: 'EUR');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Widget Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CurrencyPicker(
              currencyController: _controller,
              defaultCurrencyCode: 'EUR',
            ),
            SizedBox(height: 20),
            // You can listen to changes in the controller
            ValueListenableBuilder<Currency>(
              valueListenable: _controller.currencyNotifier,
              builder: (_, currency, __) {
                return Text('Selected Currency: ${currency.code}');
              },
            ),
            SizedBox(
                width: 200,
                child:
                CurrencyCardReport( title: Text('Currency Report'), icon: Icon(Icons.currency_exchange),mount: 250.24, currencyCode: 'usd', lang: 'en',)
            ),
            SizedBox(height: 20),
            // CurrencyChooser: pick a currency without entering an amount
            CurrencyChooser(currencyController: _controller),
            ValueListenableBuilder<Currency?>(
              valueListenable: _controller.currencyNotifier,
              builder: (_, currency, __) {
                return Text('Selected: ${currency?.getDefaultView() ?? ''}');
              },
            ),
            SizedBox(height: 20),
            // CurrencyMultiSelector: pick multiple currencies at once
            CurrencyMultiSelector(
              showOnlyCommon: true,
              onChanged: (selectedList) {
                print('Selected currencies: $selectedList');
              },
            ),
            SizedBox(height: 20),
            // CustomCurrencyChooser: pick a single currency from a restricted list using chips
            CustomCurrencyChooser(
              currencyController: _controller,
              currencyCodes: ['USD', 'EUR', 'ARS'],
              defaultCurrencyCode: 'USD',
            ),
            SizedBox(height: 20),
            // CustomCurrencyPicker: pick a currency from a restricted list with amount input
            CustomCurrencyPicker(
              currencyController: _controller,
              currencyCodes: ['USD', 'GBP', 'JPY'],
              defaultCurrencyCode: 'GBP',
            ),
            SizedBox(height: 20),
            // CustomCurrencyDropdown: pick a favorite currency from a dropdown
            CustomCurrencyDropdown(
              currencyController: _controller,
              favoriteCurrencyCodes: ['USD', 'EUR', 'ARS'],
              defaultCurrencyCode: 'USD',
            ),
          ],
        ),
      ),
    );
  }
}
```

## Additional Information

To report any issues or contribute to the package, please file an issue at the [GitHub repository](https://github.com/your_username/currency_widget/issues). We appreciate your feedback and contributions!

## Help this project
If you find this package helpful and want to support its development, consider making a donation. Thank you for your support!

[![Support via PayPal](https://www.paypalobjects.com/webstatic/en_US/i/buttons/PP_logo_h_150x38.png)](https://www.paypal.com/paypalme/gonojuarez)

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/DecksPlayer/currency_widget)