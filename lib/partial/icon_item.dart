import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/partial/share_icon.dart';
import 'package:zoea1/super_base.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoea1/ults/functions.dart';

import '../json/place.dart';
import '../place_detail_screen.dart';
import '../rating_bottom_dialog.dart';
import '../views/more/widgets/profile_item.dart';

class _Option {
  IconData iconData;
  String type;
  Color? color;

  _Option(this.iconData, this.type, {this.color});
}

class IconItem extends StatefulWidget {
  final Place place;
  final bool fromDetail;
  const IconItem({super.key, required this.place, this.fromDetail = false});

  @override
  State<IconItem> createState() => _IconItemState();
}

class _IconItemState extends Superbase<IconItem> {
  _Option? _option;

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

  Widget item(_Option e) {
    var place = widget.place;
    return Material(
        color:isDarkTheme(context)?semiBlack: Colors.white,
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
        // color: _option?.type == e.type
        //     ? Theme.of(context).primaryColor
        //     : place.categoryId == "6" && e.type == "location"
        //         ? Colors.grey.shade100
        //         : Colors.grey.shade300,
        child: InkWell(
          // onTap: place.categoryId == "6"
          //     ? null
          //     : () {
          //
          //       },
          child: ProfileItem(
              title: getTitleText(e.type),
              onPressed: () {
                setState(() {
                  _option = e;
                });

                if (e.type == "info") {
                  push(PlaceDetailScreen(place: place));
                }

                if (e.type == "rating") {
                  if (User.user == null) {
                    authanticatePlease();
                  } else {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => RatingBottomDialog(
                              place: place,
                            ));
                  }
                }

                if (e.type == 'favorite') {
                  if (User.user == null) {
                    authanticatePlease();
                  } else {
                    changeFavorite(place);
                  }
                }

                if (e.type == "location") {
                  String googleUrl =
                      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeQueryComponent(place.address ?? place.title)}';
                  launchUrlString(googleUrl);
                }

                if (e.type == "share") {
                  print(place.venueCode);
                  Share.share(
                      "https://zoea.africa/place?venue=${place.venueCode}");
                }

                if (e.type == 'call') {
                  if (place.phone?.trim().isNotEmpty == true) {
                    launchUrlString("tel:${place.phone!.split(" ").join("")}");
                  } else {
                    showSnack("No phone number available");
                  }
                }
                if (e.type == 'email') {
                  if (place.email?.trim().isNotEmpty == true) {
                    launchUrlString("mailto:${place.email!}");
                  } else {
                    showSnack("No email address available !");
                  }
                }
                if (e.type == 'globe') {
                  if (place.website?.trim().isNotEmpty == true) {
                    launchUrlString("mailto:${place.website!}");
                  } else {
                    showSnack("No website available !");
                  }
                }
              },
              leadingIcon: e.type == 'favorite' && place.adding
                  ? const CupertinoActivityIndicator()
                  : Icon(
                      e.iconData,
                      size: 21,
                      color: e.color ??
                          (_option?.type == e.type ? Colors.white : isDarkTheme(context)?Colors.grey:null),
                    ),
              avatarColor:isDarkTheme(context)?Colors.black: const Color(0xffeff4f8)),
          // SizedBox(
          //     height: 38,
          //     width: 38,
          //     child: Center(
          //         child: e.type == 'favorite' && place.adding
          //             ? const CupertinoActivityIndicator()
          //             : Icon(
          //                 e.iconData,
          //                 size: 21,
          //                 color: e.color ??
          //                     (_option?.type == e.type ? Colors.white : null),
          //               )
          //     )
          // ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var place = widget.place;
    var list0 = [
      _Option(Entypo.globe, "globe"),
      _Option(Icons.email_outlined, "email"),
      _Option(place.favorite ? Entypo.heart : Entypo.heart_outlined, "favorite",
          color: place.favorite ?isDarkTheme(context)?Colors.white: Colors.red : null),
      _Option(Entypo.phone, "call"),
    ];
    var list = [
      _Option(Entypo.star_outlined, "rating"),
      _Option(Entypo.location_pin, "location"),
      _Option(shareIcon(), "share"),
    ];

    if (!widget.fromDetail) {
      list.add(_Option(Entypo.info, "info"));
    } else {
      list.add(_Option(MaterialCommunityIcons.whatsapp, "whatsapp"));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list.map(item).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list0.map(item).toList(),
          ),
        ],
      ),
    );
  }
}

String getTitleText(String type) {
  switch (type) {
    case 'info':
      return 'Information';
    case 'rating':
      return 'Review';
    case 'favorite':
      return 'Add to favorites';
    case 'whatsapp':
      return 'Whatsapp';
    case 'location':
      return 'Directions';
    case 'share':
      return 'Share';
    case 'call':
      return 'Call Us';
    case 'email':
      return 'Send Email';
    case 'globe':
      return 'Visit Website';
    default:
      return '';
  }
}
