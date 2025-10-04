class Cuisine {
  final String cuisineId;
  final String cuisineName;
  final String cuisineImage;

  Cuisine({
    required this.cuisineId,
    required this.cuisineName,
    required this.cuisineImage,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      cuisineId: json['cuisine_Id'] ?? '',
      cuisineName: json['cuisine_name'] ?? '',
      cuisineImage: json['cuisine_image'] ?? '',
    );
  }
}
