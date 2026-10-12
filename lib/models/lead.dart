class Lead {
  final int? id;
  final int? customerId;
  final int? propertyId;
  final int? assignedTo;
  final String? status;
  final String? source;
  final String? message;
  final String? createdAt;
  final String? updatedAt;

  Lead({
    this.id,
    this.customerId,
    this.propertyId,
    this.assignedTo,
    this.status,
    this.source,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: (json['id'] as num?)?.toInt(),
      customerId: (json['customerId'] as num?)?.toInt(),
      propertyId: (json['propertyId'] as num?)?.toInt(),
      assignedTo: (json['assignedTo'] as num?)?.toInt(),
      status: json['status']?.toString(),
      source: json['source']?.toString(),
      message: json['message']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (customerId != null) 'customerId': customerId,
      if (propertyId != null) 'propertyId': propertyId,
      if (assignedTo != null) 'assignedTo': assignedTo,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (message != null) 'message': message,
    };
  }
}
