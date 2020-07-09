import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  static Color greenPoint = HexColor('#06614e');
  static Color greenPointMild = HexColor('#0a8d71');
  static Color blackGreen = HexColor('#001914');
  static Color marine = HexColor('#2bcbba');
  static Color lightGray = HexColor('#bababa');
  static Color darkGray = HexColor('#545454');
  static Color blueSky = HexColor('#56d2d2');
  static Color mint = HexColor('#66e098');
  static Color lightOrange = HexColor('#f1c96e');
  static Color lightPink = HexColor('#f88185');
  static Color moss = HexColor('#018181');
  
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