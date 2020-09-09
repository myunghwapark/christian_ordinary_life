import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/model/TodayBible.dart';
import 'package:christian_ordinary_life/src/screens/readingBible/readingBibleComplete.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/Book.dart';
import 'package:christian_ordinary_life/src/model/Chapter.dart';
import 'package:christian_ordinary_life/src/model/GoalProgress.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';

class ReadingBible extends StatefulWidget {
  static const routeName = '/readingBible';
  final TodayBible todayBible;

  ReadingBible(this.todayBible);

  @override
  ReadingBibleState createState() => ReadingBibleState();
}

class ReadingBibleState extends State<ReadingBible> {
  ScrollController _scrollController;
  TodayBible todayBible = new TodayBible();
  AppButtons appButtons = new AppButtons();
  GoalInfo goalInfo = new GoalInfo();
  GoalProgress goalProgress = new GoalProgress();

  // 성경별, 장별로 구분하기 위해 두개의 배열이 필요
  List<Chapter> todaysBible = new List<Chapter>(); // 계획 ex) gen 1-3
  List<Chapter> todaysBibleChapters =
      new List<Chapter>(); // 계획 상세 ex) gen 1, gen 2, gen 3
  List<Chapter> chapterDropDown = new List<Chapter>();

  List<Book> bookToRead = new List<Book>(); // 성경 1장 분량
  String _dropDownValue;
  String _dropDownSelectedTitle;
  GlobalKey _keyTodaysBible = GlobalKey();
  bool _first = true;

  void _moveContent() {
    if (_first) {
      Size size = getSizes(_keyTodaysBible);
      _scrollTo(size.height);
      _first = false;
    }
  }

  void _scrollTo(double moveHeight) {
    double maxScroll = _scrollController.position.maxScrollExtent;

    if (moveHeight > maxScroll) {
      moveHeight = maxScroll;
    }

    _scrollController.animateTo(moveHeight,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      //reach the bottom

    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      // reach the top
    }
  }

  void _setChapterReadYn(Chapter chapter, int count) {
    if (goalProgress.bibleProgressNo >= count)
      chapter.read = 'y';
    else if ((goalProgress.bibleProgressNo + 1) == count)
      chapter.read = 'o'; // ongoing
    else
      chapter.read = 'n';
    todaysBibleChapters.add(chapter);
    if (chapter.read == 'o' || chapter.read == 'n')
      chapterDropDown.add(chapter);
  }

  Future<void> getTodaysBible() async {
    try {
      if (todayBible.result == 'success') {
        List<dynamic> tempList;
        goalProgress.bibleDays = todayBible.days;
        tempList = json
            .decode(todayBible.chapter)
            .map((model) => Chapter.fromJson(model))
            .toList();

        setState(() {
          todaysBible = new List<Chapter>();
          goalProgress.bibleProgressNo = int.parse(todayBible.bibleProgress);
          goalProgress.bibleProgress = todayBible.bibleProgress;
          for (int i = 0; i < tempList.length; i++) {
            todaysBible.add(tempList[i]);
          }
          todaysBibleChapters = new List<Chapter>();
          chapterDropDown = new List<Chapter>();

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
                chapterObj.no = count;
                chapterObj.book = todaysBible[i].book;
                chapterObj.volume = j.toString();
                _setChapterReadYn(chapterObj, count);
              }
            } else {
              count++;
              Chapter chapterObj = new Chapter();
              chapterObj.no = count;
              chapterObj.book = todaysBible[i].book;
              chapterObj.volume = todaysBible[i].volume;

              _setChapterReadYn(chapterObj, count);
            }
          }
        });

