class NotificationData {
  final String title;
  final String body;
  final String? imageUrl;

  NotificationData({required this.title, required this.body, this.imageUrl});

  factory NotificationData.fromMap(Map<String, String?> data) {
    return NotificationData(
      title: data['title'] ?? 'No Title',
      body: data['body'] ?? 'No Body',
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, String?> toMap() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
    };
  }
}
