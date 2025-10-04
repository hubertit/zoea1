import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/utils/number_formatter.dart';

import 'json/hotel.dart';
import 'json/room.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends Superbase<HotelDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadInfo();
    });
    super.initState();
  }

  void loadInfo() {
    ajax(
        url:
            "https://smartbookings.rw/Client-HotelDetail/${Superbase.smartKey}/5e158144c15aa/Find?adult=2&child=0&numberofroom=1&checkin=06%2F19%2F2022&checkout=06%2F25%2F2022",
        absolutePath: true,
        onValue: (obj, url) {
          setState(() {
            widget.hotel.rooms = (obj['rooms'] as Iterable)
                .map((e) => Room.fromJson(e))
                .toList();
          });
        });
  }

  void changeFavorite() async {
    if (widget.hotel.adding) {
      return;
    }

    setState(() {
      widget.hotel.adding = true;
    });
    await ajax(
        url: "others/favorites",
        method: "POST",
        data: FormData.fromMap({
          "venue_id": widget.hotel.code,
          "action": widget.hotel.favorite ? "remove" : "add"
        }),
        onValue: (obj, url) {
          if (obj['code'] == 200) {
            setState(() {
              widget.hotel.favorite = !widget.hotel.favorite;
            });
          }
        });
    setState(() {
      widget.hotel.adding = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.grey.shade500,
            Colors.grey.shade500,
            Colors.grey.shade500,
            Colors.white,
            Colors.white,
            Colors.white,
          ])),
      child: Stack(
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
              image: widget.hotel.banner.isNotEmpty
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(widget.hotel.banner),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.repeatY)
                  : null,
            ),
          ),
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                  // title: const Text("Vacation Details"),
                  ),
              body: ListView(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    )),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 600),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        widget.hotel.name,
                                        style: Theme.of(context)
                                            .appBarTheme
                                            .titleTextStyle
                                            ?.copyWith(fontSize: 24),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          children: [
                                            RichText(
                                                text: TextSpan(children: [
                                              WidgetSpan(
                                                  child: Icon(
                                                Icons.location_on_sharp,
                                                size: 16,
                                                color: smallTextColor,
                                              )),
                                              TextSpan(
                                                  text: widget.hotel.address,
                                                  style: TextStyle(
                                                      color: smallTextColor))
                                            ])),
                                            const SizedBox(
                                              width: 50,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow.shade600,
                                              size: 18,
                                            ),
                                            Text(
                                              "${widget.hotel.star}",
                                              style: TextStyle(
                                                  color:
                                                      Colors.yellow.shade600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: changeFavorite,
                                    icon: widget.hotel.adding
                                        ? const CupertinoActivityIndicator()
                                        : Icon(
                                            widget.hotel.favorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: widget.hotel.favorite
                                                ? Colors.red
                                                : null,
                                          ))
                              ],
                            ),
                            widget.hotel.facilities.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: widget.hotel.facilities
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Text(
                                                      e.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge,
                                                    ),
                                                    Wrap(
                                                      children: e.items
                                                          .map((e) => Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            4),
                                                                child: Chip(
                                                                    label: Text(
                                                                        e)),
                                                              ))
                                                          .toList(),
                                                    )
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                "Details",
                                style: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                widget.hotel.description,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                "Rooms",
                                style: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle,
                              ),
                            ),
                            SizedBox(
                              height: 170,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var room = widget.hotel.rooms[index];
                                  return SizedBox(
                                    width: 220,
                                    child: Card(
                                      elevation: 6,
                                      shadowColor: Colors.black45,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  room.name,
                                                  style: const TextStyle(
                                                      color: Color(0xff10644D),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                                Text(
                                                  NumberFormatter.formatCurrencyWithCode(double.tryParse(room.price) ?? 0, 'USD'),
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                room.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: widget.hotel.rooms.length,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 20),
                            //   child: Row(
                            //     children: [
                            //       Expanded(
                            //           child: Text(
                            //             "Tour Guide",
                            //             style: Theme
                            //                 .of(context)
                            //                 .appBarTheme
                            //                 .titleTextStyle,
                            //           )),
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
                            //       return TourGuideItem(
                            //           guide: Guide(
                            //               "John Doe", "Ibirunga, Musanze", 4.3, 20000,"1 Day"));
                            //     },
                            //     itemCount: 1000,
                            //   ),
                            // ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Reviews",
                                  style: Theme.of(context)
                                      .appBarTheme
                                      .titleTextStyle,
                                )),
                                TextButton(
                                    onPressed: () {
                                      // push(ReviewsScreen(place: widget.place));
                                    },
                                    child: const Text("See All")),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Center(child: Text("No Reviews yet !")),
                            ),
                            // ReviewItem(review: Review("John Doe", 3, "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.", "23 Nov 2022"))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10)
                      .copyWith(top: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        NumberFormatter.formatPricePerUnit(widget.hotel.minPrice, 'Person'),
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      )),
                      ElevatedButton(
                        onPressed: () {
                          // push(HotelBookingForm(hotel: widget.hotel),fullscreenDialog: true);
                          // showModalBottomSheet(context: context,isScrollControlled: true, builder: (context)=>BookingScreen2(place: widget.place));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 15)),
                        child: const Text("Book Now"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
