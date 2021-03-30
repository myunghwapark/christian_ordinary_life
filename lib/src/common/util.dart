import 'package:christian_ordinary_life/src/model/Alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:christian_ordinary_life/src/component/timePicker.dart';
import 'package:christian_ordinary_life/src/component/calendar.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';

import 'commonSettings.dart';
import 'userInfo.dart';

String wrongImage() {
  return 'assets/images/temp_image.png';
}

/*
  return type: String
  ex) 7월 22일 수요일 or Wednesday, July 22
*/
String getTodayFormat() {
  var now = new DateTime.now();
  return DateFormat.MMMMEEEEd().format(now);
}

/*
  return type: String
  ex) 2022년 or 2020
*/
String getTodayYear() {
  var now = new DateTime.now();
  return DateFormat.y().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 수요일 or Wednesday, July 22 2020
*/
String getDateOfWeek(DateTime now) {
  if (now == null) return '';
  return DateFormat.yMMMMEEEEd().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 or July 22 2020
*/
String getDate(DateTime now) {
  if (now == null) return '';
  return DateFormat.yMMMMd().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 or July 22 2020
*/
String getDateOfWeek2(DateTime now) {
  if (now == null) return '';
  return DateFormat.MMMMEEEEd().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 or 2020
*/
String getYear(DateTime now) {
  if (now == null) return '';
  return DateFormat.y().format(now);
}

/*
  return type: String
  ex) 2020-08-28
*/
String getToday() {
  var now = new DateTime.now();
  final template = DateFormat('yyyy-MM-dd');
  return template.format(now);
}

/*
  return type: String
  ex) 2020-08-28
*/
String getCalDateFormat(DateTime now) {
  if (now == null) return null;
  final template = DateFormat('yyyy-MM-dd');
  return template.format(now);
}

/*
  return type: String
  ex) 2020-08
*/
String getTodayYearMonth(DateTime now) {
  final template = DateFormat('yyyy-MM');
  return template.format(now);
}

bool isBeforeDate(DateTime compareDate) {
  var now = new DateTime.now();
  return compareDate.isBefore(now);
}

int dateDifferenceInDays(DateTime targetDate) {
  DateTime now = new DateTime.now();
  int different = targetDate.difference(now).inDays;

  return different;
}

int dateDifferenceInHours(DateTime targetDate) {
  DateTime now = new DateTime.now();
  int different = targetDate.difference(now).inHours;

  return different;
}

DateTime convertDateFromString(String strDate) {
  DateTime date = DateTime.parse(strDate);
  return date;
}

String makeTimeFormat(int time) {
  String timeStr = '';
  if (time < 10) {
    timeStr = '0' + time.toString();
  } else {
    timeStr = time.toString();
  }

  return timeStr;
}

Future<void> openTimePicker(BuildContext context, Function method,
    {DateTime initTime}) async {
  await DatePicker.showPicker(context,
      showTitleActions: true,
      theme: DatePickerTheme(
        //headerColor: AppSettings.mainColor,
        backgroundColor: Colors.grey[200],
        // doneStyle: TextStyle(color: Colors.white, fontSize: 16)
      ), onChanged: (date) {
    print(
        'change $date in time zone ' + date.timeZoneOffset.inHours.toString());
  }, onConfirm: (date) {
    method(date);
  }, pickerModel: TimePicker(currentTime: initTime ?? DateTime.now()));
}

Future<void> showAlertDialog(BuildContext context, String alertText) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(alertText),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<String> showConfirmDialog(BuildContext context, String alertText) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        //title: Text('AlertDialog Demo'),
        content: Text(alertText),
        actions: <Widget>[
          TextButton(
            child: Text(Translations.of(context).trans('cancel')),
            onPressed: () {
              Navigator.pop(context, "cancel");
            },
          ),
          TextButton(
            child: Text(Translations.of(context).trans('confirm')),
            onPressed: () {
              Navigator.pop(context, "ok");
            },
          ),
        ],
      );
    },
  );

  return result;
}

Future<DateTime> showCalendar(
    BuildContext context, DateTime date, double topPadding) async {
  final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext builder) {
        return Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: topPadding,
            ),
            child: Calendar(date));
      });

  return result;
}

void showToast(BuildContext context, String toastText,
    {SnackBarAction action}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(toastText),
    action: action != null ? action : null,
  ));
}

Future<String> showImageDialog(BuildContext context, Image image) async {
  AlertDialog alert = AlertDialog(
    content: new SingleChildScrollView(
      child: new ListBody(children: <Widget>[
        GestureDetector(
          child: Container(child: image != null ? image : null),
          onTap: () => Navigator.pop(context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.pop(context, "delete");
                  },
                )),
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.edit),
                color: Colors.grey,
                onPressed: () {
                  Navigator.pop(context, "edit");
                },
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Flexible(
                fit: FlexFit.tight,
                flex: 2,
                child: TextButton(
                  child: Text(
                    Translations.of(context).trans('close'),
                    textAlign: TextAlign.right,
                  ),
                  onPressed: () {
                    Navigator.pop(context, "close");
                  },
                ))
          ],
        )
      ]),
    ),
  );

  String result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });

  return result;
}

