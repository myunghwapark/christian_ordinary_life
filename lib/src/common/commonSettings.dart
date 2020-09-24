import 'package:shared_preferences/shared_preferences.dart';

class CommonSettings {
  SharedPreferences prefs;
  static double minimumFontSize = 15.0;
  static double maximumFontSize = 25.0;
  static double defaultFontSize = 18.0;
  static double fontSize;
  static double tempFontSize;
  static String language;

  Future<double> getFontSize() async {
    prefs = await SharedPreferences.getInstance();

    fontSize = prefs.getDouble("fontSize");

    return fontSize;
  }

  Future<void> setFontSize(double size) async {
    prefs.setDouble('fontSize', size);
  }
}
