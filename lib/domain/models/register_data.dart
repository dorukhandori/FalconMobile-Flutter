import 'package:auth_app/domain/models/register_params.dart';

class RegisterData {
  final int customerType;
  final String fullName;
  final String email;
  final String phone;
  final String taxOffice;
  final String taxNumber;
  final bool isAccessories;
  final bool isService;
  final bool isAvm;
  final bool isOil;
  final bool isOto;
  final bool isMarket;
  final String address;
  final String address2;
  final String country;
  final String city;
  final String region;
  final String postalCode;
  final List<String> fileUrls;

  RegisterData({
    required this.customerType,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.taxOffice,
    required this.taxNumber,
    required this.isAccessories,
    required this.isService,
    required this.isAvm,
    required this.isOil,
    required this.isOto,
    required this.isMarket,
    required this.address,
    required this.address2,
    required this.country,
    required this.city,
    required this.region,
    required this.postalCode,
    required this.fileUrls,
  });

  RegisterData copyWith({
    int? customerType,
    String? fullName,
    String? email,
    String? phone,
    String? taxOffice,
    String? taxNumber,
    bool? isAccessories,
    bool? isService,
    bool? isAvm,
    bool? isOil,
    bool? isOto,
    bool? isMarket,
    String? address,
    String? address2,
    String? country,
    String? city,
    String? region,
    String? postalCode,
    List<String>? fileUrls,
  }) {
    return RegisterData(
      customerType: customerType ?? this.customerType,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      taxOffice: taxOffice ?? this.taxOffice,
      taxNumber: taxNumber ?? this.taxNumber,
      isAccessories: isAccessories ?? this.isAccessories,
      isService: isService ?? this.isService,
      isAvm: isAvm ?? this.isAvm,
      isOil: isOil ?? this.isOil,
      isOto: isOto ?? this.isOto,
      isMarket: isMarket ?? this.isMarket,
      address: address ?? this.address,
      address2: address2 ?? this.address2,
      country: country ?? this.country,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      fileUrls: fileUrls ?? this.fileUrls,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerType': customerType,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'taxOffice': taxOffice,
      'taxNumber': taxNumber,
      'isAccessories': isAccessories ? 1 : 0,
      'isService': isService ? 1 : 0,
      'isAvm': isAvm ? 1 : 0,
      'isOil': isOil ? 1 : 0,
      'isOto': isOto ? 1 : 0,
      'isMarket': isMarket ? 1 : 0,
      'address': address,
      'address2': address2,
      'country': country,
      'city': city,
      'region': region,
      'postalCode': postalCode,
      'filePath1': fileUrls.isNotEmpty ? fileUrls[0] : '',
      'filePath2': fileUrls.length > 1 ? fileUrls[1] : '',
      'filePath3': fileUrls.length > 2 ? fileUrls[2] : '',
      'filePath4': fileUrls.length > 3 ? fileUrls[3] : '',
    };
  }
}

extension RegisterDataX on RegisterData {
  RegisterParams toRegisterParams() {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    return RegisterParams(
      customerType: customerType,
      fullName: fullName,
      email: email,
      phone: cleanPhone,
      taxOffice: taxOffice,
      taxNumber: taxNumber,
      isAccessories: isAccessories,
      isService: isService,
      isAvm: isAvm,
      isOil: isOil,
      isOto: isOto,
      isMarket: isMarket,
      address: address,
      address2: address2,
      country: country,
      city: city,
      region: region,
      postalCode: postalCode,
      filePath1: fileUrls.isNotEmpty ? fileUrls[0] : '',
      filePath2: fileUrls.length > 1 ? fileUrls[1] : '',
      filePath3: fileUrls.length > 2 ? fileUrls[2] : '',
      filePath4: fileUrls.length > 3 ? fileUrls[3] : '',
    );
  }
}
