import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/business_directories.dart';
import '../../models/businesses_model.dart';
import '../../models/tech_businesses.dart';
import '../providers.dart';

const baseUrlB = 'https://ihuzo.rw/api';


class WebMobileNotifier extends StateNotifier<List<WebMobileModel>> {
  // final JbService _jobService;

  WebMobileNotifier() : super([]);
  final Dio _dio = Dio();
  // final String baseUrl = 'http://app.ihuzo.rw/api';

  Future<void> fetchWebMobileApps() async {
    try {
      final response = await _dio.get('$baseUrlB/web-mobile');

      if (response.statusCode == 200) {
        // print("=====+=== web-mobile");
        // print(response.data['data'].length);
        final List<dynamic> jobList = response.data['data'];
        // print(jobList);
        state = jobList.map((json) => WebMobileModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch web-mobile');
      }
    } catch (e) {
      // print('Failed to fetch saved jobs: $e');
    } finally {
      // ref.read(isLoadingProvider.notifier).state = false;
    }
  }
}

class TechBusinessesNotifier extends StateNotifier<List<TechBusinessModel>> {
  // final JbService _jobService;

  TechBusinessesNotifier() : super([]);
  final Dio _dio = Dio();
  // final String baseUrl = 'http://app.ihuzo.rw/api';

  Future<void> fetchTechBusinesses(WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true;
    try {
      final response = await _dio.get('https://ihuzo.rw/api/tech-business');
      // print("For tech");
      if (response.statusCode == 200) {
        final List<dynamic> jobList = response.data['data'];

        state = jobList.map((json) => TechBusinessModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch tech-business ');
      }
    } catch (e) {
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }
  Future<void> fetchBusinessDirectories(WidgetRef ref) async {
    ref.read(isLoadingProvider.notifier).state = true;
    try {
      final response = await _dio.get('https://ihuzo.rw/api/business-directories');
      // print(response.data);
      // print("For tech");
      if (response.statusCode == 200) {
        final List<dynamic> jobList = response.data['data'];

        state = jobList.map((json) => TechBusinessModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch tech-business ');
      }
    } catch (e) {
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }
}

class BusinessDirectoriesNotifier extends StateNotifier<List<BusinessDirectoriesModel>> {
  // final JbService _jobService;

  BusinessDirectoriesNotifier() : super([]);
  final Dio _dio = Dio();
  // final String baseUrl = 'http://app.ihuzo.rw/api';

  Future<void> fetchWebMobileApps() async {
    try {
      final response = await _dio.get('$baseUrlB/api/tech-business');

      if (response.statusCode == 200) {
        // print("=====+=== Saved opppo");
        // print(response.data['job_opportunity']);
        final List<dynamic> jobList = response.data['data'];

        state = jobList.map((json) => BusinessDirectoriesModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch tech-business ');
      }
    } catch (e) {
      // print("=====+===");
      // print('Failed to fetch saved jobs: $e');
      // print(user!.id);
      // print(user.token);
      // print("=====+===");print("=====+===");
    } finally {
      // ref.read(isLoadingProvider.notifier).state = false;
    }
  }
}