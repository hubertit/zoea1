import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/real_estate.dart';
import 'package:zoea1/main.dart';

import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';

class EstateDetailsScreen extends StatefulWidget {
  final Property property;
  const EstateDetailsScreen({super.key, required this.property});

  @override
  State<EstateDetailsScreen> createState() => _EstateDetailsScreenState();
}

class _EstateDetailsScreenState extends Superbase<EstateDetailsScreen> {
  List<Property> _list = [];
  final _key = GlobalKey<RefreshIndicatorState>();
  bool loading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    // Call loadData immediately
    loadData();
    // Set up a Timer to call loadData every second
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   loadData();
    // });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadData() {
    return ajax(
        url: "realestate/",
        method: "POST",
        onValue: (obj, url) {
          setState(() {
            _list = (obj['properties'] as Iterable?)
                    ?.map((e) => Property.fromJson(e))
                    .toList() ??
                [];
            loading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.property;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.property.title),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.black)),
                  child: const Icon(Icons.edit,size: 15,)))
        ],
      ),
      body: RefreshIndicator(
          color: refleshColor,
          key: _key,
          onRefresh: loadData,
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: isDarkTheme(context) ? Colors.white : primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    // height: 400,
                    clipBehavior: Clip.antiAlias,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.asset(AssetsUtils.event),
                        Stack(
                          children: [
                            Image.network(
                              widget.property.photoUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                bottom: 15,
                                left: 15,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                      "For ${widget.property.propertyType}"),
                                ))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                widget.property.address,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.bed,
                                      ),
                                      Text(
                                        "${item.bedrooms}",
                                        style: TextStyle(color: smallTextColor),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.bath,
                                      ),
                                      Text(
                                        "${item.bathrooms}",
                                        style: TextStyle(color: smallTextColor),
                                      )
                                    ],
                                  ),
                                  if (item.size.isNotEmpty)
                                    Column(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.square,
                                        ),
                                        Text(
                                          "${item.size}",
                                          style:
                                              TextStyle(color: smallTextColor),
                                        )
                                      ],
                                    ),
                                  Column(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.car,
                                      ),
                                      Text(
                                        "${item.parkingSpaces}",
                                        style: TextStyle(color: smallTextColor),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text(
                                "Description",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Text(
                                widget.property.description,
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    Text("Posted on:"),
                                    Text(
                                      "${widget.property.listingDate}",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
