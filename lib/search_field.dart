import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:zoea1/partial/show_custom_date_range_picker.dart';
import 'package:zoea1/place_collection_search.dart';
import 'package:zoea1/search_delegate.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'package:zoea1/ults/style_utls.dart';

class SearchField extends StatefulWidget {
  final bool fromHotel;
  final void Function(FilterOption option)? callback;
  final bool homeSearch;
  final bool isIcon;
  const SearchField(
      {super.key,
      this.isIcon = false,
      this.fromHotel = false,
      this.callback,
      this.homeSearch = false});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  FilterOption? _option;

  @override
  void initState() {
    if (widget.homeSearch) {
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          showSearch(
              context: context,
              delegate: SearchDemoSearchDelegate((query) {
                return Theme(
                    data: Theme.of(context),
                    child: PlaceCollectionSearch(query: query));
              }));
        }
      });
    }
    _controller.addListener(() {
      if (widget.callback != null) {
        _option ??= FilterOption.init();
        _option!.query = _controller.text;
        widget.callback!(_option!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isIcon) {
      return SizedBox(
          width: 30,
          child: (TextField(
            focusNode: _focusNode,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Feather.search,
                size: 20,
              ),
              filled: false
            ),
          )));
    } else {
      return Flexible(
        child: TextField(
          focusNode: _focusNode,
          controller: _controller,
          decoration: InputDecoration(border: StyleUtls.commonInputBorder,
              hintText: "Search ....",
              prefixIcon: const Icon(Feather.search),
              suffixIcon: widget.homeSearch
                  ? null
                  : InkWell(
                      onTap: () async {
                        var b = await showModalBottomSheet<FilterOption?>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return FilteringOptions(
                                filterOption: _option,
                              );
                            });
                        if (b != null && widget.callback != null) {
                          b.query = _controller.text;
                          setState(() {
                            _option = b;
                            widget.callback!(b);
                          });
                        }
                      },
                      child: const Icon(Ionicons.ios_filter_outline))),
        ),
      );
    }
  }
}

// class _Option {
//   String label;
//   int number;
//
//   _Option(this.label, this.number);
// }

var initTimeRange = DateTimeRange(
    start: DateTime.now(), end: DateTime.now().add(const Duration(days: 2)));

const double _max = 2000.0;
const double _min = 20.0;

var initRange = const RangeValues(_min, _max);

class FilterOption {
  DateTimeRange timeRange;
  RoomOption roomOption;
  int rating;
  String? query;
  RangeValues rangeValues;

  FilterOption(this.timeRange, this.roomOption, this.rating, this.rangeValues,
      {this.query});

  FilterOption.init()
      : timeRange = initTimeRange,
        roomOption = RoomOption.create(),
        rating = 0,
        rangeValues = initRange;
}

class FilteringOptions extends StatefulWidget {
  final FilterOption? filterOption;
  final void Function(FilterOption option)? callback;
  final bool hideButtons;
  final bool loading;

  const FilteringOptions(
      {super.key,
      this.filterOption,
      this.hideButtons = false,
      this.callback,
      this.loading = false});

  @override
  State<FilteringOptions> createState() => _FilteringOptionsState();
}

class _FilteringOptionsState extends Superbase<FilteringOptions> {
  RangeValues _values = initRange;
  RangeValues _values0 = const RangeValues(20, 2000);

  List<double> _numbers = [];
  List<double> _numbers0 = [];
  final _controller = TextEditingController();

  // final _options = [
  //   _Option("Hotels", 340),
  //   _Option("Swimming Pool", 140),
  //   _Option("5 Stars", 100),
  //   _Option("Private Bathroom", 200),
  //   _Option("Breakfast Included", 115),
  //   _Option("Kitchen", 10),
  // ];

  int? _rating;

  // _Option? _option;

