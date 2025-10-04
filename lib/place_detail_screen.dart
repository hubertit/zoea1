import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoea1/booking_screen2.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/partial/cover_container.dart';
import 'package:zoea1/partial/icon_item.dart';
import 'package:zoea1/super_base.dart';

import 'json/place.dart';
import 'json/review.dart';
import 'partial/share_icon.dart';
import 'ults/functions.dart';
import 'constants/theme.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends Superbase<PlaceDetailScreen> {
  List<Review> _list = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
    super.initState();
  }

  Future<void> loadData() {
    return ajax(
        url: "venues/reviews",
        method: "POST",
        data: FormData.fromMap({
          "venue_id": widget.place.id,
          "limit": 2,
        }),
        onValue: (obj, url) {
          setState(() {
            _list = (obj['venues'] as Iterable?)
                    ?.map((e) => Review.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  // void changeFavorite() async {
  //   if (widget.place.adding) {
  //     return;
  //   }
  //
  //   setState(() {
  //     widget.place.adding = true;
  //   });
  //   await ajax(
  //       url: "others/favorites",
  //       method: "POST",
  //       data: FormData.fromMap({
  //         "venue_id": widget.place.id,
  //         "action": widget.place.favorite ? "remove" : "add"
  //       }),
  //       onValue: (obj, url) {
  //         if (obj['code'] == 200) {
  //           setState(() {
  //             widget.place.favorite = !widget.place.favorite;
  //           });
  //         }
  //       });
  //   setState(() {
  //     widget.place.adding = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //         colors: [
        //       Colors.grey.shade500,
        //       Colors.grey.shade500,
        //       Colors.grey.shade500,
        //       Colors.white,
        //       Colors.white,
        //       Colors.white,
        //     ])),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    image: widget.place.image != null
                        ? DecorationImage(
                            image:
                                CachedNetworkImageProvider(widget.place.image!),
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.repeatY,
                          )
                        : null,
                    // gradient: LinearGradient(
                    //   begin: Alignment.center,
                    //   end: Alignment.bottomCenter,
                    //   colors: [
                    //     Colors.transparent, // Start with transparent color
                    //     Colors.black.withOpacity(0.7), // End with a darker color (adjust opacity as needed)
                    //   ],
                    // ),
                  ),
                ),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent, // Start with transparent color
                        Colors.black.withOpacity(
                            0.7), // End with a darker color (adjust opacity as needed)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      // Back Button with Liquid Effect
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Share Button with Liquid Effect
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Share.share("${widget.place.venueCode}");
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Icon(
                                shareIcon(),
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.place.title,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < widget.place.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: isDarkTheme(context)
                                    ? Colors.white
                                    : Colors.amber,
                                size: 17,
                              ),
                            ),
                          ),
                          Text(
                            "  ${widget.place.number} Reviews",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white70,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.place.currency,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          )
                          // Row(
                          //     children: List.generate(
                          //         widget.place.price.toInt(),
                          //         (index) => ))
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.place.about != null && widget.place.about != '')
              CoverContainer(children: [
                const Text(
                  "About the Place",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("${widget.place.about}")
              ]),
            CoverContainer(children: [
              IconItem(
                place: widget.place,
                fromDetail: true,
              ),
            ])

            // Container(height: MediaQuery.of(context).size.height,
            //   child: Stack(
            //     children: [
            //       Positioned.fill(
            //         child: Scaffold(
            //           backgroundColor: Colors.transparent,
            //           extendBodyBehindAppBar: true,
            //           appBar:PreferredSize(preferredSize: Size.fromHeight(-15),child: Container(color: Colors.black,),),
            //           body: ListView(
            //             children: [
            //               const SizedBox(
            //                 height: 300,
            //               ),
            //               Card(
            //                 elevation: 0,
            //                 margin: EdgeInsets.zero,
            //                 shape: const RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.vertical(
            //                   top: Radius.circular(30),
            //                 )),
            //                 child: Container(
            //                   constraints: const BoxConstraints(minHeight: 600),
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(24.0),
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.stretch,
            //                       children: [
            //                         Row(
            //                           children: [
            //                             Expanded(
            //                               child: Column(
            //                                 crossAxisAlignment:
            //                                     CrossAxisAlignment.stretch,
            //                                 children: [
            //                                   Text(
            //                                     widget.place.title,
            //                                     style: Theme.of(context)
            //                                         .appBarTheme
            //                                         .titleTextStyle
            //                                         ?.copyWith(fontSize: 24),
            //                                   ),
            //                                   Padding(
            //                                     padding:
            //                                         const EdgeInsets.only(top: 5.0),
            //                                     child: Row(
            //                                       children: [
            //                                         RichText(
            //                                             text: TextSpan(children: [
            //                                           WidgetSpan(
            //                                               child: Icon(
            //                                             Icons.location_on_sharp,
            //                                             size: 16,
            //                                             color: smallTextColor,
            //                                           )),
            //                                           TextSpan(
            //                                               text: widget.place.location,
            //                                               style: TextStyle(
            //                                                   color: smallTextColor))
            //                                         ])),
            //                                         const SizedBox(
            //                                           width: 50,
            //                                         ),
            //                                         Icon(
            //                                           Icons.star,
            //                                           color: Colors.yellow.shade600,
            //                                           size: 18,
            //                                         ),
            //                                         Text(
            //                                           "${widget.place.rating}",
            //                                           style: TextStyle(
            //                                               color:
            //                                                   Colors.yellow.shade600),
            //                                         ),
            //                                         Text("(${widget.place.number})")
            //                                       ],
            //                                     ),
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                             IconButton(
            //                                 onPressed: changeFavorite,
            //                                 icon: widget.place.adding
            //                                     ? const CupertinoActivityIndicator()
            //                                     : Icon(
            //                                         widget.place.favorite
            //                                             ? Icons.favorite
            //                                             : Icons.favorite_border,
            //                                         color: widget.place.favorite
            //                                             ? Colors.red
            //                                             : null,
            //                                       ))
            //                           ],
            //                         ),
            //                         widget.place.categoryId == "4"
            //                             ? Padding(
            //                                 padding: const EdgeInsets.only(top: 20),
            //                                 child: Row(
            //                                   crossAxisAlignment:
            //                                       CrossAxisAlignment.start,
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment.spaceBetween,
            //                                   children: Facility.items
            //                                       .map((e) => Expanded(
            //                                             child:
            //                                                 FacilityItem(facility: e),
            //                                           ))
            //                                       .toList(),
            //                                 ),
            //                               )
            //                             : const SizedBox.shrink(),
            //                         Padding(
            //                           padding: const EdgeInsets.only(top: 15.0),
            //                           child: Text(
            //                             "Details",
            //                             style: Theme.of(context)
            //                                 .appBarTheme
            //                                 .titleTextStyle,
            //                           ),
            //                         ),
            //                         Padding(
            //                           padding: const EdgeInsets.only(top: 5),
            //                           child: Text(
            //                             widget.place.about ?? '',
            //                             style: const TextStyle(
            //                                 fontSize: 15, fontWeight: FontWeight.w400),
            //                           ),
            //                         ),
            //
            //                         // Padding(
            //                         //   padding: const EdgeInsets.only(top: 20),
            //                         //   child: Row(
            //                         //     children: [
            //                         //       Expanded(
            //                         //           child: Text(
            //                         //             "Tour Guide",
            //                         //             style: Theme
            //                         //                 .of(context)
            //                         //                 .appBarTheme
            //                         //                 .titleTextStyle,
            //                         //           )),
            //                         //       TextButton(onPressed: () {}, child: const Text("See All")),
            //                         //     ],
            //                         //   ),
            //                         // ),
            //                         // SizedBox(
            //                         //   height: 130,
            //                         //   child: ListView.builder(
            //                         //     scrollDirection: Axis.horizontal,
            //                         //     padding: EdgeInsets.zero,
            //                         //     itemBuilder: (context, index) {
            //                         //       return TourGuideItem(
            //                         //           guide: Guide(
            //                         //               "John Doe", "Ibirunga, Musanze", 4.3, 20000,"1 Day"));
            //                         //     },
            //                         //     itemCount: 1000,
            //                         //   ),
            //                         // ),
            //                         _list.isEmpty
            //                             ? const SizedBox()
            //                             : Row(
            //                                 children: [
            //                                   Expanded(
            //                                       child: Text(
            //                                     "Reviews",
            //                                     style: Theme.of(context)
            //                                         .appBarTheme
            //                                         .titleTextStyle,
            //                                   )),
            //                                   TextButton(
            //                                       onPressed: () {
            //                                         push(ReviewsScreen(
            //                                             place: widget.place));
            //                                       },
            //                                       child: const Text("See All")),
            //                                 ],
            //                               ),
            //                         _list.isNotEmpty
            //                             ? const SizedBox.shrink()
            //                             : Padding(
            //                                 padding: const EdgeInsets.all(15.0)
            //                                     .copyWith(top: 30),
            //                                 child: const Center(
            //                                     child: Text("No Reviews yet !")),
            //                               ),
            //                         // Column(
            //                         //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //                         //   children: _list
            //                         //       .map((e) => ReviewItem(review: e))
            //                         //       .toList(),
            //                         // ),
            //                         IconItem(
            //                           place: widget.place,
            //                           fromDetail: true,
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //           bottomNavigationBar: widget.place.categoryId != "4"
            //               // widget.place.categoryId == "20"
            //               ? SafeArea(
            //                   child: Padding(
            //                     padding: const EdgeInsets.symmetric(horizontal: 10)
            //                         .copyWith(top: 5),
            //                     child: Row(
            //                       children: [
            //                         Expanded(
            //                             child: Text(
            //                           widget.place.currency,
            //                           style:
            //                               Theme.of(context).appBarTheme.titleTextStyle,
            //                         )),
            //                         ElevatedButton(
            //                           onPressed: () {
            //                             showModalBottomSheet(
            //                                 context: context,
            //                                 isScrollControlled: true,
            //                                 builder: (context) =>
            //                                     BookingScreen2(place: widget.place));
            //                           },
            //                           style: ElevatedButton.styleFrom(
            //                               padding: const EdgeInsets.symmetric(
            //                                   vertical: 6, horizontal: 15)),
            //                           child: Text(widget.place.categoryId != "4"
            //                               ? "Book Now"
            //                               : "Book Now"),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 )
            //               : null,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: widget.place.categoryId != "4"
          // widget.place.categoryId == "20"
          ? SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (User.user == null) {
                      authanticatePlease();
                    } else {
                      if (widget.place.id == "846") {
                        launchUrlString("https://www.vv.rw/merchant/meze-fresh",
                            mode: LaunchMode.externalNonBrowserApplication);
                      } else {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) =>
                                BookingScreen2(place: widget.place));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      widget.place.id == "846" ? "Order Now" : "Book Now",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
