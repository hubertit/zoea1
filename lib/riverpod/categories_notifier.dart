
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String baseUrl = "http://melamart.rw/api/";

class CategoriesNotifier extends StateNotifier<List<Category>> {
  // final JbService _jobService;

  CategoriesNotifier() : super([]);
  final Dio _dio = Dio();
  // final String baseUrl = 'http://app.ihuzo.rw/api';

  Future<void> featuredProducts(WidgetRef ref) async {
    // ref.read(isLoadingProvider.notifier).state = true;
    try {
      final response = await _dio.get('${baseUrl}/categories/');
      // print("For tech");
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = myList.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch Featured Categories ');
      }
    } catch (e) {
    } finally {
      // ref.read(isLoadingProvider.notifier).state = false;
    }
  }


}



class Category {
  final String categoryId;
  final String parentId;
  final String categoryName;
  final String categoryImage;
  final String categoryDescription;
  final String topCategory;
  final List<Category> subCategories;

  Category({
    required this.categoryId,
    required this.parentId,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryDescription,
    required this.topCategory,
    required this.subCategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] ?? '',
      parentId: json['parent_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryImage: json['category_image'] ?? '',
      categoryDescription: json['category_description'] ?? '',
      topCategory: json['top_category'] ?? '',
      subCategories: (json['sub_categories'] as List<dynamic> ?? [])
          .map((item) => Category.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'parent_id': parentId,
      'category_name': categoryName,
      'category_image': categoryImage,
      'category_description': categoryDescription,
      'top_category': topCategory,
      'sub_categories': subCategories.map((item) => item.toJson()).toList(),
    };
  }
}
