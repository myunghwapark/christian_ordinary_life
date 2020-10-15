import 'package:shared_preferences/shared_preferences.dart';

class CommonSettings {
  SharedPreferences prefs;
  static double minimumFontSize = 15.0;
  static double maximumFontSize = 25.0;
  static double defaultFontSize = 18.0;
  static double fontSize;
  static double tempFontSize;
  static String language;
  static String firstUser;

  static String donationAccount = '404601-01-168180\n국민은행 예금주: 박명화';

  Future<double> getFontSize() async {
    prefs = await SharedPreferences.getInstance();

    fontSize = prefs.getDouble("fontSize");

    return fontSize;
  }

  Future<void> setFontSize(double size) async {
    prefs.setDouble('fontSize', size);
  }

  Future<String> getFirstUser() async {
    prefs = await SharedPreferences.getInstance();

    firstUser = prefs.getString("firstUser");

    return firstUser;
  }

  Future<void> setFirstUser() async {
    prefs.setString('firstUser', 'n');
  }
}