        getBible();
      }
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
        'book': todaysBibleChapters[goalProgress.bibleProgressNo].book,
        'chapter': todaysBibleChapters[goalProgress.bibleProgressNo].volume
      }).then((response) {
        setState(() {
          Book book = Book.fromJson(json.decode(response));

          List<Book> tempList;
          bookToRead = new List<Book>();
          tempList = book.list.map((model) => Book.fromJson(model)).toList();
          for (int i = 0; i < tempList.length; i++) {
            bookToRead.add(tempList[i]);
          }
        });
        setState(() {
          _scrollTo(0.0);
        });
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
  }

  Future<String> setBibleProgress() async {
    GoalProgress result = new GoalProgress();

    try {
      await API.transaction(context, API.setBibleProgress, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'goalDate': getToday(),
        'readingBible': goalProgress.readingBible,
        'bibleProgress': goalProgress.bibleProgress,
        'bibleProgressDone': goalProgress.bibleProgressDone,
        'bibleDays': goalProgress.bibleDays,
        'lastDay': todayBible.lastDay,
        'userBiblePlanSeqNo': GoalInfo.goal.userBiblePlanSeqNo
      }).then((response) {
        result = GoalProgress.fromJson(json.decode(response));
        if (result.result == 'success') {
          if (goalProgress.bibleProgressDone == 'y' &&
              todayBible.lastDay == goalProgress.bibleDays) {
            _goReadingBibleComplete();
          } else if (goalProgress.bibleProgressDone == 'y') {
            Navigator.pushReplacementNamed(context, '/');
          } else {
            goalInfo.getTodaysBible(context).then((value) {
              todayBible = value;
              getTodaysBible().then((value) => getBible());
            });
          }
        } else {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
    return result.result;
  }

  Future<void> _goReadingBibleComplete() async {
    await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ReadingBibleComplete()))
        .then((value) {});
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
            Translations.of(context)
                .trans('day_order', param1: goalProgress.bibleDays),
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

    _todaysChapters() {
      return GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: todaysBibleChapters.map((Chapter chapter) {
          Widget iconType;
          Color borderColor;
          Color textColor;
          if (chapter.read == 'y') {
            iconType = Icon(
              FontAwesomeIcons.check,
              color: Colors.lightGreen,
              size: 17.0,
            );
            borderColor = Colors.lightGreen;
            textColor = Colors.lightGreen[700];
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
            hint: (_dropDownValue == null ||
                    int.parse(_dropDownValue) == todaysBibleChapters.length)
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
            items: chapterDropDown.map(
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
                  goalProgress.bibleProgress = val;
                  goalProgress.bibleProgressNo = int.parse(val);
                  if (goalProgress.bibleProgressNo ==
                      todaysBibleChapters.length) {
                    goalProgress.readingBible = 'y';
                    goalProgress.bibleProgressDone = 'y';
                  }

                  setBibleProgress().then((value) {
                    _dropDownValue = null;
                  });
                },
              );
            },
          ));
    }

    Widget _todaysBible() {
      return SliverList(
          key: _keyTodaysBible,
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todaysBible.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _chapterTitle(todaysBible[index].book),
                            _todaysChapters(),
                          ],
                        );
                      }),
                  _dropdownButton()
                ],
              ),
            );
          }, childCount: 1));
    }

    final _bibleTitle = SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      String _title = '';
      String _chapter = '';
      if (todaysBibleChapters.length != 0 &&
          goalProgress.bibleProgressNo != todaysBibleChapters.length) {
        if (todaysBibleChapters[goalProgress.bibleProgressNo].book == 'ps')
          _chapter = Translations.of(context).trans('chapter_ps');
        else
          _chapter = Translations.of(context).trans('chapter');

        _title = Translations.of(context)
                .trans(todaysBibleChapters[goalProgress.bibleProgressNo].book) +
            ' ' +
            todaysBibleChapters[goalProgress.bibleProgressNo].volume +
            _chapter;
      }

      return Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 15),
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                _title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                Translations.of(context).trans('bible_version'),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          decoration: BoxDecoration(color: Colors.grey[300]));
    }, childCount: 1));

    final _bible = SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return bookToRead.length > 0
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, bottom: 7),
                    width: 30,
                    child: Text(bookToRead[index].verse),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(right: 15, bottom: 7),
                    child: Text(
                      bookToRead[index].content,
                    ),
                  ))
                ],
              )
            : null;
      }, childCount: bookToRead.length),
    );

    final _buttons = SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          goalProgress.bibleProgressNo != 0
              ? Container(
                  height: 40,
                  width: 100,
                  margin: EdgeInsets.all(10),
                  child: appButtons.filledGreyButton(
                      Translations.of(context).trans('prev'), () {}))
              : Container(),
          Container(
              height: 40,
              width: 200,
              margin: EdgeInsets.all(10),
              child: goalProgress.bibleProgressNo != null
                  ? appButtons.filledOrangeButton(
                      todaysBibleChapters.length ==
                              (goalProgress.bibleProgressNo + 1)
                          ? Translations.of(context).trans('complete_bible',
                              param1: goalProgress.bibleDays)
                          : Translations.of(context).trans('next'), () {
                      goalProgress.bibleProgressNo++;
                      goalProgress.bibleProgress =
                          goalProgress.bibleProgressNo.toString();

                      if (goalProgress.bibleProgressNo ==
                          todaysBibleChapters.length) {
                        goalProgress.readingBible = 'y';
                        goalProgress.bibleProgressDone = 'y';
                      }
                      setBibleProgress();
                    })
                  : Container()),
        ],
      );
    }, childCount: 1));

    final _floatingButton = Container(
      height: 50.0,
      width: 50.0,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            double moveHeight = _scrollController.offset +
                (MediaQuery.of(context).copyWith().size.height - 100);
            _scrollTo(moveHeight);
          },
          child: Icon(FontAwesomeIcons.arrowDown),
          backgroundColor: Colors.orange[300],
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            sliverAppBar(
                context, Translations.of(context).trans('menu_reading_bible')),
            _todaysBible(),
            _bibleTitle,
            _bible,
            _buttons
          ],
        ),
        floatingActionButton: _floatingButton);
  }

  @override
  void initState() {
    _scrollController = new ScrollController();
    _scrollController.addListener(_scrollListener);
    todayBible = widget.todayBible;

    getTodaysBible();
    super.initState();
  }
/* 
  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(() {});
    super.dispose();
  } */
}
