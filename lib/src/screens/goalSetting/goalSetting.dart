import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingComplete.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'goalSettingQT.dart';
import 'goalSettingBible.dart';
import 'goalSettingPraying.dart';

class GoalSetting extends StatefulWidget {
  static const routeName = '/goalSetting';

  final Goal goal;
  final BibleUserPlan bibleUserPlan;
  GoalSetting({this.goal, this.bibleUserPlan});

  @override
  GoalSettingState createState() => GoalSettingState();
}

class GoalSettingState extends State<GoalSetting> {
  GoalInfo goalInfo = new GoalInfo();
  BibleUserPlan bibleUserPlan = new BibleUserPlan();

  Future<void> setUserGoal() async {
    if (!_checkContent()) return;
    try {
      showLoading(context);
      Goal result = new Goal();
      await API.transaction(context, API.setUserGoal, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'readingBible': GoalInfo.goal.readingBible,
        'thankDiary': GoalInfo.goal.thankDiary,
        'qtRecord': GoalInfo.goal.qtRecord,
        'qtTime': GoalInfo.goal.qtTime,
        'qtAlarm': GoalInfo.goal.qtAlarm,
        'praying': GoalInfo.goal.praying,
        'prayingTime': GoalInfo.goal.prayingTime,
        'prayingAlarm': GoalInfo.goal.prayingAlarm,
        'prayingDuration': GoalInfo.goal.prayingDuration,
        'biblePlanId': bibleUserPlan.biblePlanId,
        'planPeriod': bibleUserPlan.planPeriod,
        'customBible': bibleUserPlan.customBible,
        'planEndDate': bibleUserPlan.planEndDate
      }).then((response) async {
        //print('response: $response');
        result = Goal.fromJson(json.decode(response));
        if (result.result == 'success') {
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
        } else {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
  }

  bool _checkContent() {
    if (GoalInfo.goal.readingBible &&
        (bibleUserPlan.biblePlanId == null ||
            bibleUserPlan.biblePlanId == '')) {
      showAlertDialog(
          context, Translations.of(context).trans('select_bible_plan'));
      return false;
    } else if (bibleUserPlan.biblePlanId == 'custom' &&
        (bibleUserPlan.customBible == null ||
            bibleUserPlan.customBible == '')) {
      showAlertDialog(
          context, Translations.of(context).trans('select_custom_bible_plan'));
      return false;
    } else if (bibleUserPlan.biblePlanId == 'custom' &&
        (bibleUserPlan.planPeriod == null ||
            bibleUserPlan.planPeriod == '' ||
            bibleUserPlan.planPeriod == '0')) {
      showAlertDialog(
          context, Translations.of(context).trans('select_custom_bible_plan'));
      return false;
    } else {
      return true;
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
            String language = Translations.of(context).localeLaunguageCode();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalSettingBible(
                          language: language,
                          goal: GoalInfo.goal,
                          bibleUserPlan: bibleUserPlan,
                        ))).then((value) {
              if (value != null) {
                bibleUserPlan = value['bibleUserPlan'];
              }
            });
          }
          break;
        case 'diary':
          GoalInfo.goal.thankDiary = !GoalInfo.goal.thankDiary;
          break;
      }
    });
  }

  Widget _createGoal(
      String target, String title, Color bgColor, bool checkboxVar) {
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
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ))),
                  if (target != 'diary')
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

  @override
  void initState() {
    GoalInfo.goal.qtRecord = false;
    GoalInfo.goal.readingBible = false;
    GoalInfo.goal.praying = false;
    GoalInfo.goal.thankDiary = false;

    goalInfo.getUserGoal(context).then((value) {
      setState(() {
        GoalInfo.goal = value;
        bibleUserPlan.biblePlanId = GoalInfo.goal.biblePlanId;
        bibleUserPlan.customBible = GoalInfo.goal.customBible;
        bibleUserPlan.planPeriod = GoalInfo.goal.planPeriod;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      appBarCustom(
          context, Translations.of(context).trans('title_goal_setting'),
          leaderText: Translations.of(context).trans('cancel'),
          onLeaderTap: _goToMain,
          actionText: Translations.of(context).trans('save'),
          onActionTap: setUserGoal),
      _createGoal('qt', Translations.of(context).trans('daily_qt'),
          AppColors.blueSky, GoalInfo.goal.qtRecord),
      _createGoal('praying', Translations.of(context).trans('daily_praying'),
          AppColors.mint, GoalInfo.goal.praying),
      _createGoal('bible', Translations.of(context).trans('daily_bible'),
          AppColors.lightOrange, GoalInfo.goal.readingBible),
      _createGoal('diary', Translations.of(context).trans('daily_thank'),
          AppColors.pastelPink, GoalInfo.goal.thankDiary),
    ]));
  }
}
