import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

IconData shareIcon() {
  if (Platform.isIOS) {
    return Icons.ios_share;
  }
  return Icons.share;
}
