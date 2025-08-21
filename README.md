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
  final CurrencyController _controller = CurrencyController();

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
            CurrencyPicker(currencyController: _controller),
            SizedBox(height: 20),
            // You can listen to changes in the controller
            ValueListenableBuilder<Currency>(
              valueListenable: _controller.currencyNotifier,
              builder: (_, currency, __) {
                return Text('Selected Currency: ${currency.code}');
              },
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