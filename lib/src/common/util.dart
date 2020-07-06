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