// class Service {
//   String? id;
//   String title;
//   String image;
//   String? desc;
//
//   Service.fromJson(Map<String, dynamic> map)
//       : title = map['category_name'],
//         id = map['category_id'],
//         desc = map['category_description'],
//         image = map['category_image'];
//
//   Service(this.title,this.image);
// }
class Service {
  final String id;
   String title;
  final String image;
  final String cover;
  // final List<SubCategory> subCategories;

  Service({
    required this.id,
    required this.title,
    required this.image,
    required this.cover,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['category_id'],
      title: json['category_name'],
      image: json['category_image'],
      cover: json['category_cover']??''
      // subCategories: (json['sub_categories'] as List<dynamic>)
      //     .map((e) => SubCategory.fromJson(e))
      //     .toList(),
    );
  }
}

class SubCategory {
  final String categoryId;
  final String categoryName;
  final String categoryImage;

  SubCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
    );
  }
}
