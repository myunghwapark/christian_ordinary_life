import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordList.dart';
import 'package:christian_ordinary_life/src/screens/settings/howToUse.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';
import 'package:christian_ordinary_life/src/model/BiblePhrase.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/model/TodayBible.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordWrite.dart';
import 'package:christian_ordinary_life/src/screens/readingBible/readingBible.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryWrite.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSetting.dart';

import 'thankDiary/thankDiaryList.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  UserInfo userInfo = new UserInfo();
  GoalInfo goalInfo = new GoalInfo();
  BibleUserPlan bibleUserPlan = new BibleUserPlan();
  AppButtons buttons = new AppButtons();
  TodayBible todayBible = new TodayBible();
  BiblePhrase biblePhrase = new BiblePhrase();
  CommonSettings commonSettings = new CommonSettings();
  bool _isLoading = false;
  int _remainDate = 0;
  String _remainPeriod = 'until_target_date';

  String _year = '';
  String _date = '';
  DateTime _currentDateTime;

  var _checkVars = {
    'qt': false,
    'praying': false,
    'reading_bible': false,
    'thank_diary': false,
  };

  Future<void> getUserInfo() async {
    await userInfo.getUserInfo().then((value) {
      setState(() {
        UserInfo.loginUser = value;
      });
    });
  }

  Future<void> _showHowToUse() async {
    await commonSettings.getFirstUser().then((value) {
      if (value == null || value != 'n') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HowToUse()));
        commonSettings.setFirstUser();
      }
    });
  }

  Future<void> _setAlarm() async {
    if (GoalInfo.goal.qtAlarm == true) {
      await setAlarms(context, 'qt', GoalInfo.goal.qtTime);
    }

    if (GoalInfo.goal.prayingAlarm == true) {
      await setAlarms(context, 'praying', GoalInfo.goal.prayingTime);
    }

    if (GoalInfo.goal.thankDiaryAlarm == true) {
      await setAlarms(context, 'thankDiary', GoalInfo.goal.thankDiaryTime);
    }

    if (GoalInfo.goal.readingBibleAlarm == true) {
      await setAlarms(context, 'readingBible', GoalInfo.goal.readingBibleTime);
    }
  }

  Future<void> getBiblePhrase() async {
    try {
      await API.transaction(context, API.biblePhrase,
          param: {'language': CommonSettings.language}).then((response) {
        biblePhrase = BiblePhrase.fromJson(json.decode(response));
        List<BiblePhrase> tempList;
        if (biblePhrase.biblePhrase.length != 0) {
          tempList = biblePhrase.biblePhrase
              .map((model) => BiblePhrase.fromJson(model))
              .toList();
          setState(() {
            biblePhrase = tempList[0];
            String content = '';
            if (tempList.length > 1) {
              for (int i = 0; i < tempList.length; i++) {
                if (i != 0) content += ' ';
                content += tempList[i].content;
              }
              biblePhrase.content = content;
            }
          });
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

  Widget _createMainItems({String item}) {
    String text = Translations.of(context).trans('menu_$item');
    return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: (<Widget>[
                Container(
                    padding: EdgeInsets.only(left: 8.0, bottom: 15),
                    child: Icon(
                      _checkVars[item]
                          ? FontAwesomeIcons.checkCircle
                          : FontAwesomeIcons.circle,
                      color: _checkVars[item]
                          ? AppColors.marine
                          : AppColors.lightGray,
                      size: 35,
                    )),
                Container(
                  padding: EdgeInsets.only(top: 5, left: 14.0, bottom: 15),
                  child: Text(
                    text,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _checkVars[item]
                          ? AppColors.marine
                          : AppColors.lightGray,
                      fontSize: 30,
                      fontFamily: '12LotteMartHappy',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                (CommonSettings.language == 'ko' &&
                        item == 'reading_bible' &&
                        _remainDate > 0)
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red[500],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        margin: EdgeInsets.only(left: 7, bottom: 9),
                        child: Text(
                          Translations.of(context).trans(_remainPeriod,
                              param1: _remainDate.toString()),
                          style: TextStyle(fontSize: 11),
                        ),
                      )
                    : Container()
              ]),
            ),
            (CommonSettings.language == 'en' &&
                    item == 'reading_bible' &&
                    _remainDate > 0)
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red[500],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    margin: EdgeInsets.only(top: 0, left: 55, bottom: 10),
                    child: Text(
                      Translations.of(context)
                          .trans(_remainPeriod, param1: _remainDate.toString()),
                      style: TextStyle(fontSize: 11),
                    ),
                  )
                : Container()
          ],
        ),
        onTap: () {
          switch (item) {
            case 'qt':
              if (GoalInfo.goalProgress.qtRecord != 'y') {
                _goQtRecordWrite();
              } else {
                Navigator.pushNamed(context, QTRecord.routeName);
              }
              break;
            case 'praying':
              if (GoalInfo.goalProgress.praying != 'y') {
                setState(() {
                  _isLoading = true;
                });

                try {
                  GoalInfo.goalProgress.praying = 'y';
                  goalInfo.setPrayingProgress(context).then((value) {
                    setState(() {
                      _isLoading = false;
                      _checkVars[item] = !_checkVars[item];
                    });
                  });
                } on Exception catch (exception) {
                  errorMessage(context, exception);
                } catch (error) {
                  errorMessage(context, error);
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
              break;
            case 'thank_diary':
              if (GoalInfo.goalProgress.thankDiary != 'y') {
                _goThankDiaryWrite();
              } else {
                Navigator.pushNamed(context, ThankDiary.routeName);
              }
              break;
            case 'reading_bible':
              // if (GoalInfo.goalProgress.readingBible != 'y') {
              _goReadingBible();
              // }
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
            context, MaterialPageRoute(builder: (context) => QtRecordWrite()))
        .then((value) {
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
    if (!userInfo.loginCheck()) return null;
    await goalInfo.getTodaysBible(context).then((value) {
      if (this.mounted) {
        setState(() {
          todayBible = value;
          getRemainDate();
        });
      }
    });
  }

  void _setGoals() {
    if (!userInfo.loginCheck()) return;

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

  void getRemainDate() {
    if (todayBible != null && todayBible.planEndDate != null) {
      DateTime planEndDate =
          DateTime.parse('${todayBible.planEndDate} 24:00:00');
      setState(() {
        _remainDate = dateDifferenceInDays(planEndDate);
        if (_remainDate == 1) {
          _remainPeriod = 'until_target_date';
        } else {
          _remainPeriod = 'until_target_dates';
        }
        if (_remainDate == 0) {
          _remainDate = dateDifferenceInHours(planEndDate);
          if (_remainDate == 1) {
            _remainPeriod = 'until_target_hour';
          } else {
            _remainPeriod = 'until_target_hours';
          }
        }
      });
    }
  }

  Future<void> getAlarmSetting() async {
    /*  await commonSettings.getAlarmSetting().then((value) async {
      if (value == null || value == '') { */
    if (CommonSettings.firstOpenToday) {
      if (userInfo.loginCheck() &&
          GoalInfo.goal != null &&
          (GoalInfo.goal.qtAlarm == true ||
              GoalInfo.goal.prayingAlarm == true ||
              GoalInfo.goal.thankDiaryAlarm == true ||
              GoalInfo.goal.readingBibleAlarm == true)) {
        cancelAllNotifications();
        _setAlarm();
        await commonSettings.setAlarmSetting();
        CommonSettings.firstOpenToday = false;
      }
    }
    /*  }
    }); */
  }

  @override
  Widget build(BuildContext context) {
    if (CommonSettings.firstOpenToday) getAlarmSetting();

    final _dateForm = Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
          onTap: init,
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
              ])),
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

    final _scriptualPhrase = Flexible(
      fit: FlexFit.tight,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: (biblePhrase != null && biblePhrase.content != null)
              ? Text(
                  '${biblePhrase.content} [${biblePhrase.bookTitle} ${biblePhrase.chapter}:${biblePhrase.verses}]',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : Container(),
        )
      ]),
      flex: 1,
    );

    return LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        color: Colors.black,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ));
  }

  void init() {
    try {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

      GoalInfo.goal?.goalSet = false;

      _currentDateTime = new DateTime.now();
      _year = getYear(_currentDateTime);
      _date = getDateOfWeek2(_currentDateTime);

      if (this.mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      requestPermissions();
      // alarm function setting
      configureLocalTimeZone();

      getUserInfo().then((value) => goalInfo.getUserGoal(context).then((value) {
            setState(() {
              GoalInfo.goal = value;
            });

            goalInfo.getGoalProgress(context).then((value) {
              setState(() {
                GoalInfo.goalProgress = value;
                _setGoals();

                getBiblePhrase()
                    .then((value) => _getTodaysBible().then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                        }));
              });
            });
          }));

      _showHowToUse();
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
  }

  @override
  void initState() {
    //앱 상태 변경 이벤트 등록
    WidgetsBinding.instance.addObserver(this);
    init();
    super.initState();
  }

  @override
  void dispose() {
    //앱 상태 변경 이벤트 해제
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 앱 상태 변경시 호출
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //https://api.flutter.dev/flutter/dart-ui/AppLifecycleState-class.html
    switch (state) {
      case AppLifecycleState.resumed:
        // 앱이 표시되고 사용자 입력에 응답합니다.
        // 주의! 최초 앱 실행때는 해당 이벤트가 발생하지 않습니다.
        init();
        print("resumed");
        break;
      case AppLifecycleState.inactive:
        // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
        // ios에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
        // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이 집중되면 앱이이 상태로 전환됩니다.
        // inactive가 발생되고 얼마후 pasued가 발생합니다.
        print("inactive");
        break;
      case AppLifecycleState.paused:
        // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
        // 안드로이드의 onPause()와 동일합니다.
        // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을 호출하지 않습니다.
        print("paused");
        break;
      case AppLifecycleState.detached:
        // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
        // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
        // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가 파괴 된 후 일 수 있습니다.
        print("detached");
        break;
    }
  }
}
