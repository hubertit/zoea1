import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/ults/style_utls.dart';

import 'json/place.dart';

class BookingScreen2 extends StatefulWidget {
  final Place place;

  const BookingScreen2({super.key, required this.place});

  @override
  State<BookingScreen2> createState() => _BookingScreen2State();
}

class _BookingScreen2State extends Superbase<BookingScreen2> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  final _key = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final guestsController = TextEditingController();

  bool _loading = false;
  int? _size;

  void bookNow() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(
          url: "booking/tableBooking",
          method: "POST",
          data: FormData.fromMap({
            'token': User.user!.token,
            'venue_id': widget.place.id,
            "checkinDate": fmtDate(_checkIn, format: "yyyy-MM-dd"),
            "checkoutDate": fmtDate(_checkOut, format: "yyyy-MM-dd"),
            "checkinTime": fmtDate(_checkIn, format: "hh:mm a"),
            "checkoutTime": "",
            "people": guestsController.text,
            "additional_request": _descController.text
          }),
          onValue: (s, v) {
            if (s['code'] == 200) {
              showMessageSnack(s);
              goBack();
            } else {
              showMessageSnack(s);
            }
          });
      setState(() {
        _loading = false;
      });
    }
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Text(
                            "Make a Reservation",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).appBarTheme.titleTextStyle,
                          ),
                        ),
                        IconButton(
                            onPressed: goBack, icon: const Icon(Icons.close)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Check In",
                            style: TextStyle(
                                color: Color(0xff78828A), fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: DateTimeFormField(
                              validator: validateRequired,
                              mode: DateTimeFieldPickerMode.dateAndTime,
                              decoration: InputDecoration(
                                  hintText: "Check In Date",
                                  border: StyleUtls.commonInputBorder,
                                  filled: true,
                                  fillColor: isDarkTheme(context)
                                      ? Colors.black
                                      : null),
                              onChanged: (s) {
                                setState(() {
                                  _checkIn = s;
                                });
                              },
                              // initialDate: _checkIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "People",
                            style: TextStyle(
                                color: Color(0xff78828A), fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: TextFormField(
                              controller: guestsController,
                              validator: validateNonZero,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  border: StyleUtls.commonInputBorder,
                                  hintText: 'Number of people',
                                  filled: true,
                                  fillColor: isDarkTheme(context)
                                      ? Colors.black
                                      : null),
                              // )
                            ),
                          ),
                        ],
                      ),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 40),
                      child: TextFormField(
                        minLines: 5,
                        maxLines: 7,
                        controller: _descController,
                        decoration: InputDecoration(
                            hintText: "Add special request (optional)",
                            border: StyleUtls.commonInputBorder,
                            filled: true,
                            fillColor:
                                isDarkTheme(context) ? Colors.black : null),
                      ),
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
