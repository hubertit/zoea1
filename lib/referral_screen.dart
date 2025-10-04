import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoea1/bookin_list_screen.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/delete_account_dialog.dart';
import 'package:zoea1/edit_profile_screen.dart';
import 'package:zoea1/feedback_bottom_dialog.dart';
import 'package:zoea1/json/merchant.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/real_estate.dart';
import 'package:zoea1/real_estate_search.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/views/events/my_events.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoea1/views/more/switch_country.dart';
import 'constants/assets.dart';
import 'json/user.dart';
import 'partial/cover_container.dart';
import 'partial/profile_item.dart';
import 'ults/functions.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends Superbase<ReferralScreen> {
  @override
  Widget build(BuildContext context) {
    print(User.user!.token);
    return  SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Invite your friends",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                Spacer(),
                IconButton(
                    onPressed: goBack,
                    icon: CircleAvatar(
                        radius: 14,
                        backgroundColor:
                        isDarkTheme(context) ? Colors.black : scaffoldColor,
                        child: const Icon(
                          Icons.close,
                          size: 17,
                        ))),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: InkWell(
// margin: const EdgeInsets.only(
//   left: 20,
//   right: 20,
// ),
              onTap: () {
                Share.share("https://linktr.ee/zoea.africa");
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xffeff4f8),
                          child: Icon(
                            CupertinoIcons.share,
                            color: Colors.black54,
// size: widget.iconSize,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          "Share invitation link",
                          style: TextStyle(
// color: widget.titleColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 50),
            child: Row(
              children: [
                Text(
                  "Your invitation code is:",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                Text("${generateRandomFiveDigitNumber()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    )
    ;
  }
}

//
// SingleChildScrollView(
// child: Column(
// children: [
// const SizedBox(
// height: 20,
// ),
// Padding(
// padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// "Invite your friends",
// textAlign: TextAlign.center,
// style: Theme.of(context).appBarTheme.titleTextStyle,
// ),
// Spacer(),
// IconButton(
// onPressed: goBack,
// icon: CircleAvatar(
// radius: 14,
// backgroundColor:
// isDarkTheme(context) ? Colors.black : scaffoldColor,
// child: const Icon(
// Icons.close,
// size: 17,
// ))),
// ],
// ),
// ),
// Container(
// margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
// child: InkWell(
// // margin: const EdgeInsets.only(
// //   left: 20,
// //   right: 20,
// // ),
// onTap: () {
// Share.share("https://linktr.ee/zoea.africa");
// },
// child: Column(
// children: [
// Row(
// children: [
// CircleAvatar(
// radius: 14,
// backgroundColor: const Color(0xffeff4f8),
// child: Icon(
// CupertinoIcons.share,
// color: Colors.black54,
// // size: widget.iconSize,
// )),
// const SizedBox(
// width: 20,
// ),
// const Padding(
// padding: EdgeInsets.symmetric(vertical: 6),
// child: Text(
// "Share invitation link",
// style: TextStyle(
// // color: widget.titleColor,
// fontWeight: FontWeight.w400),
// ),
// ),
// Expanded(child: Container()),
// ],
// ),
// ],
// ),
// ),
// ),
// Container(
// margin: EdgeInsets.only(left: 20, right: 20, bottom: 50),
// child: Row(
// children: [
// Text(
// "Your invitation code is:",
// style: TextStyle(fontWeight: FontWeight.w400),
// ),
// Text("${generateRandomFiveDigitNumber()}",
// style: const TextStyle(
// fontWeight: FontWeight.bold, color: Colors.green)),
// ],
// ),
// ),
// ],
// ),
// )
int generateRandomFiveDigitNumber() {
  Random random = Random();
  int randomNumber = 10000 +
      random.nextInt(90000); // Generates a number between 10000 and 99999
  return randomNumber;
}
