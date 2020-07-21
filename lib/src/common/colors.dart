import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  static Color greenPoint = HexColor('#06614e');
  static Color greenPointMild = HexColor('#0a8d71');
  static Color blackGreen = HexColor('#001914');

  static Color mint = HexColor('#66e098');
  static Color lightMint = HexColor('#e4ffef');
  static Color moss = HexColor('#018181');

  static Color blueSky = HexColor('#56d2d2');
  static Color lightSky = HexColor('#dff4f4');
  static Color marine = HexColor('#2bcbba');
  static Color sky = HexColor('#3fcece');

  static Color lightOrange = HexColor('#f1c96e');

  static Color pastelPink = HexColor('#f88185');
  static Color lightPinks = HexColor('#fceff0');

  static Color lightGray = HexColor('#bababa');
  static Color lightBgGray = HexColor('#ebebeb');
  static Color moreLightGray = HexColor('#d6d6d6');
  static Color darkGray = HexColor('#545454');
  static Color lightBlack = HexColor('#2a2a2a');
  static Color black = HexColor('#000000');
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
