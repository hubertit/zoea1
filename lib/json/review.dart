import 'user.dart';

class Review {
  String id;
  String? image;
  String names;
  int rating;
  String comment;
  String date;
  User user;

  Review.fromJson(Map<String, dynamic> map)
      : id = map['review_id'],
        comment = map['review'],
        date = map['review_time'],
        user = User.fromJson(map),
        image = map['user_profile_picture'],
        rating = int.tryParse(map['rating']) ??0,
        names = "${map['user_fname']} ${map['user_lname']}";
}
