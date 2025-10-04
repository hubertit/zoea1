class Property {
  final String propertyId;
  final String? locationId;
  final String? agentId;
  final String uid;
  final String slug;
  final String category;
  final String bedrooms;
  final String bathrooms;
  final String size;
  final String parkingSpaces;
  final String yearBuilt;
  final String listingDate;
  final String status;
  final String title;
  final String description;
  final String address;
  final String? features;
  final String photoUrl;
  final String propertyType;
  final String price;
  final bool? breakfastIncluded;
  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.propertyId,
    this.locationId,
    this.agentId,
    required this.uid,
    required this.slug,
    required this.category,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.parkingSpaces,
    required this.yearBuilt,
    required this.listingDate,
    required this.status,
    required this.title,
    required this.description,
    required this.address,
    this.features,
    required this.photoUrl,
    required this.propertyType,
    required this.price,
    this.breakfastIncluded,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      propertyId: json['property_id'] as String,
      locationId: json['location_id'] as String?,
      agentId: json['agent_id'] as String?,
      uid: json['uid'] as String,
      slug: json['slug'] as String,
      category: json['category'] as String,
      bedrooms: json['bedrooms'] as String,
      bathrooms: json['bathrooms'] as String,
      size: json['size'] ?? "",
      parkingSpaces: json['parking_spaces'] as String,
      yearBuilt: json['year_built'] as String,
      listingDate: json['listing_date'] ,
      status: json['status'] as String,
      title: json['title'] as String,
      description: json['description'] ??"",
      address: json['address'] ?? "",
      features: json['features'] as String?,
      photoUrl: json['photo_url'] as String,
      propertyType: json['property_type'] as String,
      price: json['price'] as String,
      breakfastIncluded: json['breakfast_included'] != null
          ? json['breakfast_included'] as bool
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'location_id': locationId,
      'agent_id': agentId,
      'uid': uid,
      'slug': slug,
      'category': category,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'size': size,
      'parking_spaces': parkingSpaces,
      'year_built': yearBuilt,
      'listing_date': listingDate,
      'status': status,
      'title': title,
      'description': description,
      'address': address,
      'features': features,
      'photo_url': photoUrl,
      'property_type': propertyType,
      'price': price,
      'breakfast_included': breakfastIncluded,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
