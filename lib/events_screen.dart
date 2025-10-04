import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zoea1/constants/apik.dart';
import 'package:zoea1/services/api_key_manager.dart';
import 'package:zoea1/json/event_categories.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/views/events/widgets/event_card.dart';
import 'constants/theme.dart';
import 'event_details_screen.dart';
import 'json/event.dart';
import 'json/user.dart';

class EventsScreen extends StatefulWidget {
  final String id;
  final String catName;

  const EventsScreen({super.key, required this.id, required this.catName});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends Superbase<EventsScreen> {
  final _key = GlobalKey<RefreshIndicatorState>();
  List<Event> _events = [];
  List<EventCategory> _categories = [];
  EventCategory? selectedCategory;
  bool isLoading = true;
  bool isSelected(EventCategory cat) {
    if (selectedCategory != null) {
      if (cat.categoryId == selectedCategory!.categoryId) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reload();
      loadCategories();
      // kwitizinaSnack(context);
    });
  }

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  OverlayEntry? _calendarOverlay;
  void _showCalendarOverlay() {
    _calendarOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight, // Adjust the top position if needed
        left: 0,
        right: 0,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              // height: 30,
              width: MediaQuery.of(context).size.width,
              child: IconButton(
                style: IconButton.styleFrom(
                    backgroundColor:
                        isDarkTheme(context) ? Colors.grey : Colors.black),
                onPressed: () {
                  _removeCalendarOverlay();
                },
                icon: Icon(
                  Icons.close,
                  color: isDarkTheme(context) ? Colors.black : Colors.white,
                ),
              ),
            ),
            Material(
              elevation: 0,
              child: Container(
                color: Theme.of(context).cardColor, // Matches current theme
                padding: const EdgeInsets.all(16),
                child: TableCalendar(
                  focusedDay: focusedDay,
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                    reload();
                    _removeCalendarOverlay(); // Remove the overlay on date selection
                  },
                  // Calendar Style
                  calendarStyle: CalendarStyle(
                    todayDecoration: const BoxDecoration(
                      color: Colors.black, // Customize today's highlight
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.black, // Text color for the selected date
                    ),
                    selectedDecoration: BoxDecoration(
                      color: isDarkTheme(context)
                          ? Colors.grey
                          : scaffoldColor, // Selected date color
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    outsideTextStyle: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .color
                          ?.withOpacity(0.5),
                    ),
                  ),

                  // Header Style
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false, // Remove the "2 Weeks" toggle
                    titleCentered: true, // Center-align title
                    decoration: BoxDecoration(
                      color: isDarkTheme(context)
                          ? Colors.grey
                          : scaffoldColor, // Header background color
                    ),

                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: Colors.black, // Left arrow color
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: Colors.black, // Right arrow color
                    ),

                    titleTextStyle: const TextStyle(
                      color: Colors.black, // Header text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Insert the overlay entry into the Overlay
    Overlay.of(context)?.insert(_calendarOverlay!);
  }

  // Method to remove the calendar overlay
  void _removeCalendarOverlay() {
    _calendarOverlay?.remove();
    _calendarOverlay = null;
  }

  Future<void> loadCategories({bool fromHome = false}) {
    return ajax(
        url: "events/categories",
        method: "POST",
        onValue: (obj, url) {
          // print("Categories ${obj['categories']}");
          setState(() {
            _categories = (obj['categories'] as Iterable?)
                    ?.map((e) => EventCategory.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  Future<void> loadEvents() {
    // setState(() {
    //   isLoading = true;
    // });
    return ajax(
        url: "${baseUrll}events/",
        absolutePath: true,
        onValue: (object, url) {
          setState(() {
            _events = (object['events'] as Iterable)
                .map((e) => Event.fromJson(e))
                .toList();
            isLoading = false;
          });
        });
  }

  Future<void> loadEventsInCategory(id) {
    return ajax(
        // url: "https://tarama.ai/api/events/",
        url: "events/?category_id=${id}",
        absolutePath: true,
        onValue: (object, url) {
          print(object);
          setState(() {
            // print(object);
            _events = (object['events'] as Iterable)
                .map((e) => Event.fromJson(e))
                .toList();
          });
        });
  }

  void reload() {
    _key.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catName),
        actions: [
          if (User.user != null)
            InkWell(
              onTap:
                  //     () {
                  //
                  // }
                  _showCalendarOverlay
              // push(const CreateEventScreen());
              // }
              ,
              child: const Icon(
                Icons.calendar_month,
              ),
            ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: RefreshIndicator(
        color: isDarkTheme(context) ? Colors.white : refleshColor,
        key: _key,
        onRefresh: loadEvents,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 7),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _categories
                            .map((e) => Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color:
                                            isSelected(e) ? isDarkTheme(context)?Colors.white:primaryColor : null,
                                        padding: const EdgeInsets.all(1),
                                        child: Material(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        1000)),
                                            color: isDarkTheme(context)
                                                ? Colors.grey
                                                : Theme.of(context)
                                                    .inputDecorationTheme
                                                    .fillColor,
                                            child: InkWell(
                                              onTap: () {
                                                loadEventsInCategory(
                                                    e.categoryId);
                                                setState(() {
                                                  selectedCategory = e;
                                                });
                                              },
                                              child: SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: isDarkTheme(context)?
                                                        // ? ColorFiltered(
                                                        //     colorFilter:
                                                        //         const ColorFilter
                                                        //             .mode(
                                                        //       Colors
                                                        //           .grey, // Apply white color
                                                        //       BlendMode
                                                        //           .srcATop, // Overlay the color
                                                        //     ),
                                                        //     child:
                                                            Image(
                                                                image: (e.categoryName ==
                                                                            null
                                                                        ? AssetImage(
                                                                            "assets/${e.categoryImage}")
                                                                        : CachedNetworkImageProvider(
                                                                            e.categoryImage))
                                                                    as ImageProvider,
                                                                fit: BoxFit
                                                                    .fitHeight)
                                                          // )
                                                        : Image(
                                                            image: (e.categoryName ==
                                                                        null
                                                                    ? AssetImage(
                                                                        "assets/${e.categoryImage}")
                                                                    : CachedNetworkImageProvider(
                                                                        e.categoryImage))
                                                                as ImageProvider,
                                                            fit: BoxFit
                                                                .fitHeight),
                                                  )),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, right: 10),
                                      child: Text(
                                        e.categoryName,
                                        style: const TextStyle(
                                            // color:isSelected(e)?primaryColor: textsColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  //  Padding(
                  //   padding: EdgeInsets.only(left: 5, top: 20,bottom: 7),
                  //   child: Text(selectedCategory==null?
                  //     "All Events":"${selectedCategory}",
                  //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  //   ),
                  // ),
                  isLoading
                      ? Center(
                          child: Container(
                              padding: EdgeInsets.only(top: 50),
                              child: const CircularProgressIndicator(
                                color: primaryColor,
                              )))
                      : _events.isEmpty
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                      "There is no event in this category"),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var item = _events[index];
                                  return EventCard(
                                    event: item,
                                    callback: () {
                                      push(EventDetailsScreen(event: item));
                                    },
                                  );
                                },
                                itemCount: _events.length,
                              ),
                            ),
                ],
              ),
              // kwitizinaBanner(context)
            ],
          ),
        ),
      ),
    );
  }
}
// Container(
// padding: const EdgeInsets.symmetric(vertical: 10),
// child: InkWell(
// onTap: () {
// push(EventDetailsScreen(event: item));
// },
// child: Padding(
// padding:
// const EdgeInsets.symmetric(horizontal: 10),
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Card(
// shape: RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(10)),
// clipBehavior:
// Clip.antiAliasWithSaveLayer,
// child: Image(
// image: CachedNetworkImageProvider(
// item.poster),
// height: 100,
// width: 100,
// fit: BoxFit.cover,
// )),
// Expanded(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment:
// CrossAxisAlignment.stretch,
// children: [
// Text(
// item.name,
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 18),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// vertical: 8),
// child: Text(
// item.startDate,
// style: const TextStyle(
// color: Color(0xffF2A034),
// fontSize: 17),
// ),
// ),
// RichText(
// text: TextSpan(
// style: const TextStyle(
// color: Colors.black45),
// children: [
// const WidgetSpan(
// child: Icon(
// Icons.location_pin,
// color: Colors.black45,
// size: 17,
// )),
// TextSpan(text: item.address)
// ]))
// ],
// ),
// ))
// ],
// ),
// ),
// ),
// );
//
// Container(
// padding: const EdgeInsets.symmetric(
// vertical: 3, horizontal: 2),
// margin: const EdgeInsets.symmetric(
// horizontal: 10, vertical: 5),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(5)),
// child: InkWell(
// onTap: () {
// push(EventDetailsScreen(event: item));
// },
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Card(
// shape: RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(2)),
// clipBehavior: Clip.antiAliasWithSaveLayer,
// child: Image(
// image: CachedNetworkImageProvider(
// item.poster),
// height: 100,
// width: 100,
// fit: BoxFit.cover,
// )),
// Expanded(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment:
// CrossAxisAlignment.stretch,
// children: [
// Row(
// children: [
// Expanded(
// child: Text(
// item.name,
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 14),
// ),
// ),
// const Icon(
// Icons.more_horiz,
// size: 15,
// )
// ],
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// vertical: 8),
// child: Text(
// "${item.details}",
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// vertical: 8),
// child: Text(
// item.startDate,
// style: const TextStyle(
// color: Color(0xffF2A034),
// fontSize: 17),
// ),
// ),
// RichText(
// text: TextSpan(
// style: const TextStyle(
// color: Colors.black45),
// children: [
// const WidgetSpan(
// child: Icon(
// Icons.location_pin,
// color: Colors.black45,
// size: 17,
// )),
// TextSpan(text: item.address)
// ]))
// ],
// ),
// ))
// ],
// ),
// ),
// );

// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:zoea1/constants/theme.dart';
// import '../json/event.dart';
// import 'event_details_screen.dart';
// import 'json/event_categories.dart';
// import 'json/user.dart';
// import 'main.dart';
// import 'super_base.dart';
//
//
// class EventsScreen extends StatefulWidget {
//   final String id;
//   final String catName;
//
//   const EventsScreen({super.key, required this.id, required this.catName});
//
//   @override
//   State<EventsScreen> createState() => _EventsScreenState();
// }
//
// class _EventsScreenState extends Superbase<EventsScreen> {
//   final _key = GlobalKey<RefreshIndicatorState>();
//   List<Event> _events = [];
//   List<EventCategory> _categories = [];
//   EventCategory? selectedCategory;
//   DateTime selectedDay = DateTime.now();
//   DateTime focusedDay = DateTime.now();
//   OverlayEntry? _calendarOverlay;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       reload();
//       loadCategories();
//     });
//   }
//
//   bool isSelected(EventCategory cat) => selectedCategory?.categoryId == cat.categoryId;
//
//   void _showCalendarOverlay() {
//     _calendarOverlay = OverlayEntry(
//       builder: (context) => Positioned(
//         top: kToolbarHeight,
//         left: 0,
//         right: 0,
//         child: Material(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           child: Container(
//             color: Theme.of(context).cardColor,
//             child: TableCalendar(
//               focusedDay: focusedDay,
//               firstDay: DateTime(2020),
//               lastDay: DateTime(2030),
//               selectedDayPredicate: (day) => isSameDay(selectedDay, day),
//               onDaySelected: (day, focus) {
//                 setState(() {
//                   selectedDay = day;
//                   focusedDay = focus;
//                 });
//                 reload();
//                 _removeCalendarOverlay();
//               },
//               calendarStyle: CalendarStyle(
//                 todayDecoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
//                 selectedDecoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
//               ),
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//     Overlay.of(context)?.insert(_calendarOverlay!);
//   }
//
//   void _removeCalendarOverlay() {
//     _calendarOverlay?.remove();
//     _calendarOverlay = null;
//   }
//
//   void reload() => _key.currentState?.show();
//
//   Future<void> loadCategories() async {
//     await ajax(
//       url: "events/categories",
//       method: "POST",
//       onValue: (obj, _) {
//         setState(() {
//           _categories = (obj['categories'] as List?)?.map((e) => EventCategory.fromJson(e)).toList() ?? [];
//         });
//       },
//     );
//   }
//
//   Future<void> loadEvents() async {
//     setState(() => isLoading = true);
//     await ajax(
//       url: "https://tarama.ai/api/events/",
//       absolutePath: true,
//       onValue: (obj, _) {
//         setState(() {
//           _events = (obj['events'] as List).map((e) => Event.fromJson(e)).toList();
//           isLoading = false;
//         });
//       },
//     );
//   }
//
//   Future<void> loadEventsInCategory(String id) async {
//     await ajax(
//       url: "https://tarama.ai/api/events/?category_id=$id",
//       absolutePath: true,
//       onValue: (obj, _) {
//         setState(() {
//           _events = (obj['events'] as List).map((e) => Event.fromJson(e)).toList();
//         });
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         centerTitle: false,
//         title: Text(widget.catName, style: Theme.of(context).textTheme.titleLarge),
//       ),
//       body: RefreshIndicator(
//         key: _key,
//         onRefresh: loadEvents,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),
//               TextField(
//                 style: Theme.of(context).textTheme.bodyMedium,
//                 decoration: InputDecoration(
//                   hintText: "Search events",
//                   hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[700]),
//                   prefixIcon: Icon(Icons.search, color: isDark ? Colors.grey[300] : Colors.black54),
//                   filled: true,
//                   fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               Text("Upcoming Events", style: Theme.of(context).textTheme.titleMedium),
//               const SizedBox(height: 12),
//               if (isLoading)
//                 const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
//               else if (_events.isEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: Center(
//                     child: Text(
//                       "There are no events in this category.",
//                       style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
//                     ),
//                   ),
//                 )
//               else
//                 Column(
//                   children: _events.map((item) => Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: GestureDetector(
//                       onTap: () => push(EventDetailsScreen(event: item)),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).cardColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: CachedNetworkImage(
//                                 imageUrl: item.poster ?? '',
//                                 width: 80,
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.name,
//                                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     item.startDate,
//                                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                       color: isDark ? Colors.grey[400] : Colors.grey[600],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )).toList(),
//                 ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
