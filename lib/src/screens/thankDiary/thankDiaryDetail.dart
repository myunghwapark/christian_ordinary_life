import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
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
  Diary detailDiary = new Diary();

  Future<void> getThankDiary() async {
    try {
      await API.transaction(context, API.thanksDiaryDetail, param: {
        'thankDiarySeqNo': widget.diary.seqNo,
        'diaryDate': widget.diary.diaryDate
      }).then((response) {
        Diary diary = Diary.fromJson(json.decode(response));
        List<Diary> tempList;
        tempList = diary.detail.map((model) => Diary.fromJson(model)).toList();
        setState(() {
          detailDiary = tempList[0];
        });
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
      return null;
    } catch (error) {
      errorMessage(context, error);
      return null;
    }
  }

  Future<void> _goQtRecordWrite() async {
    await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ThankDiaryWrite(diary: widget.diary)))
        .then((value) {
      if (value == 'delete') {
        Navigator.pop(context);
      } else {
        setState(() {
          detailDiary = value;
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
    String imageURL = API.diaryImageURL +
        (detailDiary.imageURL == null ? '' : detailDiary.imageURL);
    final _categoryIcon = detailDiary.categoryImageUrl != null
        ? FadeInImage.assetNetwork(
            image: API.systemImageURL + detailDiary.categoryImageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.fill,
            placeholder: wrongImage())
        : Container();

    final _qtDate = detailDiary.diaryDate != null
        ? Text(
            getDateOfWeek(DateTime.parse(detailDiary.diaryDate)),
            style: TextStyle(color: AppColors.darkGray),
          )
        : Container();

    final _qtTitle = detailDiary.title != null
        ? Text(
            detailDiary.title,
            style: TextStyle(color: AppColors.black, fontSize: 18),
          )
        : Container();

    final _image = Visibility(
        visible: detailDiary.imageURL == null || detailDiary.imageURL == ''
            ? false
            : true,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage.assetNetwork(
                fit: BoxFit.fill, placeholder: wrongImage(), image: imageURL)));

    final _qtContent = detailDiary.content != null
        ? Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            constraints: BoxConstraints(minHeight: 100),
            child: Text(detailDiary.content))
        : Container();

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
                Row(
                  children: [
                    _categoryIcon,
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _qtDate,
                        _qtTitle,
                      ],
                    )
                  ],
                ),
                Divider(
                  color: AppColors.pastelPink,
                ),
                _image,
                _qtContent
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    getThankDiary();
    super.initState();
  }
}