  @override
  void initState() {
    _numbers = List.generate(51, (index) => index * 10);
    _numbers0 = _numbers.toList();
    _option = widget.filterOption?.roomOption ?? _option;
    _dateTime = widget.filterOption?.timeRange ?? _dateTime;
    _rating = widget.filterOption?.rating ?? _rating;
    _values = widget.filterOption?.rangeValues ?? _values;
    _values0 = widget.filterOption?.rangeValues ?? _values0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // onStartChanged(_values.start);
    });
    super.initState();
  }

  DateTimeRange _dateTime = initTimeRange;

  RoomOption _option = RoomOption.create();

  void onStartChanged(double? e, {double? newEnd}) {
    var end = newEnd ?? _values0.end;
    setState(() {
      var n = e! / 10;
      var newEnd = e + 10;
      _values0 = RangeValues(
          e,
          end > e
              ? end
              : newEnd <= 2000
                  ? newEnd
                  : e);
      var min = 210 - n;
      _numbers0 = List.generate(min.toInt(), (index) => (index * 10) + e);
    });
  }

  @override
  Widget build(BuildContext context) {
    double textSize = 14;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.hideButtons
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close)),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Text(
                        "Filter",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ))
                  ],
                ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 15),
          //   child: Text("Price Range", style: Theme
          //       .of(context)
          //       .appBarTheme
          //       .titleTextStyle,),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                  filled: false,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Kigali, Rwanda"),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white12))),
            child: Row(
              children: [
                Expanded(
                    child: DropdownButtonFormField<double>(
                  items: List.generate(
                      199,
                      (index) => DropdownMenuItem(
                          value: (index + 2) * 10,
                          child: Text("\$${fmtNbr((index + 2) * 10)}"))),
                  value: _values0.start,
                  onChanged: onStartChanged,
                  decoration: const InputDecoration(
                    filled: false,
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: DropdownButtonFormField<double>(
                  items: List.generate(
                      199,
                      (index) => DropdownMenuItem(
                          value: (index + 2) * 10,
                          child: Text("\$${fmtNbr((index + 2) * 10)}"))),
                  value: _values0.end,
                  onChanged: onStartChanged,
                  decoration: const InputDecoration(
                    filled: false,
                  ),
                )),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 0),
          //   child: SliderTheme(
          //     data: SliderThemeData(
          //       rangeTrackShape: SliderCustomTrackShape()
          //     ),
          //     child: RangeSlider(max: _max,min: _min,values: _values, onChanged: (val){
          //       setState(() {
          //         _values = val;
          //       });
          //     }),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       OutlinedButton(onPressed: (){},style: OutlinedButton.styleFrom(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(16)
          //         )
          //       ), child: Text("\$${formatter.format(_values.start)}"),),
          //       OutlinedButton(onPressed: (){},style: OutlinedButton.styleFrom(
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(16)
          //           )
          //       ), child: Text("\$${formatter.format(_values.end)}")),
          //     ],
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white12))),
            child: InkWell(
              onTap: () async {
                var now = DateTime.now();
                var data = await showCustomRangePicker(context, now,
                    initialRange: _dateTime);
                setState(() {
                  _dateTime = data ?? _dateTime;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range_outlined,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${fmtDate2(_dateTime.start)} - ${fmtDate2(_dateTime.end)}",
                      style: TextStyle(fontSize: textSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 0),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white12))),
            child: InkWell(
              onTap: () async {
                var data = await showModalBottomSheet<RoomOption?>(
                    context: context,
                    builder: (context) => RoomSelector(
                          option: _option,
                        ));
                setState(() {
                  _option = data ?? _option;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const Icon(
                      AntDesign.user,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${_option.rooms} Room . ${_option.adults} Adults . ${_option.children > 0 ? "${_option.children} children" : "No Children"}",
                      style: TextStyle(fontSize: textSize),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 15),
          //   child: Text("Popular Filters",style: Theme.of(context).appBarTheme.titleTextStyle,),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 10),
          //   child: Wrap(children: _options.map((e) => Padding(
          //     padding: const EdgeInsets.only(right: 6),
          //     child: OutlinedButton(onPressed: (){
          //       setState(() {
          //         _option = e;
          //       });
          //     },style: OutlinedButton.styleFrom(
          //       backgroundColor: _option?.label == e.label ? Theme.of(context).primaryColor : null,
          //       foregroundColor: _option?.label == e.label ? Colors.white : null,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16)
          //       )
          //     ), child: Text(e.label)),
          //   )).toList(),),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 15),
          //   child: Text("Star Rating", style: Theme
          //       .of(context)
          //       .appBarTheme
          //       .titleTextStyle,),
          // ),
          // Container(
          //   padding: const EdgeInsets.only(top: 10),
          //   decoration: BoxDecoration(
          //       border: Border(top: BorderSide(color: Colors.grey.shade300))),
          //   child: Wrap(
          //     alignment: WrapAlignment.center,
          //     children: [1, 2, 3, 4, 5]
          //         .map((e) => Padding(
          //               padding: const EdgeInsets.only(right: 6),
          //               child: OutlinedButton(
          //                   onPressed: () {
          //                     setState(() {
          //                       _rating = e;
          //                     });
          //                   },
          //                   style: OutlinedButton.styleFrom(
          //                       backgroundColor: _rating == e
          //                           ? Colors.yellow.shade700
          //                           : null,
          //                       foregroundColor: _rating == e
          //                           ? Colors.white
          //                           : Colors.yellow.shade700,
          //                       shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(16))),
          //                   child: Row(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: List.generate(
          //                         e, (index) => const Icon(Icons.star)),
          //                   )),
          //             ))
          //         .toList(),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor:isDarkTheme(context)?Colors.white12: Colors.black,
                    shape: const RoundedRectangleBorder()),
                onPressed: widget.loading
                    ? null
                    : () {
                        widget.callback?.call(FilterOption(
                            _dateTime, _option, _rating ?? 0, _values0,
                            query: _controller.text));
                      },
                child: widget.loading
                    ? const CupertinoActivityIndicator()
                    : const Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      )),
          ),
          widget.hideButtons
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: 5),

                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // _option = null;
                        _rating = null;
                      });
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text("Clear All"),
                  ),
                ),
        ],
      ),
    );
  }
}

