import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final DateTime selectedDate;
  const Calendar(this.selectedDate);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  DateTime returnDate;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _apply() {
    Navigator.pop(context, returnDate);
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('apply'),
          style: TextStyle(color: AppColors.darkGray)),
      onPressed: _apply,
      textColor: AppColors.greenPoint,
    );
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    returnDate = day;
  }

  @override
  Widget build(BuildContext context) {
    returnDate = widget.selectedDate;

    return Scaffold(
      appBar: appBarComponent(
          context, Translations.of(context).trans('select_date'),
          actionWidget: actionIcon()),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      initialSelectedDay: widget.selectedDate,
      calendarController: _calendarController,
      //events: _events,
      //holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        //todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        centerHeaderTitle: true,
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),

      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
      },
      //onVisibleDaysChanged: _onVisibleDaysChanged,
      //onCalendarCreated: _onCalendarCreated,
    );
  }
}
