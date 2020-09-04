import 'package:christian_ordinary_life/src/component/componentStyle.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/component/calendar.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';

class QtRecordWrite extends StatefulWidget {
  final QT qt;
  final User loginUser;
  const QtRecordWrite({this.qt, this.loginUser});

  @override
  QtRecordWriteStatus createState() => QtRecordWriteStatus();
}

class QtRecordWriteStatus extends State<QtRecordWrite> {
  QT newQt = new QT();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _contentController = new TextEditingController();
  final TextEditingController _bibleController = new TextEditingController();

  ScrollController _scroll;
  FocusNode _focus = new FocusNode();
  ComponentStyle componentStyle = new ComponentStyle();

  String qtDateForm = '';
  DateTime qtDate = new DateTime.now();
  bool _trashVisibility = false;
  final _formKey = GlobalKey<FormState>();

  void _writeQT() async {
    try {
      await API.transaction(context, API.qtRecordWrite, param: {
        'userSeqNo': widget.loginUser.seqNo,
        'qtRecordSeqNo': newQt.seqNo,
        'title': newQt.title,
        'qtDate': newQt.qtDate,
        'bible': newQt.bible,
        'content': newQt.content,
        'qtRecord': 'y',
        'goalDate': getToday()
      }).then((response) {
        print('response: $response');
        QT writeResult = QT.fromJson(json.decode(response));
        if (writeResult.result == 'success') {
          Navigator.pop(context, newQt);
        } else {
          errorMessage(context, newQt.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
      return null;
    } catch (error) {
      errorMessage(context, error);
      return null;
    }
  }

  void _delete() async {
    try {
      final confirmResult = await showConfirmDialog(
          context, Translations.of(context).trans('delete_confirm'));

      if (confirmResult == 'ok') {
        await API.transaction(context, API.qtRecordDelete, param: {
          'userSeqNo': widget.loginUser.seqNo,
          'qtRecordSeqNo': widget.qt.seqNo
        }).then((response) {
          QT deleteResult = QT.fromJson(json.decode(response));
          if (deleteResult.result == 'success') {
            Navigator.pop(context, 'delete');
          } else {
            errorMessage(context, newQt.errorMessage);
          }
        });
      }
    } on Exception catch (exception) {
      errorMessage(context, exception);
      return null;
    } catch (error) {
      errorMessage(context, error);
      return null;
    }
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('save')),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          newQt = new QT(
              seqNo: widget.qt != null ? widget.qt.seqNo : null,
              title: _titleController.text,
              content: _contentController.text,
              bible: _bibleController.text,
              qtDate: qtDate.toString());

          _writeQT();
        }
      },
      textColor: AppColors.darkGray,
    );
  }

  _setQtRecord() {
    _titleController.text = widget.qt.title;
    _bibleController.text = widget.qt.bible;
    _contentController.text = widget.qt.content;
    qtDate = DateTime.parse(widget.qt.qtDate);
  }

  void _setDate(DateTime selectedDate) {
    setState(() {
      qtDate = selectedDate;
      qtDateForm = getDateOfWeek(qtDate);
    });
  }

  void _showCalendar() async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Calendar(qtDate);
        });

    if (result != null) _setDate(result);
  }

  @override
  void initState() {
    if (widget.qt != null) {
      _setQtRecord();
      _trashVisibility = true;
    } else {
      _trashVisibility = false;
    }
    qtDateForm = getDateOfWeek(qtDate);

    _scroll = new ScrollController();
    _focus.addListener(() {
      if (_scroll.hasClients) {
        Future.delayed(Duration(milliseconds: 50), () {
          _scroll?.jumpTo(120);
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _bibleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _calendarButton = Container(
        padding: EdgeInsets.only(right: 5),
        child: IconButton(
          icon: Icon(Icons.calendar_today),
          color: AppColors.marine,
          onPressed: _showCalendar,
        ));

    final _qtDate = Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        child: Text(
          qtDateForm,
          style: TextStyle(fontSize: 18),
        ),
        onTap: _showCalendar,
      ),
    );

    final _deleteButton = Visibility(
        visible: _trashVisibility,
        child: Container(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.trash),
              color: AppColors.lightGray,
              onPressed: _delete,
            )));

    final _qtTitle = Container(
      padding: EdgeInsets.all(12),
      height: 90,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        decoration: componentStyle
            .whiteGreyInput(Translations.of(context).trans('title_hint')),
        controller: _titleController,
        keyboardType: TextInputType.text,
        maxLength: 80,
        validator: (value) {
          if (value.isEmpty) {
            return Translations.of(context).trans('validate_title');
          }
          return null;
        },
      ),
    );

    final _qtBible = Container(
      padding: EdgeInsets.all(12),
      height: 90,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        decoration: componentStyle
            .whiteGreyInput(Translations.of(context).trans('qt_bible_hint')),
        controller: _bibleController,
        keyboardType: TextInputType.text,
        maxLength: 30,
      ),
    );

    final _qtContent = Container(
        padding: EdgeInsets.all(12),
        child: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          keyboardType: TextInputType.multiline,
          minLines: 10,
          maxLines: 100,
          decoration: componentStyle
              .whiteGreyInput(Translations.of(context).trans('qt_hint')),
          controller: _contentController,
          maxLength: 1000,
          focusNode: _focus,
          validator: (value) {
            if (value.isEmpty) {
              return Translations.of(context).trans('validate_content');
            }
            return null;
          },
        ));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_qt_record'),
            actionWidget: actionIcon()),
        body: SingleChildScrollView(
            controller: _scroll,
            padding: EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: new Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _calendarButton,
                        _qtDate,
                        _deleteButton,
                      ],
                    ),
                    _qtTitle,
                    _qtBible,
                    _qtContent,
                    Padding(
                      padding: EdgeInsets.all(130),
                    )
                  ],
                ))));
  }
}
