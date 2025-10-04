import 'package:flutter/material.dart';
import 'storage_service.dart';
import 'notification_data.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: FutureBuilder<List<Map<String, String?>>>(
        future: StorageService().getUnopenedNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No unopened notifications'));
          } else {
            List<Map<String, String?>> notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                NotificationData notification = NotificationData.fromMap(notifications[index]);

                return ListTile(
                  leading: notification.imageUrl != null
                      ? Image.network(notification.imageUrl!)
                      : Icon(Icons.notification_important),
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                );
              },
            );
          }
        },
      ),
    );
  }
}
