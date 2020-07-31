import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/translations.dart';

/*
  return type: String
  ex) 7월 22일 수요일 or Wednesday, July 22
*/
String getTodayFormat(BuildContext context) {
  var now = new DateTime.now();
  if (Translations.of(context).localeLaunguageCode() == 'ko') {
    Intl.defaultLocale = 'ko_KR';
  } else {
    Intl.defaultLocale = 'en_US';
  }
  return DateFormat.MMMMEEEEd().format(now);
}

/*
  return type: String
  ex) 2022년 or 2020
*/
String getTodayYear(BuildContext context) {
  var now = new DateTime.now();
  if (Translations.of(context).localeLaunguageCode() == 'ko') {
    Intl.defaultLocale = 'ko_KR';
  } else {
    Intl.defaultLocale = 'en_US';
  }
  return DateFormat.y().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 수요일 or Wednesday, July 22 2020
*/
String getDateOfWeek(BuildContext context, DateTime now) {
  if (now == null) return '';
  return DateFormat.yMMMMEEEEd().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 or 2020
*/
String getDate(BuildContext context, DateTime now) {
  if (now == null) return '';
  return DateFormat.yMMMMd().format(now);
}

List timepickerChanged(List timeArray) {
  int hour = timeArray[0], minute = timeArray[1];
  List<String> timeStrings = new List<String>(2);

  if (hour < 10) {
    timeStrings[0] = '0' + hour.toString();
  } else {
    timeStrings[0] = hour.toString();
  }

  if (minute < 10) {
    timeStrings[1] = '0' + minute.toString();
  } else {
    timeStrings[1] = minute.toString();
  }

  return timeStrings;
}

showAlertDialog(BuildContext context, String alertText) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        //title: Text('AlertDialog Demo'),
        content: Text(alertText),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, "ok");
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, "cancel");
            },
          ),
        ],
      );
    },
  );

  return result;
}

bool validatePassword(String value) {
  Pattern pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*~]).{8,}$';
  RegExp regex = new RegExp(pattern);

  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}
