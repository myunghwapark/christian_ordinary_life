import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/component/timeBox.dart';
import 'package:christian_ordinary_life/src/common/util.dart';

class GoalSettingQT extends StatefulWidget {
  final Goal goal;
  GoalSettingQT({this.goal});

  @override
  GoalSettingQTState createState() => GoalSettingQTState();
}

class GoalSettingQTState extends State<GoalSettingQT> {
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
    if (goal.qtTime == null) {
      goal.qtTime = _setHour + ':' + _setMinute;
    } else {
      List<String> qtTime = goal.qtTime.split(':');
      _setHour = qtTime[0];
      _setMinute = qtTime[1];
    }

    if (goal.qtAlarm == null) {
      goal.qtAlarm = _selected == 0 ? true : false;
    } else {
      _selected = goal.qtAlarm == true ? 0 : 1;
    }
  }

  void _onRadioChanged(int value) {
    setState(() {
      _selected = value;
    });
    goal.qtAlarm = value == 0 ? true : false;
  }

  void _onTimepickerChanged(List timeArray) {
    setState(() {
      List times = timepickerChanged(timeArray);
      _setHour = times[0];
      _setMinute = times[1];
      goal.qtTime = times[0] + ':' + times[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final _qtTimeBox = timeBox(
        context,
        _setHour,
        _setMinute,
        AppColors.blueSky,
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

    final _preposition =
        Text(Translations.of(context).trans('purposeful_qt_time_2'),
            style: TextStyle(
              fontSize: 20,
              fontFamily: '12LotteMartHappy',
              fontWeight: FontWeight.w300,
            ));

    final _resolution = Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(top: 10, bottom: 27),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Translations.of(context).trans('purposeful_qt_time_1'),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: '12LotteMartHappy',
                    fontWeight: FontWeight.w300,
                  )),
              Translations.of(context).localeLaunguageCode() == 'ko'
                  ? _qtTimeBox
                  : Container(),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Translations.of(context).localeLaunguageCode() != 'ko'
                ? _qtTimeBox
                : Container(),
            Translations.of(context).localeLaunguageCode() == 'ko'
                ? _preposition
                : Container(),
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
          Translations.of(context).trans('qt_notice_setting_ment'),
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
        backgroundColor: AppColors.blueSky,
        appBar: appBarBack(
            context, Translations.of(context).trans('qt_notice_setting_title'),
            onTap: _backAction),
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
}
