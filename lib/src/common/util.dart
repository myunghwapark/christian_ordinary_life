import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/translations.dart';


String getTodayFormat(BuildContext context) {
  var now = new DateTime.now();
  if(Translations.of(context).localeLaunguageCode() == 'ko') {
    Intl.defaultLocale = 'ko_KR';
  }
  else {
    Intl.defaultLocale = 'en_US';
  }
  return DateFormat.MMMMEEEEd().format(now);
}

String getTodayYear(BuildContext context) {
  var now = new DateTime.now();
  if(Translations.of(context).localeLaunguageCode() == 'ko') {
    Intl.defaultLocale = 'ko_KR';
  }
  else {
    Intl.defaultLocale = 'en_US';
  }
  return DateFormat.y().format(now);
}


List timepickerChanged(List timeArray) {
  
    int hour = timeArray[0], minute = timeArray[1];
    List<String> timeStrings = new List<String>(2);

    if(hour < 10) {
      timeStrings[0] = '0'+hour.toString();
    }
    else {
      timeStrings[0] = hour.toString();
    }

    if(minute < 10) {
      timeStrings[1] = '0'+minute.toString();
    }
    else {
      timeStrings[1] = minute.toString();
    }

    return timeStrings;
  
}