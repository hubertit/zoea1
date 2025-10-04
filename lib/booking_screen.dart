import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/booking_alert_dialog.dart';
import 'package:zoea1/partial/facility_item.dart';
import 'package:zoea1/partial/place_list_item.dart';
import 'package:zoea1/super_base.dart';

import 'json/facility.dart';
import 'json/place.dart';

class BookingScreen extends StatefulWidget {
  final Place place;
  const BookingScreen({super.key, required this.place});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends Superbase<BookingScreen> {
  var now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Hotel"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text(
            "Customer Info",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "Name",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff78828A)),
                )),
                Text(
                  "Hubert",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "Email",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff78828A)),
                )),
                Text(
                  "example@gmail.com",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Order Info",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          PlaceListItem(
            place: widget.place,
            padding: const EdgeInsets.only(top: 10),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.place.title,
                        style: Theme.of(context)
                            .appBarTheme
                            .titleTextStyle
                            ?.copyWith(fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            RichText(
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
                            ])),
                            const SizedBox(
                              width: 50,
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
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: Facility.items
                  .map((e) => Expanded(
                        child: FacilityItem(facility: e),
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Stay Time",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(platform: TargetPlatform.android),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Check In",
                          style:
                              TextStyle(color: Color(0xff78828A), fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: DateTimeField(
                            mode: DateTimeFieldPickerMode.date,
                            onChanged: (s) {
                              setState(() {
                                now = s!;
                              });
                            },
                            // selectedDate: now
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Check Out",
                          style:
                              TextStyle(color: Color(0xff78828A), fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: DateTimeField(
                              mode: DateTimeFieldPickerMode.date,
                              onChanged: (s) {
                                setState(() {
                                  now = s!;
                                });
                              },
                              // selectedDate: now
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const BookingAlertDialog());
                },
                child: const Text("Continue")),
          )
        ],
      ),
    );
  }
}
