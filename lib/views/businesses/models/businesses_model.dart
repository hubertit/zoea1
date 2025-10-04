class PlatformType {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? nameKn;
  final String link;

  PlatformType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.nameKn,
    required this.link,
  });

  factory PlatformType.fromJson(Map<String, dynamic> json) {
    return PlatformType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      nameKn: json['name_kn'],
      link: json['pivot']['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'name_kn': nameKn,
      'link': link,
    };
  }
}

class WebMobileModel {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String description;
  final String? website;
  final String? province;
  final String? district;
  final String? sector;
  final String? cell;
  final String? village;
  final String logo;
  final List<PlatformType> types;

  WebMobileModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    required this.description,
    this.website,
    this.province,
    this.district,
    this.sector,
    this.cell,
    this.village,
    required this.logo,
    required this.types,
  });

  factory WebMobileModel.fromJson(Map<String, dynamic> json) {
    var typesFromJson = json['types'] as List? ?? [];
    List<PlatformType> typeList = typesFromJson.map((typeJson) => PlatformType.fromJson(typeJson)).toList();

    return WebMobileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'],
      email: json['email'],
      description: json['description'] ?? '',
      website: json['website'],
      province: json['province'],
      district: json['district'],
      sector: json['sector'],
      cell: json['cell'],
      village: json['village'],
      logo: json['logo'] ?? '',
      types: typeList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'description': description,
      'website': website,
      'province': province,
      'district': district,
      'sector': sector,
      'cell': cell,
      'village': village,
      'logo': logo,
      'types': types.map((type) => type.toJson()).toList(),
    };
  }
}
