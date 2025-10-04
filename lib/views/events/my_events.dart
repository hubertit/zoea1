import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/views/events/add_event.dart';

import '../../constants/apik.dart';
import '../../services/api_key_manager.dart';
import '../../event_details_screen.dart';
import '../../json/event.dart';
import '../../json/user.dart';
import '../../ults/functions.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends Superbase<MyEventsScreen> {
  final _key = GlobalKey<RefreshIndicatorState>();
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reload();
    });
  }

  // Future<void> loadEvents(){
  //   return ajax(url: "https://itike.io/api/events/tarama",absolutePath: true,onValue: (object,url){
  //     setState(() {
  //       _events = (object['events'] as Iterable).map((e) => Event.fromJson(e)).toList();
  //     });
  //   });
  // }
  Future<void> loadEvents() {
    return ajax(
        method: "POST",
        url: "${baseUrll}account/myevents",
        absolutePath: true,
        data: FormData.fromMap({
          'token': User.user!.token,
        }),
        onValue: (object, url) {
          setState(() {
            _events = (object['events'] as Iterable)
                .map((e) => Event.fromJson(e))
                .toList();
            print(_events);
          });
        });
  }

  void reload() {
    _key.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    print(User.user!.token);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My events"),
        actions: [
          IconButton(
              onPressed: () {
                push(const CreateEventScreen());
              },
              icon: const Icon(Icons.add_rounded))
        ],
      ),
      body: RefreshIndicator(color: refleshColor,
        key: _key,
        onRefresh: loadEvents,
        child: ListView.builder(
          itemBuilder: (context, index) {
            var item = _events[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color:isDarkTheme(context)?semiBlack: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: InkWell(
                onTap: () {
                  push(EventDetailsScreen(event: item));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          image: CachedNetworkImageProvider(item.poster),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              const Icon(
                                Icons.more_horiz,
                                size: 15,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              "It has survived not only five centuries, but also the leap into electronic typesetting."
                                  .substring(0, 50),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              item.startDate,
                              style:
                                  TextStyle(color: primaryColor, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
          },
          itemCount: _events.length,
        ),
      ),
    );
  }
}
