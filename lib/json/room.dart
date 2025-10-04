// class Room {
//   String roomId;
//   String venueId;
//   String name;
//   String description;
//   String review;
//   num capacity;
//   String? bedType;
//   num price;
//   String bedSize;
//   String roomPhoto;
//   bool checked = false;
//   String status;
//   Room.fromJson(Map<String, dynamic> map)
//       : roomId= map['room_id'],
//         venueId=map['venue_id'],
//         name = map['name'],
//         description = map['description'],
//         review = map['room_view'],
//         price = num.parse(map['price']),
//         capacity = num.parse(map['capacity']),
//         bedType = map['bed_type']??'',
//         bedSize = map['bed_size'],
//         roomPhoto = map['photo'],
//         status = map["status"];
// }
class Room {
  String roomId;
  String venueId;
  String name;
  String description;
  String review;
  String capacity;
  String? bedType;
  String price;
  String bedSize;
  String roomPhoto;
  String? checked;
  String status;
  final List<Amenity> amenities;

  Room({
    required this.roomId,
    required this.venueId,
    required this.name,
    required this.description,
    required this.review,
    required this.price,
    required this.capacity,
    required this.bedType,
    required this.checked,
    required this.bedSize,
    required this.roomPhoto,
    required this.status,
    required this.amenities,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['room_id'],
      venueId: json['venue_id'],
      name: json['name'],
      description: json['description'],
      review: json['room_view'],
      price: json['price'],
      capacity: json['capacity'],
      bedType: json['bed_type'],
      checked: json['available'],
      bedSize: json['bed_size'],
      roomPhoto: json['photo'],
      status: json['status'],
      amenities: List<Amenity>.from(json['amenities'].map((x) => Amenity.fromJson(x))),
    );
  }
}

class Amenity {
  final String amenityId;
  final String amenityName;
  final String amenityIcon;

  Amenity({
    required this.amenityId,
    required this.amenityName,
    required this.amenityIcon,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      amenityId: json['amenity_id'],
      amenityName: json['amenity_name'],
      amenityIcon: json['amenity_icon'],
    );
  }
}
