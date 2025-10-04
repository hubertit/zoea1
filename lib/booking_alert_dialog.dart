import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';

class BookingAlertDialog extends StatefulWidget{
  const BookingAlertDialog({super.key});

  @override
  State<BookingAlertDialog> createState() => _BookingAlertDialogState();
}

class _BookingAlertDialogState extends Superbase<BookingAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset("assets/like.png",height: 100,),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Booking successful",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("We have received your booking info, we are waiting for you !",style: TextStyle(   color: Color(0xff6C6C6C),
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