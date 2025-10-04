class User {
  static User? user;

  String id;
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? location;
  String? gender;
  String? token;
  String? profile;
  String? cover;
  String? accountType;
  DateTime? regDate;

  User.fromJson(Map<String, dynamic> map)
      : id = map['user_id'],
        fName = map['user_fname'],
        lName = map['user_lname'],
        email = map['user_email'],
        location = map['user_location'],
        gender = map['user_gender'],
        phone = map['user_phone'],
        profile = map['user_profile_picture'],
        cover = map['user_profile_cover'],
        regDate = DateTime.parse(map['user_reg_date']),
        accountType = map["account_type"],
        token = map['user_token'];

  Map<String, dynamic> toJson() => {
        "user_id": id,
        "user_fname": fName,
        "user_lname": lName,
        "user_email": email,
        "user_location": location,
        "user_gender": gender,
        "user_phone": phone,
        "user_profile_picture": profile,
        "user_profile_cover": cover,
        "user_reg_date": regDate?.toString(),
        "user_token": token
      };

  String get display => "${fName ?? ""} ${lName ?? ""}";
  String get initials =>
      "${fName != null && fName!.length > 1 ? fName!.substring(0, 1) : ""} ${lName != null && lName!.length > 1 ? lName!.substring(0, 1) : ""}";
}
