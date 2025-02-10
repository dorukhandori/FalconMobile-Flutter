class RegisterParams {
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
  final String filePath1;
  final String filePath2;
  final String filePath3;
  final String filePath4;

  RegisterParams({
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
    required this.filePath1,
    required this.filePath2,
    required this.filePath3,
    required this.filePath4,
  });
}
