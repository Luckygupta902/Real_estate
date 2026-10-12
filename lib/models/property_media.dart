
class PropertyMedia {
  final int? id;
  final int? propertyId;
  final String? mediaType;
  final String? mediaUrl;
  final String? thumbnailUrl;

  PropertyMedia({
    this.id,
    this.propertyId,
    this.mediaType,
    this.mediaUrl,
    this.thumbnailUrl,
  });

  factory PropertyMedia.fromJson(Map<String, dynamic> json) {
    return PropertyMedia(
      id: (json['id'] as num?)?.toInt(),
      propertyId: (json['propertyId'] as num?)?.toInt(),
      mediaType: json['mediaType']?.toString(),
      mediaUrl: json['mediaUrl']?.toString(),
      thumbnailUrl: json['thumbnailUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'mediaType': mediaType,
    'mediaUrl': mediaUrl,
    'thumbnailUrl': thumbnailUrl,
  };
}
