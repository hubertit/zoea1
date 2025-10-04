class EventCategory {
  final String categoryId;
  final String sort;
  final String categoryName;
  final String categoryImage;

  EventCategory({required this.categoryId, required this.sort, required this.categoryName, required this.categoryImage});

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      categoryId: json['category_id'],
      sort: json['sort'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
    );
  }
}
