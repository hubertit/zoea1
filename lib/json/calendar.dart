class CalendarDay {
  final String day;
  final String date;

  CalendarDay({required this.day, required this.date});

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      day: json['day'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'date': date,
    };
  }
}