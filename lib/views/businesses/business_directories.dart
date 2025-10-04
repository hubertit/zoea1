import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoea1/views/businesses/riverpod/providers.dart';
import 'package:zoea1/views/businesses/tab_details.dart';
import 'package:zoea1/views/businesses/web_mobile_details.dart';

import '../../constants/theme.dart';
import 'wigets/rounded_containers.dart';

class BusinessDirectoriesScreen extends ConsumerStatefulWidget {
  const BusinessDirectoriesScreen({super.key});

  @override
  ConsumerState<BusinessDirectoriesScreen> createState() =>
      _WebMobileAppScreenState();
}

class _WebMobileAppScreenState
    extends ConsumerState<BusinessDirectoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bDirectories =
          ref.read(businessDirectoriesNotifierProvider.notifier);
      await bDirectories.fetchBusinessDirectories(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final apps = ref.watch(businessDirectoriesNotifierProvider);
    var loading = ref.watch(isLoadingProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Directories"),
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
                                builder: (context) => TabsDetails(businessModel: app),
                              ),
                            );
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
                                          app.companyName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Wrap(
                                          runSpacing: 2,
                                          children: List.generate(
                                              app.sectors.length,
                                              (index) => roundedContainer(
                                                  app.sectors[index], () {})),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          color: Colors.white,
                                          child: Text(
                                            // "${fakeDescription.substring(0, 100)}...",
                                            app.companyDescription.length <= 100
                                                ? app.companyDescription
                                                : "${app.companyDescription.substring(0, 100)}...",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        )
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
            ),
    );
  }
}
