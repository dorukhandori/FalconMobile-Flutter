// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BannerModelImpl _$$BannerModelImplFromJson(Map<String, dynamic> json) =>
    _$BannerModelImpl(
      id: (json['id'] as num).toInt(),
      picturePath: json['picturePath'] as String,
      header: json['header'] as String?,
      content: json['content'] as String?,
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String),
      createDateStr: json['createDateStr'] as String?,
    );

Map<String, dynamic> _$$BannerModelImplToJson(_$BannerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'picturePath': instance.picturePath,
      'header': instance.header,
      'content': instance.content,
      'createDate': instance.createDate?.toIso8601String(),
      'createDateStr': instance.createDateStr,
    };
