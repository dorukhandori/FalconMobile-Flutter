class User {
  final String? id;
  final String? customerCode;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? taxOffice;
  final String? taxNumber;
  final int? customerType;
  final int isAccessories;
  final int isService;
  final int isAvm;
  final int isOil;
  final int isOto;
  final int isMarket;
  final String? address;
  final String? address2;
  final String? country;
  final String? city;
  final String? region;
  final String? postalCode;
  final String? filePath1;
  final String? filePath2;
  final String? filePath3;
  final String? filePath4;

  User({
    this.id,
    this.customerCode,
    this.fullName,
    this.email,
    this.phone,
    this.taxOffice,
    this.taxNumber,
    this.customerType,
    this.isAccessories = 0,
    this.isService = 0,
    this.isAvm = 0,
    this.isOil = 0,
    this.isOto = 0,
    this.isMarket = 0,
    this.address,
    this.address2,
    this.country,
    this.city,
    this.region,
    this.postalCode,
    this.filePath1,
    this.filePath2,
    this.filePath3,
    this.filePath4,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      customerCode: json['customerCode']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      taxOffice: json['taxOffice']?.toString(),
      taxNumber: json['taxNumber']?.toString(),
      customerType: json['customerType'] as int?,
      isAccessories: json['isAccessories'] as int? ?? 0,
      isService: json['isService'] as int? ?? 0,
      isAvm: json['isAvm'] as int? ?? 0,
      isOil: json['isOil'] as int? ?? 0,
      isOto: json['isOto'] as int? ?? 0,
      isMarket: json['isMarket'] as int? ?? 0,
      address: json['address']?.toString(),
      address2: json['address2']?.toString(),
      country: json['country']?.toString(),
      city: json['city']?.toString(),
      region: json['region']?.toString(),
      postalCode: json['postalCode']?.toString(),
      filePath1: json['filePath1']?.toString(),
      filePath2: json['filePath2']?.toString(),
      filePath3: json['filePath3']?.toString(),
      filePath4: json['filePath4']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerCode': customerCode,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'taxOffice': taxOffice,
      'taxNumber': taxNumber,
      'customerType': customerType,
      'isAccessories': isAccessories,
      'isService': isService,
      'isAvm': isAvm,
      'isOil': isOil,
      'isOto': isOto,
      'isMarket': isMarket,
      'address': address,
      'address2': address2,
      'country': country,
      'city': city,
      'region': region,
      'postalCode': postalCode,
      'filePath1': filePath1,
      'filePath2': filePath2,
      'filePath3': filePath3,
      'filePath4': filePath4,
    };
  }
}
