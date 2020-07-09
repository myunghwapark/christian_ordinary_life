import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import '../common/translations.dart';
import '../component/appBarComponent.dart';

class GoalSettingDetail extends StatefulWidget {
  @override
  GoalSettingDetailState createState() => GoalSettingDetailState();
}

class GoalSettingDetailState extends State<GoalSettingDetail> {

  int _selected = 0;
  bool visibleVar = true;
  String _setHour = '06', _setMinute = '00';
  
  

  DateTime _setInitTime() {
    DateTime _dateTime = new DateTime(2020, 07, 16, int.parse(_setHour),  int.parse(_setMinute));
    return _dateTime;
  }

  void _onRadioChanged(int value) {
    setState((){
      _selected = value;
      if(value == 0) {
        visibleVar = true;
      }
      else {
        visibleVar = false;
      }
    });

    print('Value = $value');
  }

  void _onTimepickerChanged(List timeArray) {
    setState(() {
      int hour = timeArray[0], minute = timeArray[1];

      if(hour < 10) {
        _setHour = '0'+hour.toString();
      }
      else {
        _setHour = hour.toString();
      }

      if(minute < 10) {
        _setMinute = '0'+minute.toString();
      }
      else {
        _setMinute = minute.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, Translations.of(context).trans('qt_notice_setting_title'), null, null),
      body: Container(
        color: AppColors.blueSky,
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top:10, bottom:10),
              child: Text(
                Translations.of(context).trans('qt_notice_setting_ment'),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: '12LotteMartHappy',
                  fontWeight: FontWeight.w300,
                ),
              )
            ),
            Row(
              children: [
                Radio(
                  value: 0, 
                  groupValue: _selected, 
                  onChanged: (int value){
                    _onRadioChanged(value);
                  }
                ),
                Text(Translations.of(context).trans('yes'))
              ],
            ),
            // QT Time Box
            Visibility(
              visible: visibleVar,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 10, left:20, right:20, bottom: 10),
                  margin: EdgeInsets.only(top:5, left:10, right:10, bottom:20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        Translations.of(context).trans('qt_time'),
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.greenPoint
                        ),
                      ),
                      Spacer(flex: 1,),
                      Container(
                        width: 50,
                        height: 40,
                        //padding: EdgeInsets.only(top:10, left:15),
                        child: Center(
                          child: Text(
                            _setHour, 
                            style:TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: AppColors.blueSky,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child:Text(':', style:TextStyle(
                          color: AppColors.marine))
                      ),
                      Container(
                        width: 50,
                        height: 40,
                        child: Center(
                          child:Text(
                            _setMinute, style:TextStyle(
                            color: Colors.white)
                          )
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: AppColors.blueSky,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                  ),
                ),
                onTap: () => {
                  // Time picker
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext builder) {
                      return Container(
                          height: MediaQuery.of(context).copyWith().size.height / 2.5,
                          child: TimePickerWidget(
                            initDateTime: _setInitTime(),
                            dateFormat: 'HH:mm',
                            onConfirm: (time, timeArray) => {
                              _onTimepickerChanged(timeArray)
                            }
                          )
                        );
                    })
                },
              )
            ),
            // No text
            Row(
              children: [
                Radio(
                  value: 1, 
                  groupValue: _selected, 
                  onChanged: (int value){
                    _onRadioChanged(value);
                  }
                ),
                Text(Translations.of(context).trans('no'))
              ],
            )
          ]
        
        ),
      ),
    );
  }
}