class PostModel {
  final int id;
  final String title;
  final String body;
  final int userId;
  bool isLiked;
  int likeCount;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    this.isLiked = false,
    this.likeCount = 0,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      likeCount: json['likeCount'] ?? 0,
    );
  }
}