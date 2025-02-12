class Language {
  final int id;
  final String name;
  final String languageCulture;
  final String uniqueSeoCode;
  final String flagImageFileName;
  final bool published;
  final int displayOrder;
  final bool isSelected;

  Language({
    required this.id,
    required this.name,
    required this.languageCulture,
    required this.uniqueSeoCode,
    required this.flagImageFileName,
    required this.published,
    required this.displayOrder,
    required this.isSelected,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as int,
      name: json['name'] as String,
      languageCulture: json['languageCulture'] as String,
      uniqueSeoCode: json['uniqueSeoCode'] as String,
      flagImageFileName: json['flagImageFileName'] as String,
      published: json['published'] as bool,
      displayOrder: json['displayOrder'] as int,
      isSelected: json['isSelected'] as bool,
    );
  }
}
