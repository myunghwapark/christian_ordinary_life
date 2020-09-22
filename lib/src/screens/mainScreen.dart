import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/model/TodayBible.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordWrite.dart';
import 'package:christian_ordinary_life/src/screens/readingBible/readingBible.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryWrite.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/translations.dart';
import '../common/colors.dart';
import '../common/util.dart';
import 'goalSetting/goalSetting.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  UserInfo userInfo = new UserInfo();
  GoalInfo goalInfo = new GoalInfo();
  BibleUserPlan bibleUserPlan = new BibleUserPlan();
  AppButtons buttons = new AppButtons();
  TodayBible todayBible = new TodayBible();

  String _year = '';
  String _date = '';
  DateTime _currentDateTime;

  var _checkVars = {
    'qt': false,
    'praying': false,
    'reading_bible': false,
    'thank_diary': false,
  };

  Future<void> getSharedPrefs() async {
    await userInfo.getUserInfo().then((value) {
      setState(() {
        UserInfo.loginUser = value;
      });
    });
  }

  Widget _createMainItems({String item}) {
    //print('item: $item');
    //print('_checkVars: ${_checkVars[item]}');
    String text = Translations.of(context).trans('menu_$item');
    return ListTile(
        title: Row(
          children: (<Widget>[
            Container(
                padding: EdgeInsets.only(left: 8.0, bottom: 15),
                child: Icon(
                  _checkVars[item]
                      ? FontAwesomeIcons.checkCircle
                      : FontAwesomeIcons.circle,
                  color:
                      _checkVars[item] ? AppColors.marine : AppColors.lightGray,
                  size: 35,
                )),
            Container(
              padding: EdgeInsets.only(top: 5, left: 14.0, bottom: 15),
              child: Text(
                text,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      _checkVars[item] ? AppColors.marine : AppColors.lightGray,
                  fontSize: 30,
                  fontFamily: '12LotteMartHappy',
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
          ]),
        ),
        onTap: () {
          switch (item) {
            case 'qt':
              if (GoalInfo.goalProgress.qtRecord != 'y') {
                _goQtRecordWrite();
              }
              break;
            case 'praying':
              if (GoalInfo.goalProgress.praying != 'y') {
                GoalInfo.goalProgress.praying = 'y';
                goalInfo.setPrayingProgress(context).then((value) {
                  setState(() {
                    _checkVars[item] = !_checkVars[item];
                  });
                });
              }
              break;
            case 'thank_diary':
              if (GoalInfo.goalProgress.thankDiary != 'y') {
                _goThankDiaryWrite();
              }
              break;
            case 'reading_bible':
              if (GoalInfo.goalProgress.readingBible != 'y') {
                _goReadingBible();
              }
              break;
            default:
          }
        });
  }

  void _refresh() {
    goalInfo.getGoalProgress(context).then((value) {
      setState(() {
        GoalInfo.goalProgress = value;
        _setGoals();
      });
    });
  }

  Future<void> _goQtRecordWrite() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QtRecordWrite(
                  loginUser: UserInfo.loginUser,
                ))).then((value) {
      setState(() {
        _refresh();
      });
    });
  }

  Future<void> _goThankDiaryWrite() async {
    await Navigator.push(
            context, MaterialPageRoute(builder: (context) => ThankDiaryWrite()))
        .then((value) {
      setState(() {
        _refresh();
      });
    });
  }

  Future<void> _goReadingBible() async {
    if (todayBible.result == 'success') {
      await Navigator.push(context,
              MaterialPageRoute(builder: (context) => ReadingBible(todayBible)))
          .then((value) {
        setState(() {
          _refresh();
        });
      });
    } else {
      showConfirmDialog(
              context, Translations.of(context).trans('no_bible_plan_ment'))
          .then((value) {
        if (value == 'ok') {
          goalInfo.goBiblePlan(context);
        } else {
          Navigator.pushReplacementNamed(context, '/');
        }
      });
    }
  }

  Future<void> _getTodaysBible() async {
    await goalInfo.getTodaysBible(context).then((value) {
      setState(() {
        todayBible = value;
      });
    });
  }

  void _setGoals() {
    //print('_setGoals: ${GoalInfo.goalProgress.readingBible}');
    if (GoalInfo.goalProgress.thankDiary == 'y')
      _checkVars['thank_diary'] = true;
    else
      _checkVars['thank_diary'] = false;

    if (GoalInfo.goalProgress.qtRecord == 'y')
      _checkVars['qt'] = true;
    else
      _checkVars['qt'] = false;

    if (GoalInfo.goalProgress.praying == 'y')
      _checkVars['praying'] = true;
    else
      _checkVars['praying'] = false;

    if (GoalInfo.goalProgress.readingBible == 'y')
      _checkVars['reading_bible'] = true;
    else
      _checkVars['reading_bible'] = false;
  }

  Future<void> _goGoalSet() async {
    if (!userInfo.loginCheck()) {
      var result = await showConfirmDialog(
          context, Translations.of(context).trans('login_needs'));

      if (result == 'ok') {
        userInfo.showLogin(context);
      }
    } else {
      Navigator.pushReplacementNamed(context, GoalSetting.routeName,
          arguments: UserInfo.loginUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    /* final _leftArrow = GestureDetector(
      child: Icon(
        Icons.arrow_back_ios,
        color: AppColors.lightGray,
        size: 35,
      ),
      onTap: () {
        setState(() {
          print('left button');
          _currentDateTime = _currentDateTime.add(new Duration(days: -1));
          _year = getYear(_currentDateTime);
          _date = getDate(_currentDateTime);
        });
      },
    ); */

    final _dateForm = Flexible(
      fit: FlexFit.tight,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _year,
              style: TextStyle(
                fontFamily: '12LotteMartHappy',
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            Text(
              _date,
              style: TextStyle(
                fontFamily: '12LotteMartHappy',
                fontSize: 30,
              ),
            ),
          ]),
      flex: 1,
    );

    Widget _goalCheck() {
      if (GoalInfo.goal == null) return Container();
      return Flexible(
        fit: FlexFit.tight,
        child: ListView(
          children: <Widget>[
            GoalInfo.goal.qtRecord ? _createMainItems(item: 'qt') : Container(),
            GoalInfo.goal.praying
                ? _createMainItems(item: 'praying')
                : Container(),
            GoalInfo.goal.readingBible
                ? _createMainItems(item: 'reading_bible')
                : Container(),
            GoalInfo.goal.thankDiary
                ? _createMainItems(item: 'thank_diary')
                : Container(),
          ],
        ),
        flex: 2,
      );
    }

    final _goalSet = Column(
      children: [
        Text(
          Translations.of(context).trans('init_ment'),
          style: TextStyle(
              fontSize: 20,
              fontFamily: '12LotteMartHappy',
              fontWeight: FontWeight.w300,
              height: 2),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 35,
        ),
        buttons.outerlineMintButton(
            Translations.of(context).trans('goal_set_button'), () {
          _goGoalSet();
        })
      ],
    );

    /* final _rightArrow = GestureDetector(
      child: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.lightGray,
        size: 35,
      ),
      onTap: () {
        setState(() {
          print('right button');
          _currentDateTime = _currentDateTime.add(new Duration(days: 1));
          _year = getYear(_currentDateTime);
          _date = getDate(_currentDateTime);
        });
      },
    ); */

    final _scriptualPhrase = Flexible(
      fit: FlexFit.tight,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          //padding: EdgeInsets.all(10),
          child: Text(
            Translations.of(context).pharaseTrans('mark_9_23'),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ]),
      flex: 1,
    );

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //_leftArrow,
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(children: [
            _dateForm,
            (userInfo.loginCheck() &&
                    GoalInfo.goal != null &&
                    GoalInfo.goal.goalSet)
                ? _goalCheck()
                : _goalSet,
            _scriptualPhrase,
          ])),
          //_rightArrow,
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    GoalInfo.goal?.goalSet = false;
    getSharedPrefs()
        .then((value) => goalInfo.getUserGoal(context).then((value) {
              setState(() {
                GoalInfo.goal = value;
              });

              goalInfo.getGoalProgress(context).then((value) {
                setState(() {
                  GoalInfo.goalProgress = value;
                  _setGoals();

                  _getTodaysBible();
                });
              });
            }));
    _currentDateTime = new DateTime.now();
    _year = getYear(_currentDateTime);
    _date = getDate(_currentDateTime);
    super.initState();
  }
}
