import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/calendar.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/Diary.dart';

class ThankDiaryWrite extends StatefulWidget {
  final Diary diary;
  final User loginUser;
  ThankDiaryWrite({this.diary, this.loginUser});

  @override
  ThankDiaryWriteState createState() => ThankDiaryWriteState();
}

class ThankDiaryWriteState extends State<ThankDiaryWrite> {
  Diary newDiary = new Diary();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _contentController = new TextEditingController();
  ScrollController _scroll;
  FocusNode _focus = new FocusNode();

  String diaryDateForm = '';
  DateTime diaryDate = new DateTime.now();
  bool _trashVisibility = false;
  final _formKey = GlobalKey<FormState>();

  void writeDiary(BuildContext context) async {
    try {
      await API.transaction(context, API.thanksDiaryWrite, param: {
        'userSeqNo': widget.loginUser.seqNo,
        'thankDiarySeqNo': newDiary.seqNo,
        'title': newDiary.title,
        'diaryDate': newDiary.diaryDate,
        'content': newDiary.content
      }).then((response) {
        Diary writeResult = Diary.fromJson(json.decode(response));
        if (writeResult.result == 'success') {
          Navigator.pop(context, newDiary);
        } else {
          showAlertDialog(
              context,
              (Translations.of(context).trans('error_message') +
                  '\n' +
                  newDiary.errorMessage));
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

  void _delete(BuildContext context) async {
    try {
      final confirmResult = await showConfirmDialog(
          context, Translations.of(context).trans('delete_confirm'));

      if (confirmResult == 'ok') {
        await API.transaction(context, API.thanksDiaryDelete,
            param: {'thankDiarySeqNo': widget.diary.seqNo}).then((response) {
          Diary deleteResult = Diary.fromJson(json.decode(response));
          if (deleteResult.result == 'success') {
            Navigator.pop(context, 'delete');
          } else {
            showAlertDialog(
                context,
                (Translations.of(context).trans('error_message') +
                    '\n' +
                    newDiary.errorMessage));
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
          newDiary = new Diary(
              seqNo: widget.diary != null ? widget.diary.seqNo : null,
              title: _titleController.text,
              content: _contentController.text,
              diaryDate: diaryDate.toString());

          writeDiary(context);
        }
      },
      textColor: AppColors.darkGray,
    );
  }

  void _setDiary() {
    _titleController.text = widget.diary.title;
    _contentController.text = widget.diary.content;
    diaryDate = DateTime.parse(widget.diary.diaryDate);
  }

  void _setDate(DateTime selectedDate) {
    setState(() {
      diaryDate = selectedDate;
      diaryDateForm = getDateOfWeek(diaryDate);
    });
  }

  void _showCalendar() async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Calendar(diaryDate);
        });

    if (result != null) _setDate(result);
  }

  @override
  void initState() {
    if (widget.diary != null) {
      _setDiary();
      _trashVisibility = true;
    } else {
      _trashVisibility = false;
    }
    diaryDateForm = getDateOfWeek(diaryDate);

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _calendarButton = Container(
        padding: EdgeInsets.only(right: 5),
        child: IconButton(
          icon: Icon(Icons.calendar_today),
          color: AppColors.pastelPink,
          onPressed: _showCalendar,
        ));

    final _diaryDate = Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        child: Text(
          diaryDateForm,
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
                onPressed: () => _delete(context))));

    final _diaryTitle = Container(
      padding: EdgeInsets.all(12),
      height: 90,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[400], width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            hintText: Translations.of(context).trans('title_hint'),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.pastelPink, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            )),
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

    final _diaryContent = Container(
        padding: EdgeInsets.all(12),
        child: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          keyboardType: TextInputType.multiline,
          minLines: 10,
          maxLines: 100,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue[400], width: 2),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              hintText: Translations.of(context).trans('qt_hint'),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              )),
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
        backgroundColor: AppColors.lightPinks,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_thank_diary'),
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
                        _diaryDate,
                        _deleteButton,
                      ],
                    ),
                    _diaryTitle,
                    _diaryContent,
                    Padding(
                      padding: EdgeInsets.all(130),
                    )
                  ],
                ))));
  }
}
