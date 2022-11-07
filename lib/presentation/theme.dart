import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff6200ee);
const kBackgroundColor = Color(0xff1a1a1a);

final kAppTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.standard,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) return kPrimaryColor;
        return kPrimaryColor;
      }),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) return const Color(0xff1a1520);
        return null;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) return Colors.white;
        return Colors.white;
      }),
    ),
  ),
  primarySwatch: Colors.deepPurple,
  primaryColor: kPrimaryColor,
  primaryColorLight: kPrimaryColor,
  primaryColorDark: kPrimaryColor,
  accentColor: kPrimaryColor,
  canvasColor: kBackgroundColor,
  shadowColor: const Color(0xff414141),
  scaffoldBackgroundColor: kBackgroundColor,
  bottomAppBarColor: kPrimaryColor,
  cardColor: kPrimaryColor,
  focusColor: Colors.white,
  toggleableActiveColor: kPrimaryColor,
);
