import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingThankDiary.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:christian_ordinary_life/src/model/Alarm.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingComplete.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingQT.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingBible.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingPraying.dart';

class GoalSetting extends StatefulWidget {
  static const routeName = '/goalSetting';

  final BibleUserPlan bibleUserPlan;
  GoalSetting({this.bibleUserPlan});

  @override
  GoalSettingState createState() => GoalSettingState();
}

class GoalSettingState extends State<GoalSetting> {
  GoalInfo goalInfo = new GoalInfo();
  BibleUserPlan bibleUserPlan = new BibleUserPlan();
  bool _isLoading = false;
  //final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //String timezone;
  CommonSettings commonSettings = new CommonSettings();

  Future<void> setUserGoal() async {
    bool saveAvailable = true;
    if (!goalInfo.checkContent(context, bibleUserPlan)) saveAvailable = false;

    if (_compareBiblePlan()) {
      await showConfirmDialog(context,
              Translations.of(context).trans('replace_bible_plan_ment'))
          .then((value) {
        if (value == 'cancel') saveAvailable = false;
      });
    }

    // If bible plan is the same as before, do not change.
    if (_isEqualBiblePlan()) {
      GoalInfo.goal.keepBiblePlan = true;
    } else {
      GoalInfo.goal.keepBiblePlan = false;
    }

    if (saveAvailable) {
      setState(() {
        _isLoading = true;
      });

      cancelAllNotifications();

      if (GoalInfo.goal.qtRecord && GoalInfo.goal.qtAlarm) {
        await _setAlarm('qt');
      } else {
        _saveAlarm('qt', false);
      }
      if (GoalInfo.goal.praying && GoalInfo.goal.prayingAlarm) {
        await _setAlarm('praying');
      } else {
        _saveAlarm('praying', false);
      }
      if (GoalInfo.goal.thankDiary && GoalInfo.goal.thankDiaryAlarm) {
        await _setAlarm('thankDiary');
      } else {
        _saveAlarm('thankDiary', false);
      }
      if (GoalInfo.goal.readingBible && GoalInfo.goal.readingBibleAlarm) {
        await _setAlarm('readingBible');
      } else {
        _saveAlarm('readingBible', false);
      }

      goalInfo.setUserGoal(context, bibleUserPlan).then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value.result == 'success') {
          bool nothingSelected = false;

          // For the case of when a user chooses nothing, next page must show a different message.
          if (!GoalInfo.goal.readingBible &&
              !GoalInfo.goal.thankDiary &&
              !GoalInfo.goal.qtRecord &&
              !GoalInfo.goal.praying) {
            nothingSelected = true;
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GoalSettingComplete(nothingSelected)));
        }
      });
    }
  }

  bool _isEqualBiblePlan() {
    bool equal = false;
    if (GoalInfo.goal.readingBible == true &&
        GoalInfo.goal.oldBiblePlan == true &&
        GoalInfo.goal.oldBiblePlanId != null &&
        GoalInfo.goal.oldBiblePlanId.isNotEmpty &&
        bibleUserPlan.biblePlanId.isNotEmpty &&
        GoalInfo.goal.oldBiblePlanId == bibleUserPlan.biblePlanId &&
        GoalInfo.goal.oldPlanPeriod != null &&
        GoalInfo.goal.oldPlanPeriod.isNotEmpty &&
        bibleUserPlan.planPeriod.isNotEmpty &&
        GoalInfo.goal.oldPlanPeriod == bibleUserPlan.planPeriod &&
        GoalInfo.goal.oldCustomBible == bibleUserPlan.customBible) {
      equal = true;
    }

    return equal;
  }

  bool _compareBiblePlan() {
    bool different = false;
    if ((GoalInfo.goal.oldBiblePlanId != null &&
            GoalInfo.goal.oldBiblePlanId.isNotEmpty &&
            bibleUserPlan.biblePlanId != null &&
            bibleUserPlan.biblePlanId.isNotEmpty &&
            GoalInfo.goal.oldBiblePlanId != bibleUserPlan.biblePlanId) ||
        (GoalInfo.goal.oldPlanPeriod != null &&
            GoalInfo.goal.oldPlanPeriod.isNotEmpty &&
            bibleUserPlan.planPeriod != null &&
            bibleUserPlan.planPeriod.isNotEmpty &&
            GoalInfo.goal.oldPlanPeriod != bibleUserPlan.planPeriod) ||
        GoalInfo.goal.oldCustomBible != bibleUserPlan.customBible) {
      different = true;
    }

    return different;
  }

  Future<void> _saveAlarm(String target, bool allow) async {
    Alarm alarm = new Alarm();
    alarm.title = target;
    alarm.time = GoalInfo.goal.prayingTime;
    alarm.allow = allow;
    await commonSettings.setAlarm(alarm);
  }

  Future<void> _setAlarm(String target) async {
    _saveAlarm(target, true);

    if (target == 'praying') {
      String prayingTime = GoalInfo.goal.prayingTime;
      List<String> time = prayingTime.split(':');
      Time alramTime = new Time(int.parse(time[0]), int.parse(time[1]), 00);
      await dailyPrayingTimeNotification(context, alramTime);
    } else if (target == 'qt') {
      String qtTime = GoalInfo.goal.qtTime;
      List<String> time = qtTime.split(':');
      Time alramTime = new Time(int.parse(time[0]), int.parse(time[1]), 00);
      await dailyQtTimeNotification(context, alramTime);
    } else if (target == 'thankDiary') {
      String thankDiaryTime = GoalInfo.goal.thankDiaryTime;
      List<String> time = thankDiaryTime.split(':');
      Time alramTime = new Time(int.parse(time[0]), int.parse(time[1]), 00);
      await dailyThankDiaryTimeNotification(context, alramTime);
    } else if (target == 'readingBible') {
      String readingBibleTime = GoalInfo.goal.readingBibleTime;
      List<String> time = readingBibleTime.split(':');
      Time alramTime = new Time(int.parse(time[0]), int.parse(time[1]), 00);
      await dailyReadingBibleTimeNotification(context, alramTime);
    }
  }

  _goToSettingDetail(String title) {
    setState(() {
      switch (title) {
        case 'qt':
          GoalInfo.goal.qtRecord = !GoalInfo.goal.qtRecord;
          if (GoalInfo.goal.qtRecord == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GoalSettingQT(goal: GoalInfo.goal))).then((value) {
              if (value != null) {
                GoalInfo.goal = value['goal'];
              }
            });
          }
          break;
        case 'praying':
          GoalInfo.goal.praying = !GoalInfo.goal.praying;
          if (GoalInfo.goal.praying == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GoalSettingPraying(goal: GoalInfo.goal))).then((value) {
              if (value != null) {
                GoalInfo.goal = value['goal'];
              }
            });
          }
          break;
        case 'bible':
          GoalInfo.goal.readingBible = !GoalInfo.goal.readingBible;
          if (GoalInfo.goal.readingBible == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalSettingBible(
                          newBiblePlan: false,
                          goal: GoalInfo.goal,
                          bibleUserPlan: bibleUserPlan,
                        ))).then((value) {
              if (value != null) {
                setState(() {
                  bibleUserPlan = value['bibleUserPlan'];
                });
              }
            });
          }
          break;
        case 'diary':
          GoalInfo.goal.thankDiary = !GoalInfo.goal.thankDiary;
          if (GoalInfo.goal.thankDiary == true) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GoalSettingThankDiary(goal: GoalInfo.goal)))
                .then((value) {
              if (value != null) {
                setState(() {
                  GoalInfo.goal = value['goal'];
                });
              }
            });
          }
          break;
      }
    });
  }

  Widget _createGoal(
      String target, String title, Color bgColor, bool checkboxVar) {
    if (checkboxVar == null) checkboxVar = false;

    return Flexible(
        fit: FlexFit.tight,
        flex: 1,
        child: InkWell(
            onTap: () => _goToSettingDetail(target),
            child: Container(
              color: bgColor,
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: Checkbox(
                      value: checkboxVar,
                      onChanged: (bool newValue) => _goToSettingDetail(target),
                      activeColor: AppColors.darkGray,
                    ),
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(top: 3),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize:
                                  CommonSettings.language == 'ko' ? 35 : 28,
                              color: Colors.white,
                            ),
                          ))),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            )));
  }

  _goToMain() {
    Navigator.pushReplacementNamed(context, '/');
  }
