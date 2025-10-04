import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/json/service.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/json/venue.dart';
import 'package:zoea1/partial/place_list_item.dart';
import 'package:zoea1/service_detail_screen.dart';
import 'package:zoea1/super_base.dart';

import 'constants/theme.dart';
import 'hotel_details_screen_v2.dart';
import 'json/booking.dart';
import 'main.dart';
import 'ults/functions.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends Superbase<BookingListScreen> {
  final _key = GlobalKey<RefreshIndicatorState>();

  List<Booking> _list = [];

  Future<void> loadData() {
    return ajax(
        url: "booking/mybookings",
        method: "POST",
        onValue: (obj, url) {

          setState(() {
            _list = (obj['venues'] as Iterable?)
                    ?.map((e) => Booking.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // reload();
      loadData();
    });
    super.initState();
  }

  void reload() {
    _key.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    print(User.user!.token);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
      ),
      body: RefreshIndicator(color: refleshColor,
        key: _key,
        onRefresh: loadData,
        child: ListView.builder(
          // separatorBuilder: (context, index) => const Divider(
          //   height: 0.2,
          //   color: Colors.grey,
          // ),
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            var item = _list[index];
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 3, left: 2, right: 2, bottom: 20),
                  margin: const EdgeInsets.only(bottom: 0, top: 5),
                  decoration: BoxDecoration(
                      color:isDarkTheme(context)?semiBlack: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                    onTap: () {


                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image(
                              image:
                                  CachedNetworkImageProvider(item.venueImage),
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
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.venueName,
                                      style: TextStyle(
                                          color:isDarkTheme(context)?null: textsColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  // Icon(item.isFavorite==0?
                                  // Icons.favorite_border:Icons.favorite,
                                  //   size: 15,
                                  //   color:item.isFavorite==1?Colors.red:null ,
                                  // )
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),

                              BookingRow(
                                  attribute: "Booking:  ",
                                  value: "${item.bookingTime}"),
                              BookingRow(
                                  attribute: "Check-In:  ",
                                  value:
                                      "${item.checkinDate} ${item.checkinTime}"),
                              BookingRow(
                                  attribute: "Guests:  ",
                                  value:
                                      "${int.parse(item.adults) + int.parse(item.children)}"),

                              if (item.checkoutTime != null &&
                                  item.checkoutDate != null)
                                BookingRow(
                                    attribute: "Check-Out:  ",
                                    value:
                                        "${item.checkoutDate} ${item.checkoutTime}"),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(vertical: 5),
                              //   child: Text(
                              //     "\$ ${item.venuePrice}",style:  TextStyle(fontSize: 16,color: primaryColor,fontWeight: FontWeight.bold),),
                              // ),
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
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: item.bookingStatus == 'Pending'
                                ? const Color(0xffFFF4A3)
                                : item.bookingStatus == 'Cancelled'
                                    ? const Color(0xffFEEFF1)
                                    : Colors.black,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10))),
                        child: Text(
                          '${item.bookingStatus}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500,fontSize: 12),
                        ))),
              ],
            );
            InkWell(
              onTap: () {
                // push(HotelDetailsScreenV2(venueId: _list[index].venueId));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: item.venueImage,
                        height: 120,
                        width: 170,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            item.venueName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 4),
                          //   child: Text(item.venueAddress),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              item.currency,
                              style: const TextStyle(
                                  color: Color(0xffD30808),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: List.generate(
                                  6,
                                  (index) => index == 5
                                      ? const Expanded(
                                          child: Text(
                                          "30 Reviews",
                                          textAlign: TextAlign.end,
                                        ))
                                      : Icon(
                                          index < num.parse(item.venueRating)
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                        )),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
          },
          itemCount: _list.length,
        ),
      ),
      // RefreshIndicator(
      //   key: _key,
      //   onRefresh: loadData,
      //   child: _list.isEmpty
      //       ? Center(
      //           child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             const Text("No Booked places !"),
      //             TextButton.icon(
      //                 icon: const Icon(Icons.refresh),
      //                 onPressed: reload,
      //                 label: const Text("Refresh"))
      //           ],
      //         ))
      //       : ListView.builder(
      //           itemBuilder: (context, index) {
      //             var item = _list[index];
      //             return Card(
      //               clipBehavior: Clip.antiAliasWithSaveLayer,
      //               child: InkWell(
      //                 onTap: () {},
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.stretch,
      //                     children: [
      //                       Row(
      //                         children: [
      //                           Expanded(
      //                               child: Text(
      //                             item.venueName,
      //                             style: const TextStyle(
      //                                 color: Color(0xff78828A), fontSize: 15),
      //                           )),
      //                           Chip(
      //                             label: Text(
      //                               item.venuePrice,
      //                               style: const TextStyle(
      //                                   color: Color(0xffFF784B)),
      //                             ),
      //                             backgroundColor: const Color(0xffFFF2ED),
      //                           )
      //                         ],
      //                       ),
      //                       // PlaceListItem(
      //                       //   place: item.venueAddress,
      //                       //   imageHeight: 90,
      //                       //   fromBooking: true,
      //                       //   padding:
      //                       //       const EdgeInsets.symmetric(horizontal: 0),
      //                       // ),
      //                       // Padding(
      //                       //   padding: const EdgeInsets.only(top: 10),
      //                       //   child: Row(
      //                       //     children: [
      //                       //       Expanded(child: Column(
      //                       //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //                       //         children: [
      //                       //           const Text("Total Price",style: TextStyle(
      //                       //             fontSize: 16,
      //                       //             color: Color(0xff78828A)
      //                       //           ),),
      //                       //           Text(item.place.currency,style: Theme.of(context).appBarTheme.titleTextStyle,)
      //                       //         ],
      //                       //       )),
      //                       //       OutlinedButton(onPressed: (){},style: OutlinedButton.styleFrom(
      //                       //         side: const BorderSide(
      //                       //           color: Color(0xff10644D)
      //                       //         ),
      //                       //         shape: RoundedRectangleBorder(
      //                       //           borderRadius: BorderRadius.circular(24)
      //                       //         )
      //                       //       ), child: const Text("Details"),)
      //                       //     ],
      //                       //   ),
      //                       // )
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //           itemCount: _list.length,
      //         ),
      // ),
    );
  }
}

class BookingRow extends StatelessWidget {
  final String attribute;
  final String value;
  const BookingRow({super.key, required this.attribute, required this.value});

  @override
  Widget build(BuildContext context) {
    const bookingsColor = Color(0xff696969);
    return Row(
      children: [
        Expanded(
          child: Text(
            attribute,
            style: const TextStyle(fontWeight: FontWeight.bold, color: bookingsColor),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, color: bookingsColor),
        )
      ],
    );
  }
}
