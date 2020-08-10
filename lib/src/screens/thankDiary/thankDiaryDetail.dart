import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/Diary.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryWrite.dart';
import 'package:flutter/material.dart';

class ThankDiaryDetail extends StatefulWidget {
  final Diary diary;
  final User loginUser;
  ThankDiaryDetail({this.diary, this.loginUser});

  @override
  ThankDiaryDetailState createState() => ThankDiaryDetailState();
}

class ThankDiaryDetailState extends State<ThankDiaryDetail> {
  Diary updatedDiray = new Diary();
  Future<void> _goQtRecordWrite() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ThankDiaryWrite(
                  diary: widget.diary,
                  loginUser: widget.loginUser,
                ))).then((value) {
      if (value == 'delete') {
        Navigator.pop(context);
      } else {
        setState(() {
          updatedDiray = value;
        });
      }
    });
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('edit')),
      onPressed: _goQtRecordWrite,
      textColor: AppColors.darkGray,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _qtDate = Text(
      getDateOfWeek(DateTime.parse(updatedDiray.diaryDate)),
      style: TextStyle(color: AppColors.darkGray),
    );

    final _qtTitle = Text(
      updatedDiray.title,
      style: TextStyle(color: AppColors.black, fontSize: 18),
    );

    final _qtContent = Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        constraints: BoxConstraints(minHeight: 100),
        child: Text(updatedDiray.content));

    return Scaffold(
        backgroundColor: AppColors.lightPinks,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_thank_diary'),
            actionWidget: actionIcon()),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _qtDate,
                _qtTitle,
                Divider(
                  color: AppColors.pastelPink,
                ),
                _qtContent
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    updatedDiray = widget.diary;
    super.initState();
  }
}
