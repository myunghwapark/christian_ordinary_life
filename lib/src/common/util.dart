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
  ex) 2022년 7월 22일 or 2020
*/
String getTodayDate(BuildContext context) {
  var now = new DateTime.now();
  /* if (Translations.of(context).localeLaunguageCode() == 'ko') {
    Intl.defaultLocale = 'ko_KR';
  } else {
    Intl.defaultLocale = 'en_US';
  } */
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
