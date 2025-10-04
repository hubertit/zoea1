class Ticket {
  String id;
  String name;
  num price;
  num qty;
  num newQty = 0;
  String status;

  Ticket.fromJson(Map<String, dynamic> map)
      : id = map['event_ticket_id'],
        name = map['event_ticket_name'],
        price = num.tryParse(map['event_ticket_price']) ?? 0,
        qty = num.tryParse(map['event_ticket_qty']) ?? 0,
        status = map['event_ticket_status'];

  num get total =>newQty*price;
}
