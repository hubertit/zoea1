import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zoea1/authentication.dart';
import 'package:zoea1/complete_registration.dart';
import 'package:zoea1/reset_new_password.dart';
import 'constants/assets.dart';
import 'super_base.dart';
import 'ults/functions.dart';
import 'ults/style_utls.dart';
import 'views/auth/widgets/auth_btn.dart';
import 'views/auth/widgets/title_text.dart';

class VerificationCode extends StatefulWidget {
  final String phone;
  final String email;
  final String message;
  final bool fromRegistration;
  const VerificationCode(
      {super.key,
      required this.phone,
      this.fromRegistration = false,
      required this.message,
      required this.email});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends Superbase<VerificationCode> {
  final _key = GlobalKey<FormState>();
  final codeController = TextEditingController();

  bool _loading = false;

  String? _code;

  void validateCode() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(
          url: "account/verifyCode",
          method: "POST",
          data: FormData.fromMap(
              {"user_phone": widget.phone, "code": codeController.text}),
          onValue: (object, url) {
            if (object['code'] == 200) {
              // if (widget.fromRegistration) {
              //   push(CompleteRegistration(
              //     token: object['data']['user_token'],
              //     fromPhone: widget.phone.isNotEmpty,
              //   ));
              // } else {
              push(ResetNewPassword(
                token: object['data']['user_token'],
                userId: object['data']['user_id'],
              ));
              // }
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

  bool _resending = false;

  void resendCode() async {
    if (_resending) {
      return;
    }
    setState(() {
      _resending = true;
    });
    await ajax(
        url: "account/resendCode",
        method: "POST",
        data: FormData.fromMap({"user_phone": widget.phone}));
    setState(() {
      _resending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
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

                // const TitleText
                //   text: "Guhingura ijambobanga",
                // ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "${widget.message}, check and fill it in the form below",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: codeController,
                  validator: validateRequired,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      border: StyleUtls.commonInputBorder,
                      hintText: 'Enter code '),
                  // )
                ),
                _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : AuthButton(onPressed: validateCode, text: 'Verify code'),
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

      // Center(
      //   child: Form(
      //     key: _key,
      //     child: ListView(
      //       padding: listPadding,
      //       children: [
      //         const Center(
      //           child: Padding(
      //             padding: EdgeInsets.only(top: 20,bottom: 20),
      //             child: Text("Enter OTP",style: TextStyle(
      //                 fontSize: 25,
      //                 fontWeight: FontWeight.w700
      //             ),),
      //           ),
      //         ),
      //         Text("We have just sent you 4 digit code via your phone ${widget.email} ${widget.phoneCode}${widget.phone}",style: const TextStyle(
      //           color: Color(0xff6C6C6C),
      //           fontWeight: FontWeight.w500,
      //           fontSize: 14
      //         ),textAlign: TextAlign.center,),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 25,top: 25),
      //           child: PinCodeTextField(
      //             length: 4,
      //             obscureText: false,
      //             enabled: !_loading,
      //             animationType: AnimationType.fade,
      //             keyboardType: TextInputType.number,
      //             cursorColor: Theme.of(context).primaryColor,
      //             backgroundColor: Colors.transparent,
      //             pinTheme: PinTheme(
      //               activeColor: Theme.of(context).primaryColor,
      //               inactiveColor: Colors.grey,
      //               shape: PinCodeFieldShape.box,
      //               borderRadius: BorderRadius.circular(24),
      //               fieldHeight: 55,
      //               fieldWidth: 55,
      //               borderWidth: 1,
      //               inactiveFillColor: Colors.transparent
      //             ),
      //             // errorAnimationController: errorController,
      //             // controller: textEditingController,
      //             onCompleted: (v) {
      //               validateCode();
      //             },
      //             onChanged: (value) {
      //               setState(() {
      //                 _code = value;
      //               });
      //             },
      //             validator: (s)=>s?.length != 4 ? "Code must be 6 digits " : null,
      //             beforeTextPaste: (text) {
      //               //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
      //               //but you can show anything you want here, like your pop up saying wrong paste format or etc
      //               return true;
      //             }, appContext: context,
      //           ),
      //         ),
      //          Padding(
      //           padding: const EdgeInsets.only(bottom: 15),
      //           child: _loading ? const Center(
      //             child: CircularProgressIndicator(),
      //           ) : ElevatedButton(onPressed: validateCode, child: const Text("Verify")),
      //         ),
      //         Center(
      //           child: _resending ? const CupertinoActivityIndicator() : InkWell(
      //             onTap: resendCode,
      //             child: RichText(text: TextSpan(
      //                 style: const TextStyle(
      //                     color: Color(0xff6C6C6C),
      //                     fontSize: 16,
      //                     fontWeight: FontWeight.w600
      //                 ),
      //                 children: [
      //                   const TextSpan(text: "Did not receive code?"),
      //                   TextSpan(text: "Resend Code",style: TextStyle(
      //                       color: Theme.of(context).primaryColor
      //                   ))
      //                 ]
      //             )),
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(bottom: 15,top: 15),
      //           child: TextButton(onPressed: goBack, child: const Text("Cancel")),
      //         )
      //       ],
      //     ),
      //   ),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
      // bottomNavigationBar: const SafeArea(child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text("Trama Solutions, All Rights Reserved."),
      //   ],
      // )),
    );
  }
}
