import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  // this file define all colors that used in this app

  // normal color
  static Color black = const Color(0xFF000000);
  static Color white = const Color(0xFFFFFFFF);

  // palette
  static Color mainColor = const Color(0xFF4F6F52);
  static Color subColor = const Color(0xFF739072);
  static Color commonColor = const Color(0xFF86A789);
  //negative

  // color on feature
  static Color successColor = Colors.green;
  static Color dangerColor = Colors.yellow;
  static Color errorColor = Colors.red;
  static Color infoColor = Colors.blue;
  static Color borderColor = const Color(0xFF828487);

  static Color bgDarkColor = const Color(0xFF86A789);
  static Color bgColor = const Color(0xFFD2E3C8);

  static Color primaryText = const Color(0xFF4F6F52);
  static Color secondaryText = const Color(0xFF739072);
  static Color hintText = const Color(0xFFD2E3C8);


  // blur color
  static Color blurColor(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}