/* 
  Future<void> _dailyQtTimeNotification(Time alarmTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        CommonSettings.qtAlarmId,
        '[${Translations.of(context).trans('app_title')}] ${Translations.of(context).trans('qt_time')}',
        Translations.of(context)
            .trans('qt_time_alarm_message', param1: UserInfo.loginUser.name),
        _scheduledDaily(alarmTime),
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

  Future<void> _dailyPrayingTimeNotification(Time alarmTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        CommonSettings.prayingAlarmId,
        '[${Translations.of(context).trans('app_title')}] ${Translations.of(context).trans('thankdiary_time')}',
        Translations.of(context).trans('praying_time_alarm_message',
            param1: UserInfo.loginUser.name),
        _scheduledDaily(alarmTime),
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

  Future<void> _dailyThankDiaryTimeNotification(Time alarmTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        CommonSettings.thankDiaryAlarmId,
        '[${Translations.of(context).trans('app_title')}] ${Translations.of(context).trans('thankdiary_time')}',
        Translations.of(context).trans('thankdiary_time_alarm_message',
            param1: UserInfo.loginUser.name),
        _scheduledDaily(alarmTime),
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

  Future<void> _dailyReadingBibleTimeNotification(Time alarmTime) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        CommonSettings.readingBibleAlarmId,
        '[${Translations.of(context).trans('app_title')}] ${Translations.of(context).trans('readingbible_time')}',
        Translations.of(context).trans('readingbible_time_alarm_message',
            param1: UserInfo.loginUser.name),
        _scheduledDaily(alarmTime),
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

  tz.TZDateTime _scheduledDaily(Time alarmTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, alarmTime.hour, alarmTime.minute);
    scheduledDate = scheduledDate.add(const Duration(days: 1));
    return scheduledDate;
  }

  Future<void> _cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  } */

  @override
  void initState() {
    if (GoalInfo.goal == null) GoalInfo.goal = new Goal();
    GoalInfo.goal.qtRecord = false;
    GoalInfo.goal.readingBible = false;
    GoalInfo.goal.praying = false;
    GoalInfo.goal.thankDiary = false;

    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    goalInfo.getUserGoal(context).then((value) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          GoalInfo.goal = value;
          bibleUserPlan.biblePlanId = GoalInfo.goal.biblePlanId;
          bibleUserPlan.customBible = GoalInfo.goal.customBible;
          bibleUserPlan.planPeriod = GoalInfo.goal.planPeriod;
        });
      }
    });

    requestPermissions();
    // alarm function setting
    configureLocalTimeZone();
/* 
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    CommonSettings.flutterLocalNotificationsPlugin
        .initialize(initializationSettings); */

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: UserInfo.loginUser != null
                ? Column(children: [
                    appBarCustom(context,
                        Translations.of(context).trans('title_goal_setting'),
                        leaderText: Translations.of(context).trans('cancel'),
                        onLeaderTap: _goToMain,
                        actionText: Translations.of(context).trans('save'),
                        onActionTap: setUserGoal),
                    _createGoal(
                        'qt',
                        Translations.of(context).trans('daily_qt'),
                        AppColors.blueSky,
                        GoalInfo.goal?.qtRecord),
                    _createGoal(
                        'praying',
                        Translations.of(context).trans('daily_praying'),
                        AppColors.mint,
                        GoalInfo.goal?.praying),
                    _createGoal(
                        'bible',
                        Translations.of(context).trans('daily_bible'),
                        AppColors.lightOrange,
                        GoalInfo.goal?.readingBible),
                    _createGoal(
                        'diary',
                        Translations.of(context).trans('daily_thank'),
                        AppColors.pastelPink,
                        GoalInfo.goal?.thankDiary),
                  ])
                : Container()));
  }
}
