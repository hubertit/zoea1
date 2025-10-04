import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoea1/real_estate.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'constants/theme.dart';

import 'search_field.dart';

class RealEstateSearch extends StatefulWidget {
  final String? query;
  final FilterOption? filterOption;

  const RealEstateSearch({super.key, this.query, this.filterOption});

  @override
  State<RealEstateSearch> createState() => _RealEstateSearchState();
}
// https://tarama.ai/api/realestate/filter?address=kigali&type=sale&category=house&rooms=2&priceFrom=100000&priceTo=300000
class _RealEstateSearchState extends Superbase<RealEstateSearch> {
  var now = DateTime.now();
  List<String> offerTipe = ['Rent', "Sale"];
  List<String> propertyType = [
    'House',
    "Apartment",
    "Shared room",
    'Warehouse',
    'Land',
  ];
  List<String> rooms = [
    '1 room',
    "2 rooms",
    '3-5 rooms',
    "6-8 rooms",
    "8+ rooms"
  ];
  List<String> prices = [
    'Under 100k',
    "100-200k",
    '200k-300k',
    "300k-400k",
    '400k-600k',
    '600k-800k',
    '800k-1M',
    'Above 1M'
  ];
  List<String> furnished = ["Yes", "No"];
  String? selectedOffer;
  String? selectedPropertyType;
  String? selectedRoomsNumber;
  String? selectedFurnished;
  String? selectedPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.query == null
            ? AppBar(
                elevation: 2,
                iconTheme: const IconThemeData(color: kWhite),
                backgroundColor: isDarkTheme(context)
                    ? null
                    : Theme.of(context).primaryColor,
                title: const Text("Real estate",
                    style: TextStyle(color: kWhite)),
              )
            : null,
        body: ListView(
          children: [
            Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(5)),
                elevation: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextFormField(
                        // controller: _controller,
                        decoration: const InputDecoration(
                            filled: false,
                            prefixIcon: Icon(Icons.search),
                            hintText: "Address: province,districts, etc"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: kGrayLight))),
                      child: Row(
                        children: [
                          Expanded(
                              child: DropdownButtonFormField<String>(
                            hint: Text("Offer type"),
                            items: List.generate(
                                offerTipe.length,
                                (index) => DropdownMenuItem(
                                    value: offerTipe[index],
                                    child: Text("${offerTipe[index]}"))),
                            // value: _values0.start,
                            onChanged: (value) {
                              setState(() {
                                selectedOffer = value;
                              });
                            },
                            decoration: const InputDecoration(
                              filled: false,
                            ),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: DropdownButtonFormField<String>(
                            hint: const Text("Property type"),
                            items: List.generate(
                                propertyType.length,
                                (index) => DropdownMenuItem(
                                    value: propertyType[index],
                                    child: Text(propertyType[index]))),
                            // value: _values0.start,
                            onChanged: (value) {
                              setState(() {
                                selectedPropertyType = value;
                              });
                            },
                            decoration: const InputDecoration(
                              filled: false,
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: kGrayLight))),
                      child: Row(
                        children: [
                          Expanded(
                              child: DropdownButtonFormField<String>(
                            hint: Text("Rooms"),
                            items: List.generate(
                                rooms.length,
                                (index) => DropdownMenuItem(
                                    value: rooms[index],
                                    child: Text("${rooms[index]}"))),
                            // value: _values0.start,
                            onChanged: (value) {
                              setState(() {
                                selectedRoomsNumber = value;
                              });
                            },
                            decoration: const InputDecoration(
                              filled: false,
                            ),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: DropdownButtonFormField<String>(
                            hint: const Text("Furnished"),
                            items: List.generate(
                                furnished.length,
                                (index) => DropdownMenuItem(
                                    value: furnished[index],
                                    child: Expanded(
                                        child: Text(furnished[index])))),
                            // value: _values0.start,
                            onChanged: (value) {
                              setState(() {
                                selectedFurnished = value;
                              });
                            },
                            decoration: const InputDecoration(
                              filled: false,
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: kGrayLight))),
                      child: DropdownButtonFormField<String>(
                        hint: const Text("Price"),
                        items: List.generate(
                            prices.length,
                            (index) => DropdownMenuItem(
                                value: prices[index],
                                child: Expanded(child: Text(prices[index])))),
                        // value: _values0.start,
                        onChanged: (value) {
                          setState(() {
                            selectedPrice = value;
                          });
                        },
                        decoration: const InputDecoration(
                          filled: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder()),
                          onPressed: () {
                            // widget.callback?.call(FilterOption(
                            //     _dateTime, _option, _rating ?? 0, _values0,
                            //     query: _controller.text)
                            // );
                            push(RealEstateScreen());
                          },
                          child:
                              // widget.loading
                              //     ? const CupertinoActivityIndicator()
                              //     :
                              Container(
                            width: double.maxFinite,
                            child: const Text(
                              textAlign: TextAlign.center,
                              "Search",
                              style: TextStyle(color: kWhite),
                            ),
                          )),
                    ),
                  ],
                )),
          ],
        ));
  }
}
