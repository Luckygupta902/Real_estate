
class Comment {
  final int id;
  final int userId;
  final int propertyId;
  final String commentText;
  final String? createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.commentText,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      propertyId: (json['propertyId'] as num).toInt(),
      commentText: json['commentText']?.toString() ?? '',
      createdAt: json['createdAt']?.toString(),
    );
  }
}
