import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoea1/constants/apik.dart';
import 'package:zoea1/services/api_key_manager.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/partial/share_icon.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import '../../../authentication.dart';
import '../../../json/event.dart';
import '../../../json/user.dart';
import 'package:zoea1/event_details_screen.dart';
import 'package:zoea1/partial/safe_cached_network_image.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback? callback;
  final double? imageHeight;
  final EdgeInsets? padding;
  final bool fromBooking;
  final String? category;
  const EventCard(
      {super.key,
      required this.event,
      this.callback,
      this.imageHeight,
      this.padding,
      this.fromBooking = false,
      this.category});

  @override
  State<EventCard> createState() => _EventCardState();
}

bool canLike = true;
bool canGo = true;

class _EventCardState extends Superbase<EventCard> {
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
          if (canGo) {
            setState(() {
              widget.event.going += 1;
              canGo = !canGo;
            });
          } else {
            setState(() {
              widget.event.going -= 1;
              canGo = !canGo;
            });
          }
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
    var colorAvatar = const Color(0xcbebf8ef);
    return Container(
      margin: widget.padding ?? const EdgeInsets.only(bottom: 7.5),
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
      decoration: BoxDecoration(
          color: isDarkTheme(context) ? semiBlack : Colors.white,
          borderRadius: BorderRadius.circular(0)),
      child: InkWell(
        onTap: widget.callback,
        child: SizedBox(
          width: double.infinity,
          // height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: SafeCachedNetworkImage(
                  imageUrl: widget.event.poster,
                  width: double.maxFinite,
                  // height: 200,
                  fit: BoxFit.cover,
                  contextInfo: "Event: ${widget.event.name} (ID: ${widget.event.id})",
                  eventId: widget.event.id,
                  eventName: widget.event.name,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.event.name} . ${widget.event.status}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            // miniText("${widget.place.rating}"),
                            // Row(
                            //   children: List.generate(
                            //     widget.place.rating
                            //         .toInt(), // Ensure rating is an integer
                            //         (index) => Icon(
                            //       Icons.star,
                            //       color: Colors.yellow.shade600,
                            //       size: 18,
                            //     ),
                            //   ),
                            // ),
                            miniText(
                              "${widget.event.startTime}",
                            )
                          ],
                        ),
                        Row(
                          children: [
                            // miniText(
                            //     "${widget.category} . ${widget.place.price}"),
                            Text(
                              "${widget.event.address}".length < 30
                                  ? "${widget.event.address}"
                                  : "${widget.event.address}".substring(0, 30),
                              style: TextStyle(
                                  // fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "${widget.event.address}".length < 30
                                    ? ""
                                    : " ...",
                                style: TextStyle(
                                    // fontSize: 12,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // miniText(
                        //   "You rated it ${widget.place.rating} stars",
                        // ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  // widget.event.ticketUrl.isNotEmpty? InkWell(
                  //    onTap: () {
                  //      Share.share(
                  //          "https://tarama.ai/place?venue=${widget.event.address}");
                  //    },
                  //    child: const CircleAvatar(
                  //      radius: 18,
                  //      backgroundColor: Color(0xffF4F5F7),
                  //      child: Icon(
                  //        Icons.share,
                  //        size: 21,
                  //        color: Colors.black,
                  //      ),
                  //    ),
                  //  ):Container()
                ],
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
                        : push(Authentication());                  }, widget.event.going),
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
              )
            ],
          ),
        ),
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
                    isDarkTheme(context) ? Colors.grey : Colors.black,
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

miniText(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 12),
  );
}
