import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoea1/hotel_details_screen_v2.dart';
import 'package:zoea1/hotels_screen.dart';
import 'package:zoea1/json/venue.dart';
import 'package:zoea1/main.dart';

import '../event_details_screen.dart';
import '../hotel_list_view.dart';
import '../json/event.dart';
import '../search_field.dart';
import '../super_base.dart';

class HotelItemCard extends StatefulWidget {
  final Venue event;

  const HotelItemCard({super.key, required this.event});

  @override
  State<HotelItemCard> createState() => _HotelItemCardState();
}

class _HotelItemCardState extends Superbase<HotelItemCard> {
  @override
  Widget build(BuildContext context) {
    var card = Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // shadowColor: Colors.black26,
      margin: const EdgeInsets.all(5).copyWith(bottom: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          push(HotelDetailsScreenV2(venueId: widget.event.venueId));
          // push(
          //     const HotelsScreen()).then((value) {
          //   if (value != null && value is FilterOption) {
          //     push(HotelListView(
          //       filterOption: value,
          //     ));
          //   }
          // }
          // );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Image(
                    image: CachedNetworkImageProvider(widget.event.venueImage),
                    fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.event.venueName,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.event.venueCoordinates,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.event.currency,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 14,
                            // color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return SizedBox(
      width: 170,
      child: card,
    );
  }
}
