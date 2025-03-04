import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String productCode,
    required String productName,
    @JsonKey(name: 'ListPrice') required double listPrice,
    @JsonKey(name: 'DiscountRate') required double discountRate,
    @JsonKey(name: 'NetPrice') required double netPrice,
    @JsonKey(name: 'NetPriceWithVAT') required double netPriceWithVAT,
    @JsonKey(name: 'ImagePath') required String imageUrl,
    @JsonKey(name: 'IsFavorite') required bool isFavorite,
    String? barcode,
    String? unit,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
