class TownModel {
  final String town;

  TownModel({required this.town});

  factory TownModel.fromMap(Map<String, dynamic> map) {
    return TownModel(
      town: map['town'] ?? '',
    );
  }
}
