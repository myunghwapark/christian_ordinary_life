import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/radioBox.dart';
import 'package:christian_ordinary_life/src/model/BiblePlan.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'goalBibleCustom1.dart';

class GoalSettingBible extends StatefulWidget {
  final User loginUser;
  final String language;
  final Goal goal;
  final BibleUserPlan bibleUserPlan;
  GoalSettingBible(
      {this.loginUser, this.language, this.goal, this.bibleUserPlan});

  @override
  GoalSettingBibleState createState() => GoalSettingBibleState();
}

class GoalSettingBibleState extends State<GoalSettingBible> {
  BibleUserPlan bibleUserPlan = new BibleUserPlan();
  List<BiblePlan> biblePlanList = <BiblePlan>[];

  Future<void> _getBiblePlan() async {
    BiblePlan result;
    try {
      await API.transaction(context, API.biblePlanList,
          param: {'language': widget.language}).then((response) {
        result = BiblePlan.fromJson(json.decode(response));

        if (result.result == 'success') {
          setState(() {
            List<BiblePlan> tempList;
            tempList = result.biblePlanList
                .map((model) => BiblePlan.fromJson(model))
                .toList();
            for (int i = 0; i < tempList.length; i++) {
              tempList[i].isSelected = false;

              if (bibleUserPlan.biblePlanId != null &&
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
    });

    if (biblePlanList[index].biblePlanId == 'custom') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoalBibleCustom1(bibleUserPlan: bibleUserPlan),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightOrange,
        appBar: appBarBack(
          context,
          Translations.of(context).trans('bible_reading_plan'),
          onTap: _backScreen,
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
