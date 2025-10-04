import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoea1/homepage.dart';
import 'package:zoea1/json/country_model.dart';

import '../../ults/style_utls.dart';
import 'notifiers/country_notifier.dart';
import 'widgets/countries_card.dart';

final storesProvider = StateNotifierProvider<StoreNotifier, StoreState?>((ref) {
  return StoreNotifier();
});
final myCountryProvider = StateProvider<CountryModel?>((ref) => null);

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  // var selectedStoreProvider = StateProvider<Store?>((ref) => null);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadStoreCountryPreferences(ref);
      await ref.read(storesProvider.notifier).stores(context);
      var stores = ref.watch(storesProvider);
      var myStore = ref.watch(myCountryProvider);
      if (myStore == null) {
        ref.read(myCountryProvider.notifier).state = stores!.stores[0];
      }
    });

    super.initState();
  }

  Future<void> _saveCountryToPreferences(CountryModel country) async {
    final prefs = await SharedPreferences.getInstance();
    final storeJson = jsonEncode(country.toJson());
    await prefs.setString('country', storeJson);
  }

  @override
  Widget build(BuildContext context) {
    var stores = ref.watch(storesProvider);
    var selectedSore = ref.watch(myCountryProvider);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 100),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Switch country",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 2.0,
                ),
                // const Center(
                //   child: Text(
                //     "Choose store and currency!",
                //     style: TextStyle(
                //       fontSize: 13,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: stores!.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                                List.generate(stores.stores.length, (index) {
                              CountryModel store = stores.stores[index];
                              return LanguageList(
                                chooseLanguages: stores.stores[index],
                                onTap: () {
                                  ref.read(myCountryProvider.notifier).state =
                                      store;
                                },
                                isSelected:
                                    store.countryId == selectedSore!.countryId,
                              );
                            }),
                          ),
                        ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 120,
          ),
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 50),
            width: 200,
            child: ElevatedButton(
              // style: StyleUtls.buttonStyle,
              onPressed: () async {
                if (selectedSore != null) {
                  await _saveCountryToPreferences(selectedSore);
                  ref.read(myCountryProvider.notifier).state = selectedSore;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homepage(),
                    ),
                  );
                  // context.go('/');
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Continue",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
