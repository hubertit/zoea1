import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/favorites_screen.dart';
import 'package:zoea1/hotel_details_screen_v2.dart';
import 'package:zoea1/hotel_map_details.dart';
import 'package:zoea1/hotels_screen.dart';
import 'package:zoea1/json/venue.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/search_field.dart';
import 'package:zoea1/super_base.dart';

import 'event_details_screen.dart';
import 'json/hotel.dart';
import 'ults/functions.dart';

class HotelListView extends StatefulWidget {
  final FilterOption? filterOption;

  const HotelListView({super.key, this.filterOption});

  @override
  State<HotelListView> createState() => _HotelListViewState();
}

class _HotelListViewState extends Superbase<HotelListView> {
  final _key = GlobalKey<RefreshIndicatorState>();
  final _focusNode = FocusNode();
  List<Venue> _list = [];
  bool _loading = false;
  FilterOption? _filterOption;

  String? _sort;

  Future<void> loadData() async {
    setState(() {
      _loading = true;
    });
    await ajax(
        url:
            "https://zoea.africa/api/hotels/filter?name=${_filterOption!.query}&priceFrom=${_filterOption!.rangeValues.start}&priceTo=${_filterOption!.rangeValues.end}&checkIn=${_filterOption!.timeRange.start}&checkOut=${_filterOption!.timeRange.end}&rooms=${_filterOption!.roomOption.rooms}&adults=${_filterOption!.roomOption.adults}&children=${_filterOption!.roomOption.children}",
        absolutePath: true,
        // https://tarama.ai/api/hotels/filter?name=Kigali&priceFrom=20&priceTo=100&checkIn=2024-02-29&checkOut=2024-03-01&rating=4&rooms=1&adults=1&children=0
        // method: "POST",
        // data: FormData.fromMap({
        //   "sort":_sort
        // }),
        onValue: (obj, url) {
          if (obj is Map) {
            print(obj);
            setState(() {
              _list = (obj['venues'] as Iterable)
                  .map((e) => Venue.fromJson(e))
                  .toList();
            });
          } else {
            setState(() {
              _list = [];
            });
          }
        });
    setState(() {
      _loading = false;
    });
    return Future.value();
  }

