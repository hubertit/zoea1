import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoea1/password_filed.dart';
import 'package:zoea1/super_base.dart';

class ChangePasswordScreen extends StatefulWidget{
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends Superbase<ChangePasswordScreen> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  bool _loading = false;

  final _key = GlobalKey<FormState>();

  void changePassword()async{
    if (_key.currentState?.validate() ?? false) {
      setState(() {
        _loading = true;
      });
      await ajax(url: "account/changePassword",
          method: "POST",
          data: FormData.fromMap(
              {
                "current_password": _oldPassword.text,
                "new_password": _newPassword.text,
              }), onValue: (obj, url) {
            if( obj['code'] == 200 ){
              goBack();
            }
              showSnack(obj['message']);

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
        title: const Text("Change Password"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
             Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(bottom: 15),
                child: const Text("The new password must be different from the current password",textAlign: TextAlign.center,style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18
                ),),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("Old Password",style: TextStyle(
                  color: Color(0xff78828A),
                  fontSize: 16
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PasswordField(
                controller: _oldPassword,
                validator: validateRequired,
                decoration: const InputDecoration(
                    hintText: "Enter Old Password"
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("New Password",style: TextStyle(
                  color: Color(0xff78828A),
                  fontSize: 16
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PasswordField(
                controller: _newPassword,
                validator: validateRequired,
                decoration: const InputDecoration(
                    hintText: "Enter your new password"
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(children: [
                Icon(Icons.check,color: Colors.green,size: 17,),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("There must be at least 8 characters",style: TextStyle(
                      color: Colors.green
                  ),),
                )
              ],),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(children: [
                Icon(Icons.check,color: Colors.green,size: 17,),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("There must be a unique code like @!#",style: TextStyle(
                      color: Colors.green
                  ),),
                )
              ],),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("Confirm Password",style: TextStyle(
                  color: Color(0xff78828A),
                  fontSize: 16
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: PasswordField(
              validator: (s)=>s?.isNotEmpty == true ? s == _newPassword.text ? null : "Password and confirm has to match" : "Confirm Password is required !",
    decoration: const InputDecoration(
                    hintText: "Confirmation password"
                ),
              ),
            ),
            _loading ? const Center(
              child: CircularProgressIndicator(),
            ) : ElevatedButton(onPressed: changePassword, child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}