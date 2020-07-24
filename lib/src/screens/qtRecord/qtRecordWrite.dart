import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/component/calendar.dart';
import 'package:christian_ordinary_life/src/database/qtRecordBloc.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QtRecordWrite extends StatefulWidget {
  final QT qt;
  const QtRecordWrite(this.qt);

  @override
  QtRecordWriteStatus createState() => QtRecordWriteStatus();
}

class QtRecordWriteStatus extends State<QtRecordWrite> {
  final QtRecordBloc _qtRecordBloc = QtRecordBloc();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _contentController = new TextEditingController();
  final TextEditingController _bibleController = new TextEditingController();
  String qtDateForm = '';
  DateTime qtDate = new DateTime.now();
  bool _trashVisibility = false;
  //DateTime qtDate = new DateTime(2020, 7, 17);

  Future<void> _save() async {
    QT qt = new QT(
        title: _titleController.text,
        bible: _bibleController.text,
        content: _contentController.text,
        date: qtDate.toString());

    if (widget.qt == null) {
      await _qtRecordBloc.addQtRecord(qt).then((result) {
        Navigator.pop(context);
      });
    } else {
      qt.qtRecordId = widget.qt.qtRecordId;
      await _qtRecordBloc.updateQtRecord(qt).then((result) {
        Navigator.pop(context);
      });
    }
  }

  _delete() async {
    final result = await showAlertDialog(
        context, Translations.of(context).trans('delete_confirm'));
    if (result == 'ok') {
      await _qtRecordBloc.deleteQtRecord(widget.qt.qtRecordId).then((result) {
        Navigator.pop(context);
      });
    }
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('save')),
      onPressed: _save,
      textColor: AppColors.greenPoint,
    );
  }

  _setQtRecord() {
    _titleController.text = widget.qt.title;
    _bibleController.text = widget.qt.bible;
    _contentController.text = widget.qt.content;
    qtDate = DateTime.parse(widget.qt.date);
  }

  @override
  void initState() {
    if (widget.qt != null) {
      _setQtRecord();
      _trashVisibility = true;
    } else {
      _trashVisibility = false;
    }
    qtDateForm = getDateofWeek(context, qtDate);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _qtRecordBloc.dispose();
    super.dispose();
  }

  void _setDate(DateTime selectedDate) {
    setState(() {
      qtDate = selectedDate;
      qtDateForm = getDateofWeek(context, qtDate);
    });
  }

  void _showCalendar() async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Calendar(qtDate);
        });

    _setDate(result);
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
                        onPressed: _showCalendar,
                      )),
                  Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      child: Text(
                        qtDateForm,
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: _showCalendar,
                    ),
                  ),
                  Visibility(
                      visible: _trashVisibility,
                      child: Container(
                          padding: EdgeInsets.only(right: 5),
                          child: IconButton(
                            icon: Icon(FontAwesomeIcons.trash),
                            color: AppColors.lightGray,
                            onPressed: _delete,
                          ))),
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
              Container(
                padding: EdgeInsets.all(12),
                height: 90,
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: Translations.of(context).trans('qt_bible_hint'),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.marine, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      )),
                  controller: _bibleController,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
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
