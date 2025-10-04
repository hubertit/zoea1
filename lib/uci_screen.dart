// import 'dart:async';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'main.dart';
// import 'riverpod/providers.dart';
//
// class UCIScreen extends ConsumerStatefulWidget {
//   const UCIScreen({super.key});
//
//   @override
//   ConsumerState<UCIScreen> createState() => _UCIScreenState();
// }
//
// class _UCIScreenState extends ConsumerState<UCIScreen> {
//   late Timer _timer;
//   late Duration _timeRemaining;
//
//   @override
//   void initState() {
//     super.initState();
//     DateTime eventStart = DateTime(2025, 9, 21, 0, 0, 0);
//     _timeRemaining = eventStart.difference(DateTime.now());
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         _timeRemaining -= const Duration(seconds: 1);
//       });
//     });
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await ref.read(categoriesProvider.notifier).featuredProducts(ref);
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     Color darkBlue = const Color(0xff1D428A);
//     Color redii = const Color(0xffCE2943);
//     var categories = ref.watch(categoriesProvider);
//
//     int days = _timeRemaining.inDays;
//     int hours = _timeRemaining.inHours % 24;
//     int minutes = _timeRemaining.inMinutes % 60;
//     int seconds = _timeRemaining.inSeconds % 60;
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primaryColor,
//         title: const Text(
//           "Basketball Africa League (BAL)",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       backgroundColor: isDark ? Colors.black : Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               color: redii,
//               height: 60,
//               width: MediaQuery.of(context).size.width,
//               child: const Center(
//                 child: Text(
//                   '05 APRIL - 14 JUNE 2025',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ),
//             ),
//             Image.network(
//               "https://cdn-bal.nba.com/manage/sites/3/2025/02/16x9-generic-1024x576.png",
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "BASKETBALL AFRICA LEAGUE ",
//                       style: TextStyle(
//                         color: darkBlue,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "SEASON 5 ",
//                       style: TextStyle(
//                         color: redii,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "TICKETS",
//                       style: TextStyle(
//                         color: darkBlue,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 20),
//               child: RichText(
//                 text: TextSpan(
//                   style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black),
//                   children: [
//                     const TextSpan(
//                       text: "Tickets for season 5 of the BAL season are now available. Learn more about ticket prices and where to purchase by clicking the LEARN MORE button below. You can purchase your tickets at ",
//                     ),
//                     TextSpan(
//                       text: "Teewtickets.com (Dakar)",
//                       style: TextStyle(color: darkBlue),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse("https://bal-teewticket.com/#events"));
//                         },
//                     ),
//                     const TextSpan(text: " and at "),
//                     TextSpan(
//                       text: "Guichet.com/sport (Rabat)",
//                       style: TextStyle(color: darkBlue),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse("https://bal.nba.com/2025-tickets#:~:text=Dakar)%20and%20at-,Guichet.com/sport"));
//                         },
//                     ),
//                     const TextSpan(text: ". Printed tickets can be purchased for the Kalahari Conference as well as at the following physical locations: "),
//                     TextSpan(
//                       text: "Megarama Cinema in Casablanca",
//                       style: TextStyle(color: darkBlue),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse("https://www.google.com/maps/dir/14.7324928,-17.514496/megarama+casablanca/..."));
//                         },
//                     ),
//                     const TextSpan(text: ", "),
//                     TextSpan(
//                       text: "Megarama Cinema in Fes",
//                       style: TextStyle(color: darkBlue),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse("https://www.google.com/maps/dir/14.7324928,-17.514496/megarama+fes/..."));
//                         },
//                     ),
//                     const TextSpan(text: ", and "),
//                     TextSpan(
//                       text: "National Theatre in Rabat",
//                       style: TextStyle(color: darkBlue),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse("https://www.google.com/maps/dir/14.7324928,-17.514496/national+theatre+rabat/..."));
//                         },
//                     ),
//                     const TextSpan(text: "."),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: 50,
//               margin: const EdgeInsets.all(10.0),
//               width: double.maxFinite,
//               child: ElevatedButton(
//                 onPressed: () {
//                   launchUrlString("https://bal.nba.com/games");
//                 },
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: darkBlue,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5))),
//                 child: const Text(
//                   "Explore more",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimeCard(int value, String label) {
//     return Column(
//       children: [
//         Text(
//           value.toString().padLeft(2, '0'),
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 14, fontWeight: FontWeight.w400)),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/functions.dart';
import 'constants/theme.dart';
import 'main.dart';
import 'riverpod/providers.dart';

class UCIScreen extends ConsumerStatefulWidget {
  const UCIScreen({super.key});

