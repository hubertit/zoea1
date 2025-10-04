import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoea1/views/businesses/riverpod/providers.dart';
import 'package:zoea1/views/businesses/web_mobile_details.dart';

import '../../constants/theme.dart';
import 'wigets/rounded_containers.dart';

class WebMobileAppScreen extends ConsumerStatefulWidget {
  const WebMobileAppScreen({super.key});

  @override
  ConsumerState<WebMobileAppScreen> createState() => _WebMobileAppScreenState();
}

class _WebMobileAppScreenState extends ConsumerState<WebMobileAppScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final webMobileApps = ref.read(webMobileAppsNotifierProvider.notifier);
      await webMobileApps.fetchWebMobileApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final apps = ref.watch(webMobileAppsNotifierProvider);
    var loading = ref.watch(isLoadingProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Web/Mobile Apps"),
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: scaffoldColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Column(
                        children: List.generate(apps.length, (index) {
                          var app = apps[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WebMobileDetails(businessModel: app),
                                ),
                              );
                              // context.push("/webMobileDetails", extra: app);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                    // height: 120,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                        // color: Colors.white,
                                        ),
                                    child: CachedNetworkImage(
                                      imageUrl: app.logo,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      // height: 120,
                                      padding: const EdgeInsets.only(left: 10),
                                      // color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            app.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Wrap(
                                            runSpacing: 2,
                                            children: List.generate(
                                                app.types.length,
                                                (index) => roundedContainer(
                                                    app.types[index].name,
                                                    () {})),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            color: Colors.white,
                                            child: Text(
                                              // "${fakeDescription.substring(0, 100)}...",
                                              app.description.length <= 100
                                                  ? app.description
                                                  : "${app.description.substring(0, 100)}...",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          )
                                          // Row(
                                          //   children: [
                                          //     roundedContainer("Rect1", () {}),
                                          //     roundedContainer("Rect2", () {}),
                                          //     roundedContainer("Rect3", () {}),
                                          //   ],
                                          // ),
                                          // Container(
                                          //   padding: const EdgeInsets.all(3),
                                          //   color: Colors.white,
                                          //   child:  Text(app.description.length<=100?
                                          //   app.description:"${app.description.substring(0,100)}...",
                                          //     style: const TextStyle(fontSize: 12),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ));
    // Scaffold(
    //   appBar: AppBar(
    //     // leading: IconButton(
    //     //   onPressed: () {
    //     //     context.pop();
    //     //   },
    //     //     icon: const Icon(Ionicons.ios_arrow_back),
    //     // ),
    //     title: const Text("Cart"),
    //   ),
    //
    //   body:
    // );
  }
}
