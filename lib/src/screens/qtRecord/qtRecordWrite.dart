import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/component/calendar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QtRecordWrite extends StatefulWidget {
  @override
  QtRecordWriteStatus createState() => QtRecordWriteStatus();
}

class QtRecordWriteStatus extends State<QtRecordWrite> {
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _contentController = new TextEditingController();
  String qtDate = '';

  void _save() {
    print('${_titleController.text}, ${_contentController.text}');
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('save')),
      onPressed: _save,
      textColor: AppColors.greenPoint,
    );
  }

  @override
  void initState() {
    qtDate = getTodayDate(context);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(context,
            Translations.of(context).trans('menu_qt_record'), actionIcon()),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      padding: EdgeInsets.only(right: 5),
                      child: IconButton(
                        icon: Icon(Icons.calendar_today),
                        color: AppColors.marine,
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext builder) {
                                return Calendar();
                              });
                        },
                      )),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      qtDate,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 5),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.trash),
                        color: AppColors.lightGray,
                        onPressed: () {},
                      )),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12),
                height: 90,
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: Translations.of(context).trans('title_hint'),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.marine, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      )),
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  maxLength: 80,
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: Translations.of(context).trans('qt_hint'),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          )),
                      controller: _contentController,
                      maxLength: 1000,
                    ),
                  ))
            ],
          ),
        ));
  }
}
