import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/hotel_booking_form.dart';
import 'package:zoea1/json/venue.dart';
import 'package:zoea1/room_details.dart';
import 'package:zoea1/search_field.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/utils/number_formatter.dart';

import 'constants/theme.dart';
import 'json/hotel.dart';
import 'json/room.dart';
import 'main.dart';

class RoomsScreen extends StatefulWidget {
  final VenueDetail hotel;
  final FilterOption? filterOption;

  const RoomsScreen({super.key, required this.hotel, this.filterOption});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends Superbase<RoomsScreen> {
  Room? _room;
  List<Amenity> facilities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Rooms"),
      ),
      body: ListView.builder(
          itemCount: widget.hotel.rooms.length,
          itemBuilder: (context, index) {
            var room = widget.hotel.rooms[index];
            List<Amenity> amenities = room.amenities;
            // final facilitiesData = room.amenities as Iterable?;
            // facilities = facilitiesData?.map((e) => Amenity.fromJson(e)).toList() ?? [];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
              margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
              decoration: BoxDecoration(
                  color: isDarkTheme(context) ? semiBlack : Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: InkWell(
                onTap: () {
                  push(RoomDetails(
                    room: room,
                    venue: widget.hotel,
                    filterOption: widget.filterOption,
                  ));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          image: CachedNetworkImageProvider(room.roomPhoto),
                          height: 120,
                          width: 120,
                          fit: BoxFit.fitHeight,
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  room.name,
                                  style: TextStyle(
                                      color: isDarkTheme(context)
                                          ? null
                                          : textsColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              // Icon(room.isFavorite==0?
                              // Icons.favorite_border:Icons.favorite,
                              //   size: 15,
                              //   color:item.isFavorite==1?Colors.red:null ,
                              // )
                            ],
                          ),

                          // Row(children:List.generate(
                          //     6,
                          //         (index) => index == 5
                          //         ? Text(
                          //       "  (${room.}) Reviews",
                          //       textAlign: TextAlign.end,style: const TextStyle(fontSize: 12),
                          //     )
                          //         : Icon(
                          //       index <
                          //           num.parse(
                          //               item.venueRating)
                          //           ? Icons.star
                          //           : Icons.star_border,
                          //       color: Colors.amber,size: 18,
                          //     )) ,),
                          Text(
                            "${room.status}",
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    isDarkTheme(context) ? null : primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: Text(
                              "${room.capacity} rooms left",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),

                          // Text("${room.a}",style: const TextStyle(fontSize: 12)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              NumberFormatter.formatCurrency(double.tryParse(room.price) ?? 0),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkTheme(context)?null:primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 8),
                          //   child: Text(
                          //     item.startDate,
                          //     style:  TextStyle(
                          //         color: primaryColor, fontSize: 14),
                          //   ),
                          // ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 100,
                child: Card(
                  elevation: 6,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: room.roomId == _room?.roomId
                      ? Colors.grey.shade400
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  shadowColor: Colors.black45,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _room = room;
                      });
                      // push(RoomDetails(room: room));
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(right: 20.0).copyWith(left: 0),
                      child: Row(
                        children: [
                          // Checkbox(
                          //     value: room.roomId == _room?.roomId,
                          //     onChanged: (v) {
                          //       setState(() {
                          //         _room = room;
                          //       });
                          //     }),
                          CachedNetworkImage(
                            imageUrl: room.roomPhoto,
                            fit: BoxFit.fitHeight,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      room.name,
                                      style: const TextStyle(
                                          color: Color(0xff10644D),
                                          fontWeight: FontWeight.w700),
                                    )),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      NumberFormatter.formatCurrencyWithCode(double.tryParse(room.price) ?? 0, 'USD'),
                                      style: const TextStyle(color: Colors.red),
                                    )),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 4),
                                //   child: Text(
                                //     "children:${room.children}, adults:${room.adults}, beds:${room.bed}",
                                //     style: const TextStyle(
                                //         color: Color(0xff78828A)),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
      // bottomNavigationBar: SafeArea(child: Padding(
      //   padding: const EdgeInsets.all(15.0),
      //   child: ElevatedButton(onPressed: (){
      //
      //     if(_room == null){
      //       return;c
      //     }
      //
      //     // push(
      //     //     HotelBookingForm(hotel: widget.hotel,room: _room!,filterOption: widget.filterOption,
      //     //     ));
      //   },style: ElevatedButton.styleFrom(
      //     shape: const RoundedRectangleBorder()
      //   ), child: const Text("Reserve",style: TextStyle(color: Colors.white),)),
      // )),
    );
  }

  roundedContainer(IconData iconData, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: const Color(0xcbebf8ef),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Theme.of(context).primaryColor,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
