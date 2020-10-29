import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SetNotification extends StatefulWidget {
  @override
  SetNotificationState createState() => SetNotificationState();
}

class SetNotificationState extends State<SetNotification> {
  var _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
/* 
  Future<void> onSelectNotification(String payload) async {
    debugPrint("$payload");
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Notification Payload'),
              content: Text('Payload: $payload'),
            ));
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _showNotification,
              child: Text('Show Notification'),
            ),
            RaisedButton(
              onPressed: () {
                Time alramTime = new Time(18, 54, 00);
                _dailyPrayingTimeNotification(alramTime);
              },
              child: Text('기도시간 알람'),
            ),
            RaisedButton(
              onPressed: () {
                Time alramTime = new Time(18, 55, 00);
                _dailyQtTimeNotification(alramTime);
              },
              child: Text('묵상시간 알람'),
            ),
            RaisedButton(
              onPressed: () {
                _repeatNotification();
              },
              child: Text('At every minutes Notification'),
            ),
            RaisedButton(
              onPressed: () {
                _cancelAllNotifications();
              },
              child: Text('Cancel App Notification'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
        0, '단일 Notification', '단일 Notification 내용', platformChannelSpecifics);
  }

  Future<void> _dailyQtTimeNotification(Time alarmTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '[크리스천의 평범한 삶] 묵상시간',
        '${UserInfo.loginUser.name}님, 오늘도 말씀으로 승리하세요.',
        _nextInstanceOfTenAM(alarmTime),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'qt',
            'colQt',
            'Time to qt',
            priority: Priority.high,
            importance: Importance.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> _dailyPrayingTimeNotification(Time alarmTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '[크리스천의 평범한 삶] 기도시간',
        '${UserInfo.loginUser.name}님, 하나님과 행복한 기도시간 보내세요.',
        _nextInstanceOfTenAM(alarmTime),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'praying',
            'colPraying',
            'Time to praying',
            priority: Priority.high,
            importance: Importance.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfTenAM(Time alarmTime) {
    /* var detroit = tz.getLocation('Asia/Tokyo');
    var now = tz.TZDateTime.now(detroit); */
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print(
        'TZDateTime:  ${tz.local}, ${now.year}, ${now.month}, ${now.day}, ${now.hour}, ${now.minute}');
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, alarmTime.hour, alarmTime.minute);
    //if (scheduledDate.isBefore(now)) {
    print('schedule added');
    scheduledDate = scheduledDate.add(const Duration(days: 1));
    // }
    return scheduledDate;
  }

  Future<void> _repeatNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'repeat', 'repeating channel name', 'repeating description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'repeating title',
        'repeating body',
        RepeatInterval.everyMinute,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  Future<void> _cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
