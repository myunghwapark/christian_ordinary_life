import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final int selectedItem;
  final List<Widget> pickerList;
  const CustomPicker({Key key, this.selectedItem, this.pickerList})
      : super(key: key);

  @override
  CustomPickerState createState() => CustomPickerState();
}

class CustomPickerState extends State<CustomPicker> {
  @override
  Widget build(BuildContext context) {
    int _selectedItem = widget.selectedItem != null ? widget.selectedItem : 0;
    List<Widget> pickerList = widget.pickerList;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            Translations.of(context).trans('setting'),
            textAlign: TextAlign.justify,
          ),
          backgroundColor: Colors.grey,
          actions: <Widget>[
            TextButton(
              child: Text(
                Translations.of(context).trans('done'),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                Navigator.pop(context, _selectedItem);
              },
            )
          ],
        ),
        body: Container(
            child: CupertinoPicker(
          scrollController:
              FixedExtentScrollController(initialItem: _selectedItem),
          magnification: 1,
          onSelectedItemChanged: (int value) {
            _selectedItem = value;
          },
          itemExtent: 50,
          looping: false,
          children: pickerList,
        )));
  }
}
