class CustomerModel {
  final int id;
  final String code;
  final String name;
  final String city;
  final String town;
  final String tel;

  CustomerModel({
    required this.id,
    required this.code,
    required this.name,
    required this.city,
    required this.town,
    required this.tel,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? 0,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      town: map['town'] ?? '',
      tel: map['tel1'] ?? '',
    );
  }
}
