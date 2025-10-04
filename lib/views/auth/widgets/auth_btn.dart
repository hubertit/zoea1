import 'package:flutter/material.dart';

import '../../../constants/theme.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color background;
  AuthButton({super.key, required this.onPressed, required this.text, this.background = const Color(0xff264E9A)});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                // backgroundColor: background,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: onPressed,
            child: Text(text,style: TextStyle(color:elevatedTexts),)));
  }
}