  @override
  ConsumerState<UCIScreen> createState() => _UCIScreenState();
}

class _UCIScreenState extends ConsumerState<UCIScreen> {
  Timer? _timer; // Make nullable
  Duration _timeRemaining = Duration.zero; // Initialize with default value

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(categoriesProvider.notifier).featuredProducts(ref);
      } catch (e) {
        debugPrint('Error loading featured products: $e');
      }
    });
  }

  void _initializeTimer() {
    try {
      DateTime eventStart = DateTime(2025, 9, 21, 0, 0, 0);
      _timeRemaining = eventStart.difference(DateTime.now());
      
      // Only start timer if time remaining is positive
      if (_timeRemaining.isNegative) {
        _timeRemaining = Duration.zero;
        return;
      }
      
      // Start a timer to update the countdown every second
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _timeRemaining -= const Duration(seconds: 1);
            if (_timeRemaining.isNegative) {
              _timeRemaining = Duration.zero;
              _timer?.cancel();
            }
          });
        }
      });
    } catch (e) {
      debugPrint('Error initializing timer: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var categories = ref.watch(categoriesProvider);

    // services.add(Service("More", "menu.png"));
    // Extract days, hours, minutes, and seconds
    int days = _timeRemaining.inDays;
    int hours = _timeRemaining.inHours % 24;
    int minutes = _timeRemaining.inMinutes % 60;
    int seconds = _timeRemaining.inSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width,
        backgroundColor: primaryColor,
        leading: Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Image.asset(
            AssetUtls.uciLogo,
            // height: 20,
            width: MediaQuery.of(context).size.width / 1,
          ),
        ),
        // actions: const [
        //   Icon(
        //     Ionicons.cart,
        //     color: Colors.white,
        //     size: 30,
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event date range
            Container(
              color: const Color(0xffb42741),
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Text(
                  '21-28 September 2025',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Countdown row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeCard(days, 'Days'),
                  const SizedBox(
                    width: 20,
                    child: Center(
                        child: Text(
                          ":",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                  _buildTimeCard(hours, 'Hours'),
                  const SizedBox(
                    width: 20,
                    child: Center(
                        child: Text(
                          ":",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                  _buildTimeCard(minutes, 'Minutes'),
                  const SizedBox(
                    width: 20,
                    child: Center(
                        child: Text(
                          ":",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ),
                  _buildTimeCard(seconds, 'Seconds'),
                ],
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: const Text(
            //     "Packages",
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold, fontSize: 16),
            //   ),
            // ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children:
            //     List.generate(categories.length, (index) {
            //       var category = categories[index];
            //       return InkWell(
            //         onTap: () {
            //           // context.push("/category", extra: category);
            //         },
            //         child: Container(
            //           height: 100,
            //           width: 100,
            //           margin: const EdgeInsets.only(right: 10),
            //           padding: const EdgeInsets.symmetric(
            //               vertical: 10, horizontal: 10),
            //           decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(5),
            //           ),
            //           child: Column(
            //             children: [
            //               Expanded(
            //                   child: Image.network(
            //                       category.categoryImage)),
            //               Text(
            //                 trimm(11, category.categoryName),
            //                 style: const TextStyle(fontSize: 12),
            //               )
            //             ],
            //           ),
            //         ),
            //       );
            //     }),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Image.asset(AssetUtls.uciImg),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: RichText(
                text: const TextSpan(
                  children: [
                    // First word: "Riding"
                    TextSpan(
                      text: "Riding ",
                      style: TextStyle(
                        color: Colors.blue, // Blue color
                        fontSize: 24, // Font size
                        fontWeight: FontWeight.bold, // Bold font
                      ),
                    ),
                    // Middle word: "New"
                    TextSpan(
                      text: "New ",
                      style: TextStyle(
                        color: Colors.green, // Green color
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Last word: "Heights"
                    TextSpan(
                      text: "Heights",
                      style: TextStyle(
                        color: Colors.blue, // Blue color
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                  "From September 21st to 28th, 2025, the global cycling spotlight will shine on the vibrant city of Kigali, Rwanda, to host the prestigious UCI Road World Championships for the first time on the African continent in the event’s 103-year history."),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                  "It is a momentous occasion that will leave a lasting legacy, inspiring generations to embrace the joy of cycling and continue reaching new heights."),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.all(10.0),
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: () {
                    launchUrlString("https://ucikigali2025.rw/");
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text(
                    "Read more",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

// Helper method to build each time card
  Widget _buildTimeCard(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                // color: Colors.black,
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}