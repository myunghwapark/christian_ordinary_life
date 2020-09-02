import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/BiblePlanDetail.dart';
import 'package:christian_ordinary_life/src/model/Book.dart';
import 'package:christian_ordinary_life/src/model/Chapter.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReadingBible extends StatefulWidget {
  static const routeName = '/readingBible';

  @override
  ReadingBibleState createState() => ReadingBibleState();
}

class ReadingBibleState extends State<ReadingBible> {
  ScrollController _scrollController = new ScrollController();
  BiblePlanDetail biblePlanDetail = new BiblePlanDetail();

  // 성경별, 장별로 구분하기 위해 두개의 배열이 필요
  List<Chapter> todaysBible = new List<Chapter>();
  List<Chapter> todaysBibleChapters = new List<Chapter>();

  List<Book> bookToRead = new List<Book>();
  String bibleDays = '';
  int bibleProress = 0;
  String _dropDownValue;
  String _dropDownSelectedTitle;

  void _setChapterReadYn(Chapter chapter, int count) {
    if (bibleProress >= count)
      chapter.read = 'y';
    else if ((bibleProress + 1) == count)
      chapter.read = 'o'; // ongoing
    else
      chapter.read = 'n';
    todaysBibleChapters.add(chapter);
  }

  Future<void> getTodaysBible() async {
    try {
      await API.transaction(context, API.todayBible, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'goalDate': getToday()
      }).then((response) {
        print('response: $response');
        setState(() {
          List<dynamic> tempList;
          biblePlanDetail = BiblePlanDetail.fromJson(json.decode(response));
          bibleDays = biblePlanDetail.days;
          tempList = json
              .decode(biblePlanDetail.chapter)
              .map((model) => Chapter.fromJson(model))
              .toList();

          bibleProress = int.parse(biblePlanDetail.bibleProgress);
          for (int i = 0; i < tempList.length; i++) {
            todaysBible.add(tempList[i]);
          }
          int count = 0;
          for (int i = 0; i < todaysBible.length; i++) {
            List<String> volumeList;
            if (todaysBible[i].volume.indexOf('-') != -1) {
              volumeList = todaysBible[i].volume.split('-');
              int startNum = int.parse(volumeList[0]);
              int endNum = int.parse(volumeList[1]);

              for (int j = startNum; j <= endNum; j++) {
                count++;
                Chapter chapterObj = new Chapter();
                chapterObj.no = (count - 1);
                chapterObj.book = todaysBible[i].book;
                chapterObj.volume = j.toString();
                _setChapterReadYn(chapterObj, count);
              }
            } else {
              count++;
              Chapter chapterObj = new Chapter();
              chapterObj.no = (count - 1);
              chapterObj.book = todaysBible[i].book;
              chapterObj.volume = todaysBible[i].volume;

              _setChapterReadYn(chapterObj, count);
            }
          }
        });
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
  }

  Future<void> getBible() async {
    try {
      await API.transaction(context, API.getBible, param: {
        'language': UserInfo.language,
        'book': todaysBibleChapters[bibleProress].book,
        'chapter': todaysBibleChapters[bibleProress].volume
      }).then((response) {
        //print('response: $response');
        setState(() {
          Book book = Book.fromJson(json.decode(response));

          List<Book> tempList;
          tempList = book.list.map((model) => Book.fromJson(model)).toList();
          for (int i = 0; i < tempList.length; i++) {
            bookToRead.add(tempList[i]);
          }
        });
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _days = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              border: Border.all(color: AppColors.orange)),
          child: Text(
            Translations.of(context).trans('day_order', param1: bibleDays),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );

    _chapterTitle(String bible) {
      return Container(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            Translations.of(context).trans(bible),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkGray),
          ));
    }

    _todaysChapters(String chapters) {
      return GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 2,
        shrinkWrap: true,
        children: todaysBibleChapters.map((Chapter chapter) {
          Widget iconType;
          Color borderColor;
          Color textColor;
          if (chapter.read == 'y') {
            iconType = Icon(
              FontAwesomeIcons.check,
              color: AppColors.yellowishGreenDarker,
              size: 17.0,
            );
            borderColor = AppColors.yellowishGreenDarker;
            textColor = AppColors.yellowishGreenDarker;
          } else if (chapter.read == 'o') {
            iconType = Icon(
              FontAwesomeIcons.arrowRight,
              color: Colors.orange,
              size: 17.0,
            );
            borderColor = Colors.orange;
            textColor = Colors.orange[700];
          } else {
            iconType = Icon(
              FontAwesomeIcons.check,
              color: Colors.grey[400],
              size: 17.0,
            );
            borderColor = Colors.grey[400];
            textColor = Colors.grey[600];
          }

          return Center(
            child: InkWell(
                child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Row(children: [
                      Container(
                          width: 26,
                          padding: EdgeInsets.only(right: 5),
                          child: iconType),
                      Text(
                        chapter.volume +
                            Translations.of(context).trans('chapter'),
                        style: TextStyle(color: textColor),
                      ),
                    ]))),
          );
        }).toList(),
      );
    }

    String _setDropdownval(Chapter selectedChapter) {
      String book = Translations.of(context).trans(selectedChapter.book);
      String volume =
          '${selectedChapter.volume} ${Translations.of(context).trans(selectedChapter.book == 'ps' ? 'chapter_ps' : 'chapter')}';

      _dropDownSelectedTitle = Translations.of(context)
          .trans('read_up_to', param1: book, param2: volume);
      return _dropDownSelectedTitle;
    }

    Widget _dropdownButton() {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: Colors.grey, style: BorderStyle.solid, width: 0.80),
          ),
          child: DropdownButton(
            hint: _dropDownValue == null
                ? Text(Translations.of(context).trans('manual_read_check'))
                : Text(
                    _setDropdownval(
                        todaysBibleChapters[int.parse(_dropDownValue)]),
                    style: TextStyle(color: AppColors.darkGray),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(color: AppColors.darkGray),
            underline: SizedBox.shrink(),
            items: todaysBibleChapters.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val.no.toString(),
                  child: Text(_setDropdownval(val)),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                () {
                  _dropDownValue = val;
                  // TODO reading update
                },
              );
            },
          ));
    }

    final _todaysBible = Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: AppColors.orange)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _days,
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: todaysBible.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _chapterTitle(todaysBible[index].book),
                    _todaysChapters(todaysBible[index].volume),
                  ],
                );
              }),
          _dropdownButton()
        ],
      ),
    );

    final _bibleTitle = Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Text(
        todaysBibleChapters.length != 0
            ? Translations.of(context)
                .trans(todaysBibleChapters[bibleProress].book)
            : '',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        ),
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(color: Colors.grey[300]),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        body: new NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: new Text(
                  Translations.of(context).trans('menu_reading_bible'),
                  style: TextStyle(
                      color: AppColors.darkGray, fontWeight: FontWeight.bold),
                ),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                backgroundColor: Colors.white,
                iconTheme: new IconThemeData(
                  color: AppColors.lightGray,
                ),
              ),
            ];
          },
          body: Column(
            children: [
              _todaysBible,
              _bibleTitle,
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 50.0,
          width: 50.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {},
              child: Icon(FontAwesomeIcons.arrowDown),
              backgroundColor: Colors.orange[300],
            ),
          ),
        ));
  }

  @override
  void initState() {
    getTodaysBible().then((value) => getBible());
    super.initState();
  }
}