bool validatePassword(String value) {
  Pattern pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*~]).{8,}$';
  // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*~]).{8,}$';
  RegExp regex = new RegExp(pattern);

  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

void errorMessage(BuildContext context, dynamic e) {
  if (e.toString() != 'Expired token') {
    try {
      showAlertDialog(
          context,
          (Translations.of(context).trans('error_message') +
              '\n' +
              e.toString()));
    } on Exception catch (exception) {
      print(exception.toString());
      return null;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

String getPlanPeriod(BuildContext context, String period) {
  if (period == null) return null;
  String _periodType = period.substring(period.length - 1, period.length);
  String _planPeriod = period.substring(0, period.length - 1);

  switch (_periodType) {
    case 'd':
      _periodType = Translations.of(context).trans("day");
      break;
    case 'w':
      _periodType = Translations.of(context).trans("week");
      break;
    default:
  }
  return _planPeriod + _periodType;
}

Size getSizes(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  final size = renderBox.size;
  return size;
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}

Future<void> dailyQtTimeNotification(
    BuildContext context, Time alarmTime) async {
  await CommonSettings.flutterLocalNotificationsPlugin.zonedSchedule(
      CommonSettings.qtAlarmId,
      '[${Translations.of(context).trans('app_title')}] ${Translations.of(context).trans('qt_time')}',
      Translations.of(context)
          .trans('qt_time_alarm_message', param1: UserInfo.loginUser.name),
      scheduledDaily(alarmTime),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'qt',
          'colQt',
          'Time for QT',
          priority: Priority.high,
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

Future<void> dailyPrayingTimeNotification(
    BuildContext context, Time alarmTime) async {
  await CommonSettings.flutterLocalNotificationsPlugin.zonedSchedule(
      CommonSettings.prayingAlarmId,
      '[${Translations.of(context).trans('app_title')}] ${Translations.of(context).trans('praying_time')}',
      Translations.of(context)
          .trans('praying_time_alarm_message', param1: UserInfo.loginUser.name),
      scheduledDaily(alarmTime),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'praying',
          'colPraying',
          'Time to pray',
          priority: Priority.high,
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

Future<void> dailyThankDiaryTimeNotification(
    BuildContext context, Time alarmTime) async {
  await CommonSettings.flutterLocalNotificationsPlugin.zonedSchedule(
      CommonSettings.thankDiaryAlarmId,
      '[${Translations.of(context).trans('app_title')}] ${Translations.of(context).trans('thankdiary_time')}',
      Translations.of(context).trans('thankdiary_time_alarm_message',
          param1: UserInfo.loginUser.name),
      scheduledDaily(alarmTime),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'thankDiary',
          'colThankDiary',
          'Time for Thank Diary',
          priority: Priority.high,
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

Future<void> dailyReadingBibleTimeNotification(
    BuildContext context, Time alarmTime) async {
  await CommonSettings.flutterLocalNotificationsPlugin.zonedSchedule(
      CommonSettings.readingBibleAlarmId,
      '[${Translations.of(context).trans('app_title')}] ${Translations.of(context).trans('readingbible_time')}',
      Translations.of(context).trans('readingbible_time_alarm_message',
          param1: UserInfo.loginUser.name),
      scheduledDaily(alarmTime),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'readingBible',
          'colReadingBible',
          'Time for Reading Bible',
          priority: Priority.high,
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

tz.TZDateTime scheduledDaily(Time alarmTime) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, alarmTime.hour, alarmTime.minute);
  scheduledDate = scheduledDate.add(const Duration(days: 1));
  return scheduledDate;
}

void requestPermissions() {
  CommonSettings.flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

Future<void> configureLocalTimeZone() async {
  String timezone;
  tz.initializeTimeZones();
  try {
    timezone = await FlutterNativeTimezone.getLocalTimezone();
  } on PlatformException {
    print('Failed to get the timezone.');
  }
  final String timeZoneName = timezone;
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> cancelAllNotifications() async {
  await CommonSettings.flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> setAlarms(
    BuildContext context, String target, String alarmTime) async {
  CommonSettings commonSettings = new CommonSettings();

  await commonSettings.getAlarm(target).then((value) async {
    Alarm alarm = value;
    if (value == null || alarm.time == null || alarm.allow == false) {
      List<String> time = alarmTime.split(':');
      Time alramTime = new Time(int.parse(time[0]), int.parse(time[1]), 00);
      alarm.time = alarmTime;
      alarm.allow = true;
      alarm.title = target;

      switch (target) {
        case 'qt':
          await dailyQtTimeNotification(context, alramTime);
          break;
        case 'praying':
          await dailyPrayingTimeNotification(context, alramTime);
          break;
        case 'thankDiary':
          await dailyThankDiaryTimeNotification(context, alramTime);
          break;
        case 'readingBible':
          await dailyReadingBibleTimeNotification(context, alramTime);
          break;
        default:
      }

      await commonSettings.setAlarm(alarm);
    }
  });
}
