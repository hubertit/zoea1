import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/place_detail_screen.dart';
import 'package:zoea1/super_base.dart';

import '../json/place.dart';
import '../json/user.dart';
import 'place_grid_item.dart';

class EventGridItem extends StatefulWidget {
  final Place place;

  const EventGridItem({super.key, required this.place});

  @override
  State<EventGridItem> createState() => _EventGridItemState();
}

class _EventGridItemState extends Superbase<EventGridItem> {
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.place.image ?? ""),
                    fit: BoxFit.cover)),
            height: hasHeight ? null : 150,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000)),
              child: InkWell(
                onTap:User.user==null?() => showSnack(authMessage): changeFavorite,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.place.adding
                      ? const CupertinoActivityIndicator()
                      : Icon(
                          widget.place.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.place.favorite ? Colors.red : null,
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
          size: 16,
          color: smallTextColor,
        )),
        TextSpan(
            text: widget.place.location,
            style: TextStyle(color: smallTextColor))
      ]));

      return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            push(PlaceDetailScreen(place: widget.place));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              item,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(top: 10),
                child: Text(
                  widget.place.title,
                  maxLines: hasHeight ? 1 : null,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 5, right: 5, bottom: 10),
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
                          Text("(${widget.place.number})")
                        ],
                      ),
              ),
              // widget.place.hasPrice ? Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Text(widget.place.currency,style: const TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w700
              //         ),),
              //       ),
              //       Icon(Icons.star,color: Colors.yellow.shade600,size: 18,),
              //       Text("${widget.place.rating}",style: TextStyle(
              //         color: Colors.yellow.shade600
              //       ),),
              //       Text("(${widget.place.number})")
              //     ],
              //   ),
              // ) : const SizedBox.shrink()
            ],
          ),
        ),
      );
    });
  }
}
