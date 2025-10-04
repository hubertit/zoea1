import 'package:flutter/material.dart';


class CoverContainer extends StatelessWidget {
  final List<Widget> children;
  final double margin;
  const CoverContainer({super.key, required this.children,this.margin= 20 });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      margin:  EdgeInsets.all(margin),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
