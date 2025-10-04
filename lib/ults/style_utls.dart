import 'package:flutter/material.dart';

class StyleUtls {
  static InputBorder commonInputBorder = OutlineInputBorder(
    borderSide:  BorderSide.none,
    borderRadius: BorderRadius.circular(8),
  );
  static InputBorder dashInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.blueGrey),
  );
}