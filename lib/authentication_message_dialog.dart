import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';

class AuthenticationMessageDialog extends StatefulWidget {
  const AuthenticationMessageDialog({super.key});

  @override
  State<AuthenticationMessageDialog> createState() =>
      _AuthenticationMessageDialogState();
}

class _AuthenticationMessageDialogState
    extends Superbase<AuthenticationMessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xff00C566),
            size: 120,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "You have logged in successfully",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.",style: TextStyle(   color: Color(0xff6C6C6C),
                fontWeight: FontWeight.w500,
                fontSize: 14),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(onPressed: (){
              goBack();
            }, child: const Text(("Continue"))),
          )
        ],
      ),
    );
  }
}