  @override
  void initState() {
    _filterOption = widget.filterOption;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // reload();
      loadData();
    });
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    });
  }

  void reload() {
    _key.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.filterOption!.timeRange);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: Theme.of(context)
            .appBarTheme
            .titleTextStyle
            ?.copyWith(color: Colors.white),
        title: Text(
            "${_filterOption?.query ?? ""} ${fmtDate(_filterOption?.timeRange.start, format: "dd MMM")} - ${fmtDate(_filterOption?.timeRange.end, format: "dd MMM")}"),
        backgroundColor:isDarkTheme(context)?null: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          _loading ? const LinearProgressIndicator() : const SizedBox.shrink(),
          Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            child: Row(
              children: [
                Expanded(
                    child: TextButton.icon(
                        onPressed: () async {
                          var a = await showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "Sorting",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () =>
                                          Navigator.pop(context, "price_asc"),
                                      leading: const Icon(Icons.sort),
                                      title: const Text("Price (Low - High)"),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.sort),
                                      onTap: () =>
                                          Navigator.pop(context, "price_desc"),
                                      title: const Text("Price (High - Low)"),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.sort),
                                      onTap: () =>
                                          Navigator.pop(context, "rating_desc"),
                                      title: const Text("Rating (High - Low)"),
                                    ),
                                  ],
                                );
                              });

                          if (a is String) {
                            setState(() {
                              _sort = a;
                              loadData();
                            });
                          }
                        },
                        icon: const Icon(Icons.sort),
                        label: const Text("Sort"))),
                Expanded(
                    child: TextButton.icon(
                        onPressed: () {
                          push(HotelsScreen(
                            filterOption: _filterOption,
                          )).then((value) {
                            if (value != null && value is FilterOption) {
                              setState(() {
                                _filterOption = value;
                                reload();
                              });
                            }
                          });
                        },
                        icon: const Icon(Icons.filter_list_alt),
                        label: const Text("Filter"))),
                Expanded(
                    child: TextButton.icon(
                        onPressed: () {
                          push(const FavoritesScreen());
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text("Favorite"))),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: refleshColor,
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 2),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        decoration: BoxDecoration(
                            color:isDarkTheme(context)?semiBlack: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: InkWell(
                          onTap: () {
                            push(HotelDetailsScreenV2(
                              venueId: "${_list[index].venueId}",
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
                                    image: CachedNetworkImageProvider(
                                        item.venueImage),
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.fitHeight,
                                  )),
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                        Icon(
                                          item.isFavorite == 0
                                              ? Icons.favorite_border
                                              : Icons.favorite,
                                          size: 15,
                                          color: item.isFavorite == 1
                                              ? Colors.red
                                              : null,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    // Row(children:List.generate(
                                    //     6,
                                    //         (index) => index == 5
                                    //         ?
                                    Text(
                                      "${item.venueReviews} Reviews",
                                      // textAlign: TextAlign.end,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    //         : Icon(
                                    //       index <
                                    //           num.parse(
                                    //               item.venueRating)
                                    //           ? Icons.star
                                    //           : Icons.star_border,
                                    //       color: Colors.amber,size: 18,
                                    //     )) ,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0),
                                      child: Text(
                                        "${item.availableRooms} rooms left",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Text("${item.venueCoordinates}",
                                        style: const TextStyle(fontSize: 12)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        item.currency,
                                        style:  TextStyle(
                                            fontSize: 16,
                                            color:isDarkTheme(context)?null: primaryColor,
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
                      ),
                      if (item.breakfastIncluded == '1')
                        Positioned(
                            right: 0,
                            bottom: 5,
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10))),
                                child: const Text(
                                  'Breakfast included',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ))),
                    ],
                  );
                  InkWell(
                    onTap: () {
                      push(HotelDetailsScreenV2(venueId: _list[index].venueId));
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                                                index <
                                                        num.parse(
                                                            item.venueRating)
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
          ),
        ],
      ),
    );
  }
}

// Expanded(
//   child: RefreshIndicator(
//     key: _key,
//     onRefresh: loadData,
//     child: ListView.separated(
//       separatorBuilder: (context, index) => const Divider(
//         height: 0.5,
//         color: Colors.grey,
//       ),
//       padding: const EdgeInsets.all(10),
//       itemBuilder: (context, index) {
//         var item = _list[index];
//         return InkWell(
//           onTap: () {
//             push(HotelDetailsScreenV2(venueId: _list[index].venueId));
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(5),
//                   child: CachedNetworkImage(
//                     imageUrl: item.venueImage,
//                     height: 120,
//                     width: 170,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Expanded(
//                     child: Padding(
//                   padding: const EdgeInsets.only(left: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         item.venueName,
//                         style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       // Padding(
//                       //   padding: const EdgeInsets.only(top: 4),
//                       //   child: Text(item.venueAddress),
//                       // ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 4),
//                         child: Text(
//                           "US\$ ${fmtNbr(num.tryParse(item.venuePrice))}",
//                           style: const TextStyle(
//                               color: Color(0xffD30808),
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 4),
//                         child: Row(
//                           children: List.generate(
//                               6,
//                               (index) => index == 5
//                                   ? const Expanded(
//                                       child: Text(
//                                       "30 Reviews",
//                                       textAlign: TextAlign.end,
//                                     ))
//                                   : Icon(
//                                       index <
//                                               num.parse(
//                                                   item.venueRating)
//                                           ? Icons.star
//                                           : Icons.star_border,
//                                       color: Colors.amber,
//                                     )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ))
//               ],
//             ),
//           ),
//         );
//       },
//       itemCount: _list.length,
//     ),
//   ),
// ),
