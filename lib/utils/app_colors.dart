import 'package:demo_app_bloc/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  AppColors._();

  static const Color cDeepBlue = Color(0xff223E6D);
  static const Color cBlue = Color(0xff007aff);
  static Color cBlueShadow = const Color(0xff007aff).withOpacity(0.15);
  static const Color cBlueAccent = Color(0xff40c4ff);
  static const Color cSkyBlue = Color(0xff348CC3);
  static const Color cFadedBlue = Color(0xff92A5C6);
  static const Color cRed = Color(0xfff44336);
  static const Color cRedAccent = Color(0xffbe4d25);
  static const Color cBlueLight = Color(0xff92A5C6);
  static const Color cGreen = Color(0xff78c478);
  static const Color cGreenAccent = Color(0xff94d354);
  static const Color cWhite = Color(0xffFFFFFF);
  static const Color cLight = Color(0xfffafafa);
  static const Color cBlack = Color(0xff202020);
  static Color cBlackShadow = const Color(0xff202020).withOpacity(0.1);
  static const Color cGrey = Color(0xffa8a8a8);
  static const Color cDeepGrey = Color(0xff858585);
  static const Color transparent = Colors.transparent;

  static const Color cDarkBlue = Color(0xff0b2d39);
  static const Color cDarkBlueAccent = Color.fromARGB(255, 22, 79, 100);
  static const Color cDarkBlueLight = Color.fromARGB(255, 187, 228, 243);
  static const Color cLightShade = Color(0xffe9f5f9);
  static const Color cBlueShade = Color.fromARGB(255, 34, 130, 165);
  static const Color cDarkTextShade = Color(0xff041014);
}

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: AppColors.cLightShade,
      primaryColor: AppColors.cLight,
      fontFamily: "euclid",
      splashColor: AppColors.cBlueShade.withAlpha(40),
      highlightColor: AppColors.transparent,
      colorScheme: ColorScheme.light(
        background: AppColors.cDarkBlue,
        error: AppColors.cRedAccent,
        primary: AppColors.cDarkBlueAccent,
        secondary: AppColors.cDarkBlue,
        shadow: AppColors.cDarkBlueLight.withAlpha(220),
        outline: AppColors.cLight,
      ),
      buttonTheme: const ButtonThemeData(
        highlightColor: AppColors.transparent,
        colorScheme: ColorScheme.light(
          background: AppColors.cLight,
          error: AppColors.cRedAccent,
          primary: AppColors.cDarkBlueAccent,
          secondary: AppColors.cLight,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 28, fontWeight: black, color: AppColors.cBlack, letterSpacing: 0.5),
        titleMedium: TextStyle(fontSize: 24, fontWeight: black, color: AppColors.cDarkBlueAccent),
        titleSmall: TextStyle(fontSize: 20, fontWeight: black, color: AppColors.cDarkBlueAccent),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: semibold, color: AppColors.cBlack),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.cBlack),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.cBlack),
        displayLarge: TextStyle(fontSize: 24, color: AppColors.cBlack, fontWeight: bold),
        displayMedium: TextStyle(fontSize: 20, color: AppColors.cBlack, fontWeight: bold),
        displaySmall: TextStyle(fontSize: 18, color: AppColors.cBlack, fontWeight: semibold),
        labelSmall: TextStyle(fontSize: 12, color: AppColors.cBlack),
        labelMedium: TextStyle(color: AppColors.cDarkBlue),
        labelLarge: TextStyle(fontSize: 16, color: AppColors.cBlack, fontWeight: semibold),
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.transparent,
          iconTheme: IconThemeData(color: AppColors.cDarkBlueAccent),
          titleTextStyle: TextStyle(fontSize: 20, color: AppColors.cDarkBlue, fontWeight: bold)));

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.cDarkBlueAccent,
    primaryColor: AppColors.cDarkBlue,
    fontFamily: "euclid",
    splashColor: AppColors.cBlueShade.withAlpha(40),
    highlightColor: AppColors.transparent,
    colorScheme: ColorScheme.dark(
      error: AppColors.cRedAccent,
      primary: AppColors.cDarkBlue,
      secondary: AppColors.cDarkBlueAccent,
      shadow: AppColors.cBlackShadow.withAlpha(200),
      background: AppColors.cLight,
      outline: AppColors.cLight,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 28, fontWeight: black, color: AppColors.cLight, letterSpacing: 0.5),
      titleMedium: TextStyle(fontSize: 24, fontWeight: bold, color: AppColors.cLight),
      titleSmall: TextStyle(fontSize: 20, fontWeight: bold, color: AppColors.cLight),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: semibold, color: AppColors.cLight),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.cLight),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.cLight),
      displayLarge: TextStyle(fontSize: 24, color: AppColors.cLight, fontWeight: bold),
      displayMedium: TextStyle(fontSize: 20, color: AppColors.cLight, fontWeight: bold),
      displaySmall: TextStyle(fontSize: 18, color: AppColors.cLight, fontWeight: semibold),
      labelSmall: TextStyle(fontSize: 12, color: AppColors.cLight),
      labelMedium: TextStyle(color: AppColors.cLight),
      labelLarge: TextStyle(fontSize: 16, color: AppColors.cLight, fontWeight: semibold),
    ),
    buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.cDarkBlueAccent,
        highlightColor: AppColors.transparent,
        splashColor: AppColors.cDarkBlue),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.transparent,
      iconTheme: IconThemeData(color: AppColors.cLight),
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: AppColors.cLight,
        fontWeight: bold,
      ),
    ),
  );
}

class DarkThemePreference {
  static const themStatus = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themStatus) ?? false;
  }
}
