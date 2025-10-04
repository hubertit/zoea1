import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';

class EmailForgotPassword extends StatefulWidget {
  const EmailForgotPassword({super.key});

  @override
  State<EmailForgotPassword> createState() => _EmailForgotPasswordState();
}

class _EmailForgotPasswordState extends Superbase<EmailForgotPassword> {
  final _key = GlobalKey<FormState>();

  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(30.0),
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              color: const Color(0xffF5F5F5),
              elevation: 0,
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(Icons.info,color: Color(0xffBDBDBD),),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          "We will send the OTP code to your email for security in forgetting your password",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("E-mail",style: TextStyle(
                  color: Color(0xff78828A),
                  fontSize: 16
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextFormField(
                controller: _phoneController,
                validator: validateRequired,
                decoration:
                    const InputDecoration(hintText: "Enter your E-mail Address"),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  // push(const ResetNewPassword());
                },
                child: const Text("Continue"))
          ],
        ),
      ),
    );
  }
}
