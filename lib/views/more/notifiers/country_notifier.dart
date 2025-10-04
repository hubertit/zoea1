import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../json/country_model.dart';
import '../switch_country.dart';

class StoreNotifier extends StateNotifier<StoreState?> {
  StoreNotifier() : super(StoreState.initial());

  final Dio _dio = Dio();

  Future<void> stores(BuildContext context) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
          'https://tarama.ai/api/configs/countries'
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> myList = response.data['data'];

        state = StoreState(
          stores: myList.map((json) => CountryModel.fromJson(json)).toList(),
          isLoading: false,
        );

      } else {
        throw Exception('Failed to fetch stores: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle error appropriately, e.g., show a snackbar or log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

}

class StoreState {
  final List<CountryModel> stores;
  final bool isLoading;

  StoreState({required this.stores, required this.isLoading});

  factory StoreState.initial() =>
      StoreState(stores: [], isLoading: false);

  StoreState copyWith({List<CountryModel>? bookings, bool? isLoading}) {
    return StoreState(
      stores: bookings ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

Future<void> loadStoreCountryPreferences(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final userData = prefs.getString('country');
  if (userData != null) {
    final userMap = jsonDecode(userData) as Map<String, dynamic>;
    ref.read(myCountryProvider.notifier).state = CountryModel.fromJson(userMap);
  }
}