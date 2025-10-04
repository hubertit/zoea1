import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'room.dart';

class Hotel {
  String code;
  String name;
  String banner;
  int star;
  String address;
  String city;
  String country;
  num minPrice;
  String currency;
  int allRoom;
  int takeRoom;
  int requestedRoom;
  int available;
  String summary;
  String category;
  String description;
  List<HFacility> facilities;
  List<Room> rooms = [];
  List<String> images = [];

  bool adding = false;
  bool favorite = false;
  LatLng? latLng;

  Hotel.fromJson(Map<String, dynamic> map)
      : code = map['hotelcode'],
        name = map['hotelname'],
        banner = map['banner'],
        star = int.tryParse(map['banner']) ?? 0,
        address = map['address'],
        city = map['city'],
        country = map['country'],
        minPrice = num.tryParse(map['minprice']) ?? 0,
        currency = map['currency'],
        allRoom = map['allroom'],
        takeRoom = map['takeroom'],
        requestedRoom = int.tryParse("${map['requestedroom']}") ?? 0,
        available = map['available'],
        summary = map['summary'],
        description = map['description'],
        category = map['category'],
        facilities = (map['facilities'] as Iterable?)
            ?.map((v) => HFacility.fromJson(v.toString()))
            .toList() ??
            [];
}

class HFacility {
  String title;
  List<String> items;

  HFacility.fromJson(String string)
      : title = string.split(":").first,
        items =string.split(":").length > 1 ? string.split(":").last.split(",") : [];
}