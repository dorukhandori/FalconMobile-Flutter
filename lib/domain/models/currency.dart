class Currency {
  final int id;
  final String type;
  final double rate;
  final String icon;

  Currency({
    required this.id,
    required this.type,
    required this.rate,
    required this.icon,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'] as int,
      type: json['type'] as String,
      rate: (json['rate'] as num).toDouble(),
      icon: json['icon'] as String,
    );
  }
}
