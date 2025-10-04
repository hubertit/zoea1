import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoea1/authentication.dart';
import 'package:zoea1/partial/share_icon.dart';
import 'package:zoea1/super_base.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoea1/utils/number_formatter.dart';

import 'constants/apik.dart';
import 'services/api_key_manager.dart';
import 'json/event.dart';
import 'json/user.dart';
import 'main.dart';
import 'partial/cover_container.dart';
import 'ticket_payment_dialog.dart';
import 'ults/functions.dart';
import 'views/events/widgets/event_card.dart';
import 'package:zoea1/partial/safe_cached_network_image.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends Superbase<EventDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // loadInfo();
    });
    super.initState();
  }

  // void loadInfo() {
  //   ajax(
  //       url: "https://itike.io/api/events/details",
  //       absolutePath: true,
  //       method: "POST",
  //       data: FormData.fromMap({"event_id": widget.event.id}),
  //       onValue: (obj, url) {
  //         setState(() {
  //           // widget.event.tickets = (obj['event']['tickets'] as Iterable)
  //           //     .map((e) => Ticket.fromJson(e))
  //           //     .toList();
  //           // widget.event.organizer = Organizer.fromJson(obj['event']);
  //         });
  //         print("Tickets url");
  //         print(obj);
  //       });
  // }
  Future<void> likeEvent(id) {
    return ajax(
        method: "POST",
        url: "${baseUrll}events/likeEvent",
        absolutePath: true,
        data: FormData.fromMap({"token": User.user!.token, "event_id": id}),
        onValue: (object, url) {
          if (canLike) {
            setState(() {
              widget.event.likes += 1;
              canLike = !canLike;
            });
          } else {
            setState(() {
              widget.event.likes -= 1;
              canLike = !canLike;
            });
          }
        });
  }

  Future<void> goingToEvent(id) {
    return ajax(
        method: "POST",
        url: "${baseUrll}events/goingToEvent",
        absolutePath: true,
        data: FormData.fromMap({"token": User.user!.token, "event_id": id}),
        onValue: (object, url) {
          // print(object);
          setState(() {
            widget.event.going += 1;
          });
        });
  }

  Future<void> shareEvent(id) {
    return ajax(
        method: "POST",
        url: "${baseUrll}events/shareEvent",
        absolutePath: true,
        data: FormData.fromMap({"token": User.user!.token, "event_id": id}),
        onValue: (object, url) {
          setState(() {
            widget.event.shares += 1;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    // print (widget.event.);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 350,
                  child: ClipRect(
                    child: SafeCachedNetworkImage(
                      imageUrl: widget.event.poster ?? "",
                      width: double.maxFinite,
                      height: 350,
                      fit: BoxFit.cover,
                      contextInfo: "Event Details Header: ${widget.event.name} (ID: ${widget.event.id})",
                      eventId: widget.event.id,
                      eventName: widget.event.name,
                    ),
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
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: CircleAvatar(
                          backgroundColor: isDarkTheme(context)
                              ? Colors.black
                              : Colors.white,
                          radius: 15,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 15,
                          ),
                        ),
                      ),
                      const Spacer(),
                      widget.event.ticketUrl.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                Share.share("${widget.event.ticketUrl}");
                              },
                              icon: CircleAvatar(
                                backgroundColor: isDarkTheme(context)
                                    ? Colors.black
                                    : Colors.white,
                                radius: 15,
                                child: Icon(
                                  shareIcon(),
                                  size: 15,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.name,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: InkWell(
                onTap: () {
                  // String googleUrl =
                  //     'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(widget.event.address ?? hotel.venueName)}';
                  // launchUrlString(googleUrl);
                },
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(top: 0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      if (widget.event.address != "")
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              const Icon(Icons.location_pin),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  "${widget.event.address}",
                                  style: const TextStyle(fontSize: 14),
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
              margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                "${widget.event.startTime}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            if (widget.event.details != null)
              CoverContainer(children: [
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("${widget.event.details}"),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    roundedContainer(Icons.calendar_today, 'Going', () {
                      // String googleUrl =
                      //     'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(widget.place.address ?? widget.place.title)}';
                      // launchUrlString(googleUrl);
                      User.user!.token != null
                          ? goingToEvent(widget.event.id)
                          : push(Authentication());
                    }, widget.event.going),
                    // roundedContainer(Icons.menu_outlined, 'Menu'),
                    // roundedContainer(, 'Call', () {
                    //   // launchUrlString(
                    //   //     "tel:${widget.place.phone!.split(" ").join("")}");
                    // }),
                    roundedContainer(
                        canLike
                            ? MaterialCommunityIcons.thumb_up_outline
                            : MaterialCommunityIcons.thumb_up,
                        "Like", () {
                      // launchUrlString("mailto:${widget.place.email!}");
                      User.user!.token != null
                          ? likeEvent(widget.event.id)
                          : push(Authentication());
                    }, widget.event.likes),

                    if (widget.event.ticketUrl != "")
                      roundedContainer(shareIcon(), 'Share', () {
                        Share.share(widget.event.ticketUrl);
                        shareEvent(widget.event.id);
                      }, widget.event.shares),
                    SizedBox(
                      width: 0,
                    )
                  ],
                ),
              ]),
            // CoverContainer(children: [
            //   IconItem(
            //     place: widget.,
            //     fromDetail: true,
            //   ),
            // ])
          ],
        ),
      ),
      bottomNavigationBar: widget.event.ticketUrl.isNotEmpty
          // widget.place.categoryId == "20"
          ? SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 5),
                child: ElevatedButton(
                  onPressed: () {
                    // showModalBottomSheet(
                    //     context: context,
                    //     isScrollControlled: true,
                    //     builder: (context) =>
                    //         BookingScreen2(place: widget.place));
                    launchUrlString("${widget.event.ticketUrl}");
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Buy Ticket',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
    Container(
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
                          child: ClipRect(
                child: SafeCachedNetworkImage(
                  imageUrl: widget.event.poster.isNotEmpty ? widget.event.poster : "",
                  width: double.maxFinite,
                  height: 350,
                  fit: BoxFit.cover,
                  contextInfo: "Event Details Background: ${widget.event.name} (ID: ${widget.event.id})",
                  eventId: widget.event.id,
                  eventName: widget.event.name,
                ),
            ),
          ),
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(),
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
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.event.name,
                                              style: Theme.of(context)
                                                  .appBarTheme
                                                  .titleTextStyle
                                                  ?.copyWith(fontSize: 24),
                                            ),
                                          ),
                                          Chip(
                                              backgroundColor:
                                                  widget.event.status == "open"
                                                      ? Colors.green.shade700
                                                      : widget.event.status ==
                                                              "closed"
                                                          ? Colors.red
                                                          : null,
                                              label: Text(widget.event.status))
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          WidgetSpan(
                                              child: Icon(
                                            Icons.location_on_sharp,
                                            size: 16,
                                            color: smallTextColor,
                                          )),
                                          TextSpan(
                                              text: widget.event.address,
                                              style: TextStyle(
                                                  color: smallTextColor))
                                        ])),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Organizer : ",
                                              style: TextStyle(
                                                  color: Color(0xff838F9B),
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              "",
                                              style: TextStyle(
                                                  color: Color(0xff0C4DA1),
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                                widget.event.details ?? '',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ),
                            widget.event.tickets.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "No Tickets available !",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.copyWith(fontSize: 25),
                                      ),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: widget.event.tickets
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  SafeCachedNetworkImage(
                                                    imageUrl: widget.event.poster,
                                                    width: 55,
                                                    height: 55,
                                                    fit: BoxFit.cover,
                                                    contextInfo: "Event Ticket: ${widget.event.name} (ID: ${widget.event.id})",
                                                    eventId: widget.event.id,
                                                    eventName: widget.event.name,
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Text(
                                                          e.name,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 17),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 4),
                                                          child: Text(
                                                            NumberFormatter.formatCurrencyWithCode(e.price, 'USD'),
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xff0C4DA1)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                  GestureDetector(
                                                    onTap:
                                                        e.status == 'available'
                                                            ? () {
                                                                if (widget.event
                                                                        .organizerId ==
                                                                    "7") {
                                                                  openLink(
                                                                      "https://www.ticqet.rw/#/");
                                                                } else {
                                                                  showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              TicketPaymentDialog(
                                                                                ticket: e,
                                                                                event: widget.event,
                                                                              ));
                                                                }
                                                              }
                                                            : null,
                                                    child: Chip(
                                                      label: Text(
                                                        e.status == 'available'
                                                            ? 'Get it'
                                                            : e.status,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          e.status ==
                                                                  'available'
                                                              ? const Color(
                                                                  0xff0C4DA1)
                                                              : Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  )
                            // ReviewItem(review: Review("John Doe", 3, "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.", "23 Nov 2022"))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: null,
            ),
          ),
        ],
      ),
    );
  }

  roundedContainer(
      IconData iconData, String text, void Function()? onTap, int number) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: isDarkTheme(context)
                    ? Colors.black
                    : const Color(0xffF4F5F7),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Icon(
                  iconData,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              right: -12,
              top: 6,
              child: CircleAvatar(
                radius: 12,
                backgroundColor:
                    isDarkTheme(context) ? Colors.white : primaryColor,
                child: Text(
                  "${number}",
                  style: TextStyle(
                      color: isDarkTheme(context) ? Colors.black : Colors.white,
                      fontSize: 10),
                ),
              ))
        ],
      ),
    );
  }
}
