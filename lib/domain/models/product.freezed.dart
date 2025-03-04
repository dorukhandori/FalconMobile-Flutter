// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get productCode => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ListPrice')
  double get listPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'DiscountRate')
  double get discountRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'NetPrice')
  double get netPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'NetPriceWithVAT')
  double get netPriceWithVAT => throw _privateConstructorUsedError;
  @JsonKey(name: 'ImagePath')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsFavorite')
  bool get isFavorite => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String productCode,
      String productName,
      @JsonKey(name: 'ListPrice') double listPrice,
      @JsonKey(name: 'DiscountRate') double discountRate,
      @JsonKey(name: 'NetPrice') double netPrice,
      @JsonKey(name: 'NetPriceWithVAT') double netPriceWithVAT,
      @JsonKey(name: 'ImagePath') String imageUrl,
      @JsonKey(name: 'IsFavorite') bool isFavorite,
      String? barcode,
      String? unit});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productCode = null,
    Object? productName = null,
    Object? listPrice = null,
    Object? discountRate = null,
    Object? netPrice = null,
    Object? netPriceWithVAT = null,
    Object? imageUrl = null,
    Object? isFavorite = null,
    Object? barcode = freezed,
    Object? unit = freezed,
  }) {
    return _then(_value.copyWith(
      productCode: null == productCode
          ? _value.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      listPrice: null == listPrice
          ? _value.listPrice
          : listPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountRate: null == discountRate
          ? _value.discountRate
          : discountRate // ignore: cast_nullable_to_non_nullable
              as double,
      netPrice: null == netPrice
          ? _value.netPrice
          : netPrice // ignore: cast_nullable_to_non_nullable
              as double,
      netPriceWithVAT: null == netPriceWithVAT
          ? _value.netPriceWithVAT
          : netPriceWithVAT // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productCode,
      String productName,
      @JsonKey(name: 'ListPrice') double listPrice,
      @JsonKey(name: 'DiscountRate') double discountRate,
      @JsonKey(name: 'NetPrice') double netPrice,
      @JsonKey(name: 'NetPriceWithVAT') double netPriceWithVAT,
      @JsonKey(name: 'ImagePath') String imageUrl,
      @JsonKey(name: 'IsFavorite') bool isFavorite,
      String? barcode,
      String? unit});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productCode = null,
    Object? productName = null,
    Object? listPrice = null,
    Object? discountRate = null,
    Object? netPrice = null,
    Object? netPriceWithVAT = null,
    Object? imageUrl = null,
    Object? isFavorite = null,
    Object? barcode = freezed,
    Object? unit = freezed,
  }) {
    return _then(_$ProductImpl(
      productCode: null == productCode
          ? _value.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      listPrice: null == listPrice
          ? _value.listPrice
          : listPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountRate: null == discountRate
          ? _value.discountRate
          : discountRate // ignore: cast_nullable_to_non_nullable
              as double,
      netPrice: null == netPrice
          ? _value.netPrice
          : netPrice // ignore: cast_nullable_to_non_nullable
              as double,
      netPriceWithVAT: null == netPriceWithVAT
          ? _value.netPriceWithVAT
          : netPriceWithVAT // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl(
      {required this.productCode,
      required this.productName,
      @JsonKey(name: 'ListPrice') required this.listPrice,
      @JsonKey(name: 'DiscountRate') required this.discountRate,
      @JsonKey(name: 'NetPrice') required this.netPrice,
      @JsonKey(name: 'NetPriceWithVAT') required this.netPriceWithVAT,
      @JsonKey(name: 'ImagePath') required this.imageUrl,
      @JsonKey(name: 'IsFavorite') required this.isFavorite,
      this.barcode,
      this.unit});

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String productCode;
  @override
  final String productName;
  @override
  @JsonKey(name: 'ListPrice')
  final double listPrice;
  @override
  @JsonKey(name: 'DiscountRate')
  final double discountRate;
  @override
  @JsonKey(name: 'NetPrice')
  final double netPrice;
  @override
  @JsonKey(name: 'NetPriceWithVAT')
  final double netPriceWithVAT;
  @override
  @JsonKey(name: 'ImagePath')
  final String imageUrl;
  @override
  @JsonKey(name: 'IsFavorite')
  final bool isFavorite;
  @override
  final String? barcode;
  @override
  final String? unit;

  @override
  String toString() {
    return 'Product(productCode: $productCode, productName: $productName, listPrice: $listPrice, discountRate: $discountRate, netPrice: $netPrice, netPriceWithVAT: $netPriceWithVAT, imageUrl: $imageUrl, isFavorite: $isFavorite, barcode: $barcode, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.listPrice, listPrice) ||
                other.listPrice == listPrice) &&
            (identical(other.discountRate, discountRate) ||
                other.discountRate == discountRate) &&
            (identical(other.netPrice, netPrice) ||
                other.netPrice == netPrice) &&
            (identical(other.netPriceWithVAT, netPriceWithVAT) ||
                other.netPriceWithVAT == netPriceWithVAT) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      productCode,
      productName,
      listPrice,
      discountRate,
      netPrice,
      netPriceWithVAT,
      imageUrl,
      isFavorite,
      barcode,
      unit);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {required final String productCode,
      required final String productName,
      @JsonKey(name: 'ListPrice') required final double listPrice,
      @JsonKey(name: 'DiscountRate') required final double discountRate,
      @JsonKey(name: 'NetPrice') required final double netPrice,
      @JsonKey(name: 'NetPriceWithVAT') required final double netPriceWithVAT,
      @JsonKey(name: 'ImagePath') required final String imageUrl,
      @JsonKey(name: 'IsFavorite') required final bool isFavorite,
      final String? barcode,
      final String? unit}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get productCode;
  @override
  String get productName;
  @override
  @JsonKey(name: 'ListPrice')
  double get listPrice;
  @override
  @JsonKey(name: 'DiscountRate')
  double get discountRate;
  @override
  @JsonKey(name: 'NetPrice')
  double get netPrice;
  @override
  @JsonKey(name: 'NetPriceWithVAT')
  double get netPriceWithVAT;
  @override
  @JsonKey(name: 'ImagePath')
  String get imageUrl;
  @override
  @JsonKey(name: 'IsFavorite')
  bool get isFavorite;
  @override
  String? get barcode;
  @override
  String? get unit;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
