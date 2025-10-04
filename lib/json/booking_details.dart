class BookingOrderDetails {
  final String bookingId;
  final DateTime checkin;
  final DateTime checkout;
  final String rooms;
  final String adults;
  final String children;
  final String roomType;
  final String address;
  final double roomPrice;
  final String roomPhoto;
  final double subtotal;
  final double fees;
  final double tax;
  final double total;
  final String paymentUrl;

  BookingOrderDetails({
    required this.bookingId,
    required this.checkin,
    required this.checkout,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.roomType,
    required this.address,
    required this.roomPrice,
    required this.roomPhoto,
    required this.subtotal,
    required this.fees,
    required this.tax,
    required this.total,
    required this.paymentUrl,
  });

  factory BookingOrderDetails.fromJson(Map<String, dynamic> json) {
    return BookingOrderDetails(
      bookingId: json['booking_id'] ?? '',
      checkin: DateTime.parse(json['checkin'] ?? DateTime.now().toIso8601String()),
      checkout: DateTime.parse(json['checkout'] ?? DateTime.now().toIso8601String()),
      rooms: json['rooms'] ?? 0,
      adults: json['adults'] ?? 0,
      children: json['children'] ?? 0,
      roomType: json['room_type'] ?? '',
      address: json['address'] ?? '',
      roomPrice: double.parse(json['room_price']) ,
      roomPhoto: json['room_photo'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      fees: (json['fees'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      paymentUrl: json['payment_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'checkin': checkin.toIso8601String(),
      'checkout': checkout.toIso8601String(),
      'rooms': rooms,
      'adults': adults,
      'children': children,
      'room_type': roomType,
      'address': address,
      'room_price': roomPrice,
      'room_photo': roomPhoto,
      'subtotal': subtotal,
      'fees': fees,
      'tax': tax,
      'total': total,
      'payment_url': paymentUrl,
    };
  }
}
