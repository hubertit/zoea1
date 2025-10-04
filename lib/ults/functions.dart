import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String trimm(int value, String text) {
  if (text.length > value) {
    return "${text.substring(0, value - 2)}..";
  }
  return text;
}

bool isDarkTheme(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}


