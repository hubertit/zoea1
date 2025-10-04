import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoea1/authentication.dart';
import 'package:zoea1/favorites_screen.dart';
import 'package:zoea1/feedback_bottom_dialog.dart';
import 'package:zoea1/merchant_screen.dart';
import 'package:zoea1/place_collection.dart';
import 'package:zoea1/super_base.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:zoea1/uci_screen.dart';
import 'package:zoea1/welcome_screen.dart';


import 'account_screen.dart';
import 'events_screen.dart';
import 'json/user.dart';
import 'main.dart';
import 'ults/functions.dart';
import 'constants/theme.dart';
import 'conversation_screen.dart';


OverlayEntry? _overlayEntry;

bool _overlayInserted = false;

kwitizinaBanner(BuildContext context) {
  final DateTime currentDate = DateTime.now();
  final DateTime cutoffDate = DateTime(2025, 06, 15);

  // Insert the overlay only if the current date is before the cutoff date and the overlay isn't inserted yet
  if (currentDate.isBefore(cutoffDate)) {
    return
      // Positioned(
      // top: 0,
      // left: 0,
      // right: 0,
      // child: Material(
      //   color: Colors.transparent,
      //   child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0).copyWith(top: 20),
          child: InkWell(
            onTap: () {
              launchUrl(Uri.parse("https://bal.nba.com/2025-tickets"));
            },
            child: Image.network("https://tpc.googlesyndication.com/simgad/11733236589269976526")
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            //   margin: const EdgeInsets.symmetric(horizontal: 0),
            //   decoration: BoxDecoration(
            //     color: const Color(0xff0f5132),
            //     borderRadius: BorderRadius.circular(1),
            //   ),
            //   child: const Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Flexible(
            //         child: Text(
            //           'Attend 20th Kwita Izina on Friday, 18 October 2024',
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 12,
            //               fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        );
    //   ),
    // );
  }
  return Container();
}

OverlayEntry _createOverlayEntry() {
  return OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            launchUrl(Uri.parse("https://visitrwanda.com/kwita-izina/"));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: kGrayDark,
              borderRadius: BorderRadius.circular(1),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'Attend 20th Kwita Izina on Friday, 18 October 2024',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class Homepage extends StatefulWidget {
  final bool isSearching;
  const Homepage({super.key, this.isSearching = false});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends Superbase<Homepage> {
  int _index = 2;
  bool isLogged = false;
  void checkLogin() async {
    var string = (await prefs).getString(userKey);
    if (string != null) {
      if (mounted) {
        User.user = User.fromJson(jsonDecode(string));
        // push(const Homepage(), replace: true);
        setState(() {
          isLogged = true;
        });
      }
    } else if (mounted) {
      // push(const Authentication(), replace: true);
    }
  }

  void showFeebackModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => const FeedbackBottomDialog());
  }

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // checkVersion();

      Future.delayed(const Duration(minutes: 10))
          .then((value) => showFeebackModal());
      // Future.delayed(const Duration(seconds: 1))
      //     .then((value) => kwitizinaSnack(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const WelcomeScreen(),
          const PlaceCollection(),
          const Conversation(),
          const EventsScreen(
            id: '6',
            catName: "Events",
          ),
          isLogged ? const AccountScreen() : const Authentication(),
        ],
      ),
      // Temporary test button for HouseInRwanda scraper


      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },
        backgroundColor: isDarkTheme(context) ? kBlack : kWhite,
        elevation: 0,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(AntDesign.home, color: isDarkTheme(context) ? kWhite : kBlack),
            selectedIcon: Icon(AntDesign.home, color: isDarkTheme(context) ? kWhite : kBlack),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(AntDesign.appstore_o, color: isDarkTheme(context) ? kWhite : kBlack),
            selectedIcon: Icon(AntDesign.appstore_o, color: isDarkTheme(context) ? kWhite : kBlack),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: isDarkTheme(context) ? kWhite : kBlack),
            selectedIcon: Icon(Icons.chat_bubble, color: isDarkTheme(context) ? kWhite : kBlack),
            label: 'AskZoea',
          ),
          NavigationDestination(
            icon: Icon(Icons.event, color: isDarkTheme(context) ? kWhite : kBlack),
            selectedIcon: Icon(Icons.event, color: isDarkTheme(context) ? kWhite : kBlack),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(Ionicons.person_outline, color: isDarkTheme(context) ? kWhite : kBlack),
            selectedIcon: Icon(Ionicons.person_outline, color: isDarkTheme(context) ? kWhite : kBlack),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
