import 'package:christian_ordinary_life/src/model/Alarm.dart';
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
  static bool keepLogin;
  static int qtAlarmId = 0;
  static int prayingAlarmId = 1;

  static String donationAccount = '404601-01-168180\n국민은행 예금주: 박명화';

  Future<double> getFontSize() async {
    prefs = await SharedPreferences.getInstance();

    fontSize = prefs.getDouble("fontSize");

    return fontSize;
  }

  Future<void> setFontSize(double size) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', size);
  }

  Future<String> getFirstUser() async {
    prefs = await SharedPreferences.getInstance();

    firstUser = prefs.getString("firstUser");

    return firstUser;
  }

  Future<void> setFirstUser() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('firstUser', 'n');
  }

  Future<String> getLanguage() async {
    prefs = await SharedPreferences.getInstance();
    language = prefs.getString("language");

    return language;
  }

  Future<void> setLanguage(String language) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  Future<Alarm> getAlarm(String target) async {
    prefs = await SharedPreferences.getInstance();
    Alarm alarm = new Alarm();
    alarm.title = target;
    alarm.time = prefs.getString('${target}_time');
    alarm.allow = prefs.getBool('${target}_allow');

    return alarm;
  }

  Future<void> setAlarm(Alarm alarm) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('${alarm.title}_time', alarm.time);
    prefs.setBool('${alarm.title}_allow', alarm.allow);
  }
}
