import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/authentication.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/super_base.dart';
import 'package:zoea1/verification_code.dart';
import 'ults/functions.dart';
import 'views/auth/widgets/auth_btn.dart';
import 'views/auth/widgets/phone_field.dart';
import 'views/auth/widgets/title_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends Superbase<ForgotPassword> {
  final _key = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  bool _loading = false;
  late Country country;

  @override
  void initState() {
    country = CountryService().findByCode("RW")!;
    super.initState();
  }

  void register() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });

      // Construct phone number
      String phone = "${country.phoneCode}${_phoneController.text}";

      // Create FormData object and add phone number
      FormData formData = FormData.fromMap({
        "user_phone": phone,
      });

      try {
        await ajax(
          url: "account/resetPassword",
          method: "POST",
          data: formData, // Pass FormData object to ajax method
          onValue: (object, url) async {
            print(object);
            if (object["code"] == 200) {
              push(VerificationCode(
                phone: phone,
                message: object["message"],
                email: "",
              ));
            }
          },
        );
      } catch (e) {
        // Handle error
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: Column(
              children: [
                SizedBox(
                    // margin: const EdgeInsets.only(top: 100),
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
                const TitleText(
                  text: "Forgot your password?",
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Enter your phone numbe and we will send you reset code",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                PhoneField(
                  country: country,
                  controller: _phoneController,
                  callback: (Country country) {
                    setState(() {
                      this.country = country;
                    });
                  },
                ),
                _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : AuthButton(onPressed: register, text: 'Request code'),
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

      // Form(
      //   key: _key,
      //   child: ListView(
      //     padding: const EdgeInsets.all(30.0),
      //     children: [
      //       const Padding(
      //         padding: EdgeInsets.all(8.0),
      //         child: Text("Forgot Password !",textAlign: TextAlign.center,style: TextStyle(
      //             fontWeight: FontWeight.w700,
      //             fontSize: 24
      //         ),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 50).copyWith(bottom: 30,top: 8),
      //         child: const Text("Recover your account password",textAlign: TextAlign.center,style: TextStyle(
      //             fontWeight: FontWeight.w500,
      //             fontSize: 16,
      //             color: Color(0xff78828A)
      //         ),),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(bottom: 40),
      //         child: TextFormField(
      //           controller: _phoneController,
      //           validator: validateRequired,
      //           decoration: const InputDecoration(
      //
      //               hintText: "Enter your phone number"
      //           ),
      //         ),
      //       ),
      //       _loading ? const Center(
      //         child: CircularProgressIndicator(),
      //       ) : ElevatedButton(onPressed: register, child: const Text("Continue"))
      //     ],
      //   ),
      // ),
    );
  }
}
