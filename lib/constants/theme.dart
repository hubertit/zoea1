import 'package:flutter/material.dart';

// Centralized color palette
const Color kBlack = Color(0xFF000000);
const Color kWhite = Color(0xFFFFFFFF);
const Color kGrayLight = Color(0xFFF4F4F7); // light background
const Color kGray = Color(0xFFB3B3B3);      // medium gray
const Color kGrayDark = Color(0xFF4D4D4D);  // dark gray
const Color kGrayAccent = Color(0xFF808080); // accent gray

// Use these variables throughout the app
Color elevatedTexts = kWhite;
Color scaffoldColor = kGrayLight;
Color refleshColor = kBlack;
Color textsColor = kBlack;
Color semiBlack = kGrayDark;

MaterialColor createPrimarySwatch() {
  return const MaterialColor(
    0xFF000000,
    {
      50: kGrayLight,
      100: kGray,
      200: kGrayAccent,
      300: kGrayDark,
      400: kBlack,
      500: kBlack,
      600: kBlack,
      700: kBlack,
      800: kBlack,
      900: kBlack,
    },
  );
}

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kWhite,
  dialogTheme: DialogTheme(
    elevation: 0,
    backgroundColor: semiBlack,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: semiBlack,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            color: kWhite,
            fontWeight: FontWeight.bold,
          ),
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)))),
  appBarTheme: const AppBarTheme(
      backgroundColor: kBlack,
      iconTheme: IconThemeData(color: kWhite),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: kWhite,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      )),
  cardTheme: const CardTheme(color: kGrayDark),
  iconTheme: const IconThemeData(
    color: kWhite,
  ),
  scaffoldBackgroundColor: kBlack,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: kWhite),
    bodySmall: TextStyle(color: kGray),
  ),
);
