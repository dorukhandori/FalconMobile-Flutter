// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) {
  return _BannerModel.fromJson(json);
}

/// @nodoc
mixin _$BannerModel {
  int get id => throw _privateConstructorUsedError;
  String get picturePath => throw _privateConstructorUsedError;
  String? get header => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'createDate')
  DateTime? get createDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'createDateStr')
  String? get createDateStr => throw _privateConstructorUsedError;

  /// Serializes this BannerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BannerModelCopyWith<BannerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerModelCopyWith<$Res> {
  factory $BannerModelCopyWith(
          BannerModel value, $Res Function(BannerModel) then) =
      _$BannerModelCopyWithImpl<$Res, BannerModel>;
  @useResult
  $Res call(
      {int id,
      String picturePath,
      String? header,
      String? content,
      @JsonKey(name: 'createDate') DateTime? createDate,
      @JsonKey(name: 'createDateStr') String? createDateStr});
}

/// @nodoc
class _$BannerModelCopyWithImpl<$Res, $Val extends BannerModel>
    implements $BannerModelCopyWith<$Res> {
  _$BannerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? picturePath = null,
    Object? header = freezed,
    Object? content = freezed,
    Object? createDate = freezed,
    Object? createDateStr = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      picturePath: null == picturePath
          ? _value.picturePath
          : picturePath // ignore: cast_nullable_to_non_nullable
              as String,
      header: freezed == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      createDate: freezed == createDate
          ? _value.createDate
          : createDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createDateStr: freezed == createDateStr
          ? _value.createDateStr
          : createDateStr // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BannerModelImplCopyWith<$Res>
    implements $BannerModelCopyWith<$Res> {
  factory _$$BannerModelImplCopyWith(
          _$BannerModelImpl value, $Res Function(_$BannerModelImpl) then) =
      __$$BannerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String picturePath,
      String? header,
      String? content,
      @JsonKey(name: 'createDate') DateTime? createDate,
      @JsonKey(name: 'createDateStr') String? createDateStr});
}

/// @nodoc
class __$$BannerModelImplCopyWithImpl<$Res>
    extends _$BannerModelCopyWithImpl<$Res, _$BannerModelImpl>
    implements _$$BannerModelImplCopyWith<$Res> {
  __$$BannerModelImplCopyWithImpl(
      _$BannerModelImpl _value, $Res Function(_$BannerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? picturePath = null,
    Object? header = freezed,
    Object? content = freezed,
    Object? createDate = freezed,
    Object? createDateStr = freezed,
  }) {
    return _then(_$BannerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      picturePath: null == picturePath
          ? _value.picturePath
          : picturePath // ignore: cast_nullable_to_non_nullable
              as String,
      header: freezed == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      createDate: freezed == createDate
          ? _value.createDate
          : createDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createDateStr: freezed == createDateStr
          ? _value.createDateStr
          : createDateStr // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BannerModelImpl implements _BannerModel {
  const _$BannerModelImpl(
      {required this.id,
      required this.picturePath,
      this.header,
      this.content,
      @JsonKey(name: 'createDate') this.createDate,
      @JsonKey(name: 'createDateStr') this.createDateStr});

  factory _$BannerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BannerModelImplFromJson(json);

  @override
  final int id;
  @override
  final String picturePath;
  @override
  final String? header;
  @override
  final String? content;
  @override
  @JsonKey(name: 'createDate')
  final DateTime? createDate;
  @override
  @JsonKey(name: 'createDateStr')
  final String? createDateStr;

  @override
  String toString() {
    return 'BannerModel(id: $id, picturePath: $picturePath, header: $header, content: $content, createDate: $createDate, createDateStr: $createDateStr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.picturePath, picturePath) ||
                other.picturePath == picturePath) &&
            (identical(other.header, header) || other.header == header) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createDate, createDate) ||
                other.createDate == createDate) &&
            (identical(other.createDateStr, createDateStr) ||
                other.createDateStr == createDateStr));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, picturePath, header, content, createDate, createDateStr);

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerModelImplCopyWith<_$BannerModelImpl> get copyWith =>
      __$$BannerModelImplCopyWithImpl<_$BannerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BannerModelImplToJson(
      this,
    );
  }
}

abstract class _BannerModel implements BannerModel {
  const factory _BannerModel(
          {required final int id,
          required final String picturePath,
          final String? header,
          final String? content,
          @JsonKey(name: 'createDate') final DateTime? createDate,
          @JsonKey(name: 'createDateStr') final String? createDateStr}) =
      _$BannerModelImpl;

  factory _BannerModel.fromJson(Map<String, dynamic> json) =
      _$BannerModelImpl.fromJson;

  @override
  int get id;
  @override
  String get picturePath;
  @override
  String? get header;
  @override
  String? get content;
  @override
  @JsonKey(name: 'createDate')
  DateTime? get createDate;
  @override
  @JsonKey(name: 'createDateStr')
  String? get createDateStr;

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BannerModelImplCopyWith<_$BannerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
