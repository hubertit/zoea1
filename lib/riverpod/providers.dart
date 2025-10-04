import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'categories_notifier.dart';

final categoriesProvider =
StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier();
});