import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/component/timeBox.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:flutter/material.dart';

class GoalSettingThankDiary extends StatefulWidget {
  final Goal goal;
  GoalSettingThankDiary({this.goal});
  GoalSettingThankDiaryState createState() => GoalSettingThankDiaryState();
}

class GoalSettingThankDiaryState extends State<GoalSettingThankDiary> {
  Goal goal = new Goal();
  int _selected = 0;
  DateTime today = new DateTime.now();
  String _setHour = '06', _setMinute = '00';

  DateTime _setInitTime() {
    DateTime _dateTime = new DateTime(today.year, today.month, today.day,
        int.parse(_setHour), int.parse(_setMinute));
    return _dateTime;
  }

  void _init() {
    goal = widget.goal;
    if (goal.thankDiaryTime == null || goal.thankDiaryTime == '') {
      goal.thankDiaryTime = _setHour + ':' + _setMinute;
    } else {
      List<String> thankDiaryTime = goal.thankDiaryTime.split(':');
      _setHour = thankDiaryTime[0];
      _setMinute = thankDiaryTime[1];
    }

    if (goal.thankDiaryAlarm == null) {
      goal.thankDiaryAlarm = _selected == 0 ? true : false;
    } else {
      _selected = goal.thankDiaryAlarm == true ? 0 : 1;
    }
  }

  void _onRadioChanged(int value) {
    setState(() {
      _selected = value;
    });
    goal.thankDiaryAlarm = value == 0 ? true : false;
  }

  void _onTimepickerChanged(DateTime dateTime) {
    setState(() {
      _setHour = makeTimeFormat(dateTime.hour);
      _setMinute = makeTimeFormat(dateTime.minute);
      goal.thankDiaryTime = dataFormatTimeSecond(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _thankDiaryTimeBox = timeBox(
        context,
        _setHour,
        _setMinute,
        AppColors.pastelPink,
        () => {
              // Time picker

              openTimePicker(context, _onTimepickerChanged,
                  initTime: _setInitTime())
              /* showModalBottomSheet(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                        height:
                            MediaQuery.of(context).copyWith().size.height / 2.5,
                        child: TimePickerWidget(
                            initDateTime: _setInitTime(),
                            dateFormat: 'HH:mm',
                            onConfirm: (time, timeArray) =>
                                {_onTimepickerChanged(timeArray)}));
                  }) */
            });

    final _preposition =
        Text(Translations.of(context).trans('purposeful_thankdiary_time_2'),
            style: TextStyle(
              fontSize: 20,
              fontFamily: '12LotteMartHappy',
              fontWeight: FontWeight.w300,
            ));

    final _resolution = Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(top: 20, bottom: 27),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  Translations.of(context)
                      .trans('purposeful_thankdiary_time_1'),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: '12LotteMartHappy',
                    fontWeight: FontWeight.w300,
                  )),
              CommonSettings.language == 'ko'
                  ? _thankDiaryTimeBox
                  : Container(),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CommonSettings.language != 'ko' ? _thankDiaryTimeBox : Container(),
            CommonSettings.language == 'ko' ? _preposition : Container(),
          ]),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white),
    );

    final _alramSetLabel = Container(
        margin: EdgeInsets.only(top: 30, bottom: 10),
        child: Text(
          Translations.of(context).trans('thankdiary_notice_setting_ment'),
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
          _onRadioChanged(value);
        });

    final _radioNo = RadioListTile(
        title: Text(Translations.of(context).trans('no')),
        value: 1,
        groupValue: _selected,
        onChanged: (int value) {
          _onRadioChanged(value);
        });

    void _backAction() {
      Navigator.pop(context, {'goal': goal});
    }

    return Scaffold(
        backgroundColor: AppColors.pastelPink,
        appBar: appBarBack(context,
            Translations.of(context).trans('thankdiary_notice_setting_title'),
            onBackTap: _backAction),
        body: GestureDetector(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _resolution,
                    _alramSetLabel,
                    _radioYes,
                    _radioNo,
                  ]),
            ),
          ),
          onTap: () => FocusScope.of(context).unfocus(),
        ));
  }

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
