class Announcement {
  final int id;
  final String picturePath;
  final String query;

  Announcement({
    required this.id,
    required this.picturePath,
    required this.query,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as int,
      picturePath: json['picturePath'] as String,
      query: json['query'] as String,
    );
  }
}
