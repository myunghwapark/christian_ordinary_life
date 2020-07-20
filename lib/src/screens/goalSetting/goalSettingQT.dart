import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import '../../common/translations.dart';
import '../../component/appBarComponent.dart';
import '../../component/timeBox.dart';
import '../../common/util.dart';

class GoalSettingQT extends StatefulWidget {
  @override
  GoalSettingQTState createState() => GoalSettingQTState();
}

class GoalSettingQTState extends State<GoalSettingQT> {
  int _selected = 0;
  bool visibleVar = true;
  String _setHour = '06', _setMinute = '00';

  DateTime _setInitTime() {
    DateTime _dateTime =
        new DateTime(2020, 07, 16, int.parse(_setHour), int.parse(_setMinute));
    return _dateTime;
  }

  void _onRadioChanged(int value) {
    setState(() {
      _selected = value;
      if (value == 0) {
        visibleVar = true;
      } else {
        visibleVar = false;
      }
    });

    print('Value = $value');
  }

  void _onTimepickerChanged(List timeArray) {
    setState(() {
      List times = timepickerChanged(timeArray);
      _setHour = times[0];
      _setMinute = times[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBack(
          context,
          Translations.of(context).trans('qt_notice_setting_title'),
          null,
          null),
      body: Container(
        color: AppColors.blueSky,
        padding: EdgeInsets.all(20),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                Translations.of(context).trans('qt_notice_setting_ment'),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: '12LotteMartHappy',
                  fontWeight: FontWeight.w300,
                ),
              )),
          Row(
            children: [
              Radio(
                  value: 0,
                  groupValue: _selected,
                  onChanged: (int value) {
                    _onRadioChanged(value);
                  }),
              Text(Translations.of(context).trans('yes'))
            ],
          ),
          // QT Time Box
          timeBox(
              context,
              Translations.of(context).trans('qt_time'),
              visibleVar,
              _setHour,
              _setMinute,
              AppColors.blueSky,
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
                  }),
          // No text
          Row(
            children: [
              Radio(
                  value: 1,
                  groupValue: _selected,
                  onChanged: (int value) {
                    _onRadioChanged(value);
                  }),
              Text(Translations.of(context).trans('no'))
            ],
          )
        ]),
      ),
    );
  }
}
