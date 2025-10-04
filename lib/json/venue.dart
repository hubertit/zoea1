import 'image.dart';
import 'room.dart';

class Venue {
  String venueId;
  String? venueCode;
  String venueName;
  String venueAbout;
  String venuePrice;
  String venuePhone;
  String venueEmail;
  String venueWebsite;
  String venueImage;
  String venueRating;
  String venueReviews;
  String venueAddress;
  String venueCoordinates;
  String services;
  String workingHours;
  String categoryName;
  String categoryDescription;
  int isFavorite;
  int availableRooms;
  String breakfastIncluded;
  // final List<Room> rooms;
  // final List<GalleryItem> gallery;

  Venue(
      {required this.venueId,
      this.venueCode,
      required this.venueName,
      required this.venueAbout,
      required this.venuePrice,
      required this.venuePhone,
      required this.venueEmail,
      required this.venueWebsite,
      required this.venueImage,
      required this.venueRating,
      required this.venueReviews,
      required this.venueAddress,
      required this.venueCoordinates,
      required this.services,
      required this.workingHours,
      required this.categoryName,
      required this.categoryDescription,
      required this.isFavorite,
      required this.availableRooms,
      required this.breakfastIncluded
      // required this.rooms,
      // required this.gallery,
      });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
        venueId: json['venue_id'] ?? '',
        venueCode: json['venue_code'] ?? '',
        venueName: json['venue_name'] ?? '',
        venueAbout: json['venue_about'] ?? '',
        venuePrice: json['venue_price'] ?? '',
        venuePhone: json['venue_phone'] ?? '',
        venueEmail: json['venue_email'] ?? '',
        venueWebsite: json['venue_website'] ?? '',
        venueImage: json['venue_image'] ?? '',
        venueRating: json['venue_rating'] ?? '',
        venueReviews: json['venue_reviews'] ?? '',
        venueAddress: json['venue_coordinates'] ?? '',
        venueCoordinates: json['venue_address'] ?? '',
        services: json['services'] ?? '',
        workingHours: json['working_hours'] ?? '',
        categoryName: json['category_name'] ?? '',
        categoryDescription: json['category_description'] ?? '',
        isFavorite: json['is_favorite'] ?? 0,
        availableRooms: json['available_rooms'] ?? 0,
        breakfastIncluded: json['breakfast_included'] ?? '0'
        //   rooms: (json['rooms'] as List<dynamic>)
        //       .map((room) => Room.fromJson(room))
        //       .toList(),
        //   gallery: (json['gallery'] as List<dynamic>)
        //       .map((galleryItem) => GalleryItem.fromJson(galleryItem))
        //       .toList(),
        );
  }

  String get currency {
    final lower = (categoryName ?? '').toLowerCase();
    final priceNum = num.tryParse(venuePrice) ?? 0;
    if (lower.contains('accommodation') || lower.contains('hotel') || lower.contains('room')) {
      return priceNum > 0 ? '\$${priceNum.toStringAsFixed(0)}' : '';
    } else {
      if (priceNum <= 1) return '\$';
      if (priceNum == 2) return '\$\$';
      if (priceNum >= 3) return '\$\$\$';
      return '';
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['venue_id'] = venueId;
  //   data['venue_code'] = venueCode;
  //   data['venue_name'] = venueName;
  //   data['venue_about'] = venueAbout;
  //   data['venue_price'] = venuePrice;
  //   data['venue_phone'] = venuePhone;
  //   data['venue_email'] = venueEmail;
  //   data['venue_website'] = venueWebsite;
  //   data['venue_image'] = venueImage;
  //   data['venue_rating'] = venueRating;
  //   data['venue_reviews'] = venueReviews;
  //   data['venue_address'] = venueAddress;
  //   data['venue_coordinates'] = venueCoordinates;
  //   data['services'] = services;
  //   data['working_hours'] = workingHours;
  //   data['category_name'] = categoryName;
  //   data['category_description'] = categoryDescription;
  //   data['is_favorite'] = isFavorite;
  //   // data['rooms'] = rooms??[];
  //   // data['gallery'] = gallery??[];
  //   return data;
  // }
}

class VenueDetail {
  final String venueId;
  final String venueCode;
  final String venueName;
  final String venueAbout;
  final String venuePrice;
  final String venuePhone;
  final String venueEmail;
  final String venueWebsite;
  final String venueImage;
  final String venueRating;
  final String venueReviews;
  final String venueAddress;
  final String venueCoordinates;
  final String services;
  final String workingHours;
  final String categoryName;
  final String categoryDescription;
  final String venuePolicy;
  final String cancellationPolicy;
  int isFavorite;
  final List<Room> rooms;
  final List<GalleryItem> gallery;
  final List<FacilityCategory> facilities;

  bool adding = false;
  VenueDetail({
    required this.venuePolicy,
    required this.cancellationPolicy,
    required this.venueId,
    required this.venueCode,
    required this.venueName,
    required this.venueAbout,
    required this.venuePrice,
    required this.venuePhone,
    required this.venueEmail,
    required this.venueWebsite,
    required this.venueImage,
    required this.venueRating,
    required this.venueReviews,
    required this.venueAddress,
    required this.venueCoordinates,
    required this.services,
    required this.workingHours,
    required this.categoryName,
    required this.categoryDescription,
    required this.isFavorite,
    required this.rooms,
    required this.gallery,
    required this.facilities,
  });

  factory VenueDetail.fromJson(Map<String, dynamic> json) {
    return VenueDetail(
      venueId: json['venue_id'] ?? '',
      venueCode: json['venue_code'] ?? '',
      venueName: json['venue_name'] ?? '',
      venueAbout: json['venue_about'] ?? '',
      venuePrice: json['venue_price'] ?? '',
      venuePhone: json['venue_phone'] ?? '',
      venueEmail: json['venue_email'] ?? '',
      venueWebsite: json['venue_website'] ?? '',
      venueImage: json['venue_image'] ?? '',
      venueRating: json['venue_rating'] ?? '',
      venueReviews: json['venue_reviews'] ?? '',
      venueAddress: json['venue_coordinates'] ?? '',
      venueCoordinates: json['venue_address'] ?? '',
      services: json['services'] ?? '',
      workingHours: json['working_hours'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryDescription: json['category_description'] ?? '',
      venuePolicy: json['venue_policy']?? '',
      cancellationPolicy: json['cancellation_policy']?? '',
      isFavorite: json['is_favorite'] ?? 0,
      rooms: (json['rooms'] as List<dynamic>)
          .map((room) => Room.fromJson(room))
          .toList(),
      gallery: (json['gallery'] as List<dynamic>)
          .map((galleryItem) => GalleryItem.fromJson(galleryItem))
          .toList(),
      facilities: (json['facilities'] as List<dynamic>)
          .map((facilityCategoryJson) =>
              FacilityCategory.fromJson(facilityCategoryJson))
          .toList(),
    );
  }
}

class FacilityCategory {
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  // final List<Facility> facilities;

  FacilityCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    // required this.facilities,
  });

  factory FacilityCategory.fromJson(Map<String, dynamic> json) {
    return FacilityCategory(
      categoryId: json['facility_id']??"",
      categoryName: json['facility_name']??"",
      categoryIcon: json['facility_icon']??"",
      // facilities: (json['facilities'] as List<dynamic>)
      //     .map((facilityJson) => Facility.fromJson(facilityJson))
      //     .toList(),
    );
  }
}

class Facility {
  final String facilityId;
  final String categoryId;
  final String facilityName;
  final String facilityIcon;

  Facility({
    required this.facilityId,
    required this.categoryId,
    required this.facilityName,
    required this.facilityIcon,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      facilityId: json['facility_id']??"",
      categoryId: json['category_id']??"",
      facilityName: json['facility_name']??"",
      facilityIcon: json['facility_icon']??"",
    );
  }
}
