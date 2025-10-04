import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/homepage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';
import 'package:zoea1/ults/functions.dart';

import 'constants/theme.dart';

import 'notification/push_notifications.dart';
import 'super_base.dart';
import 'services/api_key_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;


const primaryColor = Color(0xff000000);
final navigatorKey = GlobalKey<NavigatorState>();



void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add global error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };
  
  // Handle errors that occur during zone execution
  runZonedGuarded(() async {
    // Initialize API Key Manager
    await ApiKeyManager.initialize();
    




  PushNotifications.init();
  // only initialize if platform is not web
  if (!kIsWeb) {
    try {
      PushNotifications.localNotiInit();
    } catch (e) {
      print("Error initializing local notifications: $e");
    }
  }



  ThemeMode _themeMode = ThemeMode.system;
  runApp(riverpod.ProviderScope(child: MyApp()));
  }, (error, stack) {
    print('Unhandled error: $error');
    print('Stack trace: $stack');
  });
}

class MyApp extends StatefulWidget {
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
  // final ThemeMode themeMode;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    _loadTheme(); // Load the saved theme when the app starts
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void toggleTheme() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      theme: ThemeData(
          fontFamily: 'Sora',
          primaryColor: primaryColor,
          scaffoldBackgroundColor: scaffoldColor,
          progressIndicatorTheme: ProgressIndicatorThemeData(
              refreshBackgroundColor:
                  isDarkTheme(context) ? Colors.black : Colors.white),
          textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: 0.85, // 14 * 0.85 ≈ 12
              ),
          bottomSheetTheme: const BottomSheetThemeData(
            elevation: 0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          ),
          cardTheme:  CardTheme(color:isDarkTheme(context)?semiBlack: Colors.white),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.black, // Set your desired title text color here
                fontSize: 18, // Set your desired title text size here
                fontWeight: FontWeight.bold,
              )),
          primarySwatch: createPrimarySwatch(),
          dialogTheme: DialogTheme(
            elevation: 0,
            backgroundColor: Colors.white, // Set your desired background color
            // titleTextStyle: TextStyle(color: Colors.white), // Set title text color
            // contentTextStyle: TextStyle(color: Colors.white), // Set content text color
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Set dialog border radius
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            elevation: 0,

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Set dialog border radius
            ),
            // backgroundColor: Colors.grey[900], // Set background color
            // S// Set confirm button text color
          ),
          timePickerTheme: TimePickerThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Set dialog border radius
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? null
                  : const Color(0xfae4e4e4),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24))),
          snackBarTheme: const SnackBarThemeData(
              contentTextStyle: TextStyle(color: primaryColor),
              backgroundColor:
                  Color(0xffb9cbcb) // Set your desired background color here
              // You can also set other properties like contentTextStyle, elevation, etc.
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  textStyle:  TextStyle(
                    fontSize: 16,
                    color:isDarkTheme(context)?semiBlack: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)))),
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black))),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              // backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.black), // Button background color
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
              textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(fontSize: 16)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: kWhite,
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(
                  color: kBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
              }
              return const TextStyle(
                color: kGrayAccent,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              );
            }),
            iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(color: kBlack);
              }
              return const IconThemeData(color: kGrayAccent);
            }),
          ),
        ),
      home: const MyHomePage(title: 'Tarama'),
      themeMode: _themeMode,
      darkTheme: darkTheme,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends Superbase<MyHomePage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      navigate();
    });
  }

  // void checkPlatform() {
  //   final now = DateTime.now();
  //   final cutoffDate = DateTime(2025, 4, 1);
  //
  //   if (Platform.isAndroid && now.isAfter(cutoffDate)) {
  //     showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //               title: const Text(
  //                   "🚨 This version of the ZOEA App is no longer supported",
  //                   style: TextStyle(fontSize: 16),
  //                   textAlign: TextAlign.center),
  //               content: Container(
  //                 height: 150,
  //                 child: const Column(
  //                   children: [
  //                     Text(
  //                       "Please uninstall this version and download the latest version from our new Play Store link to continue enjoying updates and features.",
  //                       style: TextStyle(fontSize: 14),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Divider(),
  //                     Text(
  //                       "If you have any questions or need help, feel free to contact us",
  //                       style: TextStyle(fontSize: 14),
  //                       textAlign: TextAlign.center,
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ));
  //     // showDialog(
  //     //   context: context,
  //     //   builder: (context) => AlertDialog(
  //     //     title: const Text("Update Required"),
  //     //     content: const Text(
  //     //         "Please download the updated app from the Play Store to continue."),
  //     //     actions: [
  //     //       TextButton(
  //     //         onPressed: () => Navigator.of(context).pop(),
  //     //         child: const Text("OK"),
  //     //       ),
  //     //     ],
  //     //   ),
  //     // );
  //   } else if (Platform.isIOS) {
  //     checkVersion();
  //     Future.delayed(const Duration(seconds: 0))
  //         .then((value) => checkVersion());
  //     print("Running on iOS");
  //   } else {
  //     print("Running on another platform");
  //   }
  // }

  void navigate() async {
    var string = (await prefs).getString(userKey);
    // if (string != null) {
      if (mounted) {
    //     User.user = User.fromJson(jsonDecode(string));
            Future.delayed(const Duration(seconds: 2))
                .then((value) =>
    push(const Homepage(), replace: true));
    }
    // } else if (mounted) {
    //   push(const Authentication(), replace: true);
    // }
  }

  // void checkVersion() async {
  //   await ajax(
  //       url: "version/",
  //       method: "POST",
  //       data: FormData.fromMap({"token": ""}),
  //       onValue: (s, v) {
  //         print("________");
  //         print(s);
  //         print("________");
  //         // Superbase.smartKey = s['key'];
  //         // Superbase.smartKey = s['key'];
  //         // Superbase.gptKey = s['gpt_key'];
  //         var version = s['version'];
  //
  //         if (Platform.isIOS) {
  //           version = version['iOS'];
  //           checkDeviceVersion(context, version['version'],
  //               url: version['url']);
  //         } else if (Platform.isAndroid) {
  //           version = version['Android'];
  //           checkDeviceVersion(context, version['version'],
  //               url: version['url']);
  //         }
  //       });
  //   setState(() {
  //     _loading = false;
  //   });
  // }

  void reload() {
    setState(() {
      _loading = true;
    });
    // checkVersion();
    navigate();
  }

  // // Future<bool>
  // checkDeviceVersion(BuildContext context, String version,
  //     {required String url})  {
  //   // var inf = await getVersion;
  //   // Version currentVersion = Version.parse(inf);
  //   // Version storeVersion = Version.parse(version);
  //   //
  //   // bool dismissible = currentVersion >= storeVersion;
  //   //
  //   // if (currentVersion < storeVersion && mounted) {
  //   //   showDialog(
  //   //       context: context,
  //   //       barrierDismissible: false,
  //   //       builder: (context) => WillPopScope(
  //   //             onWillPop: () => Future.value(dismissible),
  //   //             child: Builder(builder: (context) {
  //   //               var button = TextButton(
  //   //                 onPressed: () {
  //   //                   // final Uri urlUpdate = Uri.parse('https://www.tarama.ai/update');
  //   //                   // launchUrl(urlUpdate);
  //   //
  //   //                   launchUrl(Uri.parse("https://www.tarama.ai/update"));
  //   //                 },
  //   //                 // url != null ? () => openLink(url) : null,
  //   //                 child: const Text("Update"),
  //   //               );
  //   //               return AlertDialog(
  //   //                 title: const Text("Updates Available"),
  //   //                 content: Text(
  //   //                     "Update to new version $version from currently installed version $inf"),
  //   //                 actions: [button],
  //   //               );
  //   //             }),
  //   //           ));
  //   // } else {
  //     navigate();
  //   // }
  //   //
  //   // return dismissible;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xff10644D),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetUtls.kigali), // Replace with your image URL or AssetImage for local assets
                  fit: BoxFit
                      .cover, // Adjust the image's fit within the container
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 10,
              right: 10,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                // height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 70,
              left: 10,
              right: 10,
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(left: 20),
                // height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "to Rwanda",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // const Text(
                    //   "to Kigali",
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 45,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    const Text(
                      "Explore, Connect, Experience!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    // const Text(
                    //   "Kigali together",
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w700),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),

                    // const Text(
                    //   "of the city with us",
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w500),
                    // ),
                    const Text(
                      "Powered by ZOEA AFRICA",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      AssetUtls.zoeaWhite,
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
