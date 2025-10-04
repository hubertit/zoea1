import 'package:flutter/material.dart';

roundedContainer(String text, void Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: const Color(0xff73b06e),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          // fontSize: 12,c
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
  );
}
