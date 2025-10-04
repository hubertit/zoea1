import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoea1/bookin_list_screen.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/conversation_screen.dart';
import 'package:zoea1/delete_account_dialog.dart';
import 'package:zoea1/edit_profile_screen.dart';
import 'package:zoea1/favorites_screen.dart';
import 'package:zoea1/feedback_bottom_dialog.dart';
import 'package:zoea1/json/merchant.dart';
import 'package:zoea1/main.dart';
import 'package:zoea1/referral_screen.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/views/events/my_events.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoea1/views/more/switch_country.dart';
import 'constants/assets.dart';
import 'json/user.dart';
import 'partial/cover_container.dart';
import 'partial/profile_item.dart';
import 'ults/functions.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends Superbase<AccountScreen> {
  Merchant? merchant;
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    // TODO: implement initState
    navigate();
    getMerchant();
    super.initState();
  }

  void navigate() async {
    var string = (await prefs).getString(userKey);
    if (string != null) {
      if (mounted) {
        User.user = User.fromJson(jsonDecode(string));
        setState(() {});
      }
    }
  }

  void getMerchant() async {
    await ajax(
        url: "account/profile",
        method: "POST",
        data: FormData.fromMap({
          "token": User.user!.token,
        }),
        onValue: (s, v) async {
          if (s['code'] == 200) {
            if (s['data']['merchant'] != null) {
              setState(() {
                merchant = Merchant.fromJson(s['data']['merchant']);
              });
            }
          } else {}
        });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      _saveTheme(_themeMode);
    });
  }

  void _saveTheme(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    print(User.user!.token);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My account')),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF181A20) // dark background
            : const Color(0xFFF7F7F9), // light background
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF23242B) // dark card background
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF262A34)
                            : scaffoldColor,
                        child: Image.asset(
                          AssetUtls.user,
                          height: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${User.user!.fName}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${User.user!.phone}",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFFB3B3B3)
                                : Colors.black87,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (User.user!.accountType == "merchant")
                Container(
                  height: 180,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: Stack(
                        children: [
                          Container(
                            height: 180,
                            width: double.maxFinite,
                            margin: const EdgeInsets.only(right: 20),
                            padding: EdgeInsets.only(left: 25, top: 5),
                            color: Colors.white,
                            child: IntrinsicHeight(
                              child: IntrinsicWidth(
                                child: PieChart(
                                  PieChartData(
                                    centerSpaceRadius: 2,
                                    borderData: FlBorderData(show: false),
                                    sectionsSpace: 2,
                                    sections: [
                                      PieChartSectionData(
                                        value: merchant!.chat.reservations,
                                        color: primaryColor,
                                        titleStyle:
                                            const TextStyle(color: Colors.white),
                                        radius: 80,
                                      ),
                                      PieChartSectionData(
                                        value: merchant!.chat.payments,
                                        color: const Color(0xffe2e2e7),
                                        titleStyle:
                                            const TextStyle(color: primaryColor),
                                        radius: 80,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              width: double.maxFinite,
                              child: const Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 4.5,
                                        backgroundColor: primaryColor,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Reservations',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 4.5,
                                        backgroundColor: Color(0xffe2e2e7),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Payments',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 84,
                            width: 115,
                            color: primaryColor,
                            child: Card(
                              elevation: 0.2, color: primaryColor,
                              shape: const RoundedRectangleBorder(),
                              // decoration: BoxDecoration(border: Border.all(color: const Color(
                              //     0xff1d542b))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "WALLET",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${merchant!.wallet}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 84,
                            width: 115,
                            color: const Color(0xffe2e2e7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Collected",
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${merchant!.collected}",
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              if (User.user!.accountType == "merchant")
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    children: [
                      SummaryBox(
                          tape: () async {},
                          image: 'assets/images/success.png',
                          title: "Reservations",
                          subtitle: Text(
                            "${merchant!.reservations}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                      Container(
                        width: 20,
                      ),
                      SummaryBox(
                          tape: () async {},
                          image: 'assets/images/success.png',
                          title: "Payments",
                          subtitle: Text(
                            "${merchant!.payments}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                    ],
                  ),
                ),
              CoverContainer(children: [
                Column(
                  children: [
                    Row(
                      children: [
                         CircleAvatar(
                            radius: 14,
                            backgroundColor:  isDarkTheme(context)
                                ? Colors.grey
                                : const Color(0xffeff4f8),
                            child: const Icon(
                              Icons.dark_mode,
                              color: Colors.black54,
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            "Dark mode",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(child: Container()),
                        Switch(
                          value: isDarkTheme(context),
                          onChanged: (value) {
                            MyApp.of(context).toggleTheme();
                            // _toggleTheme();
                          },
                          inactiveTrackColor: Colors.white,
                          activeTrackColor: Colors.white,
                          activeColor: Colors.black,
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.4,
                    )
                  ],
                ),
                ProfileItemIcon(
                  title: 'Switch country',
                  onPressed: () {
                    push(const StoreScreen());
                  },
                  leadingIcon: Icons.language,
                  // avatarColor: const Color(0xffeff4f8),
                  isLast: true,
                ),
              ]),
              CoverContainer(children: [
                ProfileItemIcon(
                  title: 'My events',
                  onPressed: () {
                    push(const MyEventsScreen());
                  },
                  leadingIcon: Icons.event,
                  // avatarColor: Colors.grey,
                ),
                ProfileItemIcon(
                  title: 'Favorites',
                  onPressed: () {
                    push(const FavoritesScreen());
                  },
                  leadingIcon: Icons.favorite,
                  // avatarColor: Colors.grey,
                ),
                ProfileItemIcon(
                  title: 'My bookings',
                  onPressed: () {
                    push(const BookingListScreen());
                  },
                  isLast: true,
                  leadingIcon: Entypo.ticket,
                  // avatarColor: Colors.grey,
                ),
              ]),
              CoverContainer(children: [
                ProfileItemIcon(
                    title: 'Invite friends',
                    onPressed: () {
                      // push(ReferralScreen());
                      // final Uri uri = Uri(
                      //   scheme: 'https',
                      //   path:
                      //   'https://tawk.to/chat/66197da9a0c6737bd12b35b6/1hr9p5o24',
                      // );
                      // launchUrlString('https://join.zoea.africa/?=hki83');
                      // _launch(uri);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => const ReferralScreen());
                    },
                    leadingIcon: Icons.link,
                    // avatarColor:  Colors.grey
                ),
                ProfileItemIcon(
                  title: 'Feedback',
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => const FeedbackBottomDialog());
                  },
                  leadingIcon: Entypo.message,
                  // avatarColor: Colors.grey,
                  // isLast: true,
                ),
                ProfileItemIcon(
                    title: 'Support',
                    onPressed: () {
                      final Uri uri = Uri(
                        scheme: 'https',
                        path:
                            'https://tawk.to/chat/66197da9a0c6737bd12b35b6/1hr9p5o24',
                      );
                      launchUrlString(
                          'https://tawk.to/chat/66197da9a0c6737bd12b35b6/1hr9p5o24');
                      // _launch(uri);
                    },
                    leadingIcon: Icons.help_outline,
                    isLast: true,
                    // avatarColor: Colors.grey
                ),
              ]),
              CoverContainer(children: [
                ProfileItemIcon(
                    title: 'Edit profile',
                    onPressed: () {
                      push(const EditProfileScreen());
                    },
                    leadingIcon: Icons.edit,
                    // avatarColor: Colors.grey
                ),
                ProfileItemIcon(
                    title: 'Logout',
                    onPressed: () {
                      Future<void> logMeOut() async {
                        var b = await confirmDialog(context);
                        if (b) {
                          logOut();
                        }
                      }

                      logMeOut();
                    },
                    leadingIcon: Icons.logout,
                    iconColor: Colors.red,
                    // avatarColor: Colors.grey
                ),
                ProfileItemIcon(
                  title: 'Delete account',
                  titleColor: Colors.red,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content:
                              const Text('Do you want to delete your account?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const DeleteAccountDialog());
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  leadingIcon: Icons.delete,
                  iconColor: Colors.red,
                  // avatarColor: Colors.grey,
                  arrowColor: Colors.red,
                  isLast: true,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryBox extends StatelessWidget {
  final String image;
  final String title;
  final Widget subtitle;
  final VoidCallback? tape;
  const SummaryBox(
      {super.key,
      required this.image,
      required this.title,
      this.tape,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: tape,
        child: Container(
          padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: scaffoldColor,
                radius: 25,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    image,
                    // fit: BoxFit.contain,
                    height: 20,
                  ),
                ),
              ),
              Container(
                width: 10,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 12),
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    subtitle
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
