class Booking {
  final String bookingId;
  final String venueId;
  final dynamic roomId;
  final String userId;
  final String bookingTime;
  final String checkinDate;
  final String checkinTime;
  final String? checkoutDate;
  final String? checkoutTime;
  final String adults;
  final String children;
  final String additionalRequest;
  final String bookingStatus;
  final String paymentStatus;
  final String categoryId;
  final String locationId;
  final String venueCode;
  final String venueName;
  final String venueAbout;
  final String venuePolicy;
  final String cancellationPolicy;
  final String checkinPolicy;
  final String checkoutPolicy;
  final String venuePrice;
  final String breakfastIncluded;
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
  final String timeAdded;
  final String venueStatus;
  final String locationName;
  final String locationDescription;
  final String locationImage;
  final int isFavorite;

  Booking({
    required this.bookingId,
    required this.venueId,
    required this.roomId,
    required this.userId,
    required this.bookingTime,
    required this.checkinDate,
    required this.checkinTime,
    required this.checkoutDate,
    required this.checkoutTime,
    required this.adults,
    required this.children,
    required this.additionalRequest,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.categoryId,
    required this.locationId,
    required this.venueCode,
    required this.venueName,
    required this.venueAbout,
    required this.venuePolicy,
    required this.cancellationPolicy,
    required this.checkinPolicy,
    required this.checkoutPolicy,
    required this.venuePrice,
    required this.breakfastIncluded,
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
    required this.timeAdded,
    required this.venueStatus,
    required this.locationName,
    required this.locationDescription,
    required this.locationImage,
    required this.isFavorite,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      venueId: json['venue_id'],
      roomId: json['room_id'] ?? 0,
      userId: json['user_id'],
      bookingTime: json['booking_time'],
      checkinDate: json['checkin_date'],
      checkinTime: json['checkin_time'],
      checkoutDate: json['checkout_date'],
      checkoutTime: json['checkout_time'],
      adults: json['adults'],
      children: json['children'],
      additionalRequest: json['additional_request'],
      bookingStatus: json['booking_status'],
      paymentStatus: json['payment_status'],
      categoryId: json['category_id'],
      locationId: json['location_id'],
      venueCode: json['venue_code'],
      venueName: json['venue_name'],
      venueAbout: json['venue_about'],
      venuePolicy: json['venue_policy'] ?? ' ',
      cancellationPolicy: json['cancellation_policy'] ?? ' ',
      checkinPolicy: json['checkin_policy'],
      checkoutPolicy: json['checkout_policy'],
      venuePrice: json['venue_price'],
      breakfastIncluded: json['breakfast_included'],
      venuePhone: json['venue_phone'],
      venueEmail: json['venue_email'] ?? ' ',
      venueWebsite: json['venue_website'],
      venueImage: json['venue_image'],
      venueRating: json['venue_rating'],
      venueReviews: json['venue_reviews'],
      venueAddress: json['venue_address'],
      venueCoordinates: json['venue_coordinates'],
      services: json['services'] ?? ' ',
      workingHours: json['working_hours'],
      timeAdded: json['time_added'],
      venueStatus: json['venue_status'],
      locationName: json['location_name'],
      locationDescription: json['location_description'] ?? ' ',
      locationImage: json['location_image'] ?? ' ',
      isFavorite: json['is_favorite'],
    );
  }

  String get currency {
    final priceNum = num.tryParse(venuePrice) ?? 0;
    if (priceNum <= 1) return ' 4';
    if (priceNum == 2) return ' 4 4';
    if (priceNum >= 3) return ' 4 4 4';
    return '';
  }
}
