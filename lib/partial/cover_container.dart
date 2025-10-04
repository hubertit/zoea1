import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../ults/functions.dart';

class CoverContainer extends StatelessWidget {
  final List<Widget> children;
  final double margin;
  const CoverContainer({super.key, required this.children, this.margin = 17});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      margin: EdgeInsets.all(margin),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF23242B) // dark card background
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
