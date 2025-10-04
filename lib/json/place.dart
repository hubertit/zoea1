import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zoea1/utils/number_formatter.dart';

class Place {
  String id;
  String title;
  String location;
  num rating;
  num price;
  num number;
  String? image;
  bool favorite;
  String? status;
  String? about;
  String? email;
  String? phone;
  String? website;
  String? categoryId;
  LatLng? venueCoordinates;
  String? address;
  String? services;
  String? venueCode;

  bool adding = false;

  Place.fromJson(Map<String, dynamic> map)
      : title = map['venue_name'],
        location = map['location_name'],
        id = map['venue_id'],
        rating = num.tryParse(map['venue_rating']) ?? 0,
        number = num.tryParse(map['venue_reviews']) ?? 0,
        status = map['venue_status'],
        venueCoordinates = getCoordinates(map['venue_coordinates']),
        about = map['venue_about'],
        services = map['services'],
        phone = map['venue_phone'],
        venueCode = map['venue_code'],
        favorite = map['is_favorite'] == 1,
        email = map['venue_email'],
        address = map['venue_address'],
        website = map['venue_website'],
        categoryId = map['category_id'],
        price = num.tryParse(map['venue_price']) ?? 0,
        image = map['venue_image'];

  bool get hasPrice => price > 0;

  // For accommodations (categoryId == '4'), show exact price. For others, show $, $$, $$$
  String get currency {
    if (categoryId == '4') {
      // Accommodation: show exact price with $ sign, e.g. $120
      return NumberFormatter.formatHotelPrice(price);
    } else {
      return NumberFormatter.formatRestaurantPrice(price);
    }
  }

  static LatLng? getCoordinates(String? coordinates) {
    if (coordinates != null && coordinates.trim().isNotEmpty) {
      var split = coordinates.split(",");
      return LatLng(double.parse(split[0]), double.parse(split[1]));
    }

    return null;
  }
}
