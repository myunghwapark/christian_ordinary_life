import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingComplete.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'goalSettingQT.dart';
import 'goalSettingBible.dart';
import 'goalSettingPraying.dart';

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

  Future<void> setUserGoal() async {
    bool saveAvailable = true;
    if (!goalInfo.checkContent(context, bibleUserPlan)) saveAvailable = false;

    if (GoalInfo.goal.oldBiblePlan) {
      await showConfirmDialog(context,
              Translations.of(context).trans('replace_bible_plan_ment'))
          .then((value) {
        if (value == 'cancel') saveAvailable = false;
      });
    }

    if (saveAvailable) {
      goalInfo.setUserGoal(context, bibleUserPlan).then((value) {
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
    if (GoalInfo.goal == null) GoalInfo.goal = new Goal();
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
