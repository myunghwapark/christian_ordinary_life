import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  static Color greenPoint = HexColor('#06614e');
  static Color greenPointMild = HexColor('#0a8d71');
  static Color blackGreen = HexColor('#001914');
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}