import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';

import 'search_field.dart';
import 'constants/theme.dart';

class HotelsScreen extends StatefulWidget {
  final String? query;
  final FilterOption? filterOption;

  const HotelsScreen({super.key, this.query, this.filterOption});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends Superbase<HotelsScreen> {
  // final _controller = TextEditingController();

  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.query == null
            ? AppBar(
                elevation: 2,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: isDarkTheme(context)
                    ? null
                    : Theme.of(context).primaryColor,
                title: const Text("Accommodation",
                    style: TextStyle(color: Colors.white)),
              )
            : null,
        body: ListView(
          children: [
            // Stack(
            //   children: [
            //     Image.asset("assets/sea.png",fit: BoxFit.cover,width: double.infinity,),
            //     const Positioned.fill(child: Padding(
            //       padding: EdgeInsets.all(30.0),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Text("Search for Hotels",style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.w600,
            //             fontSize: 24
            //           ),),
            //           Text("Discover accommodations of your choice in every corner of the country.",textAlign: TextAlign.center,style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.w300,
            //             fontSize: 17
            //           ),),
            //         ],
            //       ),
            //     ))
            //   ],
            // ),
            Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color:isDarkTheme(context)?Colors.white12: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                elevation: 3,
                child: FilteringOptions(
                  hideButtons: true,
                  filterOption: widget.filterOption,
                  callback: (option) {
                    goBack(option);
                  },
                )),
            // const Card(
            //   margin: EdgeInsets.all(16),
            //   child: Padding(
            //     padding: EdgeInsets.all(20.0),
            //     child: Row(
            //       children: [
            //         Icon(Icons.check_circle_rounded,size: 30,),
            //         Expanded(
            //           child: Padding(
            //             padding: EdgeInsets.only(left: 10),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.stretch,
            //               children: [
            //                 Text("Book Now , Pay Later",style: TextStyle(
            //                   fontSize: 17,
            //                   fontWeight: FontWeight.w500
            //                 ),),
            //                 Text("With free cancellation on most rooms",style: TextStyle(
            //                   fontSize: 14
            //                 ),)
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ));
  }
}
