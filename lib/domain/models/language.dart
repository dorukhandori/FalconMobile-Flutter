class Language {
  final int id;
  final String code;
  final String name;
  final String languageCulture;
  final bool isActive;

  Language({
    required this.id,
    required this.code,
    required this.name,
    required this.languageCulture,
    required this.isActive,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      languageCulture: json['languageCulture'] ?? json['code'] ?? 'tr-TR',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'languageCulture': languageCulture,
      'isActive': isActive,
    };
  }
}
