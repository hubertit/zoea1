import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/password_filed.dart';
import 'package:zoea1/super_base.dart';

import 'homepage.dart';
import 'json/user.dart';
import 'constants/theme.dart';

class CompleteRegistration extends StatefulWidget{
  final String token;
  final bool fromPhone;
  const CompleteRegistration({super.key, required this.token, this.fromPhone = true});

  @override
  State<CompleteRegistration> createState() => _CompleteRegistrationState();
}

class _CompleteRegistrationState extends Superbase<CompleteRegistration> {

  final _key = GlobalKey<FormState>();

  final _firstController = TextEditingController();
  final _lastController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  void register() async {
    if(_key.currentState?.validate()??false){

      setState(() {
        _loading = true;
      });
      await ajax(url: "account/register",method: "POST",data: FormData.fromMap({
        "token":widget.token,
        "user_fname":_firstController.text,
        "user_lname":_lastController.text,
        "user_email":_emailController.text,
        "user_password":_passwordController.text,
      }),onValue: (obj,url)async{
        if(obj['code'] == 200){
          save(userKey, obj['data']);
          User.user = User.fromJson(obj['data']);

          // await showDialog(context: context, builder: (context)=>const AuthenticationMessageDialog());
          if(mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
            push(const Homepage(),replaceAll: true);
          }
        }
      });

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF181A20) // dark background
            : const Color(0xFFF7F7F9), // light background
        child: Form(
          key: _key,
          child: ListView(
            padding: const EdgeInsets.all(30.0),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Complete your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50).copyWith(bottom: 30, top: 8),
                child: Text(
                  "Fill in your personal information to create your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFB3B3B3)
                        : Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: TextFormField(
                  controller: _firstController,
                  validator: validateRequired,
                  decoration: InputDecoration(
                    hintText: "Enter your first name",
                    filled: true,
                    fillColor: Colors.white,
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: TextFormField(
                  controller: _lastController,
                  validator: validateRequired,
                  decoration: InputDecoration(
                    hintText: "Enter your last name",
                    filled: true,
                    fillColor: Colors.white,
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
              ),
              widget.fromPhone ? Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: TextFormField(
                  controller: _emailController,
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: kBlack,
                  decoration: InputDecoration(
                    hintText: "Enter your email address",
                    filled: true,
                    fillColor: Colors.white,
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
              ) : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: PasswordField(
                  validator: validateRequired,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    filled: true,
                    fillColor: Colors.white,
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: PasswordField(
                  validator: (s)=>_passwordController.text != s ? "This field has to math password" : null,
                  decoration: InputDecoration(
                    hintText: "Confirm your password",
                    filled: true,
                    fillColor: Colors.white,
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
              ),
              _loading ? const Center(
                child: CircularProgressIndicator(),
              ) : ElevatedButton(onPressed: register, child: const Text("Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}