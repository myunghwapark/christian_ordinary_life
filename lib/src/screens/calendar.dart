import 'package:flutter/material.dart';
import '../navigation/appDrawer.dart';
import '../component/appBarComponent.dart';
import '../common/translations.dart';
import '../common/colors.dart';

class Calendar extends StatefulWidget {
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightMint,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_calendar'), null),
        drawer: AppDrawer(),
        body: Center(child: Text("Calendar")));
  }
}
