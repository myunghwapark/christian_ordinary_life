import 'package:christian_ordinary_life/src/component/timeBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'dart:convert';
import 'package:loading_overlay/loading_overlay.dart';

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
  bool _isLoading = false;
  int _selected = 0;
  bool _timeBoxVisible = true;
  DateTime today = new DateTime.now();
  String _setHour = '06', _setMinute = '00';

  DateTime _setInitTime() {
    DateTime _dateTime = new DateTime(today.year, today.month, today.day,
        int.parse(_setHour), int.parse(_setMinute));
    return _dateTime;
  }

  Future<void> _getBiblePlan() async {
    BiblePlan result;
    setState(() {
      _isLoading = true;
    });

    try {
      await API.transaction(context, API.biblePlanList,
          param: {'language': CommonSettings.language}).then((response) {
        result = BiblePlan.fromJson(json.decode(response));

        setState(() {
          _isLoading = false;
        });

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
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  void _onAlarmRadioChanged(int value) {
    setState(() {
      _selected = value;
    });
    GoalInfo.goal.readingBibleAlarm = value == 0 ? true : false;

    setState(() {
      if (value == 0) {
        _timeBoxVisible = true;
      } else {
        _timeBoxVisible = false;
      }
    });
  }

  void _onTimepickerChanged(List timeArray) {
    setState(() {
      List times = timepickerChanged(timeArray);
      _setHour = times[0];
      _setMinute = times[1];
      GoalInfo.goal.readingBibleTime = times[0] + ':' + times[1];
    });
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
    final _alramSetLabel = Container(
        margin: EdgeInsets.only(top: 30, left: 20, bottom: 10),
        child: Text(
          Translations.of(context).trans('readingbible_notice_setting_ment'),
          style: TextStyle(
            fontSize: 20,
            fontFamily: '12LotteMartHappy',
            fontWeight: FontWeight.w300,
          ),
        ));

    final _radioYes = RadioListTile(
        title: Text(Translations.of(context).trans('yes')),
        value: 0,
        groupValue: _selected,
        onChanged: (int value) {
          _onAlarmRadioChanged(value);
        });

    final _radioNo = RadioListTile(
        title: Text(Translations.of(context).trans('no')),
        value: 1,
        groupValue: _selected,
        onChanged: (int value) {
          _onAlarmRadioChanged(value);
        });

    final _readingBibleTimeBox = Visibility(
        visible: _timeBoxVisible,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightBrown),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(Translations.of(context).trans('readingbible_time'),
                  style: TextStyle(color: AppColors.lightBrown, fontSize: 17)),
              timeBox(
                  context,
                  _setHour,
                  _setMinute,
                  AppColors.lightBrown,
                  () => {
                        // Time picker
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext builder) {
                              return Container(
                                  height: MediaQuery.of(context)
                                          .copyWith()
                                          .size
                                          .height /
                                      2.5,
                                  child: TimePickerWidget(
                                      initDateTime: _setInitTime(),
                                      dateFormat: 'HH:mm',
                                      onConfirm: (time, timeArray) =>
                                          {_onTimepickerChanged(timeArray)}));
                            })
                      })
            ])));

    final _bibleAlarm = Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _alramSetLabel,
            _radioYes,
            _readingBibleTimeBox,
            _radioNo,
          ],
        ));

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
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: ListView(
              children: [
                _bibleAlarm,
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: biblePlanList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          _onRadioChanged(index);
                        },
                        title: RadioBox(biblePlanList[index]),
                      );
                    })
              ],
            )));
  }

  @override
  initState() {
    super.initState();
    bibleUserPlan = widget.bibleUserPlan;

    if (GoalInfo.goal.readingBibleTime == null ||
        GoalInfo.goal.readingBibleTime == '') {
      GoalInfo.goal.readingBibleTime = _setHour + ':' + _setMinute;
    } else {
      List<String> readingBibleTime = GoalInfo.goal.readingBibleTime.split(':');
      _setHour = readingBibleTime[0];
      _setMinute = readingBibleTime[1];
    }

    if (GoalInfo.goal.readingBibleAlarm == null) {
      GoalInfo.goal.readingBibleAlarm = _selected == 0 ? true : false;
    } else {
      _selected = GoalInfo.goal.readingBibleAlarm == true ? 0 : 1;
    }

    if (!GoalInfo.goal.readingBibleAlarm) {
      setState(() {
        _timeBoxVisible = false;
      });
    }

    _getBiblePlan();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
