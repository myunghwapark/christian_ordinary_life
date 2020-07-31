import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final int timeSelected;
  final String pickerType;
  const CustomPicker({Key key, this.timeSelected, this.pickerType})
      : super(key: key);

  @override
  CustomPickerState createState() => CustomPickerState();
}

class CustomPickerState extends State<CustomPicker> {
  @override
  Widget build(BuildContext context) {
    int _timeSelected = widget.timeSelected != null ? widget.timeSelected : 0;
    var customOption;

    final _timeType = <Widget>[
      Text(
        Translations.of(context).trans('hours'),
        style: TextStyle(color: AppColors.darkGray, fontSize: 20),
      ),
      Text(
        Translations.of(context).trans('minutes'),
        style: TextStyle(color: AppColors.darkGray, fontSize: 20),
      ),
    ];

    if (widget.pickerType == 'time') {
      customOption = _timeType;
    } else {
      customOption = _timeType;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            Translations.of(context).trans('setting'),
            textAlign: TextAlign.justify,
          ),
          backgroundColor: Colors.teal,
          actions: <Widget>[
            FlatButton(
              child: Text(
                Translations.of(context).trans('done'),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                Navigator.pop(context, _timeSelected);
              },
            )
          ],
        ),
        body: Container(
            child: CupertinoPicker(
          scrollController:
              FixedExtentScrollController(initialItem: _timeSelected),
          magnification: 1,
          onSelectedItemChanged: (int value) {
            _timeSelected = value;
          },
          itemExtent: 35,
          looping: false,
          children: customOption,
        )));
  }
}
