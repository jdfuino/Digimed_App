import 'package:flutter/material.dart';

class AppColors{
  static const Color backgroundColor = Color(0xff007CFF);
  static const Color statusBarColor = Color(0xff1161C9);
  static const Color contactColor = Color(0xff0649C3);
  static const Color accentColor = Color(0xff10006D);
    static const Color iconBiometricFalseColor = Color.fromARGB(255, 238, 10, 22);
  static const Color beginGradient = Color(0xff0844BD);
  static const Color backGroundColorButton = Color(0xffF0F4FD);
  static const Color endGradient = Color(0xff10006D);
  static const Color textColor = Color(0xffFFFFFF);
  static const Color textColor2 = Color(0xff6C6C6C);
  static const Color accentColor2 = Color(0xffF05225);
  static const Color backgroundInput = Color(0xffFFFFFF);
  static const Color hintColor = Color(0xff788B9A);
  static const Color contentTextColor = Color(0xff6C6C6C);
  static const Color appBarColor = Color(0xff323232);
  static const Color backgroundSelectors = Color(0xffEFF3FC);
  static const Color backgroundSearchColor = Color(0xffF0F4FD);
  static const Color backgroundSettingSaveColor = Color(0xff02BE58);
  static const Color backgroundSettingSaveColorWithOpacity = Color(0x5202BE58);
  static const Color backgroundSaveAreaBlueWithOpacity = Color(0x52BDD2EB);
  static const Color backgroundImageColor = Color(0xffF0F4FD);
  static const Color scaffoldBackgroundColor = Color(0xffF0F4FD);
  static const Color buttonDisableBackgroundColor = Color(0xffE3E8F3);
  static const Color buttonSelectedRangeColor = Color(0xffEFF3FC);
  static const Color DisableLabelTabBarBackgroundColor = Color(0xff788B9A);
  static const Color hintColor2 = Color(0xff788B9A);
  static const Color dividerColor = Color(0xffEEEEEE);
  static const Color alteredColor = Color(0xffFAFBFF);
  static const Color separatorColor = Color(0xffECECEC);

  static const List<Color> gradientColors = [
    AppColors.beginGradient,
    AppColors.backgroundInput,
  ];

  static ThemeData timePickerTheme = ThemeData.light().copyWith(
      timePickerTheme: TimePickerThemeData(
        dialBackgroundColor: Color(0xffF0F4FD),
        dialTextColor:
        MaterialStateColor.resolveWith(
                (states) => states.contains(
                MaterialState.selected)
                ? Colors.white
                : Color(0xff6C6C6C)),
        hourMinuteColor:
        MaterialStateColor.resolveWith(
                (states) => states.contains(
                MaterialState.selected)
                ? Color(0xffCBE4FF)
                : Color(0xffF0F4FD)),
        hourMinuteTextColor:
        MaterialStateColor.resolveWith(
                (states) => states.contains(
                MaterialState.selected)
                ? Color(0xff007CFF)
                : Color(0xff6C6C6C)),
      ));
}