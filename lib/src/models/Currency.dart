import 'dart:convert';

class Currency{
  String code;
  String name;
  String symbol;
  String emoji;
  int decimal_digits;
  String position;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.emoji,
    required this.decimal_digits,
    required this.position
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] as String? ?? 'Unknown',
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
      decimal_digits: json['decimal_digits'] as int? ?? 0,
      position: json['position'] as String? ?? '',
    );
  }

  /// Converts the [Country] object to a [Map<String, dynamic>].
  Map<String,dynamic> toMap(){
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'emoji': emoji,
      'decimal_digits': decimal_digits,
      'position': position,
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