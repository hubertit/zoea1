import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';
import 'package:zoea1/post_real_estate.dart';
import 'package:zoea1/post_venue.dart';
import 'package:zoea1/json/user.dart';
import 'package:zoea1/super_base.dart';
import 'homepage.dart';
import 'partial/background_stack.dart';
import 'ults/functions.dart';
import 'views/events/add_event.dart';

class MerchantDialog extends StatefulWidget {
  const MerchantDialog({
    super.key,
  });

  @override
  State<MerchantDialog> createState() => _MerchantDialogState();
}

class _MerchantDialogState extends Superbase<MerchantDialog> {
  final _key = GlobalKey<FormState>();
  final _reviewController = TextEditingController();

  bool _loading = false;

  int _rating = 0;

  void submit() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(
          url: "app/addReview",
          method: "POST",
          data: FormData.fromMap({
            "token": User.user!.token,
            "rating": _rating,
            "review": _reviewController.text
          }),
          onValue: (obj, url) {
            if (obj['code'] == 200) {
              goBack();
              showMessageSnack(obj);
            }
          });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    // kwitizinaSnack(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBlur(
      screens: Container(
        height: 400,
        child: SafeArea(
          child: Container(
            // height: 800,
            decoration: BoxDecoration(
                color: isDarkTheme(context) ? semiBlack : Colors.white,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            padding: const EdgeInsets.all(15)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(
                      //     onPressed: () {},
                      //     icon: CircleAvatar(
                      //         radius: 14,
                      //         backgroundColor: isDarkTheme(context)
                      //             ? Colors.black
                      //             : scaffoldColor,
                      //         child: const Icon(
                      //           Ionicons.ios_close,
                      //           size: 23,
                      //         ))),
                      Text(
                        "Onboard your self",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    postItem(context, Icons.calendar_month, "Event", () {
                      push(const CreateEventScreen());
                    }),
                    postItem(context, Icons.explore, "Venues", () {
                      push(const PostVenueScreen());
                    }),
                    postItem(context, Icons.real_estate_agent_outlined,
                        "Post properties", () {
                      push(const PostRealEstate());
                    })
                  ],
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
      paddingSize: 0.0,
    );
  }
}

postItem(
    BuildContext context, IconData icon, String title, void Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDarkTheme(context) ? Color(0xff212121) : scaffoldColor,
          ),
          child: Icon(
            icon,
            size: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
