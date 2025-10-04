import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/venue.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/partial/share_icon.dart';
import 'package:zoea1/rooms_screen.dart';
import 'package:zoea1/search_field.dart';
import 'package:zoea1/super_base.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoea1/ults/functions.dart';

import 'constants/apik.dart';
import 'services/api_key_manager.dart';
import 'json/image.dart';
import 'json/room.dart';
import 'json/user.dart';
import 'partial/place_grid_item.dart';

class HotelDetailsScreenV2 extends StatefulWidget {
  final String venueId;
  final FilterOption? filterOption;
  const HotelDetailsScreenV2(
      {super.key, required this.venueId, this.filterOption});

  @override
  State<HotelDetailsScreenV2> createState() => _HotelDetailsScreenV2State();
}

class _HotelDetailsScreenV2State extends Superbase<HotelDetailsScreenV2> {
  bool _loading = false;
  List<GalleryItem> gallery = [];
  List<FacilityCategory> facilities = [];
  List<Room> rooms = [];
  bool isFavorite = false;
  double lati = 0;
  double longi = 0;
  late CameraPosition position;
  Completer<GoogleMapController> _controller = Completer();
  String prulars(int value) {
    if (value == 1) {
      return "";
    }
    return "s";
  }

  VenueDetail hotel = VenueDetail(
      venueId: '0',
      venueName: '',
      venueAbout: '',
      venuePrice: '0',
      venuePhone: '',
      venueCode: '',
      venueEmail: '',
      venueWebsite: '',
      venueImage: '',
      venueRating: '0',
      venueReviews: '0',
      venueAddress: '0.0,0.0',
      venueCoordinates: '',
      services: '',
      workingHours: '',
      categoryName: '',
      categoryDescription: '',
      isFavorite: 0,
      venuePolicy: '',
      cancellationPolicy: '',
      rooms: [],
      gallery: [],
      facilities: []);
  @override
  void initState() {
    position = const CameraPosition(
      target: LatLng(0.0, 0.0), // Default coordinates
      zoom: 15.0,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      loadInfo();
    });
    super.initState();
  }

  Future<void> loadInfo() async {
    setState(() {
      _loading = true;
    });
    await ajax(
        url: "${baseUrll}hotels/details?venue_id=${widget.venueId}",
        absolutePath: true,
        // data:FormData.fromMap({
        //   "venue_id":widget.venueId
        // }),
        onValue: (obj, url) {
          // print('running ${obj['code']}');
          // print('-----------');
          // print(obj['venues']);
          // print('-----------');
          if (obj['code'] == 200) {
            setState(() {
              hotel = VenueDetail.fromJson(obj['venues']);
              print("Venue details");
              print(obj['venues']['rooms']);
              // Handle null case for rooms
              final roomsData = obj['venues']['rooms'] as Iterable?;
              rooms = roomsData?.map((e) => Room.fromJson(e)).toList() ?? [];

              // Handle null case for gallery
              final galleryData = obj['venues']['gallery'] as Iterable?;
              gallery =
                  galleryData?.map((e) => GalleryItem.fromJson(e)).toList() ??
                      [];

              // Handle null case for facilities
              final facilitiesData = obj['venues']['facilities'] as Iterable?;
              facilities = facilitiesData
                      ?.map((e) => FacilityCategory.fromJson(e))
                      .toList() ??
                  [];

              final venueAddress = obj['venues']['venue_coordinates'];
              if (venueAddress != null && venueAddress.isNotEmpty) {
                final coordinates = venueAddress.split(',');
                if (coordinates.length == 2) {
                  try {
                    position = CameraPosition(
                      target: LatLng(
                        double.parse(coordinates[0]),
                        double.parse(coordinates[1]),
                      ),
                      zoom: 12,
                    );
                  } catch (e) {
                    print("Error parsing coordinates: $e");
                  }
                } else {
                  print("Invalid coordinates format: $venueAddress");
                }
              } else {
                print("Venue address is null or empty");
              }
            });
          }
        });
    setState(() {
      _loading = false;
    });
  }

  bool _showText = false;
  bool _showCancelationPolicy = false;
  bool _showVenuePolicy = false;
  bool allFacilities = false;

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(fontSize: 16, height: 1.6);
    final span = TextSpan(text: hotel.venueAbout, style: style);
    final tp =
        TextPainter(text: span, maxLines: 10, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width);
    var limit = 6;
    var length = gallery.length > limit ? limit : gallery.length;
    Widget textWidget(String text, bool visibility) => Text(
          text,
          maxLines: visibility ? null : 5,
          overflow: visibility ? TextOverflow.visible : TextOverflow.ellipsis,
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel == null ? '' : hotel!.venueName),
        backgroundColor: Colors.black,
        titleTextStyle: Theme.of(context)
            .appBarTheme
            .titleTextStyle
            ?.copyWith(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: User.user == null
                  ? () => showSnack(authMessage)
                  : () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              )),
          IconButton(
              onPressed: () {
                Share.share("https://zoea.africa/place?venue=${hotel.venueCode}");
              },
              icon: Icon(shareIcon())),
        ],
      ),
      // backgroundColor: const Color(0xffF5F5F5),
      body: _loading
          ? const LinearProgressIndicator()
          : ListView(
              children: [
                length <= 0
                    ? SizedBox(
                        height: 215,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _loading
                                ? const CupertinoActivityIndicator()
                                : const SizedBox.shrink(),
                            const Text("No images available"),
                          ],
                        )))
                    : GridView.custom(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            const QuiltedGridTile(1, 1),
                            const QuiltedGridTile(1, 1),
                            const QuiltedGridTile(1, 2),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var image = gallery[index].url;

                            var container = Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(image),
                                      fit: BoxFit.cover)),
                            );
                            if (length - 1 == index) {
                              return InkWell(
                                onTap: () {
                                  push(
                                      Scaffold(
                                        appBar: AppBar(
                                          title: const Text("View Images"),
                                        ),
                                        body: PageView.builder(
                                          itemBuilder: (context, index) {
                                            return Image(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        gallery[index].url));
                                          },
                                          itemCount: gallery.length,
                                        ),
                                      ),
                                      fullscreenDialog: true);
                                },
                                child: Stack(
                                  children: [
                                    container,
                                    Positioned.fill(
                                        child: Container(
                                      color: Colors.black54,
                                      child: Center(
                                        child: Text(
                                          "+${gallery.length - 1}",
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                                  ],
                                ),
                              );
                            }
                            return container;
                          },
                          childCount: length,
                        ),
                      ),
                hotel.facilities.isNotEmpty
                    ? Card(
                  color:isDarkTheme(context)?semiBlack: Colors.white,
                  elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: hotel.facilities
                                .map((e) => SizedBox(
                                      width: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                                horizontal: 8)
                                            .copyWith(bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              child: CachedNetworkImage(
                                                imageUrl: e.categoryIcon,
                                                height: 20,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                e.categoryName,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                    color:isDarkTheme(context)?semiBlack: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(top: 0.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  hotel.venueName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: 40,
                          //   width: 40,
                          //   decoration: BoxDecoration(
                          //       color: Theme.of(context).primaryColor,
                          //       borderRadius: BorderRadius.circular(5)),
                          //   child: Center(
                          //       child: Text(
                          //     hotel.venueReviews.toString(),
                          //     style: TextStyle(
                          //         color: isDarkTheme(context)
                          //             ? Colors.black
                          //             : Colors.white,
                          //         fontSize: 16),
                          //   )),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.filterOption != null)
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      color:isDarkTheme(context)?semiBlack: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.only(top: 0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Check-in",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          "${widget.filterOption!.timeRange.start}"
                                              .substring(0, 10),
                                          style: const TextStyle(
                                              // color: primaryColor,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 1,
                                        color: Colors.black12,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            "Check-out",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "${widget.filterOption!.timeRange.end}"
                                                  .substring(0, 10),
                                              style: const TextStyle(
                                                  // color: primaryColor,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Rooms and guests",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${widget.filterOption!.roomOption.rooms} room${prulars(widget.filterOption!.roomOption.rooms)} . ${widget.filterOption!.roomOption.adults} Adult${prulars(widget.filterOption!.roomOption.adults)} . ${widget.filterOption!.roomOption.children >= 1 ? '${widget.filterOption!.roomOption.children} Children' : 'No children'}",
                                  style: const TextStyle(
                                      // color: primaryColor,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: InkWell(
                    onTap: () {
                      String googleUrl =
                          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(hotel.venueAddress ?? hotel.venueName)}';
                      launchUrlString(googleUrl);
                    },
                    child: Card(
                      color:isDarkTheme(context)?semiBlack: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.only(top: 0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                const Icon(Icons.location_pin),
                                Flexible(
                                  child: Text(
                                    "${hotel.venueCoordinates}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                    color:isDarkTheme(context)?semiBlack: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(top: 0.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10)
                              .copyWith(top: 15),
                          child: const Text(
                            "Most popular facilities",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: 8,
                          children: hotel.facilities
                              .take(allFacilities ? facilities.length : 5)
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 8)
                                        .copyWith(bottom: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.white,
                                          child: CachedNetworkImage(
                                            imageUrl: e.categoryIcon,
                                            height: 15,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Text(
                                            e.categoryName,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                allFacilities = !allFacilities;
                              });
                            },
                            child: Text(
                              allFacilities ? "See less" : "See all facilities",
                              // style: TextStyle(color: isDarkTheme(context)?Colors.white:Colors.black),
                            ))
                      ],
                    ),
                  ),
                ),
                if (hotel.venueAbout != "")
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(top: 0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15)
                                .copyWith(top: 15),
                            child: const Text(
                              "Description",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(15.0).copyWith(top: 10),
                            child: tp.didExceedMaxLines
                                ? Wrap(
                                    children: [
                                      textWidget(hotel.venueAbout, _showText),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _showText = !_showText;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "See ${_showText ? "less" : "more"}",
                                            style: const TextStyle(
                                                color: primaryColor,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Text(hotel.venueAbout),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (hotel.venuePolicy != "")
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      color:isDarkTheme(context)?semiBlack: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.only(top: 0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15)
                                .copyWith(top: 15),
                            child: const Text(
                              "Venue Policy",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(15.0).copyWith(top: 10),
                            child: tp.didExceedMaxLines
                                ? Wrap(
                                    children: [
                                      textWidget(
                                          hotel.venuePolicy, _showVenuePolicy),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _showVenuePolicy =
                                                !_showVenuePolicy;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "See ${_showVenuePolicy ? "less" : "more"}",
                                            style: const TextStyle(
                                                color: primaryColor,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Text(hotel.venuePolicy),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (hotel.cancellationPolicy != "")
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      color:isDarkTheme(context)?semiBlack: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.only(top: 0.2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15)
                                .copyWith(top: 15),
                            child: Text("Cancellation Policy",
                                style: TextStyle(
                                    fontWeight: isDarkTheme(context)
                                        ? FontWeight.bold
                                        : null)
                                // Theme.of(context)
                                //     .appBarTheme
                                //     .titleTextStyle
                                //     ?.copyWith(fontSize: 16,),
                                ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(15.0).copyWith(top: 10),
                            child: tp.didExceedMaxLines
                                ? Wrap(
                                    children: [
                                      textWidget(hotel.cancellationPolicy,
                                          _showCancelationPolicy),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _showCancelationPolicy =
                                                !_showCancelationPolicy;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            "See ${_showCancelationPolicy ? "less" : "more"}",
                                            style: TextStyle(
                                                // color: primaryColor,
                                                fontWeight: isDarkTheme(context)
                                                    ? FontWeight.bold
                                                    : null,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Text(hotel.cancellationPolicy),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Container(
                //   margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                //   child: Card(
                //     elevation: 0,
                //     margin: const EdgeInsets.only(top: 0.2),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5)),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 15)
                //               .copyWith(top: 15),
                //           child: Text(
                //             "Property Policy",
                //             style: Theme.of(context)
                //                 .appBarTheme
                //                 .titleTextStyle!
                //                 .copyWith(fontSize: 16),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(15.0).copyWith(top: 10),
                //           child: tp.didExceedMaxLines
                //               ? Wrap(
                //                   children: [
                //                     textWidget("${hotel.venuePolicy}",
                //                         _showVenuePolicy),
                //                     InkWell(
                //                       onTap: () {
                //                         setState(() {
                //                           _showVenuePolicy = !_showVenuePolicy;
                //                         });
                //                       },
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(3.0),
                //                         child: Text(
                //                           "See ${_showVenuePolicy ? "less" : "more"}",
                //                           style: const TextStyle(
                //                               color: primaryColor,
                //                               decoration:
                //                                   TextDecoration.underline),
                //                         ),
                //                       ),
                //                     )
                //                   ],
                //                 )
                //               : Text("${hotel.venuePolicy}"),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Container(
                //   margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                //   child: Card(
                //     elevation: 0,
                //     margin: const EdgeInsets.only(top: 0.2),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5)),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 15)
                //               .copyWith(top: 15),
                //           child: Text(
                //             "Cancellation Policy",
                //             style: Theme.of(context)
                //                 .appBarTheme
                //                 .titleTextStyle!
                //                 .copyWith(fontSize: 16),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.all(15.0).copyWith(top: 10),
                //           child: tp.didExceedMaxLines
                //               ? Wrap(
                //                   children: [
                //                     textWidget("${hotel.cancellationPolicy}",
                //                         _showCancelationPolicy),
                //                     InkWell(
                //                       onTap: () {
                //                         setState(() {
                //                           _showCancelationPolicy =
                //                               !_showCancelationPolicy;
                //                         });
                //                       },
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(3.0),
                //                         child: Text(
                //                           "See ${_showCancelationPolicy ? "less" : "more"}",
                //                           style: const TextStyle(
                //                               color: primaryColor,
                //                               decoration:
                //                                   TextDecoration.underline),
                //                         ),
                //                       ),
                //                     )
                //                   ],
                //                 )
                //               : Text("${hotel.cancellationPolicy}"),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ElevatedButton(
            onPressed: () {
              push(RoomsScreen(
                hotel: hotel,
                filterOption: widget.filterOption,
              ));
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: const Text(
              "See Rooms",
              style: TextStyle(color: Colors.white),
            )),
      )),
    );
  }
}

// Card(
//   margin: const EdgeInsets.only(top: 20),
//   shape: const RoundedRectangleBorder(),
//   child: Padding(
//     padding: const EdgeInsets.all(15.0),
//     child: Row(
//       children: [
//         const Icon(Icons.heart_broken_rounded,size: 40,),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   "Health & hygiene",
//                   style: Theme.of(context).appBarTheme.titleTextStyle,
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Text("This property has taken extra measures to ensure that your safety is their priority",style: TextStyle(
//                     fontSize: 15
//                   ),),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

// GridView.custom(
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         gridDelegate: SliverQuiltedGridDelegate(
//           crossAxisCount: 4,
//           mainAxisSpacing: 4,
//           crossAxisSpacing: 4,
//           repeatPattern: QuiltedGridRepeatPattern.inverted,
//           pattern: [
//             const QuiltedGridTile(1, 1),
//             const QuiltedGridTile(1, 1),
//             const QuiltedGridTile(1, 2),
//           ],
//         ),
//         childrenDelegate: SliverChildBuilderDelegate(
//           (context, index) {
//             var image = gallery[index].url;
//
//             var container = Container(
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: CachedNetworkImageProvider(image),
//                       fit: BoxFit.cover)),
//             );
//             if (length - 1 == index) {
//               return InkWell(
//                 onTap: () {
//                   push(
//                       Scaffold(
//                         appBar: AppBar(
//                           title: const Text("View Images"),
//                         ),
//                         body: PageView.builder(
//                           itemBuilder: (context, index) {
//                             return Image(
//                                 image:
//                                     CachedNetworkImageProvider(
//                                         gallery[index].url));
//                           },
//                           itemCount: gallery.length,
//                         ),
//                       ),
//                       fullscreenDialog: true);
//                 },
//                 child: Stack(
//                   children: [
//                     container,
//                     Positioned.fill(
//                         child: Container(
//                       color: Colors.black54,
//                       child: Center(
//                         child: Text(
//                           "+${gallery.length - 1}",
//                           style: const TextStyle(
//                               fontSize: 30,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ))
//                   ],
//                 ),
//               );
//             }
//             return container;
//           },
//           childCount: length,
//         ),
//       ),
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Row(
//     children: [
//       Expanded(
//           child: Row(
//         children: List.generate(
//             5,
//             (index) => Icon(
//                   index < num.parse(hotel.venueRating)
//                       ? Icons.star
//                       : Icons.star_border,
//                   size: 40,
//                   color: Colors.amber,
//                 )),
//       )),
//       // Chip(
//       //   label: Text(
//       //     "${hotel.venueRating}",
//       //     style: const TextStyle(color: Colors.white),
//       //   ),
//       //   backgroundColor: Colors.blue,
//       // )
//     ],
//   ),
// ),

// IconButton(
//     onPressed: (){},
//     icon: hotel.adding
//         ? const CupertinoActivityIndicator()
//         : Icon(
//       hotel.isFavorite==1
//           ? Icons.favorite
//           : Icons.favorite_border,
//       color: hotel.isFavorite==1
//           ? Colors.red
//           : null,
//     ));
// Padding(
//   padding: const EdgeInsets.only(top: 4),
//   child: Row(
//     children: List.generate(
//         5,
//         (index) => Icon(
//               index <
//                       num.parse(
//                           hotel.venueRating)
//                   ? Icons.star
//                   : Icons.star_border,
//               color: Colors.amber,
//             )),
//   ),
// ),

// Card(
//   elevation: 0,
//   margin: const EdgeInsets.only(top: 0.2),
//   shape: const RoundedRectangleBorder(),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//       SizedBox(
//         height: 200,
//         child: position != null
//             ? GoogleMap(
//           mapType: MapType.terrain,
//           initialCameraPosition: const CameraPosition(
//             target: LatLng(-1.9444863, 30.0248056), // New York City, USA
//             zoom: 12,
//           ),
//           onMapCreated: (GoogleMapController controller) {
//             _controller.complete(controller);
//           },
//           markers: Set<Marker>.of([
//             Marker(
//               markerId: const MarkerId("hotel_location"),
//               position: LatLng(-1.9444863, 30.0248056), // New York City, USA
//               infoWindow: const InfoWindow(
//                 title: "Hotel Location",
//               ),
//             ),
//           ]),
//         )
//             : const Center(
//           child: Text("Error loading map"),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.all(15.0),
//         child: Row(
//           children: [
//             Icon(Icons.location_pin),
//             Text(
//               hotel.venueCoordinates, // Display the address here
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//       )
//     ],
//   ),
// ),

// widget.filterOption == null ? const SizedBox.shrink() : Card(
//   margin: const EdgeInsets.only(top: 20),
//   shape: const RoundedRectangleBorder(),
//   child: Padding(
//     padding: const EdgeInsets.all(15.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Row(
//           children: [
//             Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text("Check-in",style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18
//                 ),),
//                 Text(fmtDate(widget.filterOption?.timeRange.start,format: "EEE, dd MMM"))
//               ],
//             )),
//             Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text("Check-out",style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18
//                 ),),
//                 Text(fmtDate(widget.filterOption?.timeRange.end,format: "EEE, dd MMM"))
//               ],
//             )),
//           ],
//         ),
//         const Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Text("Rooms & Guests",style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18
//           ),),
//         ),
//         Text("${widget.filterOption?.roomOption.rooms} room | ${widget.filterOption?.roomOption.adults} adults | ${widget.filterOption?.roomOption.children} Children")
//       ],
//     ),
//   ),
// ),
// Card(
//   margin: const EdgeInsets.only(top: 20),
//   shape: const RoundedRectangleBorder(),
//   child: Padding(
//     padding: const EdgeInsets.all(15.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text("Price for 1 Night  (${fmtDate(widget.filterOption?.timeRange.start,format: "dd MMM")} - ${fmtDate(widget.filterOption?.timeRange.end,format: "dd MMM")})",style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18
//         ),),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 6),
//           child: Text("US\$ ${fmtNbr(widget.hotel.minPrice)}",style: const TextStyle(
//             color: Color(0xffD30808),
//             fontSize: 21
//           ),),
//         ),
//         Text("+ US\$ ${fmtNbr(widget.hotel.minPrice*5/100)} Taxes & Charges"),
//       ],
//     ),
//   ),
// ),

// void changeFavorite(VenueDetail place) async {
//   if (place.adding) {
//     return;
//   }
//
//   setState(() {
//     place.adding = true;
//   });
//   await ajax(
//       url: "others/favorites",
//       method: "POST",
//       data: FormData.fromMap({
//         "venue_id": place.venueId,
//         "action": place.isFavorite ? "remove" : "add"
//       }),
//       onValue: (obj, url) {
//         if (obj['code'] == 200) {
//           setState(() {
//             place.favorite = !place.favorite;
//           });
//         }
//       });
//   setState(() {
//     place.adding = false;
//   });
// }

// print("Hello Option: ${widget.venueId}");
// var text = hotel!.categoryDescription;
// CameraPosition position = CameraPosition(
//   target: widget.hotel.latLng ?? const LatLng(-1.9546312, 30.0904827),
//   zoom: 15.4746,
// );

// SizedBox(
//   height: 200,
//   child: position != null
//       ? GoogleMap(
//           mapType: MapType.terrain,
//           initialCameraPosition: position!,
//           onMapCreated: (GoogleMapController controller) {
//             _controller.complete(controller);
//           },
//           markers: Set<Marker>.of([
//             Marker(
//               markerId: const MarkerId("hotel_location"),
//               position: position!
//                   .target, // Use position!.target
//               infoWindow: const InfoWindow(
//                 title: "Hotel Location",
//               ),
//             ),
//           ]),
//         )
//       : const Center(
//           child: Text("Error loading map"),
//         ),
// ),
