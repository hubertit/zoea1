
class CountryModel {
  final String countryId;
  final String name;
  final String flag;
  final String description;

  CountryModel({
    required this.countryId,
    required this.name,
    required this.flag,
    this.description = '',
  });

  // Factory method to create a Country from JSON
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      countryId: json['country_id'] as String,
      name: json['name'] as String,
      flag: json['flag'] as String,
      description: json['description'] ?? '',
    );
  }

  // Convert Country to JSON
  Map<String, dynamic> toJson() {
    return {
      'country_id': countryId,
      'name': name,
      'flag': flag,
      'description': description,
    };
  }
}