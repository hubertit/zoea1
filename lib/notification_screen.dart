import 'package:flutter/material.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/super_base.dart';
import 'authentication.dart';
import 'json/notification.dart' as e;
import 'ults/functions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends Superbase<NotificationScreen> {
  List<e.Notification> _list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadNotifications();
    });
  }

  Future<void> loadNotifications() {
    return ajax(
        url: "notifications/",
        method: "POST",
        onValue: (obj, url) {
          setState(() {
            _list = (obj['notifications'] as Iterable?)
                    ?.map((el) => e.Notification.fromJson(el))
                    .toList() ??
                [];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: RefreshIndicator(color: refleshColor,
        onRefresh: loadNotifications,
        child: _list.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) {
                  var item = _list[index];
                  return ListTile(
                    onTap: () {},
                    leading: Material(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: kGrayLight),
                          borderRadius: BorderRadius.circular(1000)),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Image.asset(
                            AssetUtls.notification,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    title: Text(item.title),
                    subtitle: Text(item.time),
                  );
                },
                itemCount: _list.length)
            : User.user == null
            ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Login to get  notifications"),
                TextButton.icon(
                    icon: const Icon(Icons.login),
                    onPressed: () {
                      push(const Authentication());
                    },
                    label: const Text("Login"))
              ],
            ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                          child: Image.asset(
                            AssetUtls.notification,
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "No notifications",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:isDarkTheme(context)?null: textsColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
