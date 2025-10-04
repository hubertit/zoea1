import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/views/events/widgets/event_card.dart';

import 'event_details_screen.dart';
import 'json/event.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends Superbase<MyEvents> {
  final _key = GlobalKey<RefreshIndicatorState>();
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reload();
    });
  }

  Future<void> loadEvents() {
    return ajax(
        url: "account/myevents",
        absolutePath: true,
        data: FormData.fromMap({"token": User.user!.token}),
        onValue: (object, url) {
          setState(() {
            _events = (object['events'] as Iterable)
                .map((e) => Event.fromJson(e))
                .toList();
          });
        });
  }

  void reload() {
    _key.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My events"),
      ),
      body: RefreshIndicator(
        color: refleshColor,
        key: _key,
        onRefresh: loadEvents,
        child: _events.isEmpty
            ? const Center(
                child: Text("You have no event"),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  var item = _events[index];
                  return EventCard(
                    event: item,
                    callback: () {
                      push(EventDetailsScreen(event: item));
                    },
                  );
                },
                itemCount: _events.length,
              ),
      ),
    );
  }
}
