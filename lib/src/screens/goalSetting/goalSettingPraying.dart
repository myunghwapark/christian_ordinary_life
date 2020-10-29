import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/component/timeBox.dart';
import 'package:christian_ordinary_life/src/common/util.dart';

class GoalSettingPraying extends StatefulWidget {
  final Goal goal;
  GoalSettingPraying({this.goal});

  @override
  GoalSettingPrayingState createState() => GoalSettingPrayingState();
}

class GoalSettingPrayingState extends State<GoalSettingPraying> {
  final TextEditingController _prayingTimeController =
      new TextEditingController();
  Goal goal = new Goal();
  int _selected = 0;
  DateTime today = new DateTime.now();
  String _setHour = '06', _setMinute = '00';

  void _init() {
    goal = widget.goal;
    if (goal.prayingTime == null || goal.prayingTime == '') {
      goal.prayingTime = _setHour + ':' + _setMinute;
    } else {
      List<String> prayingTime = goal.prayingTime.split(':');
      _setHour = prayingTime[0];
      _setMinute = prayingTime[1];
    }

    if (goal.prayingAlarm == null) {
      goal.prayingAlarm = _selected == 0 ? true : false;
    } else {
      _selected = goal.prayingAlarm == true ? 0 : 1;
    }

    if (goal.prayingDuration != null) {
      _prayingTimeController.text = goal.prayingDuration;
    }
  }

  DateTime _setInitTime() {
    DateTime _dateTime = new DateTime(today.year, today.month, today.day,
        int.parse(_setHour), int.parse(_setMinute));
    return _dateTime;
  }

  void _onRadioChanged(int value) {
    setState(() {
      _selected = value;
      goal.prayingAlarm = value == 0 ? true : false;
    });
  }

  void _onTimepickerChanged(List timeArray) {
    setState(() {
      List times = timepickerChanged(timeArray);
      _setHour = times[0];
      _setMinute = times[1];
      goal.prayingTime = times[0] + ':' + times[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final _prayingTimeBox = timeBox(
        context,
        _setHour,
        _setMinute,
        AppColors.mint,
        () => {
              // Time picker
              showModalBottomSheet(
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
                  })
            });

    final _prayingTime = Container(
        padding: EdgeInsets.only(right: 5),
        width: 60,
        child: TextField(
            textAlign: TextAlign.center,
            controller: _prayingTimeController,
            keyboardType: TextInputType.number,
            maxLength: 3,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mint, width: 2),
              ),
            )));

    final _preposition =
        Text(Translations.of(context).trans('purposeful_prayer_time_2'),
            style: TextStyle(
              fontSize: 20,
              fontFamily: '12LotteMartHappy',
              fontWeight: FontWeight.w300,
            ));

    final _resolution = Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Translations.of(context).trans('purposeful_prayer_time_1'),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: '12LotteMartHappy',
                    fontWeight: FontWeight.w300,
                  )),
              _prayingTimeBox,
              Translations.of(context).localeLaunguageCode() == 'ko'
                  ? _preposition
                  : Container(),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CommonSettings.language != 'ko' ? _preposition : Container(),
            _prayingTime,
            Text(Translations.of(context).trans('purposeful_prayer_time_3'),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: '12LotteMartHappy',
                  fontWeight: FontWeight.w300,
                )),
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
          Translations.of(context).trans('pray_notice_setting_ment'),
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
      goal.prayingDuration = _prayingTimeController.text;
      Navigator.pop(context, {'goal': goal});
    }

    return Scaffold(
        backgroundColor: AppColors.mint,
        appBar: appBarBack(context,
            Translations.of(context).trans('pray_notice_setting_title'),
            onBackTap: _backAction),
        body: GestureDetector(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_resolution, _alramSetLabel, _radioYes, _radioNo]),
            ),
          ),
          onTap: () => {FocusScope.of(context).unfocus()},
        ));
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _prayingTimeController.dispose();
    super.dispose();
  }
}
