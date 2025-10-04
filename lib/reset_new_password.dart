import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/password_filed.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/ults/style_utls.dart';

import 'authentication.dart';
import 'constants/assets.dart';
import 'ults/functions.dart';
import 'views/auth/widgets/auth_btn.dart';

class ResetNewPassword extends StatefulWidget {
  final String token;
  final String userId;
  const ResetNewPassword(
      {super.key, required this.token, required this.userId});

  @override
  State<ResetNewPassword> createState() => _ResetNewPasswordState();
}

class _ResetNewPasswordState extends Superbase<ResetNewPassword> {
  final _key = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();
  bool _loading = false;

  void validateCode() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(
          url: "account/newPassword",
          method: "POST",
          data: FormData.fromMap({
            "user_id": widget.userId,
            "new_password": _passwordController.text,
          }),
          onValue: (object, url) {
            if (object['code'] == 200) {
              showMessageSnack(object);
              push(const Authentication());
            } else {
              showMessageSnack(object);
            }
            // save(userKey, object['data']);
            // saveVal(tokenKey, object['accessToken']);
            // User.user = User.fromJson(object['data']);
            // push(const Homepage(),replaceAll: true);
          });
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: Column(
              children: [
                Image.asset(
                  isDarkTheme(context)
                      ? AssetUtls.logoWhite
                      : AssetUtls.logoDark,
                  fit: BoxFit.contain,
                  height: 60,
                ),

                // const TitleText(
                //   text: "Guhingura ijambobanga",
                // ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Create new password",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                PasswordField(
                  controller: _passwordController,
                  validator: validateRequired,
                  decoration: InputDecoration(
                      border: StyleUtls.commonInputBorder,
                      hintText: "Enter new password"),
                ),
                const SizedBox(
                  height: 20,
                ),
                PasswordField(
                  controller: _cPasswordController,
                  validator: validateRequired,
                  decoration: InputDecoration(
                      border: StyleUtls.commonInputBorder,
                      hintText: "Confirm password"),
                ),
                _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : AuthButton(
                        onPressed: validateCode, text: 'Create password'),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: OutlinedButton(
                      onPressed: () {
                        push(const Authentication());
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red),
                      child: Container(
                          height: 52,
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          child: const Text("Cancel"))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
