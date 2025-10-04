import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/hotel_booking_form.dart';
import 'package:zoea1/json/room.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/json/venue.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/search_field.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/utils/number_formatter.dart';

import 'super_base.dart';

class RoomDetails extends StatefulWidget {
  final Room room;
  final VenueDetail venue;
  final FilterOption? filterOption;
  const RoomDetails(
      {super.key, required this.room, required this.venue, this.filterOption});

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends Superbase<RoomDetails> {
  bool _showText = false;
  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(fontSize: 16, height: 1.6);
    final span = TextSpan(text: widget.room.description, style: style);
    final tp =
        TextPainter(text: span, maxLines: 10, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: MediaQuery.of(context).size.width);
    var textWidget = Text(
      widget.room.description,
      maxLines: _showText ? null : 5,
      overflow: _showText ? TextOverflow.visible : TextOverflow.ellipsis,
    );
    final List<String> imageUrls = [
      widget.room.roomPhoto,
      widget.room.roomPhoto,
      widget.room.roomPhoto,
      widget.room.roomPhoto,
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Center the title horizontally
        title: Text(
          "${widget.room.name}",
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(imageUrls),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   widget.room.name,
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // Text(
                  //   "With  ${widget.room.capacity} Capacity",
                  //   style: TextStyle(fontSize: 12),
                  // ),
                  // const Text(
                  //   'Non-refundable',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 5,),
                  // Container(
                  //   padding: EdgeInsets.all(3),
                  //   decoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor,
                  //       borderRadius: BorderRadius.circular(5)),
                  //   child: const Text(
                  //     'Secret deal',
                  //     style: TextStyle(color: Colors.white, fontSize: 12),
                  //   ),
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Price for 1 night",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    NumberFormatter.formatCurrencyWithCode(double.tryParse(widget.room.price) ?? 0, 'USD'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme(context) ? null : primaryColor,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0)
                        .copyWith(top: 15),
                    child: const Text(
                      "Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0)
                        .copyWith(top: 10),
                    child: tp.didExceedMaxLines
                        ? Wrap(
                            children: [
                              textWidget,
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _showText = !_showText;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    "See ${_showText ? "less" : "more"}",
                                    style: TextStyle(
                                        color: isDarkTheme(context)
                                            ? null
                                            : Colors.blue.shade900,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Text(widget.room.description),
                  ),
                  // OutlinedButton(
                  //   onPressed: () {},
                  //   style: OutlinedButton.styleFrom(
                  //       fixedSize: const Size(double.maxFinite, 30),
                  //       side: BorderSide(
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(5))),
                  //   child: const Text('Book now'),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
            onPressed: () {
              if (User.user == null) {
                authanticatePlease();
              } else {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => HotelBookingForm(
                          room: widget.room,
                          hotel: widget.venue,
                          filterOption: widget.filterOption != null
                              ? widget.filterOption
                              : null,
                        ));
              }
              // print(widget.room.capacity);
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: const Text(
              "Book now",
              style: TextStyle(color: Colors.white),
            )),
      )),
    );
  }

  Widget buildTop(List<String> imageUrls) {
    // final bottom = profileHeight / 2;
    // final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: buildCoverImage(imageUrls),
        ),
        // Positioned(
        //   top: top,
        //   child: buildProfileImage(),
        // ),
      ],
    );
  }

  Widget buildCoverImage(List<String> imageUrls) => CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        items: imageUrls.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      );
}
