import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/authentication.dart';
import 'package:zoea1/constants/assets.dart';
import 'package:zoea1/super_base.dart';
import 'homepage.dart';
import 'json/user.dart';
import 'ults/functions.dart';
import 'ults/style_utls.dart';
import 'views/auth/widgets/auth_btn.dart';
import 'views/auth/widgets/custom_text_button.dart';
import 'views/auth/widgets/phone_field.dart';
import 'constants/theme.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends Superbase<Registration> {
  final _key = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _invController = TextEditingController();

  late Country country;
  final String _type = "phone";

  @override
  void initState() {
    country = CountryService().findByCode("RW")!;
    super.initState();
  }

  bool _loading = false;

  void register() async {
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      // var phone = "${country.phoneCode}${_phoneController.text}";
      var code = country.phoneCode;
      // var isEmail = _type == "email";
      // var key = isEmail ? "user_email" : "user_phone";
      await ajax(
          url: "account/register",
          method: "POST",
          data: FormData.fromMap({
            "user_names": _nameController.text,
            "user_phone": "${country.phoneCode}${_phoneController.text}",
            "user_email": _emailController.text,
            "user_password": _passwordController.text
          }),
          onValue: (obj, url) {
            if (obj['code'] == 200) {
              print("Data returned registration ${obj['data']}");

              save(userKey, obj['data']);
              User.user = User.fromJson(obj['data']);
              showSnack(obj['message'], context: context);
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
        _loading = false;
      });
    }
  }
  String? _selectedGender;

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
                      key: _key,
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
                              height: 50,
                            ),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _nameController,
                              validator: validateRequired,
                              cursorColor: kBlack,
                              decoration: InputDecoration(
                                hintText: 'Enter your full name',
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _emailController,
                              validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: kBlack,
                              decoration: InputDecoration(
                                hintText: 'Enter your email address',
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField<String>(
                              value: null, // Initial value (null means no selection initially)
                              onChanged: (String? newValue) {
                                // Update the selected gender here
                                setState(() {
                                  _selectedGender = newValue!;
                                });
                              },
                              validator: validateRequired, // Keep your validation logic
                              decoration: InputDecoration(
                                hintText: 'Select your gender',
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              items: ['Male', 'Female', 'Other'] // Gender options
                                  .map((String gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              validator: validateRequired,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _invController,
                              cursorColor: kBlack,
                              decoration: InputDecoration(
                                hintText: 'Enter your invitation code (optional)',
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AuthButton(
                              onPressed: register,
                              text: 'Register',
                            ),
                            CustomTextButton(
                                questionText: "Already have an account?",
                                directingText: 'Login',
                                onTap: () {
                                  push(const Authentication());
                                }),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        // Column(
        //   children: [
        //     const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: Text("Create Account",style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.w700,
        //         fontSize: 24
        //       ),),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 50).copyWith(bottom: 30,top: 8),
        //       child: const Text("Please enter you personal identification to create a free account",textAlign: TextAlign.center,style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.w500,
        //         fontSize: 16
        //       ),),
        //     ),
        //     Expanded(child: Card(
        //       margin: EdgeInsets.zero,
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.vertical(
        //           top: Radius.circular(30)
        //         )
        //       ),
        //       child: Form(
        //         key: _key,
        //         child: ListView(
        //           padding: const EdgeInsets.all(20).copyWith(top: 50),
        //           children: [
        //             // Padding(
        //             //   padding: const EdgeInsets.only(bottom: 10),
        //             //   child: Row(
        //             //     children: [
        //             //       Expanded(child: RadioListTile(value: "phone", groupValue: _type, onChanged: (val){
        //             //         setState(() {
        //             //           _type = val!;
        //             //         });
        //             //       },title: const Text("Phone"),)),
        //             //       Expanded(child: RadioListTile(value: "email", groupValue: _type, onChanged: (val){
        //             //         setState(() {
        //             //           _type = val!;
        //             //         });
        //             //       },title: const Text("Email"),)),
        //             //     ],
        //             //   ),
        //             // ),
        //             TextFormField(
        //                 controller: _nameController,
        //                 validator: validateRequired,
        //                 keyboardType: TextInputType.text,
        //                 decoration: const InputDecoration(hintText: "Your name")),
        //             const SizedBox(height: 15,),
        //             PhoneField(controller: _phoneController,country:country,callback: (country){
        //               setState(() {
        //                 this.country = country;
        //               });
        //             },),
        //             const SizedBox(height: 15,),
        //             TextFormField(
        //                 controller: _emailController,
        //                 validator: validateEmail,
        //                 keyboardType: TextInputType.emailAddress,
        //                 decoration: const InputDecoration(hintText: "Email Address")),
        //             const SizedBox(height: 15,),
        //             TextFormField(
        //                 controller: _passwordController,
        //                 validator: validateRequired,
        //                 keyboardType: TextInputType.text,
        //                 obscureText: true,
        //                 decoration: const InputDecoration(hintText: "Your password")),
        //             const SizedBox(height: 30,),
        //
        //             _loading ? const Center(child: CircularProgressIndicator()) : ElevatedButton(onPressed: register, child: const Text("Register",style: TextStyle(color: Colors.white),)),
        //             Center(
        //               child: Padding(
        //                 padding: const EdgeInsets.only(top: 30),
        //                 child: InkWell(
        //                   onTap: ()=>push(const Authentication()),
        //                   child: RichText(text: TextSpan(
        //                     style: const TextStyle(
        //                       color: Colors.black87,
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.w600
        //                     ),
        //                       children: [
        //                         const TextSpan(text: "Already have an account?"),
        //                         TextSpan(text: "Login",style: TextStyle(
        //                             color: Theme.of(context).primaryColor
        //                         ))
        //                       ]
        //                   )),
        //                 ),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ))
        //   ],
        // ),
        // ),
        );
  }
}
