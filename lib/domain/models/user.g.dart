// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      token: json['token'] as String,
      customerCode: json['customerCode'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      customerId: (json['customerId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      loginType: (json['loginType'] as num).toInt(),
      salesmanId: (json['salesmanId'] as num).toInt(),
      languageId: (json['languageId'] as num).toInt(),
      customerType: (json['customerType'] as num).toInt(),
      isAccessories: (json['isAccessories'] as num).toInt(),
      isService: (json['isService'] as num).toInt(),
      isAvm: (json['isAvm'] as num).toInt(),
      isOil: (json['isOil'] as num).toInt(),
      isOto: (json['isOto'] as num).toInt(),
      isMarket: (json['isMarket'] as num).toInt(),
      phone: json['phone'] as String?,
      taxOffice: json['taxOffice'] as String?,
      taxNumber: json['taxNumber'] as String?,
      address: json['address'] as String?,
      address2: json['address2'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      postalCode: json['postalCode'] as String?,
      filePath1: json['filePath1'] as String?,
      filePath2: json['filePath2'] as String?,
      filePath3: json['filePath3'] as String?,
      filePath4: json['filePath4'] as String?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'customerCode': instance.customerCode,
      'name': instance.name,
      'email': instance.email,
      'customerId': instance.customerId,
      'userId': instance.userId,
      'loginType': instance.loginType,
      'salesmanId': instance.salesmanId,
      'languageId': instance.languageId,
      'customerType': instance.customerType,
      'isAccessories': instance.isAccessories,
      'isService': instance.isService,
      'isAvm': instance.isAvm,
      'isOil': instance.isOil,
      'isOto': instance.isOto,
      'isMarket': instance.isMarket,
      'phone': instance.phone,
      'taxOffice': instance.taxOffice,
      'taxNumber': instance.taxNumber,
      'address': instance.address,
      'address2': instance.address2,
      'country': instance.country,
      'city': instance.city,
      'region': instance.region,
      'postalCode': instance.postalCode,
      'filePath1': instance.filePath1,
      'filePath2': instance.filePath2,
      'filePath3': instance.filePath3,
      'filePath4': instance.filePath4,
    };
