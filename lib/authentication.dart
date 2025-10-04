import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/forgot_password.dart';
import 'package:zoea1/password_filed.dart';
import 'package:zoea1/registration.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/views/auth/widgets/auth_btn.dart';

import 'homepage.dart';
import 'json/user.dart';
import 'ults/functions.dart';
import 'ults/style_utls.dart';
import 'views/auth/widgets/custom_text_button.dart';
import 'views/auth/widgets/phone_field.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends Superbase<Authentication> {
  var key = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  bool loading = false;
  late Country country;

  @override
  void initState() {
    country = CountryService().findByCode("RW")!;
    super.initState();
  }

  void login() async {
    if (key.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });
      await ajax(
          url: "account/login",
          method: "POST",
          data: FormData.fromMap({
            "user_phone": "${country.phoneCode}${phoneController.text}",
            "user_password": passwordController.text,
          }),
          onValue: (obj, url) async {
            if (obj['code'] == 200) {
              save(userKey, obj['data']);
              User.user = User.fromJson(obj['data']);
              // print("Data returned ${obj['data']}");
              // print(User.fromJson(obj['data']).fName);
              // await showDialog(context: context, builder: (context)=>const AuthenticationMessageDialog());
              if (mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
                push(const Homepage(), replaceAll: true);
              }
            } else {
              showSnack(obj['message'], context: context);
            }
          });

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF181A20) // dark background
            : const Color(0xFFF7F7F9), // light background
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Form(
                    key: key,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 100),
                              height: 60,
                              width: double.maxFinite,
                              child: Image.asset(
                                isDarkTheme(context)
                                    ? AssetUtls.logoWhite
                                    : AssetUtls.logoDark,
                                fit: BoxFit.contain,
                              )),
                          const SizedBox(
                            height: 100,
                          ),
                          Text(
                            'Log into your account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          // Container(
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(5),
                          //         color:
                          //             const Color.fromARGB(255, 224, 223, 223)),
                          //     child:
                          // TextFormField(
                          //   controller: phoneController,
                          //   validator: validateRequired,
                          //   keyboardType: TextInputType.phone,
                          //   decoration: InputDecoration(
                          //       contentPadding:
                          //           const EdgeInsets.symmetric(horizontal: 10),
                          //       border: StyleUtls.commonInputBorder,
                          //       hintText: 'Enter your phone number'),
                          //   // )
                          // ),
                          PhoneField(
                            validator: validateMobile,
                            country: country,
                            controller: phoneController,
                            callback: (Country country) {
                              setState(() {
                                this.country = country;
                                print(country.phoneCode);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Container(
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(5),
                          //         color:
                          //             const Color.fromARGB(255, 224, 223, 223)),
                          // child:
                          PasswordField(
                            controller: passwordController,
                            validator: validateRequired,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                border: StyleUtls.commonInputBorder,
                                hintText: 'Enter your password'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextButton(
                              questionText: "",
                              directingText: 'Forgot your password?',
                              onTap: () {
                                push(const ForgotPassword());
                              }),

                          loading
                              ? const CircularProgressIndicator()
                              : AuthButton(
                                  onPressed: login,
                                  text: 'Login',
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextButton(
                              questionText: "Don't have account?",
                              directingText: 'Signup',
                              onTap: () {
                                push(const Registration());
                              }),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
