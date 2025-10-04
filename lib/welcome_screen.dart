import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoea1/authentication.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/conversation_screen.dart';
import 'package:zoea1/events_screen.dart';
import 'package:zoea1/favorites_screen.dart';
import 'package:zoea1/homepage.dart';
import 'package:zoea1/hotel_list_view.dart';
import 'package:zoea1/hotels_screen.dart';
import 'package:zoea1/json/calendar.dart';
import 'package:zoea1/merchant_screen.dart';
import 'package:zoea1/notification_screen.dart';
import 'package:zoea1/partial/breaking_events_card.dart';
import 'package:zoea1/partial/restaurents_item.dart';
import 'package:zoea1/place_collection_search.dart';
import 'package:zoea1/place_detail_screen.dart';
import 'package:zoea1/search_delegate.dart';
import 'package:zoea1/search_field.dart';
import 'package:zoea1/service_detail_screen.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'constants/apik.dart';
import 'services/api_key_manager.dart';
import 'feedback_bottom_dialog.dart';
import 'json/event.dart';
import 'json/place.dart';
import 'json/service.dart';
import 'json/user.dart';
import 'json/venue.dart';
import 'partial/hotels_item.dart';
import 'partial/skeleton_loader.dart';
import 'place_collection.dart';
import 'real_estate_search.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends Superbase<WelcomeScreen> {
  final _key = GlobalKey<RefreshIndicatorState>();
  List<Venue> _hotels = [];
  int _notifications = 0;
  List<Event> _events = [];
  List<Event> _featuredEvents = [];
  List<CalendarDay> calendar = [];
  List<Event> breakingEvents = [];
  List<Place> _restaurants = [];
  List<Place> _activities = [];
  List<Place> _sponsored = [];
  
  // Loading states
  bool _isLoadingHotels = true;
  bool _isLoadingEvents = true;
  bool _isLoadingFeaturedEvents = true;
  bool _isLoadingRestaurants = true;
  bool _isLoadingActivities = true;
  bool _isLoadingCategories = true;
  bool _isLoadingSponsored = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // kwitizinaSnack(context);
      reload();
      loadCategories(fromHome: true);
      loadHotels();
      loadRestaurents();
      featuredEvents();
      loadActivities();
      loadSponsored();
      checkLogin();
    });
  }

  bool isLogged = false;
  void checkLogin() async {
    var string = (await prefs).getString(userKey);
    if (string != null) {
      if (mounted) {
        User.user = User.fromJson(jsonDecode(string));
        // push(const Homepage(), replace: true);
        setState(() {
          isLogged = true;
        });
      }
    } else if (mounted) {
      // push(const Authentication(), replace: true);
    }
  }

  void showFeebackModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => const FeedbackBottomDialog());
  }

  Future<void> loadEvents() {
    setState(() {
      _isLoadingEvents = true;
    });
    
    return ajax(
        url: "${baseUrll}events/",
        absolutePath: true,
        onValue: (object, url) {
          // print("Events ${object['events']}");
          if (object != null && mounted) {
            setState(() {
              _events = (object['events'] as Iterable?)
                  ?.skip(4)
                  .map((e) => Event.fromJson(e))
                  .toList() ?? [];
              breakingEvents = (object['events'] as Iterable?)
                  ?.take(4)
                  .map((e) => Event.fromJson(e))
                  .toList() ?? [];
              calendar = (object['calendar'] as Iterable?)
                  ?.map((e) => CalendarDay.fromJson(e))
                  .toList() ?? [];
              _isLoadingEvents = false;
            });
          }
        },
        error: (error, url) {
          print("Error loading events: $error");
          if (mounted) {
            setState(() {
              _events = [];
              breakingEvents = [];
              calendar = [];
              _isLoadingEvents = false;
            });
          }
        });
  }

  Future<void> featuredEvents() {
    setState(() {
      _isLoadingFeaturedEvents = true;
    });
    
    return ajax(
        url: "${baseUrll}events/featured",
        absolutePath: true,
        onValue: (object, url) {
          print("Featured Events ${object}");
          setState(() {
            _featuredEvents = (object['events'] as Iterable)
                .map((e) => Event.fromJson(e))
                .toList();
            _isLoadingFeaturedEvents = false;
          });
        });
  }

  void reload() {
    _key.currentState?.show();
  }

  Future<void> loadCategories({bool fromHome = false}) {
    setState(() {
      _isLoadingCategories = true;
    });
    
    return ajax(
        url: "categories/",
        method: "POST",
        onValue: (obj, url) {
          // print("Categories ${obj['categories']}");
          setState(() {
            _services = (obj['categories'] as Iterable?)
                    ?.map((e) => Service.fromJson(e))
                    .toList() ??
                [];
            _isLoadingCategories = false;
            // _services = (obj['categories'] as Iterable?)
            //         ?.map((e) => EventCategory.fromJson(e))
            //         .toList() ??
            //     [];
            // if (fromHome) {
            //   showCategoryModal();
            // }
          });
        });
  }

  Future<void> loadData() {
    loadEvents();
    return ajax(
        url: "home/",
        method: "POST",
        onValue: (obj, url) {
          // print("Notifications ${obj['data']['unseen_notifications']}");
          if (obj != null && obj['data'] != null && mounted) {
            setState(() {
              _notifications = obj['data']['unseen_notifications'] ?? 0;
              // _featured = (obj['data']['featured'] as Iterable?)
              //         ?.map((e) => Place.fromJson(e))
              //         .toList() ??
              //     [];
              // _budget = (obj['data']['On_Budget_Tour'] as Iterable?)
              //         ?.map((e) => Place.fromJson(e))
              //         .toList() ??
              //     [];
              // _travels = (obj['data']['travel_tours'] as Iterable?)
              //         ?.map((e) => Place.fromJson(e))
              //         .toList() ??
              //     [];
              // print(_featured.length);
            });
          }
        },
        error: (error, url) {
          print("Error loading home data: $error");
          if (mounted) {
            setState(() {
              _notifications = 0;
            });
          }
        });
  }

  Future<void> loadRestaurents() {
    setState(() {
      _isLoadingRestaurants = true;
    });
    
    return ajax(
        url: "categories/venues",
        method: "POST",
        data: FormData.fromMap({"category_id": '5'}),
        onValue: (object, url) {
          // print("Venues ${object['venues']}");
          setState(() {
            _restaurants = (object['venues'] as Iterable?)
                    ?.map((e) => Place.fromJson(e))
                    .toList() ??
                [];
            _isLoadingRestaurants = false;
          });
        });
  }

  Future<void> loadActivities() {
    setState(() {
      _isLoadingActivities = true;
    });
    
    return ajax(
        url: "categories/venues",
        method: "POST",
        data: FormData.fromMap({"category_id": '78'}),
        onValue: (object, url) {
          // print("Venues ${object['venues']}");
          setState(() {
            _activities = (object['venues'] as Iterable?)
                    ?.map((e) => Place.fromJson(e))
                    .toList() ??
                [];
            _isLoadingActivities = false;
          });
        });
  }

  Future<void> loadSponsored() {
    setState(() {
      _isLoadingSponsored = true;
    });
    
    return ajax(
        url: "venues/sponsored",
        method: "GET",
        onValue: (object, url) {
          setState(() {
            _sponsored = (object['venues'] as Iterable?)
                    ?.map((e) => Place.fromJson(e))
                    .toList() ??
                [];
            _isLoadingSponsored = false;
          });
        });
  }

  // List<EventCategory> _services = [];
  List<Service> _services = [];

  Future<void> loadHotels() async {
    setState(() {
      _isLoadingHotels = true;
    });
    
    // Use current dates instead of hardcoded ones
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));
    final checkIn = now.toIso8601String().split('T')[0];
    final checkOut = tomorrow.toIso8601String().split('T')[0];
    
    await ajax(
        url: "${baseUrll}hotels/filter?name=Kigali&priceFrom=20&priceTo=100&checkIn=$checkIn&checkOut=$checkOut&rating=4&rooms=1&adults=1&children=0",
        absolutePath: true,
        onValue: (obj, url) {
          if (obj is Map && obj['venues'] != null && mounted) {
            setState(() {
              _hotels = (obj['venues'] as Iterable?)
                  ?.map((e) => Venue.fromJson(e))
                  .toList() ?? [];
              _isLoadingHotels = false;
            });
          } else {
            setState(() {
              _hotels = [];
              _isLoadingHotels = false;
            });
          }
        },
        error: (error, url) {
          print("Error loading hotels: $error");
          if (mounted) {
            setState(() {
              _hotels = [];
              _isLoadingHotels = false;
            });
          }
        });

    return Future.value();
  }

  void showCategoryModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close)),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Text(
                            "All Services",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).appBarTheme.titleTextStyle,
                          ),
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        var item = _services[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Material(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(1000)),
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  child: InkWell(
                                    onTap: () {},
                                    child: SizedBox(
                                        height: 68,
                                        width: 70,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image(
                                            image: CachedNetworkImageProvider(
                                                item.image
                                                // item.categoryImage
                                                ),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                item.title,
                                // item.categoryName,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: textsColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: _services.length,
                    ),
                  ),
                ],
              ),
            ));
  }

  void handleCategory(Service e) {
    if (e.id == "4") {
      push(const HotelsScreen()).then((value) {
        if (value != null && value is FilterOption) {
          push(HotelListView(
            filterOption: value,
          ));
        }
      });
    } else if (e.id == "6") {
      push(EventsScreen(
        id: e.id,
        catName: e.title,
      ));
    } else if (e.id == "47") {
      push(const RealEstateSearch());
    } else {
      push(ServiceDetailScreen(service: e));
    }
  }

  @override
  Widget build(BuildContext context) {
    var services = _services.take(_services.length).toList();
    // services.add(Service("More", "menu.png"));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 200,
        // backgroundColor: primaryColor,
        leading: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.asset(
                isDarkTheme(context) ? AssetUtls.logoWhite : AssetUtls.logoDark,
                height: 30,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: isDarkTheme(context) ? Colors.white : Colors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchDemoSearchDelegate((query) {
                  return Theme(
                    data: Theme.of(context),
                    child: PlaceCollectionSearch(query: query)
                  );
                }),
              );
            },
          ),
          const SizedBox(width: 10),
          Material(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000)),
            child: InkWell(
              onTap: () {
                push(const NotificationScreen());
              },
              child: Container(
                  color: isDarkTheme(context) ? Colors.black45 : scaffoldColor,
                  height: 36,
                  width: 36,
                  child: Center(
                    child: Stack(
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 20,
                          color: isDarkTheme(context)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // Removed chat button
        ],
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: isDarkTheme(context) ? Colors.white : refleshColor,
        key: _key,
        onRefresh: loadData,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // padding: const EdgeInsets.all(12).copyWith(top: 10),
                children: [
                  // Row(
                  //   children: [
                  //     CircleAvatar(
                  //       backgroundColor: const Color(0xffb4cccc),
                  //       backgroundImage: User.user?.profile != null
                  //           ? CachedNetworkImageProvider(User.user!.profile!)
                  //           : null,
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: const EdgeInsets.only(left: 8),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.stretch,
                  //         children: [
                  //           Text(
                  //             "Hi, ${User.user?.fName ?? ''}",
                  //             style: Theme.of(context).appBarTheme.titleTextStyle,
                  //           ),
                  //           RichText(
                  //               text: const TextSpan(
                  //                   style: TextStyle(color: Color(0xff78828A)),
                  //                   children: [
                  //                 WidgetSpan(
                  //                     child: Icon(
                  //                   Icons.location_on_sharp,
                  //                   color: Color(0xff78828A),
                  //                   size: 14,
                  //                 )),
                  //                 TextSpan(text: "Kigali")
                  //               ])),
                  //         ],
                  //       ),
                  //     )),
                  //     Material(
                  //       clipBehavior: Clip.antiAliasWithSaveLayer,
                  //       shape: RoundedRectangleBorder(
                  //           side: const BorderSide(color: Color(0xffE3E7EC)),
                  //           borderRadius: BorderRadius.circular(1000)),
                  //       child: InkWell(
                  //         onTap: () {
                  //           push(const NotificationScreen());
                  //         },
                  //         child: SizedBox(
                  //             height: 40,
                  //             width: 40,
                  //             child: Center(
                  //               child: Stack(
                  //                 children: [
                  //                   const Icon(
                  //                     Icons.notifications_none,
                  //                     size: 20,
                  //                   ),
                  //                   Positioned(
                  //                       top: 0,
                  //                       right: 0,
                  //                       child: Container(
                  //                         decoration: BoxDecoration(
                  //                             color: _notifications > 0
                  //                                 ? Colors.red
                  //                                 : Theme.of(context).primaryColor,
                  //                             shape: BoxShape.circle),
                  //                         width: 10,
                  //                         height: 10,
                  //                       ))
                  //                 ],
                  //               ),
                  //             )),
                  //       ),
                  //     ),
                  //     // Padding(
                  //     //   padding: const EdgeInsets.only(left: 8),
                  //     //   child: ConversationButton(
                  //     //     voidCallback: () {
                  //     //       // push(const Conversation());
                  //     //     },
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 20),
                  //   child: SearchField(
                  //     homeSearch: true,
                  //   ),
                  // ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                    child: _isLoadingCategories 
                        ? SkeletonLoader.horizontalListSkeleton(
                            itemCount: 6,
                            height: 100,
                            itemBuilder: (context, index) => Container(
                              width: 95,
                              margin: const EdgeInsets.only(right: 5),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 60,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: services
                                  .map((e) => Container(
                                  width: 95,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Column(
                                    children: [
                                      Material(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1000)),
                                          color: Theme.of(context)
                                              .inputDecorationTheme
                                              .fillColor,
                                          child: InkWell(
                                            onTap: () {
                                              if (e.id == null) {
                                                showCategoryModal();
                                              } else {
                                                handleCategory(e);
                                              }
                                              // push(EventsScreen(
                                              //   // catName: e.categoryName,
                                              //   catName: e.title,
                                              //   // id: e.categoryId,
                                              //   id: e.id,
                                              // ));
                                            },
                                            child: SizedBox(
                                                height: 80,
                                                width: 80,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Image(
                                                      image: (e.id == null
                                                              ? AssetImage(
                                                                  "assets/${e.cover}")
                                                              : CachedNetworkImageProvider(
                                                                  e.cover))
                                                          as ImageProvider,
                                                      fit: BoxFit.cover),
                                                )),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 2,
                                        ),
                                        child: Text(
                                          trimm(12, e.title),
                                          style: const TextStyle(
                                              // color: textsColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Text(
                  //         "What's happening?",
                  //         style: Theme.of(context).appBarTheme.titleTextStyle,
                  //       )),
                  //       // Text("More",style: Theme.of(context).appBarTheme.titleTextStyle,),
                  //       // SizedBox(width: 10,),
                  //       // Icon(Icons.arrow_forward_ios,size: 17,color: Colors.black,)
                  //       dashedContainers()
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: SizedBox(
                  //     height:250,
                  //     child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemBuilder: (context, index) {
                  //         var item = _featured[index];
                  //         return Padding(
                  //           padding: const EdgeInsets.only(right: 8),
                  //           child: SizedBox(
                  //             width: 200,
                  //             child: EventGridItem(
                  //               place: item,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //       itemCount: _featured.length,
                  //     ),
                  //   ),
                  // ),
                  // Divider(thickness: 0.3,),
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  //   height: 50,
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: List.generate(
                  //           calendar.length,
                  //           (index) => Column(
                  //                 children: [
                  //                   Text(
                  //                     calendar[index].day,
                  //                     style: TextStyle(fontSize: 15),
                  //                   ),
                  //                   Text(
                  //                     calendar[index].date,
                  //                     style: const TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         fontSize: 19,
                  //                         color: Colors.black),
                  //                   )
                  //                 ],
                  //               ))),
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
                  //   child: Text(
                  //     "Featured Events",
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _isLoadingFeaturedEvents
                        ? SkeletonLoader.carouselSkeleton()
                        : CarouselSlider.builder(
                            itemCount: _featuredEvents.length,
                            itemBuilder: (context, index, id) =>
                                BreakingNewsCard(_featuredEvents[index]),
                            options: CarouselOptions(
                              aspectRatio: 24 / 12,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              autoPlay: true, // Enable auto slide
                              autoPlayInterval: const Duration(
                                  seconds: 3), // Slide transition every 3 seconds
                              autoPlayAnimationDuration: const Duration(
                                  milliseconds: 500), // Half-second animation
                              autoPlayCurve: Curves.easeInOut, // Smooth transition
                            )),
                  ),

                  // Events Section Title
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
                    child: InkWell(
                      onTap: () async {
                        // Navigate to venue detail screen using sponsored venues API
                        await ajax(
                          url: "venues/sponsored",
                          onValue: (obj, url) {
                            if (obj['code'] == 200 && obj['venues'] != null && obj['venues'].isNotEmpty) {
                              // Get the first sponsored venue (Villa Kigali with ID 1111)
                              final venueData = obj['venues'][0];
                              final mustVisitPlace = Place.fromJson({
                                'venue_id': venueData['venue_id'] ?? '1111',
                                'venue_name': venueData['venue_name'] ?? 'Villa Kigali',
                                'location_name': venueData['location_name'] ?? 'Kigali',
                                'venue_about': venueData['venue_about'] ?? 'Villa Kigali is a private, fully serviced luxury villa in the heart of Kigali.',
                                'venue_address': venueData['venue_address'] ?? 'KK 30 Avenue, Kigali, Kicukiro, Rwanda',
                                'services': venueData['services'] ?? '',
                                'category_id': venueData['category_id'] ?? '5',
                                'venue_coordinates': venueData['venue_coordinates'],
                                'venue_image': venueData['venue_image'] ?? 'https://res.cloudinary.com/dhwqnur8s/image/upload/v1754821802/VK_zaay4p.png',
                                'venue_rating': venueData['venue_rating']?.toString() ?? '4',
                                'venue_reviews': venueData['venue_reviews']?.toString() ?? '125',
                                'venue_price': venueData['venue_price']?.toString() ?? '2',
                                'venue_phone': venueData['venue_phone'] ?? '0788777667',
                                'venue_email': venueData['venue_email'] ?? 'info@villakigali.com',
                                'venue_website': venueData['venue_website'] ?? 'https://www.villakigali.com/',
                                'venue_status': venueData['venue_status'] ?? 'active',
                                'is_favorite': venueData['is_favorite'] ?? 0,
                              });
                              push(PlaceDetailScreen(place: mustVisitPlace));
                            } else {
                              // Fallback to hardcoded data if API fails
                              final mustVisitPlace = Place.fromJson({
                                'venue_id': '1111',
                                'venue_name': 'Villa Kigali',
                                'location_name': 'Kigali',
                                'venue_about': 'Villa Kigali is a private, fully serviced luxury villa in the heart of Kigali, offering four ensuite bedrooms, a pool, garden, and tailored services for leisure or business stays.',
                                'venue_address': 'KK 30 Avenue, Kigali, Kicukiro, Rwanda',
                                'services': '',
                                'category_id': '5',
                                'venue_coordinates': '1.9441,30.0619',
                                'venue_image': 'https://zoea.africa/../catalog/venues/689849d00340c_villa kigali (1).jpg',
                                'venue_rating': '4',
                                'venue_reviews': '125',
                                'venue_price': '2',
                                'venue_phone': '0788777667',
                                'venue_email': 'info@villakigali.com',
                                'venue_website': 'https://www.villakigali.com/',
                                'venue_status': 'active',
                                'is_favorite': 0,
                              });
                              push(PlaceDetailScreen(place: mustVisitPlace));
                            }
                          },
                        );
                      },
                      child: Text(
                        "Must Visit",
                        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Events Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            // Navigate to venue detail screen using sponsored venues API
                            await ajax(
                              url: "venues/sponsored",
                              onValue: (obj, url) {
                                if (obj['code'] == 200 && obj['venues'] != null && obj['venues'].isNotEmpty) {
                                  // Get the first sponsored venue (Villa Kigali with ID 1111)
                                  final venueData = obj['venues'][0];
                                  final mustVisitPlace = Place.fromJson({
                                    'venue_id': venueData['venue_id'] ?? '1111',
                                    'venue_name': venueData['venue_name'] ?? 'Villa Kigali',
                                    'location_name': venueData['location_name'] ?? 'Kigali',
                                    'venue_about': venueData['venue_about'] ?? 'Villa Kigali is a private, fully serviced luxury villa in the heart of Kigali.',
                                    'venue_address': venueData['venue_address'] ?? 'KK 30 Avenue, Kigali, Kicukiro, Rwanda',
                                    'services': venueData['services'] ?? '',
                                    'category_id': venueData['category_id'] ?? '5',
                                    'venue_coordinates': venueData['venue_coordinates'],
                                    'venue_image': venueData['venue_image'] ?? 'https://res.cloudinary.com/dhwqnur8s/image/upload/v1754821802/VK_zaay4p.png',
                                    'venue_rating': venueData['venue_rating']?.toString() ?? '4',
                                    'venue_reviews': venueData['venue_reviews']?.toString() ?? '125',
                                    'venue_price': venueData['venue_price']?.toString() ?? '2',
                                    'venue_phone': venueData['venue_phone'] ?? '0788777667',
                                    'venue_email': venueData['venue_email'] ?? 'info@villakigali.com',
                                    'venue_website': venueData['venue_website'] ?? 'https://www.villakigali.com/',
                                    'venue_status': venueData['venue_status'] ?? 'active',
                                    'is_favorite': venueData['is_favorite'] ?? 0,
                                  });
                                  push(PlaceDetailScreen(place: mustVisitPlace));
                                } else {
                                  // Fallback to hardcoded data if API fails
                                  final mustVisitPlace = Place.fromJson({
                                    'venue_id': '1111',
                                    'venue_name': 'Villa Kigali',
                                    'location_name': 'Kigali',
                                    'venue_about': 'Villa Kigali is a private, fully serviced luxury villa in the heart of Kigali, offering four ensuite bedrooms, a pool, garden, and tailored services for leisure or business stays.',
                                    'venue_address': 'KK 30 Avenue, Kigali, Kicukiro, Rwanda',
                                    'services': '',
                                    'category_id': '5',
                                    'venue_coordinates': '1.9441,30.0619',
                                    'venue_image': 'https://zoea.africa/../catalog/venues/689849d00340c_villa kigali (1).jpg',
                                    'venue_rating': '4',
                                    'venue_reviews': '125',
                                    'venue_price': '2',
                                    'venue_phone': '0788777667',
                                    'venue_email': 'info@villakigali.com',
                                    'venue_website': 'https://www.villakigali.com/',
                                    'venue_status': 'active',
                                    'is_favorite': 0,
                                  });
                                  push(PlaceDetailScreen(place: mustVisitPlace));
                                }
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                // Background Image
                                Image.network(
                                  'https://res.cloudinary.com/dhwqnur8s/image/upload/v1754821802/VK_zaay4p.png',
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF9C27B0), // Purple
                                            const Color(0xFF673AB7), // Deep Purple
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),


                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 15),
                  //   child: ListView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //       var item = _featuredEvents[index];
                  //       return EventCard(
                  //         event: item,
                  //         callback: () {
                  //           push(EventDetailsScreen(event: item));
                  //         },
                  //       );
                  //     },
                  //     itemCount: _featuredEvents.length,
                  //   ),
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 10, top: 20),
                  //   child: Text(
                  //     "Upcoming Events",
                  //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 15),
                  //   child: ListView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //       var item = _events[index];
                  //       return EventCard(
                  //         event: item,
                  //         callback: () {
                  //           push(EventDetailsScreen(event: item));
                  //         },
                  //       );
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(vertical: 10),
                  //         child: InkWell(
                  //           onTap: () {
                  //             push(EventDetailsScreen(event: item));
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.symmetric(horizontal: 10),
                  //             child: Row(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Card(
                  //                     shape: RoundedRectangleBorder(
                  //                         borderRadius: BorderRadius.circular(10)),
                  //                     clipBehavior: Clip.antiAliasWithSaveLayer,
                  //                     child: Image(
                  //                       image:
                  //                           CachedNetworkImageProvider(item.poster),
                  //                       height: 100,
                  //                       width: 100,
                  //                       fit: BoxFit.cover,
                  //                     )),
                  //                 Expanded(
                  //                     child: Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.stretch,
                  //                     children: [
                  //                       Text(
                  //                         item.name,
                  //                         style: const TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                             fontSize: 18),
                  //                       ),
                  //                       Padding(
                  //                         padding: const EdgeInsets.symmetric(
                  //                             vertical: 8),
                  //                         child: Text(
                  //                           item.startDate,
                  //                           style: const TextStyle(
                  //                               color: Color(0xffF2A034),
                  //                               fontSize: 17),
                  //                         ),
                  //                       ),
                  //                       RichText(
                  //                           text: TextSpan(
                  //                               style: const TextStyle(
                  //                                   color: Colors.black45),
                  //                               children: [
                  //                             const WidgetSpan(
                  //                                 child: Icon(
                  //                               Icons.location_pin,
                  //                               color: Colors.black45,
                  //                               size: 17,
                  //                             )),
                  //                             TextSpan(text: item.address)
                  //                           ]))
                  //                     ],
                  //                   ),
                  //                 ))
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 3, horizontal: 2),
                  //         margin: const EdgeInsets.symmetric(
                  //             horizontal: 10, vertical: 5),
                  //         decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(5)),
                  //         child: InkWell(
                  //           onTap: () {
                  //             push(EventDetailsScreen(event: item));
                  //           },
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Card(
                  //                   shape: RoundedRectangleBorder(
                  //                       borderRadius: BorderRadius.circular(2)),
                  //                   clipBehavior: Clip.antiAliasWithSaveLayer,
                  //                   child: Image(
                  //                     image:
                  //                         CachedNetworkImageProvider(item.poster),
                  //                     height: 100,
                  //                     width: 100,
                  //                     fit: BoxFit.cover,
                  //                   )),
                  //               Expanded(
                  //                   child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
                  //                   children: [
                  //                     Row(
                  //                       children: [
                  //                         Expanded(
                  //                           child: Text(
                  //                             item.name,
                  //                             style: const TextStyle(
                  //                                 fontWeight: FontWeight.bold,
                  //                                 fontSize: 14),
                  //                           ),
                  //                         ),
                  //                         const Icon(
                  //                           Icons.more_horiz,
                  //                           size: 15,
                  //                         )
                  //                       ],
                  //                     ),
                  //                     Padding(
                  //                       padding:
                  //                           const EdgeInsets.symmetric(vertical: 8),
                  //                       child: Text(
                  //                         "${item.details}",
                  //                       ),
                  //                     ),
                  //                     Padding(
                  //                       padding:
                  //                           const EdgeInsets.symmetric(vertical: 8),
                  //                       child: Text(
                  //                         item.startDate,
                  //                         style: const TextStyle(
                  //                             color: Color(0xffF2A034),
                  //                             fontSize: 17),
                  //                       ),
                  //                     ),
                  //                     RichText(
                  //                         text: TextSpan(
                  //                             style: const TextStyle(
                  //                                 color: Colors.black45),
                  //                             children: [
                  //                           const WidgetSpan(
                  //                               child: Icon(
                  //                             Icons.location_pin,
                  //                             color: Colors.black45,
                  //                             size: 17,
                  //                           )),
                  //                           TextSpan(text: item.address)
                  //                         ]))
                  //                   ],
                  //                 ),
                  //               ))
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     itemCount: _events.length,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Text(
                  //         "Travel & Tours",
                  //         style: Theme.of(context).appBarTheme.titleTextStyle,
                  //       )),
                  //       TextButton(onPressed: () {}, child: const Text("See All")),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 130,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: EdgeInsets.zero,
                  //     itemBuilder: (context, index) {
                  //       return PlaceTourItem(place: _travels[index],);
                  //     },
                  //     itemCount: _travels.length,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Text(
                  //         "On Budget Tour",
                  //         style: Theme.of(context).appBarTheme.titleTextStyle,
                  //       )),
                  //       TextButton(onPressed: () {}, child: const Text("See All")),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 140,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: EdgeInsets.zero,
                  //     itemBuilder: (context, index) {
                  //       var item = _budget[index];
                  //       return PlaceDetailItem(
                  //           place: item);
                  //     },
                  //     itemCount: _budget.length,
                  //   ),
                  // )
                  kwitizinaBanner(context),

                  // Removed greeting section

                  // Sponsored Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Sponsored",
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        )),
                        dashedContainers()
                      ],
                    ),
                  ),

                  Container(
                    height: 280,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: _isLoadingSponsored
                        ? SkeletonLoader.horizontalListSkeleton(
                            itemCount: 4,
                            height: 280,
                            itemBuilder: (context, index) => SkeletonLoader.restaurantCardSkeleton(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 200,
                                margin: EdgeInsets.only(right: 15),
                                child: RestaurantItemCard(
                                  event: _sponsored[index],
                                ),
                              );
                            },
                            itemCount: _sponsored.length,
                          ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Restaurants",
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        )),
                        dashedContainers()
                      ],
                    ),
                  ),

                  Container(
                    height: 250,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: _isLoadingRestaurants
                        ? SkeletonLoader.horizontalListSkeleton(
                            itemCount: 5,
                            height: 250,
                            itemBuilder: (context, index) => SkeletonLoader.restaurantCardSkeleton(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return RestaurantItemCard(
                                // category: "",
                                event: _restaurants[index],
                                // o: () {
                                //   // setState(() {
                                //   //   _place = _filteredPlaces[index];
                                //   //   if (_place?.venueCoordinates != null &&
                                //   //       _controller != null) {
                                //   //     _controller!.animateCamera(
                                //   //         CameraUpdate.newLatLngZoom(
                                //   //             _place!.venueCoordinates!, 15.4746));
                                //   //     _markers = [
                                //   //       Marker(
                                //   //           markerId: MarkerId(unique),
                                //   //           position: _place!.venueCoordinates!)
                                //   //     ];
                                //   //   }
                                //     push(PlaceDetailScreen(
                                //       place: _places[index],
                                //     )
                                //     );
                                //   // });
                                // },
                              );
                            },
                            itemCount: _restaurants.length,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Things to do",
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        )),
                        dashedContainers()
                      ],
                    ),
                  ),

                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: _isLoadingActivities
                        ? SkeletonLoader.horizontalListSkeleton(
                            itemCount: 6,
                            height: 250,
                            itemBuilder: (context, index) => SkeletonLoader.activityCardSkeleton(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return RestaurantItemCard(
                                // category: "",
                                event: _activities[index],
                                // o: () {
                                //   // setState(() {
                                //   //   _place = _filteredPlaces[index];
                                //   //   if (_place?.venueCoordinates != null &&
                                //   //       _controller != null) {
                                //   //     _controller!.animateCamera(
                                //   //         CameraUpdate.newLatLngZoom(
                                //   //             _place!.venueCoordinates!, 15.4746));
                                //   //     _markers = [
                                //   //       Marker(
                                //   //           markerId: MarkerId(unique),
                                //   //           position: _place!.venueCoordinates!)
                                //   //     ];
                                //   //   }
                                //     push(PlaceDetailScreen(
                                //       place: _places[index],
                                //     )
                                //     );
                                //   // });
                                // },
                              );
                            },
                            itemCount: _activities.length,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Accommodation",
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        )),
                        dashedContainers()
                      ],
                    ),
                  ),

                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: _isLoadingHotels
                        ? SkeletonLoader.horizontalListSkeleton(
                            itemCount: 4,
                            height: 250,
                            itemBuilder: (context, index) => SkeletonLoader.hotelCardSkeleton(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // separatorBuilder: (context, index) => const Divider(
                            //   height: 0.5,
                            //   color: Colors.grey,
                            // ),
                            // padding: const EdgeInsets.symmetric(vertical: 10),
                            // physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = _hotels[index];
                              return HotelItemCard(
                                event: item,
                              );
                            },
                            itemCount: _hotels.length,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashedContainers() => Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(left: 7),
            decoration: BoxDecoration(
                color: kGrayLight,
                borderRadius: BorderRadius.circular(1000)),
          ),
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(left: 7),
            decoration: BoxDecoration(
                color: kGrayLight,
                borderRadius: BorderRadius.circular(1000)),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            width: 27,
            height: 10,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(1000)),
          ),
        ],
      );
}
