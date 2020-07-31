import 'package:christian_ordinary_life/src/component/customPicker.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter/cupertino.dart';
import '../../common/translations.dart';
import '../../component/appBarComponent.dart';
import '../../component/timeBox.dart';
import '../../common/util.dart';

class GoalSettingPraying extends StatefulWidget {
  @override
  GoalSettingPrayingState createState() => GoalSettingPrayingState();
}

class GoalSettingPrayingState extends State<GoalSettingPraying> {
  int _selected = 0, _timeSelected = 0;
  String _setHour = '06', _setMinute = '00';
  bool visibleVar = true;
  String _timeType = '';
  final TextEditingController _textController = new TextEditingController();

  void _init(BuildContext context) {
    _setTimeType(context);
  }

  DateTime _setInitTime() {
    DateTime _dateTime =
        new DateTime(2020, 07, 16, int.parse(_setHour), int.parse(_setMinute));
    return _dateTime;
  }

  void _handleSubmitted(String text) {
    _textController.clear();
  }

  void _setTimeType(BuildContext context) {
    setState(() {
      if (_timeSelected == 0) {
        _timeType = Translations.of(context).trans('hours');
      } else {
        _timeType = Translations.of(context).trans('minutes');
      }
    });
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
  }

  void _onTimepickerChanged(List timeArray) {
    setState(() {
      List times = timepickerChanged(timeArray);
      _setHour = times[0];
      _setMinute = times[1];
    });
  }

  void _showBottomSheet() async {
    final result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return CustomPicker(
            timeSelected: _timeSelected,
            pickerType: 'time',
          );
        });
    if (result != null) {
      _timeSelected = result;
      _setTimeType(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init(context);

    final _label = Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          Translations.of(context).trans('purposeful_prayer_time'),
          style: TextStyle(
            fontSize: 20,
            fontFamily: '12LotteMartHappy',
            fontWeight: FontWeight.w300,
          ),
        ));

    final _prayingTime = Flexible(
        fit: FlexFit.tight,
        child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmitted,
            keyboardType: TextInputType.number,
            maxLength: 3,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[400], width: 2),
            ))));

    final _prayingTimeOption = InkWell(
      child: Container(
        width: 85,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.darkGray),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        margin: EdgeInsets.only(left: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(_timeType),
          Icon(Icons.arrow_drop_down, color: AppColors.darkGray, size: 20)
        ]),
      ),
      onTap: _showBottomSheet,
    );

    final _alramSetLabel = Container(
        margin: EdgeInsets.only(top: 20, bottom: 10),
        child: Text(
          Translations.of(context).trans('pray_notice_setting_ment'),
          style: TextStyle(
            fontSize: 20,
            fontFamily: '12LotteMartHappy',
            fontWeight: FontWeight.w300,
          ),
        ));

    final _radioYes = Row(
      children: [
        Radio(
            value: 0,
            groupValue: _selected,
            onChanged: (int value) {
              _onRadioChanged(value);
            }),
        Text(Translations.of(context).trans('yes'))
      ],
    );

    final _qtTimeBox = timeBox(
        context,
        Translations.of(context).trans('praying_time'),
        visibleVar,
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

    final _radioNo = Row(
      children: [
        Radio(
            value: 1,
            groupValue: _selected,
            onChanged: (int value) {
              _onRadioChanged(value);
            }),
        Text(Translations.of(context).trans('no'))
      ],
    );

    return Scaffold(
        backgroundColor: AppColors.mint,
        appBar: appBarBack(
            context,
            Translations.of(context).trans('pray_notice_setting_title'),
            null,
            null),
        body: SingleChildScrollView(
            child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _label,
                  Row(children: [_prayingTime, _prayingTimeOption]),
                  _alramSetLabel,
                  _radioYes,
                  _qtTimeBox,
                  _radioNo
                ]),
          ),
          onTap: () => {FocusScope.of(context).unfocus()},
        )));
  }
}
