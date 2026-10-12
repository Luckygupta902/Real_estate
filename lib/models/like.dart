class Like {
  final int id;
  final int userId;
  final int propertyId;
  final String? createdAt;

  Like({
    required this.id,
    required this.userId,
    required this.propertyId,
    this.createdAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      propertyId: (json['propertyId'] as num).toInt(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}
