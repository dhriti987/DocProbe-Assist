import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 0, 80, 146);
ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(centerTitle: true, color: Colors.transparent),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF75479C), shape: const StadiumBorder()),
  ),
  inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.black26, fontSize: 16)),
  listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 20, fontFamily: "Adani"),
      subtitleTextStyle: TextStyle(fontSize: 12, color: Colors.black54)),
  popupMenuTheme: const PopupMenuThemeData(
    color: Color.fromARGB(186, 235, 228, 228),
    textStyle: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 16,
    ),
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w700,
      fontSize: 28,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
      fontSize: 22,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 20,
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    bodySmall: TextStyle(fontSize: 12, color: Colors.black26),
  ),
  fontFamily: "Adani",
);
