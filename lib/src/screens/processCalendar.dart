import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:loading_overlay/loading_overlay.dart';

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
  LinkedHashMap<String, List> _events = new LinkedHashMap<String, List>();
  //List _selectedEvents;
  ValueNotifier<List<GoalDailyProgress>> _selectedEvents;
  AnimationController _animationController;
  //CalendarController _calendarController;
  List<GoalProgress> _goalProgress = [];
  String _yearMonth;
  bool _isLoading = false;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  final kNow = DateTime.now();
  DateTime kFirstDay;
  DateTime kLastDay;

  List<GoalDailyProgress> _getEventsForDay(DateTime day) {
    return _events[getCalDateFormat(day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onVisibleDaysChanged(DateTime focusDate) {
    setState(() {
      _selectedEvents.removeListener(() {});
    });
    _yearMonth = getTodayYearMonth(focusDate);
    _getProgress();
  }

  Future<void> _getProgress() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await API.transaction(context, API.getMonthGoalProgress, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'yearMonth': _yearMonth,
        'today': getToday()
      }).then((response) {
        GoalProgress result = GoalProgress.fromJson(json.decode(response));
        if (result.result == 'success') {
          _goalProgress = result.goalProgress
              .map((model) => GoalProgress.fromJson(model))
              .toList();

          setState(() {
            if (_events != null) _events.clear();
            List<GoalDailyProgress> goalDailyProgress;
            for (int i = 0; i < _goalProgress.length; i++) {
              String createTime = _goalProgress[i].goalDate;
              goalDailyProgress = [];

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
            _isLoading = false;
            // 오늘자 선택
            _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
          });
        }
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

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar<GoalDailyProgress>(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: _getEventsForDay,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, date) {
          if (date.weekday == DateTime.sunday) {
            final text = DateFormat.E().format(date);

            return Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (date.weekday == DateTime.saturday) {
            final text = DateFormat.E().format(date);

            return Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.blue),
              ),
            );
          } else {
            final text = DateFormat.E().format(date);

            return Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.black87),
              ),
            );
          }
        },
        selectedBuilder: (context, date, _) {
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
        todayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 18.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
            ),
            width: 100,
            height: 100,
            child: Text('${date.day}',
                style: TextStyle(fontSize: 16.0, color: AppColors.greenPoint)),
          );
        },
        markerBuilder: (context, date, events) {
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

          if (events.length != 0 && events.length == count) {
            children.add(
              Positioned(
                  left: 8,
                  bottom: 1,
                  child: Icon(FontAwesomeIcons.award, color: Colors.red[400])),
            );
          }

          return Stack(
            children: children,
          );
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        _onDaySelected(selectedDay, focusedDay);
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
        _onVisibleDaysChanged(focusedDay);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, int count) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: _focusedDay == date ? Colors.brown[500] : Colors.blue[400],
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
    return _selectedEvents != null
        ? ValueListenableBuilder<List<GoalDailyProgress>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    GoalDailyProgress dailyProgress = value[index];

                    return Container(
                        height: 23,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10.0),
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
                                          builder: (context) =>
                                              QtRecordDetail(qt: qt)));
                                  break;
                                default:
                              }
                            }
                          },
                        ));
                  });
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightMint,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_calendar')),
        drawer: AppDrawer(),
        body: LoadingOverlay(
          isLoading: _isLoading,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          color: Colors.black,
          child: Column(
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
        ));
  }

  @override
  void initState() {
    _yearMonth = getTodayYearMonth(new DateTime.now());
    _getProgress();
    kFirstDay = DateTime(kNow.year - 10, kNow.month, kNow.day);
    kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
    _selectedDay = _focusedDay;

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
    //_calendarController.dispose();
    super.dispose();
  }

  /* 

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
*/
  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}
