class RegisterParams {
  final int customerType;
  final String fullName;
  final String email;
  final String phone;
  final String taxOffice;
  final String taxNumber;
  final String address;
  final String city;
  final String postalCode;

  RegisterParams({
    required this.customerType,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.taxOffice,
    required this.taxNumber,
    required this.address,
    required this.city,
    required this.postalCode,
  });
}
