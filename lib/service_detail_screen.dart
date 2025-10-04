import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/json/cuisines.dart';
import 'package:zoea1/json/place.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/partial/explore_card.dart';
import 'package:zoea1/partial/icon_item.dart';
import 'package:zoea1/partial/place_list_item.dart';
import 'package:zoea1/place_detail_screen.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/views/businesses/business_directories.dart';
import 'package:zoea1/views/businesses/tech_businesses.dart';
import 'package:zoea1/views/businesses/web_mobile_apps.dart';
import 'package:zoea1/views/events/widgets/event_card.dart';

import 'constants/theme.dart';
import 'json/service.dart';
import 'ults/functions.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Service service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends Superbase<ServiceDetailScreen> {
  Widget get locationPin => Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.yellow.shade800, shape: BoxShape.circle),
        child: const Icon(Icons.location_on_sharp),
      );

  Place? _place;

  GoogleMapController? _controller;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.9546312, 30.0904827),
    zoom: 15.4746,
  );

  List<Place> _places = [];
  List<Cuisine> cuisines = [];
  List<Cuisine> fetchedCuisines = [];
  List<Place> _filteredPlaces = [];
  List<Service> subCat = [];
  List<Service> businesses = [
    Service(
        cover: "",
        id: '11111',
        title: "Buziness directory",
        image:
            "https://ihuzo.rw/storage/profile-photos/kLwkMyqe1PobQuRwEUM6gJ8vWtNyey9GQwnvzLWM.jpg"),
    Service(
        cover: '',
        id: '11112',
        title: " Tech Businesses",
        image:
            "https://ihuzo.rw/storage/profile-photos/WmvDq8HTO4J6MYCV2jHuQFNJRaxoB5R4ohHLBYIt.jpg"),
    Service(
        cover: '',
        id: '11113',
        title: "Web/Mobile Apps",
        image:
            "https://ihuzo.rw/storage/dsp/products/logo/2Fyk3I9G9nGlYA6j1iveIKpzZPwnNi7CvmCPUQyi.png")
  ];
  int selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reload();
      loadCuisines();
    });
    super.initState();
  }

  void reload() {
    loadData();
  }

  Future<void> loadData() {

    return ajax(
        url: "categories/venues",
        method: "POST",
        data: FormData.fromMap({"category_id": widget.service.id}),
        onValue: (object, url) {
          setState(() {
            _places = (object['venues'] as Iterable?)
                    ?.map((e) => Place.fromJson(e))
                    .toList() ??
                [];
            subCat = (object['sub_categories'] as Iterable?)
                    ?.map((e) => Service.fromJson(e))
                    .toList() ??
                [];
            _filteredPlaces = _places;
            isLoading = false;
          });
        });
  }

  // Future<void> reloadData(id) {
  //   return ajax(
  //       url: "categories/venues",
  //       method: "POST",
  //       data: FormData.fromMap({"category_id": id}),
  //       onValue: (object, url) {
  //         setState(() {
  //           _places = (object['venues'] as Iterable?)
  //                   ?.map((e) => Place.fromJson(e))
  //                   .toList() ??
  //               [];
  //           subCat = (object['sub_categories'] as Iterable?)
  //               ?.map((e) => SubCategory.fromJson(e))
  //               .toList() ??
  //               [];
  //           _filteredPlaces = _places;
  //         });
  //       });
  // }

  Future<void> loadCuisines() {
    return ajax(
        url: "venues/cuisines",
        // method: "POST",
        onValue: (object, url) {
          fetchedCuisines = (object['cuisines'] as Iterable?)
                  ?.map((e) => Cuisine.fromJson(e))
                  .toList() ??
              [];
          fetchedCuisines.insert(
              0,
              Cuisine(
                  cuisineId: '',
                  cuisineName: 'All Cuisines',
                  cuisineImage: ''));
          setState(() {
            cuisines = fetchedCuisines;
          });
        });
  }

  void _filterPlaces(String query) {
    setState(() {
      if (query.isEmpty) {
        // If query is empty, show all places
        _filteredPlaces = _places;
      } else {
        // Filter places based on search query
        _filteredPlaces = _places.where((place) {
          // Convert all attributes of Place to lowercase for case-insensitive search
          String title = place.title.toLowerCase();
          String location = place.location.toLowerCase();
          String description = place.about?.toLowerCase() ?? "";
          String address = place.address?.toLowerCase() ?? "";
          String services = place.services?.toLowerCase() ?? "";
          // Check if any attribute contains the search query
          return title.contains(query.toLowerCase()) ||
              location.contains(query.toLowerCase()) ||
              description.contains(query.toLowerCase()) ||
              address.contains(query.toLowerCase()) ||
              services.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    print(widget.service.id);
    var map = GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: _kGooglePlex,
      markers: Set.of(_markers),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
    return PopScope(
      canPop: _place == null,
      onPopInvoked: (didPop) {
        if (!didPop && _place != null) {
          setState(() {
            _place = null;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          widget.service.title,
        )),
        // backgroundColor: Colors.grey.shade400,
        // extendBodyBehindAppBar: true,
        body:
            // _place != null
            // ? Stack(
            //     children: [
            //       map,
            //       Positioned.fill(
            //           child: Align(
            //         alignment: Alignment.bottomCenter,
            //         child: Card(
            //           elevation: 12,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(16)),
            //           margin: const EdgeInsets.all(20),
            //           child: Padding(
            //             padding: const EdgeInsets.all(20.0),
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 PlaceListItem(
            //                   place: _place!,
            //                   imageHeight: 120,
            //                   padding:
            //                       const EdgeInsets.symmetric(horizontal: 0),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.only(top: 10),
            //                   child: Text(_place!.about??""),
            //                 ),
            //                 IconItem(place: _place!)
            //               ],
            //             ),
            //           ),
            //         ),
            //       ))
            //     ],
            //   )
            // :
            // Stack(
            //         children: [
            //           map,
            //           Positioned.fill(
            //               child: Align(
            //             alignment: Alignment.bottomCenter,
            //             child: Padding(
            //               padding: const EdgeInsets.only(top: 140),
            //               child: Card(
            //                 elevation: 7,
            //                 shape: const RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.vertical(
            //                   top: Radius.circular(20),
            //                 )),
            //                 child:
            SingleChildScrollView(
            child: Column(
              children: [
                // returnQuisines(),
                returnSubCategories(),
                isLoading
                    ? Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 50),
                            child: const CircularProgressIndicator(
                              color: primaryColor,
                            )
                        ),
                      )
                    : _filteredPlaces.isEmpty
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            height: 300,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // const SizedBox(
                                //   height: 100,
                                // ),
                                Image.asset(
                                  AssetUtls.emptyLogo,
                                  height: 70,
                                ),

                                const Text(
                                  "There is no listing in this category!",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return PlaceListItem(
                                category: widget.service.title,
                                place: _filteredPlaces[index],
                                callback: () {
                                  setState(() {
                                    _place = _filteredPlaces[index];
                                    if (_place?.venueCoordinates != null &&
                                        _controller != null) {
                                      _controller!.animateCamera(
                                          CameraUpdate.newLatLngZoom(
                                              _place!.venueCoordinates!,
                                              15.4746));
                                      _markers = [
                                        Marker(
                                            markerId: MarkerId(unique),
                                            position: _place!.venueCoordinates!)
                                      ];
                                    }
                                    push(PlaceDetailScreen(
                                      place: _filteredPlaces[index],
                                    ));
                                  });
                                },
                              );
                            },
                            itemCount: _filteredPlaces.length,
                          ),
              ],
            ),
          ),
      ),
      // ),
      //     ))
      //   ],
      // ),
      // ),
    );
  }

  Widget returnQuisines() {
    if (widget.service.id == "5") {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(cuisines.length, (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  // Update the selected index
                  selectedIndex = index;
                });
                reload();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? primaryColor
                        : Colors.white, // Change color based on selected index
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cuisines[index].cuisineName ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                      color:
                          selectedIndex == index ? Colors.white : primaryColor,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }
    return Container();
  }

  Widget returnSubCategories() {
    // var subCat = widget.service.subCategories;
    if (subCat.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: subCat
                    .map((e) => Column(
                          children: [
                            Material(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1000)),
                                color: isDarkTheme(context)
                                    ? semiBlack
                                    : Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                child: InkWell(
                                  onTap: () {
                                    push(ServiceDetailScreen(service: e));
                                    // reloadData(e.categoryId);
                                    // setState(() {
                                    //   widget.service.title = e.categoryName;
                                    // });
                                    // if (e.id == null) {
                                    //   showCategoryModal();
                                    // } else {
                                    //   handleCategory(e);
                                    // }
                                    // push(EventsScreen(id: e.categoryId));
                                  },
                                  child: SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image(
                                        image: CachedNetworkImageProvider(e.image) as ImageProvider,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 10),
                              child: Text(
                                e.title.length <= 13
                                    ? e.title
                                    : "${e.title.substring(0, 12)}...",
                                style: TextStyle(
                                    color: isDarkTheme(context)
                                        ? null
                                        : textsColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
              if (widget.service.id == '64')
                Row(
                  children: [
                    Column(
                      children: [
                        Material(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000)),
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            child: InkWell(
                              onTap: () {
                                push(const BusinessDirectoriesScreen());
                              },
                              child: SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(AssetUtls.business,
                                        // image: (
                                        //     CachedNetworkImageProvider(
                                        //     businesses[0].image)
                                        // ) as ImageProvider,
                                        fit: BoxFit.fitHeight),
                                  )),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 10),
                          child: Text(
                            businesses[0].title.length <= 13
                                ? businesses[0].title
                                : "${businesses[0].title.substring(0, 12)}...",
                            style: TextStyle(
                                color: textsColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Material(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000)),
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            child: InkWell(
                              onTap: () {
                                push(TechBusinessesAppScreen());
                              },
                              child: SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(AssetUtls.techBusinesses,
                                        // image: (
                                        //     CachedNetworkImageProvider(
                                        //     businesses[0].image)
                                        // ) as ImageProvider,
                                        fit: BoxFit.fitHeight),
                                  )),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 10),
                          child: Text(
                            businesses[1].title.length <= 13
                                ? businesses[1].title
                                : "${businesses[1].title.substring(0, 12)}...",
                            style: TextStyle(
                                color: textsColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Material(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000)),
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                            child: InkWell(
                              onTap: () {
                                push(WebMobileAppScreen());
                              },
                              child: SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(AssetUtls.webMobileApps,
                                        // image: (
                                        //     CachedNetworkImageProvider(
                                        //     businesses[0].image)
                                        // ) as ImageProvider,
                                        fit: BoxFit.fitHeight),
                                  )),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 10),
                          child: Text(
                            businesses[2].title.length <= 13
                                ? businesses[2].title
                                : "${businesses[2].title.substring(0, 12)}...",
                            style: TextStyle(
                                color: textsColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ])),
      );
    }
    return Container();
  }
}
