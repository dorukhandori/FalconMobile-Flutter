class CityModel {
  final String city;

  CityModel({required this.city});

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      city: map['city'] ?? '',
    );
  }
}
