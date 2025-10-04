import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zoea1/authentication.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/partial/favorite_place_item.dart';
import 'package:zoea1/partial/place_list_item.dart';
import 'package:zoea1/super_base.dart';

import 'json/place.dart';
import 'place_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final bool isLogged;
  const FavoritesScreen({super.key, this.isLogged = true});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends Superbase<FavoritesScreen> {
  List<Place> _list = [];
  final _key = GlobalKey<RefreshIndicatorState>();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Call loadData immediately
    loadData();
    // Remove the frequent timer - it's causing too many API calls
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   loadData();
    // });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  void reload() {
    _key.currentState?.show();
  }

  Future<void> loadData() {
    return ajax(
        url: "venues/favorites",
        method: "POST",
        onValue: (obj, url) {
          setState(() {
            _list = (obj['venues'] as Iterable?)
                    ?.map((e) => Place.fromJson(e))
                    .toList() ??
                [];
            for (var element in _list) {
              element.favorite = true;
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Favorites"),
      ),
      body: RefreshIndicator(color: refleshColor,
          key: _key,
          onRefresh: loadData,
          child: User.user == null
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Login to access your favorite places"),
                    TextButton.icon(
                        icon:
                            const Icon(Icons.login),
                        onPressed:  () {
                                push(const Authentication());
                              },
                        label: const Text("Login"))
                  ],
                ))
              : _list.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            // widget.isLogged
                            // ?
                            "You have not added favorite places!",style: TextStyle(fontSize: 16),
                            // : "Login to access your favorite places"
                        ),
                        // widget.isLogged
                        //     ?
                        SizedBox(height: 20,),
                        Image.asset(AssetUtls.favourite,height: 60,)
                            // : TextButton.icon(
                            //     icon: Icon(widget.isLogged
                            //         ? Icons.refresh
                            //         : Icons.login),
                            //     onPressed: widget.isLogged
                            //         ? reload
                            //         : () {
                            //             push(Authentication());
                            //           },
                            //     label:
                            //         Text(widget.isLogged ? "Refresh" : "Login"))
                      ],
                    ))
                  : ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return PlaceListItem(
                          place: _list[index],
                          callback: () {
                            push(PlaceDetailScreen(
                              place: _list[index],
                            ));
                          },
                        );
                      },
                      itemCount: _list.length,
                    )),
    );
  }
}
