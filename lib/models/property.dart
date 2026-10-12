class Property {
  final int? id;
  final String title;
  final String? description;
  final String? propertyType;
  final String? listingType;
  final double? price;
  final double? area;
  final int? bedrooms;
  final int? bathrooms;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? status;

  Property({
    this.id,
    required this.title,
    this.description,
    this.propertyType,
    this.listingType,
    this.price,
    this.area,
    this.bedrooms,
    this.bathrooms,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.status,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: (json['id'] as num?)?.toInt(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      propertyType: json['propertyType']?.toString(),
      listingType: json['listingType']?.toString(),
      price: (json['price'] as num?)?.toDouble(),
      area: (json['area'] as num?)?.toDouble(),
      bedrooms: (json['bedrooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      pincode: json['pincode']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'propertyType': propertyType,
    'listingType': listingType,
    'price': price,
    'area': area,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'address': address,
    'city': city,
    'state': state,
    'pincode': pincode,
    'status': status,
  };
}
