// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      productCode: json['productCode'] as String,
      productName: json['productName'] as String,
      listPrice: (json['ListPrice'] as num).toDouble(),
      discountRate: (json['DiscountRate'] as num).toDouble(),
      netPrice: (json['NetPrice'] as num).toDouble(),
      netPriceWithVAT: (json['NetPriceWithVAT'] as num).toDouble(),
      imageUrl: json['ImagePath'] as String,
      isFavorite: json['IsFavorite'] as bool,
      barcode: json['barcode'] as String?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'productCode': instance.productCode,
      'productName': instance.productName,
      'ListPrice': instance.listPrice,
      'DiscountRate': instance.discountRate,
      'NetPrice': instance.netPrice,
      'NetPriceWithVAT': instance.netPriceWithVAT,
      'ImagePath': instance.imageUrl,
      'IsFavorite': instance.isFavorite,
      'barcode': instance.barcode,
      'unit': instance.unit,
    };
