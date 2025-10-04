import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/place_detail_screen.dart';
import 'package:zoea1/super_base.dart';

import '../json/place.dart';

String authMessage = "Login first";
class PlaceGridItem extends StatefulWidget {
  final Place place;
  const PlaceGridItem({super.key, required this.place});

  @override
  State<PlaceGridItem> createState() => _PlaceGridItemState();
}

class _PlaceGridItemState extends Superbase<PlaceGridItem> {
  void changeFavorite() async {
    if (widget.place.adding) {
      return;
    }

    setState(() {
      widget.place.adding = true;
    });
    await ajax(
        url: "others/favorites",
        method: "POST",
        data: FormData.fromMap({
          "venue_id": widget.place.id,
          "action": widget.place.favorite ? "remove" : "add"
        }),
        onValue: (obj, url) {
          if (obj['code'] == 200) {
            setState(() {
              widget.place.favorite = !widget.place.favorite;
            });
          }
        });
    setState(() {
      widget.place.adding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      var hasHeight = cons.maxHeight.isFinite;
      Widget item = Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8)),
            height: hasHeight ? null : 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.place.image ?? "",
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 30,
                    ),
                  );
                },
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000)),
              child: InkWell(
                onTap: User.user==null
                    ? () => showSnack(authMessage)
                    : changeFavorite,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: widget.place.adding
                      ? const CupertinoActivityIndicator()
                      : Icon(
                          widget.place.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.place.favorite ? Colors.red : null,
                          size: 15,
                        ),
                ),
              ),
            ),
          )
        ],
      );

      if (hasHeight) {
        item = Expanded(child: item);
      }

      var location = RichText(
          text: TextSpan(children: [
        WidgetSpan(
            child: Icon(
          Icons.location_on_sharp,
          size: 14,
          color: smallTextColor,
        )),
        TextSpan(
          text: widget.place.location,
          style: TextStyle(fontSize: 11, color: smallTextColor),
        )
      ]));

      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          push(PlaceDetailScreen(place: widget.place));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            item,
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      widget.place.title,
                      maxLines: hasHeight ? 1 : null,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: widget.place.hasPrice
                        ? location
                        : Row(
                            children: [
                              Expanded(
                                child: location,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow.shade600,
                                size: 18,
                              ),
                              Text(
                                "${widget.place.rating}",
                                style: TextStyle(color: Colors.yellow.shade600),
                              ),
                              Text(widget.place.number > 0
                                  ? "(${widget.place.number})"
                                  : "")
                            ],
                          ),
                  ),
                  widget.place.hasPrice
                      ? Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.place.currency,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow.shade600,
                                size: 16,
                              ),
                              Text(
                                "${widget.place.rating}",
                                style: TextStyle(
                                  color: Colors.yellow.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.place.number > 0
                                    ? "(${widget.place.number})"
                                    : "",
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

