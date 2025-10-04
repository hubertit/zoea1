import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/json/place.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/place_detail_screen.dart';


import '../super_base.dart';

class RestaurantItemCard extends StatefulWidget {
  final Place event;

  const RestaurantItemCard({super.key, required this.event});

  @override
  State<RestaurantItemCard> createState() => _RestaurantItemCardState();
}

class _RestaurantItemCardState extends Superbase<RestaurantItemCard> {
  @override
  Widget build(BuildContext context) {
    var card = Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
      // shadowColor: Colors.black26,
      margin: const EdgeInsets.all(5).copyWith(bottom: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          push(PlaceDetailScreen(place: widget.event,));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Image(
                    image: CachedNetworkImageProvider(widget.event.image??widget.event.image!),
                    fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Text(
                    widget.event.title,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${widget.event.address}",
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 11, ),
                  ),
                  Text(
                    widget.event.currency,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      // color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  )
                  // Row(children:
                  //  List.generate(widget.event.price.toInt(), (index) => const Text("\$",style:
                  //       TextStyle(fontSize: 14,fontWeight: FontWeight.bold)))
                  //
                  //
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return SizedBox(
      width: 170,
      child:  card,
    );
  }
}
