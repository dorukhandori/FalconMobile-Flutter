class BannerModel {
  final int id;
  final String title;
  final String description;
  final String picturePath;
  final String link;
  final int order;
  final bool isActive;

  BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.picturePath,
    required this.link,
    required this.order,
    required this.isActive,
  });

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      picturePath: map['picturePath'] ?? '',
      link: map['link'] ?? '',
      order: map['order'] ?? 0,
      isActive: map['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'picturePath': picturePath,
      'link': link,
      'order': order,
      'isActive': isActive,
    };
  }
}
