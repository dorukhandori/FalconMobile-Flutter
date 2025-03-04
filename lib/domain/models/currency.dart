class Currency {
  final int id;
  final String code;
  final String name;
  final String symbol;
  final String type;
  final double rate;
  final bool isActive;

  Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.type,
    required this.rate,
    required this.isActive,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      type: json['type'] ?? json['name'] ?? '',
      rate: (json['rate'] ?? 0.0).toDouble(),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'symbol': symbol,
      'type': type,
      'rate': rate,
      'isActive': isActive,
    };
  }
}
