import 'dart:convert';

class Currency{
  String code;
  String name;
  String symbol;
  String emoji;
  int decimalDigits;
  String position;
  String thousandSeparator;
  String decimalSeparator;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.emoji,
    required this.decimalDigits,
    required this.position,
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String? ?? 'Unknown',
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
      decimalDigits: json['decimal_digits'] as int? ?? 0,
      position: json['position'] as String? ?? '',
      thousandSeparator: json['thousand_separator'] as String? ?? ',',
      decimalSeparator: json['decimal_separator'] as String? ?? '.',
    );
  }

  /// Converts the [Country] object to a [Map<String, dynamic>].
  Map<String,dynamic> toMap(){
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'emoji': emoji,
      'decimal_digits': decimalDigits,
      'position': position,
      'thousand_separator': thousandSeparator,
      'decimal_separator': decimalSeparator,
    };
  }

  /// Converts the [Country] object to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  String toString() => '$name ($symbol) $emoji';

  /// Returns a default string representation for display purposes,
  /// typically combining the emoji flag and ISO code.
  String getDefaultView(){
    return '$emoji $code';
  }




}