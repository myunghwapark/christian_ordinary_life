import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'goalSettingQT.dart';
import 'goalSettingBible.dart';
import 'goalSettingPraying.dart';

class GoalSetting extends StatefulWidget {
  static const routeName = '/goalSetting';

  final User loginUser;
  final Goal goal;
  final BibleUserPlan bibleUserPlan;
  GoalSetting({this.loginUser, this.goal, this.bibleUserPlan});

  @override
  GoalSettingState createState() => GoalSettingState();
}

class GoalSettingState extends State<GoalSetting> {
  Goal goal = new Goal();
  BibleUserPlan bibleUserPlan = new BibleUserPlan();

  Future<void> getUserGoal() async {
    try {
      Goal result = new Goal();
      await API.transaction(context, API.getUserGoal,
          param: {'userSeqNo': widget.loginUser.seqNo}).then((response) {
        result = Goal.fromJson(json.decode(response));
        print('response: $response');
        if (result.result == 'success') {
          setState(() {
            List<Goal> goalInfo =
                result.goalInfo.map((model) => Goal.fromJson(model)).toList();
            goal = goalInfo[0];
            // 한번에 파싱하기 위해 어쩔 수 없이 Goal에 담아서 분배
            bibleUserPlan.biblePlanId = goal.biblePlanId;
            bibleUserPlan.customBible = goal.customBible;
            bibleUserPlan.planPeriod = goal.planPeriod;
          });
        } else if (result.errorCode == '01') {
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

  Future<void> setUserGoal() async {
    /*  print('readingBible: ${goal.readingBible}');
    print('qtAlarm: ${goal.qtAlarm}');
    print('biblePlanId: ${bibleUserPlan.biblePlanId}');
    print('customBible: ${bibleUserPlan.customBible}');
    return; */
    try {
      Goal result = new Goal();
      await API.transaction(context, API.setUserGoal, param: {
        'userSeqNo': widget.loginUser.seqNo,
        'readingBible': goal.readingBible,
        'thankDiary': goal.thankDiary,
        'qtRecord': goal.qtRecord,
        'qtTime': goal.qtTime,
        'qtAlarm': goal.qtAlarm,
        'praying': goal.praying,
        'prayingTime': goal.prayingTime,
        'prayingAlarm': goal.prayingAlarm,
        'prayingDuration': goal.prayingDuration
      }).then((response) async {
        result = Goal.fromJson(json.decode(response));
        if (result.result == 'success') {
          final askingResult = await showConfirmDialog(
              context,
              (Translations.of(context)
                  .trans('goal_setted', param1: widget.loginUser.name)));
          if (askingResult == 'ok') _goToMain();
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

  _goToSettingDetail(String title) {
    setState(() {
      switch (title) {
        case 'qt':
          goal.qtRecord = !goal.qtRecord;
          if (goal.qtRecord == true) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GoalSettingQT(goal: goal)))
                .then((value) {
              if (value != null) {
                goal = value['goal'];
                //goal.qtAlarm = tempGoal.qtAlarm;
                //goal.qtTime = tempGoal.qtTime;
              }
            });
          }
          break;
        case 'praying':
          goal.praying = !goal.praying;
          if (goal.praying == true) {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GoalSettingPraying(goal: goal)))
                .then((value) {
              if (value != null) {
                goal = value['goal'];
              }
            });
          }
          break;
        case 'bible':
          goal.readingBible = !goal.readingBible;
          if (goal.readingBible == true) {
            String language = Translations.of(context).localeLaunguageCode();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GoalSettingBible(
                          language: language,
                          goal: goal,
                          bibleUserPlan: bibleUserPlan,
                        ))).then((value) {
              if (value != null) bibleUserPlan = value['bibleUserPlan'];
            });
          }
          break;
        case 'diary':
          goal.thankDiary = !goal.thankDiary;
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
    goal.qtRecord = false;
    goal.readingBible = false;
    goal.praying = false;
    goal.thankDiary = false;

    getUserGoal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('build qtRecord: ${goal.qtRecord}');
    return Scaffold(
        body: Column(children: [
      appBarCustom(
          context, Translations.of(context).trans('title_goal_setting'),
          leaderText: Translations.of(context).trans('cancel'),
          onLeaderTap: _goToMain,
          actionText: Translations.of(context).trans('save'),
          onActionTap: setUserGoal),
      _createGoal('qt', Translations.of(context).trans('daily_qt'),
          AppColors.blueSky, goal.qtRecord),
      _createGoal('praying', Translations.of(context).trans('daily_praying'),
          AppColors.mint, goal.praying),
      _createGoal('bible', Translations.of(context).trans('daily_bible'),
          AppColors.lightOrange, goal.readingBible),
      _createGoal('diary', Translations.of(context).trans('daily_thank'),
          AppColors.pastelPink, goal.thankDiary),
    ]));
  }
}
