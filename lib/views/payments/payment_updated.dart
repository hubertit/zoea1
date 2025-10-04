import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/booking_details.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/views/payments/sucess_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreenV2 extends StatefulWidget {
  final BookingOrderDetails bookingOrderDetails;
  const PaymentScreenV2({super.key, required this.bookingOrderDetails});

  @override
  State<PaymentScreenV2> createState() => _PaymentScreenV2State();
}

class _PaymentScreenV2State extends Superbase<PaymentScreenV2> {
  @override
  Widget build(BuildContext context) {
    print(User.user?.token);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Booking Details"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: isDarkTheme(context) ? semiBlack : Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(
                        image: CachedNetworkImageProvider(
                          widget.bookingOrderDetails.roomPhoto,
                        ),
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
                                widget.bookingOrderDetails.roomType,
                                style: const TextStyle(
                                    // color: textsColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            // Icon(
                            //   item.isFavorite == 0
                            //       ? Icons.favorite_border
                            //       : Icons.favorite,
                            //   size: 15,
                            //   color: item.isFavorite == 1
                            //       ? Colors.red
                            //       : null,
                            // )
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        // Row(children:List.generate(
                        //     6,
                        //         (index) => index == 5
                        //         ?

                        //         : Icon(
                        //       index <
                        //           num.parse(
                        //               item.venueRating)
                        //           ? Icons.star
                        //           : Icons.star_border,
                        //       color: Colors.amber,size: 18,
                        //     )) ,),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 0),
                        //   child: Text(
                        //     "${item.availableRooms} rooms left",
                        //     style: const TextStyle(fontSize: 14),
                        //   ),
                        // ),
                        Text(widget.bookingOrderDetails.address,
                            style: const TextStyle(fontSize: 12)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                "US\$ ${widget.bookingOrderDetails.roomPrice}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: isDarkTheme(context)
                                        ? null
                                        : primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                "Per night",
                                // style: TextStyle(
                                //     fontSize: 16,
                                //     color: primaryColor,
                                //     fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   children: List.generate(
                        //       4,
                        //           (index) => const Icon(
                        //         Icons.star_outline,
                        //         color: Color(0xffbd8907),
                        //       )),
                        // )
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
          Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.only(top: 0.2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Check-in",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "${widget.bookingOrderDetails.checkin}"
                                      .substring(0, 10),
                                  style: TextStyle(
                                      color: isDarkTheme(context)
                                          ? null
                                          : primaryColor,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 1,
                                color: isDarkTheme(context)
                                    ? Colors.white
                                    : Colors.black,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Check-out",
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "${widget.bookingOrderDetails.checkout}"
                                          .substring(0, 10),
                                      style: TextStyle(
                                          color: isDarkTheme(context)
                                              ? null
                                              : primaryColor,
                                          fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rooms & guests",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.bookingOrderDetails.rooms} rooms | ${widget.bookingOrderDetails.adults} Adults | ${widget.bookingOrderDetails.children} Children",
                          style: TextStyle(
                              color: isDarkTheme(context) ? null : primaryColor,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.only(top: 0.2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Order summary",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            "US\$",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("Sub total"),
                          Spacer(),
                          Text("\$ ${widget.bookingOrderDetails.subtotal}")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("Fees"),
                          Spacer(),
                          Text("\$ ${widget.bookingOrderDetails.fees}")
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("Tax"),
                          Spacer(),
                          Text("\$ ${widget.bookingOrderDetails.tax}"),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("Total"),
                          Spacer(),
                          Text(
                            "\$ ${widget.bookingOrderDetails.total}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ]),
              ),
            ),
          ),

          // const CoverContainer(children: [
          //   Text("Order summary",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          //   Row(children: [
          //     Text("Sub total"),
          //     Spacer(),
          //     Text("\$100")
          //   ],),
          //   Row(children: [
          //     Text("Fees"),
          //     Spacer(),
          //     Text("\$5")
          //   ],),
          //   Row(children: [
          //     Text("Tax"),
          //     Spacer(),
          //     Text("\$15")
          //   ],),
          //   Divider(),
          //   Row(children: [
          //     Text("Sub total"),
          //     Spacer(),
          //     Text("\$100",style: TextStyle(fontWeight: FontWeight.bold),)
          //   ],)
          // ])
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse(widget.bookingOrderDetails.paymentUrl));
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SuccessScreen()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            child: const Text(
              "Pay now",
              style: TextStyle(color: Colors.white),
            )),
      )),
    );
  }
}
