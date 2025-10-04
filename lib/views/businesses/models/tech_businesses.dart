class TechBusinessModel {
  final int id;
  final String companyName;
  final String companyPhone;
  final String companyEmail;
  final String companyDescription;
  final String website;
  final String province;
  final String district;
  final String sector;
  final String cell;
  final String village;
  final String logo;
  final List<String> sectors;

  TechBusinessModel({
    required this.id,
    required this.companyName,
    required this.companyPhone,
    required this.companyEmail,
    required this.companyDescription,
    required this.website,
    required this.province,
    required this.district,
    required this.sector,
    required this.cell,
    required this.village,
    required this.logo,
    required this.sectors,
  });

  factory TechBusinessModel.fromJson(Map<String, dynamic> json) {
    return TechBusinessModel(
      id: json['id'] ?? 0,
      companyName: json['company_name'] ?? '',
      companyPhone: json['company_phone'] ?? '',
      companyEmail: json['company_email'] ?? '',
      companyDescription: json['description'] ?? '',
      website: json['website'] ?? '',
      province: json['province'] ?? '',
      district: json['district'] ?? '',
      sector: json['sector'] ?? '',
      cell: json['cell'] ?? '',
      village: json['village'] ?? '',
      logo: json['logo'] ?? '',
      sectors: json['sectors'] != null
          ? List<String>.from(json['sectors'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'company_phone': companyPhone,
      'company_email': companyEmail,
      'company_description': companyDescription,
      'website': website,
      'province': province,
      'district': district,
      'sector': sector,
      'cell': cell,
      'village': village,
      'logo': logo,
      'sectors': sectors,
    };
  }
}
