class Organizer{
  String? id;
  String name;
  String? email;
  String? phone;
  Organizer.fromJson(Map<String,dynamic> map):name
   = map['organizer_name'],
  email = map['organizer_email'],
  id = map['organizer_id'],
  phone = map['organizer_phone'];


  Organizer(this.name);
}