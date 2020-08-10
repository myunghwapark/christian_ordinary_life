import 'dart:convert';
import 'package:christian_ordinary_life/src/component/searchBox.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryDetail.dart';
import 'package:http/http.dart' as http;

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/Diary.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryWrite.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';

class ThankDiary extends StatefulWidget {
  static const routeName = '/thankDiary';

  final User loginUser;
  ThankDiary(this.loginUser);

  @override
  ThankDiaryState createState() => ThankDiaryState();
}

class ThankDiaryState extends State<ThankDiary> {
  var diaryList = new List<Diary>();
  Diary diary = new Diary();
  TextEditingController searchController = TextEditingController();
  String keyWord = '';
  FocusNode _searchFieldNode = FocusNode();
  int startPageNum = 0;

  Future<void> getThankDiaryList(BuildContext context) async {
    final response = await http
        .post(API.thanksDiaryList,
            headers: <String, String>{
              'Content-Type': "application/json; charset=UTF-8"
            },
            body: jsonEncode({
              'userSeqNo': widget.loginUser.seqNo,
              'searchKeyword': keyWord,
              'startPageNum': startPageNum
            }))
        .catchError((e) {
      print(e.error);
    });

    try {
      // Success
      if (response.statusCode == 200) {
        diary = Diary.fromJson(json.decode(response.body));

        setState(() {
          diaryList =
              diary.diaryList.map((model) => Diary.fromJson(model)).toList();
        });
      }
    } on Exception catch (exception) {
      showAlertDialog(
          context,
          (Translations.of(context).trans('error_message') +
              '\n' +
              exception.toString()));
    } catch (error) {
      showAlertDialog(
          context,
          (Translations.of(context).trans('error_message') +
              '\n' +
              error.toString()));
    }
  }

  Future<void> _goThankDiaryWrite() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ThankDiaryWrite(
                  loginUser: widget.loginUser,
                ))).then((value) {
      setState(() {
        getThankDiaryList(context);
      });
    });
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('write')),
      onPressed: _goThankDiaryWrite,
      textColor: AppColors.darkGray,
    );
  }

  @override
  Widget build(BuildContext context) {
    GestureTapCallback _onSubmitted = () {
      setState(() {
        keyWord = searchController.text;
        getThankDiaryList(context);
      });
    };

    final _diaryList = ListView.separated(
        itemCount: diaryList.length,
        separatorBuilder: (context, index) {
          if (index == 0) return SizedBox.shrink();
          return const Divider();
        },
        itemBuilder: (context, index) {
          Diary curDiary = diaryList[index];
          return Dismissible(
            key: UniqueKey(),
            child: GestureDetector(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            curDiary.title,
                            style:
                                TextStyle(color: AppColors.black, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                      Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            getDate(DateTime.parse(curDiary.diaryDate)),
                            style: TextStyle(color: AppColors.pastelPink),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                      Text(
                        curDiary.content,
                        style: TextStyle(color: AppColors.darkGray),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    ],
                  )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ThankDiaryDetail(
                          diary: curDiary, loginUser: widget.loginUser)),
                ).then((value) {
                  setState(() {
                    getThankDiaryList(context);
                  });
                });
              },
            ),
          );
        });

    return Scaffold(
        backgroundColor: AppColors.lightPinks,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_thank_diary'),
            actionWidget: actionIcon()),
        drawer: AppDrawer(),
        body: Column(children: <Widget>[
          searchBox(context, AppColors.pastelPink, _searchFieldNode,
              searchController, _onSubmitted),
          Expanded(
            child: _diaryList,
          )
        ]));
  }

  @override
  initState() {
    super.initState();
    getThankDiaryList(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
