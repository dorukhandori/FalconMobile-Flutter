import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String token,
    required String customerCode,
    required String name,
    required String email,
    required int customerId,
    required int userId,
    required int loginType,
    required int salesmanId,
    required int languageId,
    required int customerType,
    required int isAccessories,
    required int isService,
    required int isAvm,
    required int isOil,
    required int isOto,
    required int isMarket,
    String? phone,
    String? taxOffice,
    String? taxNumber,
    String? address,
    String? address2,
    String? country,
    String? city,
    String? region,
    String? postalCode,
    String? filePath1,
    String? filePath2,
    String? filePath3,
    String? filePath4,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
