import 'organizer.dart';
import 'ticket.dart';

class Event {
  String id;
  String name;
  String poster;
  String? details;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String address;
  String status;
  String? categoryName;
  String? organizerId;
  String ticketUrl;
  int shares;
  int going;
  int likes;
  List<Ticket> tickets = [];
  Organizer? organizer;

  Event.fromJson(Map<String, dynamic> map)
      : id = map['event_id'],
        name = map['event_name'],
        poster = map['event_poster'],
        details = map['event_details'],
        organizerId = map['organizer_id'],
        startDate = map['event_start_date']??"",
        startTime = map['event_start_time'],
        categoryName = map['event_category_name'],
        endDate = map['event_end_date']??"",
        endTime = map['event_end_time']??"",
        address = map['event_address'],
        status = map['event_status'],
        ticketUrl = map["tickets_url"] ?? "",
        shares = int.parse(map['shares']) ?? 0,
        likes = int.parse(map['likes']) ?? 0,
        going = int.parse(map['going']) ?? 0;
}
