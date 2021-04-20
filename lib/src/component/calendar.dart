import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';

class Calendar extends StatefulWidget {
  final DateTime selectedDate;
  const Calendar(this.selectedDate);

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime returnDate;

  final kNow = DateTime.now();
  DateTime kFirstDay;
  DateTime kLastDay;

  @override
  void initState() {
    kFirstDay = DateTime(kNow.year - 10, kNow.month, kNow.day);
    kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
    returnDate = widget.selectedDate;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _apply() {
    Navigator.pop(context, returnDate);
  }

  Widget actionIcon() {
    return TextButton(
      child: Text(Translations.of(context).trans('apply'),
          style: TextStyle(color: AppColors.darkGray)),
      onPressed: _apply,
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      returnDate = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: returnDate,
        selectedDayPredicate: (day) => isSameDay(returnDate, day),
        //    initialSelectedDay: widget.selectedDate,
        //    calendarController: _calendarController,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.deepOrange[400],
          ),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          formatButtonTextStyle:
              TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
          formatButtonDecoration: BoxDecoration(
            color: Colors.deepOrange[400],
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          _onDaySelected(selectedDay, focusedDay);
        });
  }
}
