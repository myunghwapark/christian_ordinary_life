import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:christian_ordinary_life/src/model/Diary.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordDetail.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryDetail.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/GoalDailyProgress.dart';
import 'package:christian_ordinary_life/src/model/GoalProgress.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';

class ProcessCalendar extends StatefulWidget {
  static const routeName = '/processCalendar';

  @override
  ProcessCalendarState createState() => ProcessCalendarState();
}

class ProcessCalendarState extends State<ProcessCalendar>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  List<GoalProgress> _goalProgress = new List<GoalProgress>();
  String _yearMonth;

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    getProgress();
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _selectedEvents = [];
    });
    _yearMonth = getTodayYearMonth(first);
    getProgress();
  }

  Future<void> getProgress() async {
    try {
      await API.transaction(context, API.getMonthGoalProgress, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'yearMonth': _yearMonth
      }).then((response) {
        GoalProgress result = GoalProgress.fromJson(json.decode(response));
        if (result.result == 'success') {
          _goalProgress = result.goalProgress
              .map((model) => GoalProgress.fromJson(model))
              .toList();

          setState(() {
            _events = {};
            List<GoalDailyProgress> goalDailyProgress;
            for (int i = 0; i < _goalProgress.length; i++) {
              DateTime createTime =
                  convertDateFromString(_goalProgress[i].goalDate);
              goalDailyProgress = new List<GoalDailyProgress>();

              if (_goalProgress[i].qtRecord != '-')
                goalDailyProgress.add(_makeDailyProgressList(
                    _goalProgress[i].goalDate,
                    'qt',
                    _goalProgress[i].qtRecord,
                    FontAwesomeIcons.pen));

              if (_goalProgress[i].praying != '-')
                goalDailyProgress.add(_makeDailyProgressList(
                    _goalProgress[i].goalDate,
                    'praying',
                    _goalProgress[i].praying,
                    FontAwesomeIcons.pray));

              if (_goalProgress[i].readingBible != '-') {
                goalDailyProgress.add(_makeDailyProgressList(
                    _goalProgress[i].goalDate,
                    'reading_bible',
                    _goalProgress[i].readingBible,
                    FontAwesomeIcons.bible,
                    biblePlanId: _goalProgress[i].biblePlanID));
              }

              if (_goalProgress[i].thankDiary != '-')
                goalDailyProgress.add(_makeDailyProgressList(
                    _goalProgress[i].goalDate,
                    'thank_diary',
                    _goalProgress[i].thankDiary,
                    FontAwesomeIcons.heart));

              var original = _events[createTime];
              if (original == null) {
                _events[createTime] = goalDailyProgress;
              } else {
                _events[createTime] = List.from(original)
                  ..addAll(goalDailyProgress);
              }
            }
            //_selectedEvents = goalDailyProgress; // 오늘자 선택
          });
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }
  }

  GoalDailyProgress _makeDailyProgressList(
      String goalDate, String target, String progress, IconData targetIcon,
      {String biblePlanId}) {
    GoalDailyProgress dailyProgress = new GoalDailyProgress();
    dailyProgress.goalDate = goalDate;
    dailyProgress.target = target;
    dailyProgress.progress = progress;
    dailyProgress.targetIcon = targetIcon;
    String title = 'menu_' + target;

    dailyProgress.title = Translations.of(context).trans(title) +
        ': ' +
        _makeCompleteYn(progress);
    return dailyProgress;
  }

  String _makeCompleteYn(String yn) {
    if (yn == 'y')
      return Translations.of(context).trans('done');
    else
      return Translations.of(context).trans('incomplete');
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      //holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 14.0),
            //color: Colors.white,
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 14.0),
              color: AppColors.marine,
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 18.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              //borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle()
                  .copyWith(fontSize: 16.0, color: AppColors.greenPoint),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          int count = 0;
          for (int i = 0; i < events.length; i++) {
            GoalDailyProgress dailyProgress = events[i];
            if (dailyProgress.progress == 'y') {
              count++;
            }
          }
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 2,
                bottom: 0,
                child: _buildEventsMarker(date, count),
              ),
            );
          }

          if (events.length == count) {
            children.add(
              Positioned(
                  left: 8,
                  bottom: 1,
                  child: Icon(FontAwesomeIcons.award, color: Colors.red[400])),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, int count) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: _calendarController.isSelected(date)
              ? Colors.brown[500]
              : _calendarController.isToday(date)
                  ? Colors.brown[300]
                  : Colors.blue[400],
        ),
        width: 16.0,
        height: 16.0,
        child: Center(
          child: Text(
            '$count',
            style: TextStyle().copyWith(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ));
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents.map((event) {
        GoalDailyProgress dailyProgress = event;
        return Container(
            height: 23,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: GestureDetector(
              child: Row(
                children: [
                  Container(
                      width: 50,
                      child: Icon(
                        dailyProgress.targetIcon,
                        color: dailyProgress.progress == 'y'
                            ? AppColors.mint
                            : Colors.grey,
                      )),
                  Text(
                    dailyProgress.title,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onTap: () {
                if (dailyProgress.progress == 'y') {
                  switch (dailyProgress.target) {
                    case 'thank_diary':
                      Diary diary = new Diary();
                      diary.diaryDate = dailyProgress.goalDate;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ThankDiaryDetail(diary: diary)));
                      break;
                    case 'qt':
                      QT qt = new QT();
                      qt.qtDate = dailyProgress.goalDate;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QtRecordDetail(qt: qt)));
                      break;
                    default:
                  }
                }
              },
            ));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightMint,
      appBar: appBarComponent(
          context, Translations.of(context).trans('menu_calendar')),
      drawer: AppDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 16.0),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 15),
                  color: Colors.white.withOpacity(0.6),
                  child: _buildEventList())),
        ],
      ),
    );
  }

  @override
  void initState() {
    _yearMonth = getTodayYearMonth(new DateTime.now());
    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }
}