class RoomSelector extends StatefulWidget {
  final RoomOption? option;

  const RoomSelector({super.key, this.option});

  @override
  State<RoomSelector> createState() => _RoomSelectorState();
}

class _RoomSelectorState extends State<RoomSelector> {
  RoomOption _option = RoomOption(0, 0, 0);

  @override
  void initState() {
    _option = widget.option ?? _option;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "Select rooms and guests",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        const Expanded(child: Text(("Rooms"))),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          width: 40,
                          height: 40,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  _option.rooms = max(1, --_option.rooms);
                                });
                              },
                              child: const Icon(Icons.remove)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${_option.rooms}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          width: 40,
                          height: 40,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  _option.rooms = min(30, ++_option.rooms);
                                });
                              },
                              child: const Icon(Icons.add)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        const Expanded(child: Text(("Adults"))),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          width: 40,
                          height: 40,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  _option.adults = max(1, --_option.adults);
                                });
                              },
                              child: const Icon(Icons.remove)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${_option.adults}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          width: 40,
                          height: 40,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  _option.adults = min(30, ++_option.adults);
                                });
                              },
                              child: const Icon(Icons.add)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        const Expanded(child: Text(("Children"))),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          width: 40,
                          height: 40,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  _option.children = max(0, --_option.children);
                                });
                              },
                              child: const Icon(Icons.remove)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${_option.children}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          width: 40,
                          height: 40,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  _option.children =
                                      min(30, ++_option.children);
                                });
                              },
                              child: const Icon(Icons.add)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _option);
                },
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}

class RoomOption {
  int rooms;
  int adults;
  int children;

  RoomOption(this.rooms, this.adults, this.children);

  RoomOption.create()
      : rooms = 1,
        adults = 1,
        children = 0;
}

class SliderCustomTrackShape extends RoundedRectRangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
