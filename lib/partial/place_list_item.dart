import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/partial/share_icon.dart';
import 'package:zoea1/super_base.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoea1/ults/functions.dart';

import '../json/place.dart';
import '../json/user.dart';
import 'place_grid_item.dart';

class PlaceListItem extends StatefulWidget {
  final Place place;
  final VoidCallback? callback;
  final double? imageHeight;
  final EdgeInsets? padding;
  final bool fromBooking;
  final String? category;
  const PlaceListItem(
      {super.key,
      required this.place,
      this.callback,
      this.imageHeight,
      this.padding,
      this.fromBooking = false,
      this.category});

  @override
  State<PlaceListItem> createState() => _PlaceListItemState();
}

class _PlaceListItemState extends Superbase<PlaceListItem> {
  void changeFavorite(Place place) async {
    if (place.adding) {
      return;
    }

    setState(() {
      place.adding = true;
    });
    await ajax(
        url: "others/favorites",
        method: "POST",
        data: FormData.fromMap({
          "venue_id": place.id,
          "action": place.favorite ? "remove" : "add"
        }),
        onValue: (obj, url) {
          if (obj['code'] == 200) {
            setState(() {
              place.favorite = !place.favorite;
            });
          }
        });
    setState(() {
      place.adding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorAvatar = const Color(0xcbebf8ef);
    var location = RichText(
        text: TextSpan(children: [
      WidgetSpan(
          child: Icon(
        Icons.location_on_sharp,
        size: 16,
        color: smallTextColor,
      )),
      TextSpan(
          text: widget.place.location, style: TextStyle(color: smallTextColor))
    ]));
    var rating = Row(
      children: [
        widget.place.categoryId == "5"
            ? Expanded(child: Text(widget.place.services ?? ""))
            : const SizedBox.shrink(),
        widget.place.hasPrice
            ? Expanded(
                child: Text(
                  widget.place.currency,
                  textAlign: widget.place.categoryId == "5"
                      ? TextAlign.end
                      : TextAlign.end,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
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
          width: double.maxFinite,
          // height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: widget.place.image!,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                  placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                // width: double.infinity,
                // decoration: BoxDecoration(
                //     image: widget.place.image != null
                //         ? DecorationImage(
                //             fit: BoxFit.cover,
                //             image:
                //                 CachedNetworkImageProvider(widget.place.image!))
                //         : null,
                //     color: Colors.grey,
                //     borderRadius: BorderRadius.circular(5)),
                // height: widget.imageHeight ?? 140,
                // width: 150,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.place.title} . ${widget.place.location}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            // miniText("${widget.place.rating}"),
                            Row(
                              children: List.generate(
                                widget.place.rating
                                    .toInt(), // Ensure rating is an integer
                                (index) => Icon(
                                  Icons.star,
                                  color: isDarkTheme(context)
                                      ? Colors.white
                                      : Colors.yellow.shade600,
                                  size: 18,
                                ),
                              ),
                            ),
                            miniText(
                              "(${widget.place.number} Reviews)",
                            )
                          ],
                        ),
                        Row(
                          children: [
                            // miniText(
                            //     "${widget.category} . ${widget.place.price}"),
                            Flexible(
                              child: Text(
                                widget.place.currency,
                                style: TextStyle(
                                    // fontSize: 12,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
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
                  InkWell(
                    onTap: User.user == null
                        ? () => showSnack(authMessage)
                        : () {
                            changeFavorite(widget.place);
                          },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: isDarkTheme(context)
                          ? Colors.black
                          : const Color(0xffF4F5F7),
                      child: widget.place.adding
                          ? const CupertinoActivityIndicator()
                          : Icon(
                        widget.place.favorite
                            ?Icons.favorite_outline
                                  : Icons.favorite,
                              size: 21,
                              color: widget.place.favorite
                                  ? isDarkTheme(context)
                                      ? Colors.white
                                      : Colors.red
                                  : isDarkTheme(context)
                                  ? Colors.white
                                  : null,
                            ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  roundedContainer(Icons.directions, 'Directions', () {
                    String googleUrl =
                        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(widget.place.address ?? widget.place.title)}';
                    launchUrlString(googleUrl);
                  }),
                  // roundedContainer(Icons.menu_outlined, 'Menu'),
                  roundedContainer(Icons.call, 'Call', () {
                    launchUrlString(
                        "tel:${widget.place.phone!.split(" ").join("")}");
                  }),
                  roundedContainer(MaterialCommunityIcons.email, "Email", () {
                    launchUrlString("mailto:${widget.place.email!}");
                  }),

                  roundedContainer(shareIcon(), 'Share', () {
                    Share.share(
                        "https://zoea.africa/place?venue=${widget.place.venueCode}");
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  roundedContainer(IconData iconData, String text, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: isDarkTheme(context)
            ?Colors.black: const Color(0xffF4F5F7),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(
              iconData,
              size: 15,
            ),
            SizedBox(
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
    );
  }
}

miniText(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 12),
  );
}

class CuisinesContainer extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final IconData iconData;
  const CuisinesContainer(
      {super.key, this.onTap, required this.text, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: const Color(0xffF4F5F7),
            borderRadius: BorderRadius.circular(10)),
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
    );
  }
}
