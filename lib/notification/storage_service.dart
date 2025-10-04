import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  Future<void> saveNotification(String title, String body, String? imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList('notifications') ?? [];

    // Create a map to store the notification details
    Map<String, String?> notificationData = {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
    };

    // Convert the map to a JSON string
    notifications.add(jsonEncode(notificationData));
    await prefs.setStringList('notifications', notifications);
  }

  Future<void> markAsOpened(String messageId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> openedNotifications = prefs.getStringList('opened_notifications') ?? [];

    // Mark notification as opened by message ID
    openedNotifications.add(messageId);
    await prefs.setStringList('opened_notifications', openedNotifications);
  }

  Future<List<Map<String, String?>>> getUnopenedNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedNotifications = prefs.getStringList('notifications') ?? [];

    // Decode the notifications into maps
    return storedNotifications.map((jsonString) => Map<String, String?>.from(jsonDecode(jsonString))).toList();
  }
}
