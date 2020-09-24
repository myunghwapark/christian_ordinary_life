import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/radioBox.dart';
import 'package:christian_ordinary_life/src/model/BiblePlan.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingComplete.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'goalBibleCustom1.dart';

class GoalSettingBible extends StatefulWidget {
  static const routeName = '/golSettingBible';
  final User loginUser;
  final Goal goal;
  final BibleUserPlan bibleUserPlan;
  final bool newBiblePlan;

  GoalSettingBible(
      {this.loginUser, this.goal, this.bibleUserPlan, this.newBiblePlan});

  @override
  GoalSettingBibleState createState() => GoalSettingBibleState();
}

class GoalSettingBibleState extends State<GoalSettingBible> {
  BibleUserPlan bibleUserPlan = new BibleUserPlan();
  List<BiblePlan> biblePlanList = <BiblePlan>[];
  GoalInfo goalInfo = new GoalInfo();

  Future<void> _getBiblePlan() async {
    BiblePlan result;
    try {
      await API.transaction(context, API.biblePlanList,
          param: {'language': CommonSettings.language}).then((response) {
        result = BiblePlan.fromJson(json.decode(response));

        if (result.result == 'success') {
          setState(() {
            List<BiblePlan> tempList;
            tempList = result.biblePlanList
                .map((model) => BiblePlan.fromJson(model))
                .toList();
            for (int i = 0; i < tempList.length; i++) {
              tempList[i].isSelected = false;

              if (bibleUserPlan != null &&
                  bibleUserPlan.biblePlanId != null &&
                  bibleUserPlan.biblePlanId != '' &&
                  bibleUserPlan.biblePlanId == tempList[i].biblePlanId) {
                tempList[i].isSelected = true;
              }
              biblePlanList.add(tempList[i]);
            }
          });
        } else {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }

    return result;
  }

  Future<void> setUserGoal() async {
    if (!goalInfo.checkContent(context, bibleUserPlan)) return;

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

  String _getPlanEndDate(String period) {
    if (period == null) return null;
    String _periodType = period.substring(period.length - 1, period.length);
    int _planPeriod = int.parse(period.substring(0, period.length - 1));

    DateTime today = new DateTime.now();

    if (_periodType == 'w') _planPeriod = (_planPeriod * 7) - 2;

    DateTime _planEndDate = today.add(Duration(days: _planPeriod));
    return _planEndDate.toString();
  }

  Future<void> _onRadioChanged(int index) async {
    setState(() {
      if (bibleUserPlan.biblePlanId != biblePlanList[index].biblePlanId) {
        biblePlanList.forEach((element) => element.isSelected = false);
        biblePlanList[index].isSelected = true;
        bibleUserPlan.biblePlanId = biblePlanList[index].biblePlanId;
        if (biblePlanList[index].biblePlanId != 'custom') {
          bibleUserPlan.planPeriod = biblePlanList[index].planPeriod;

          bibleUserPlan.planEndDate =
              _getPlanEndDate(biblePlanList[index].planPeriod);
        } else {
          bibleUserPlan.planPeriod = null;
          bibleUserPlan.planEndDate = null;
        }
      }
    });

    if (biblePlanList[index].biblePlanId == 'custom') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoalBibleCustom1(
            bibleUserPlan: bibleUserPlan,
            newBiblePlan: widget.newBiblePlan,
          ),
        ),
      ).then((value) {
        if (value != null && value['result'] == 'complete') {
          Navigator.pop(context,
              {"result": "complete", "bibleUserPlan": value['bibleUserPlan']});
        }
      });
    }
  }

  void _backScreen() {
    Navigator.pop(context, {"bibleUserPlan": bibleUserPlan});
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('save')),
      onPressed: setUserGoal,
      textColor: AppColors.darkGray,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightOrange,
        appBar: widget.newBiblePlan
            ? appBarComponent(
                context, Translations.of(context).trans('bible_reading_plan'),
                actionWidget: actionIcon())
            : appBarBack(
                context,
                Translations.of(context).trans('bible_reading_plan'),
                onBackTap: _backScreen,
              ),
        body: ListView.builder(
            itemCount: biblePlanList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  _onRadioChanged(index);
                },
                title: RadioBox(biblePlanList[index]),
              );
            }));
  }

  @override
  initState() {
    super.initState();
    bibleUserPlan = widget.bibleUserPlan;
    _getBiblePlan();
  }
}
