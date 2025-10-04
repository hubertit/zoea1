class Notification {
  String id;
  String title;
  String body;
  String? image;
  String time;
  String status;

  Notification.fromJson(Map<String, dynamic> map)
      : id = map['notification_id'],
        title = map['notification_title'],
        body = map['notification_body'],
        image = map['notification_image'],
        time = map['notification_time'],
        status = map['notification_status'];
}
