import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/businesses_model.dart';
import '../models/tech_businesses.dart';
import 'notifiers/web_mobile_notifier.dart';

final webMobileAppsNotifierProvider =
StateNotifierProvider<WebMobileNotifier, List<WebMobileModel>>((ref) {
  return WebMobileNotifier();
});
final techBusinessNotifierProvider =
StateNotifierProvider<TechBusinessesNotifier, List<TechBusinessModel>>((ref) {
  return TechBusinessesNotifier();
});
final businessDirectoriesNotifierProvider =
StateNotifierProvider<TechBusinessesNotifier, List<TechBusinessModel>>((ref) {
  return TechBusinessesNotifier();
});
final isLoadingProvider = StateProvider<bool>((ref) => false);
