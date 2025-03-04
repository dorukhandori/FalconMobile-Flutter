class BannerModel {
  final String picturePath;
  final int id;
  final String? header;
  final String? content;
  final DateTime? createDate;
  final String? createDateStr;

  BannerModel.fromJson(Map<String, dynamic> json)
      : picturePath = _fixImageUrl(json['picturePath'] as String),
        id = json['id'] as int,
        header = json['header'] as String?,
        content = json['content'] as String?,
        createDate = json['createDate'] != null
            ? DateTime.parse(json['createDate'] as String)
            : null,
        createDateStr = json['createDateStr'] as String?;

  static String _fixImageUrl(String url) {
    if (url.contains('cdn.epic-soft.net')) {
      return url.replaceAll('cdn.epic-soft.net', 'cdn.allprox.com.tr');
    }
    return url;
  }

  @override
  String toString() => 'BannerModel(picturePath: $picturePath)';
}
