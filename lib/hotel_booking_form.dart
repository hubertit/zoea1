//
// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:tarama/json/user.dart';
// import 'package:tarama/json/venue.dart';
// import 'package:tarama/search_field.dart';
// import 'package:tarama/super_base.dart';
// import 'package:tarama/ults/style_utls.dart';
//
// import 'booking_alert_dialog.dart';
// import 'json/hotel.dart';
// import 'json/room.dart';
//
// class HotelBookingForm extends StatefulWidget {
//   final VenueDetail hotel;
//   final Room room;
//   final FilterOption? filterOption;
//
//   const HotelBookingForm({super.key, required this.hotel,required this.room,  this.filterOption});
//
//   @override
//   State<HotelBookingForm> createState() => _HotelBookingFormState();
// }
//
// class _HotelBookingFormState extends Superbase<HotelBookingForm> {
//   final _firstController = TextEditingController();
//   final _lastController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _countryController = TextEditingController();
//   final _key = GlobalKey<FormState>();
//   bool _loading = false;
//   late Country country;
//   final _focusNode = FocusNode();
//
//   @override
//   void initState() {
//     country = CountryService().findByCode("RW")!;
//     _firstController.text = User.user?.fName ?? "";
//     _lastController.text = User.user?.lName ?? "";
//     _emailController.text = User.user?.email ?? "";
//     _phoneController.text = User.user?.phone ?? "";
//     _countryController.text = country.name;
//     super.initState();
//     _focusNode.addListener(() {
//       if(_focusNode.hasFocus) {
//         _focusNode.unfocus();
//         showCountryPicker(context: context, onSelect: (country) {
//           this.country = country;
//           _countryController.text = country.name;
//         });
//       }
//     });
//   }
//
//   void bookHotel() async {
//     if (_key.currentState?.validate() ?? false) {
//       setState(() {
//         _loading = true;
//       });
//
//       await ajax(
//           url: "hotels/reservation",
//           method: "POST",
//           map: {
//             "title": "",
//             "fname": _firstController.text,
//             "lname": _lastController.text,
//             "email": _emailController.text,
//             "phone": _phoneController.text,
//             "checkin": fmtDate2(widget.filterOption?.timeRange.start),
//             "checkout": fmtDate2(widget.filterOption?.timeRange.end),
//             "rooms": widget.filterOption?.roomOption.rooms,
//             "adults": widget.filterOption?.roomOption.adults,
//             "children": widget.filterOption?.roomOption.children,
//             "token": "tokenuniqueme"
//           },
//           onValue: (obj, url) async {
//             if(obj == null){
//               return;
//             }
//
//             if(obj['code'] == 200){
//               await showDialog(context: context, builder: (context)=>const BookingAlertDialog());
//               goBack();
//               goBack();
//               showMessageSnack(obj);
//             }
//             // showSnack("");
//           });
//       setState(() {
//         _loading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // _loading = false;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Book a Hotel"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _key,
//           child: Theme(
//             data: Theme.of(context).copyWith(
//               platform: TargetPlatform.android,
//               inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.zero,
//                   borderSide: BorderSide(
//                     color: Colors.grey.shade300
//                   )
//                 )
//               )
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text("First Name *"),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: TextFormField(
//                     controller: _firstController,
//                     validator: validateName,
//                     decoration:  InputDecoration(hintText: "First Name",border: StyleUtls.commonInputBorder),
//                   ),
//                 ),
//                 const Text("Last Name *"),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: TextFormField(
//                     controller: _lastController,
//                     decoration:  InputDecoration(hintText: "Last Name",border: StyleUtls.commonInputBorder),
//                     validator: validateName,
//                   ),
//                 ),
//                 const Text("Email Address *"),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: TextFormField(
//                     controller: _emailController,
//                     decoration:  InputDecoration(hintText: "Email Address",border: StyleUtls.commonInputBorder),
//                     validator: validateEmail,
//                   ),
//                 ),
//                 // const Text("Number of Rooms *"),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(vertical: 10),
//                 //   child: TextFormField(
//                 //     controller: _roomNumberController,
//                 //     decoration:
//                 //         const InputDecoration(hintText: "Number of Rooms"),
//                 //     validator: validateRequired,
//                 //   ),
//                 // ),
//                 // const Text("Ask a Question *"),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(vertical: 10),
//                 //   child: TextFormField(
//                 //     controller: _questionController,
//                 //     decoration: const InputDecoration(hintText: "Ask Question"),
//                 //   ),
//                 // ),
//                 const Text("Country *"),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: TextFormField(
//                     focusNode: _focusNode,
//                     controller: _countryController,
//                     decoration:  InputDecoration(hintText: "Country",border: StyleUtls.commonInputBorder),
//                     validator: validateRequired,
//                   ),
//                 ),
//
//                 const Text("Phone *"),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: TextFormField(
//                     controller: _phoneController,
//                     decoration:  InputDecoration(hintText: "Phone",border: StyleUtls.commonInputBorder),
//                     validator: validateMobile,
//                   ),
//                 ),
//                 // const Text("Reason *"),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(vertical: 10),
//                 //   child: TextFormField(
//                 //     controller: _reasonController,
//                 //     decoration: const InputDecoration(hintText: "Reason"),
//                 //     validator: validateRequired,
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 10),
//                 //   child: DropdownButtonFormField<Room>(
//                 //     items: widget.hotel.rooms
//                 //         .map(
//                 //           (e) => DropdownMenuItem(
//                 //             value: e,
//                 //             child: Text(e.name),
//                 //           ),
//                 //         )
//                 //         .toList(),
//                 //     onChanged: (val) {
//                 //       setState(() {
//                 //         _room = val;
//                 //       });
//                 //     },
//                 //     value: _room,
//                 //     decoration: const InputDecoration(hintText: "Select Room"),
//                 //     validator: validateRequired,
//                 //   ),
//                 // ),
//                 // const Text("Booking From *"),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(vertical: 10),
//                 //   child: DateTimeFormField(
//                 //     onDateSelected: (s) {
//                 //       setState(() {
//                 //         _bookFrom = s;
//                 //       });
//                 //     },
//                 //     validator: validateRequired,
//                 //     initialValue: _bookFrom,
//                 //     decoration: const InputDecoration(hintText: "Book From"),
//                 //   ),
//                 // ),
//                 // const Text("Booking To *"),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 10),
//                 //   child: DateTimeFormField(
//                 //     onDateSelected: (s) {
//                 //       setState(() {
//                 //         _bookTo = s;
//                 //       });
//                 //     },
//                 //     validator: validateRequired,
//                 //     initialValue: _bookTo,
//                 //     decoration: const InputDecoration(hintText: "Book To"),
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 20),
//                 //   child: _loading
//                 //       ? const Center(
//                 //           child: CircularProgressIndicator(),
//                 //         )
//                 //       : ElevatedButton(
//                 //     style: ElevatedButton.styleFrom(
//                 //       shape: const RoundedRectangleBorder()
//                 //     ),
//                 //           onPressed: bookHotel, child: const Text("Book Hotel",style: TextStyle(color: Colors.white),)),
//                 // )
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: ElevatedButton(
//                 onPressed: bookHotel,
//                 style: ElevatedButton.styleFrom(elevation: 0,
//                     shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
//                 child: const Text(
//                   "Book Hotel",
//                   style: TextStyle(color: Colors.white),
//                 )),
//           )),
//     );
//   }
// }

import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/homepage.dart';
import 'package:zoea1/json/booking_details.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/json/venue.dart';
import 'package:zoea1/search_field.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/style_utls.dart';
import 'package:zoea1/views/payments/payment_updated.dart';
import 'package:zoea1/views/payments/select_payment.dart';

import 'json/place.dart';
import 'json/room.dart';
import 'ults/functions.dart';

class HotelBookingForm extends StatefulWidget {
  final Room room;
  final VenueDetail hotel;
  final FilterOption? filterOption;
  const HotelBookingForm(
      {super.key, required this.room, required this.hotel, this.filterOption});

  @override
  State<HotelBookingForm> createState() => _HotelBookingFormState();
}

class _HotelBookingFormState extends Superbase<HotelBookingForm> {
  DateTime _checkIn = DateTime.now();
  DateTime _checkOut = DateTime.now();

  final _key = GlobalKey<FormState>();
  TextEditingController adultsController = TextEditingController();
  TextEditingController childrenController = TextEditingController();
  TextEditingController roomsController = TextEditingController();

  bool _loading = false;
  int? _size;

  void bookNow() async {
    // print("Rooms ${roomsController.text}");
    // print("Children ${childrenController.text}");
    // print("Adults ${adultsController.text}");
    // print("Checkin ${_checkIn}");
    // print("checkout ${_checkOut}");
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      print(User.user!.token);
      await ajax(
          url: "hotels/reservation",
          method: "POST",
          json: true,
          jsonData: jsonEncode(
            {
              "room_id": widget.room.roomId,
              "rooms": roomsController.text,
              "adults": adultsController.text,
              "children": childrenController.text,
              "checkin": _checkIn.toString(),
              "checkout": _checkOut.toString(),
            },
            // {
            // "room_id":20,
            // "rooms":1,
            // "adults":2,
            // "children":0,
            // "checkin":"2023-06-14 10:00",
            // "checkout":"2023-06-18 10:00"
            // }
          ),
          onValue: (s, v) {
            print("hello");
            if (s['code'] == 200) {
              print(s);
              showMessageSnack(s['message']);
              // push(PaymentMethodScreen(package:s['booking_id'] ,));
              push(PaymentScreenV2(
                bookingOrderDetails:
                    BookingOrderDetails.fromJson(s['order_details']),
              ));
              // print(s);
            } else {
              // print(s);
              showMessageSnack(s);
            }
          });
      setState(() {
        _loading = false;
      });
    }
  }

  // void bookNow() async {
  //   if (_key.currentState?.validate() ?? false) {
  //     setState(() {
  //       _loading = true;
  //     });
  //
  //     final dio = Dio();
  //
  //     // Set up headers
  //     dio.options.headers = {
  //       'Authorization':"Bearer${User.user!.token}" ,
  //       'Content-Type': 'application/json',
  //     };
  //
  //     // Prepare JSON data
  //     final data = {
  //       "room_id": widget.room.roomId,
  //       "rooms": int.parse(roomsController.text),
  //       "adults": int.parse(adultsController.text),
  //       "children": int.parse(childrenController.text),
  //       "checkin": _checkIn.toIso8601String(),
  //       "checkout": _checkOut.toIso8601String(),
  //     };
  //
  //     // Debug print to check data
  //     print("Request Data: $data");
  //
  //     try {
  //       final response = await dio.post(
  //         'https://tarama.ai/api/hotels/reservation',
  //         data: data,
  //       );
  //
  //       // Debug print to check response
  //       print("Response: ${response.data}");
  //
  //       if (response.statusCode == 200) {
  //         final responseData = response.data;
  //         if (responseData['code'] == 200) {
  //           showMessageSnack(responseData['message']);
  //         } else {
  //           showMessageSnack(responseData['message']);
  //         }
  //       } else {
  //         showMessageSnack("Error: ${response.statusCode}");
  //       }
  //     } catch (e) {
  //       print("Exception: $e");
  //       showMessageSnack("An error occurred. Please try again.");
  //     }
  //
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    if (widget.filterOption != null) {
      adultsController = TextEditingController(
          text: "${widget.filterOption!.roomOption.adults}");
      childrenController = TextEditingController(
          text: "${widget.filterOption!.roomOption.children}");
      roomsController = TextEditingController(
          text: widget.filterOption!.roomOption.rooms <=
                  num.parse(widget.room.capacity)
              ? "${widget.filterOption!.roomOption.rooms}"
              : "${widget.room.capacity}");
      setState(() {
        _checkIn = widget.filterOption!.timeRange.start;
        _checkOut = widget.filterOption!.timeRange.end;
      });
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(platform: TargetPlatform.android),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              color: isDarkTheme(context) ? semiBlack : scaffoldColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15)
                  .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: goBack, icon: const Icon(Icons.close)),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Text(
                            "Reserve your stay",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).appBarTheme.titleTextStyle,
                          ),
                        ))
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     children: [
                    //       const Text(
                    //         "People",
                    //         style:
                    //             TextStyle(color: Color(0xff78828A), fontSize: 16),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(top: 4),
                    //         child: DropdownButtonFormField<int>(
                    //           items: List.generate(
                    //               20,
                    //               (index) => DropdownMenuItem(
                    //                     value: index + 1,
                    //                     child: Text("${index + 1}"),
                    //                   )),
                    //           validator: validateRequired,
                    //           value: _size,
                    //           onChanged: (size) {
                    //             setState(() {
                    //               _size = size;
                    //             });
                    //           },
                    //           decoration: InputDecoration(
                    //               hintText: "1 Person",
                    //               border: StyleUtls.commonInputBorder),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Check in",
                                  style: TextStyle(
                                      color: Color(0xff78828A), fontSize: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:isDarkTheme(context)? Colors.black:null,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DateTimeFormField(
                                      initialValue: widget.filterOption != null
                                          ? widget.filterOption!.timeRange.start
                                          : null,
                                      validator: validateRequired,
                                      mode: DateTimeFieldPickerMode.dateAndTime,
                                      decoration: InputDecoration(
                                          hintText: "Check in Date",
                                          border: StyleUtls.commonInputBorder),
                                      onChanged: (s) {
                                        setState(() {
                                          _checkIn = s!;
                                        });
                                      },
                                      // initialDate: _checkIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Check out",
                                  style: TextStyle(
                                      color: Color(0xff78828A), fontSize: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:isDarkTheme(context)? Colors.black:null,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DateTimeFormField(
                                      initialValue:
                                          widget.filterOption?.timeRange.end,
                                      validator: validateRequired,
                                      mode: DateTimeFieldPickerMode.dateAndTime,
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          hintText: "Check out Date",
                                          border: StyleUtls.commonInputBorder),
                                      onChanged: (s) {
                                        setState(() {
                                          _checkOut = s!;
                                        });
                                      },
                                      // initialDate: _checkOut,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Adult",
                                  style: TextStyle(
                                      color: Color(0xff78828A), fontSize: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:isDarkTheme(context)? Colors.black:null,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextFormField(
                                      // initialValue:
                                      //     "${widget.filterOption!.roomOption.adults}",
                                      controller: adultsController,
                                      validator: validateNonZero,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                          border: StyleUtls.commonInputBorder,
                                          hintText: 'Number of adult'),
                                      // )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Children",
                                  style: TextStyle(
                                      color: Color(0xff78828A), fontSize: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:isDarkTheme(context)? Colors.black:null,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextFormField(
                                      // initialValue:
                                      //     "${widget.filterOption!.roomOption.children}",
                                      controller: childrenController,
                                      validator: validateRequired,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                          border: StyleUtls.commonInputBorder,
                                          hintText: 'Number of children'),
                                      // )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Number of rooms",
                              style: TextStyle(
                                  color: Color(0xff78828A), fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    color:isDarkTheme(context)? Colors.black:null,
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextFormField(
                                  // initialValue:
                                  //     "${widget.filterOption!.roomOption.rooms}",
                                  controller: roomsController,
                                  validator: (value) {
                                    int people =
                                        int.parse(adultsController.text) +
                                            int.parse(childrenController.text);
                                    if (value == null) {
                                      return "This field is required!!";
                                    } else if (value.isNotEmpty &&
                                        int.parse(value) >
                                            int.parse(widget.room.capacity)) {
                                      return "Only ${widget.room.capacity} rooms available!";
                                    } else if (adultsController.text.isNotEmpty &&
                                        childrenController.text.isNotEmpty) {
                                      if (people >
                                          int.parse(widget.room.capacity)) {
                                        return "Our room can only accomodate ${widget.room.capacity} guests";
                                      }
                                      ;
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      border: StyleUtls.commonInputBorder,
                                      hintText: 'Number of Rooms'),
                                  // )
                                ),
                              ),
                            ),
                          ]),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     children: [
                    //       const Text(
                    //         "Check Out",
                    //         style:
                    //             TextStyle(color: Color(0xff78828A), fontSize: 16),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(top: 4),
                    //         child: DateTimeFormField(
                    //             decoration: const InputDecoration(
                    //                 hintText: "Check Out Date"
                    //             ),
                    //             validator: validateRequired,
                    //             mode: DateTimeFieldPickerMode.dateAndTime,
                    //             onDateSelected: (s) {
                    //               setState(() {
                    //                 _checkOut = s;
                    //               });
                    //             },
                    //             initialDate: _checkOut),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10, bottom: 40),
                    //   child: TextFormField(
                    //     minLines: 5,
                    //     maxLines: 7,
                    //     controller: _descController,
                    //     decoration: InputDecoration(
                    //         hintText: "Add special request (optional)",
                    //         border: StyleUtls.commonInputBorder),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    _loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: User.user == null
                                ? authanticatePlease
                                : bookNow,
                            child: const Text(
                              "Reserve now",
                              style: TextStyle(color: Colors.white),
                            ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
