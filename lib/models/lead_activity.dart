class LeadActivity {
  final int id;
  final int? leadId;
  final int? userId;
  final String? activityType;
  final String? description;
  final String? createdAt;

  LeadActivity({
    required this.id,
    this.leadId,
    this.userId,
    this.activityType,
    this.description,
    this.createdAt,
  });

  factory LeadActivity.fromJson(Map<String, dynamic> json) {
    return LeadActivity(
      id: (json['id'] as num).toInt(),
      leadId: (json['leadId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      activityType: json['activityType']?.toString(),
      description: json['description']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}
