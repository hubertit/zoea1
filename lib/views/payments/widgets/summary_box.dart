import 'package:flutter/material.dart';
import 'package:zoea1/constants/theme.dart';


class SummaryBox extends StatelessWidget {
  final String image;
  final String title;
  final Widget subtitle;
  final VoidCallback? tape;
  const SummaryBox(
      {super.key,
        required this.image,
        required this.title,
        this.tape,
        required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: tape,
        child: Container(
          padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: scaffoldColor,
                radius: 25,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    image,
                    // fit: BoxFit.contain,
                    height: 20,
                  ),
                ),
              ),
              Container(
                width: 10,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(title),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    subtitle
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
