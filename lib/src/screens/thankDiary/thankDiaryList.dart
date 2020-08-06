import 'package:flutter/material.dart';
import '../../navigation/appDrawer.dart';
import '../../component/appBarComponent.dart';
import '../../common/translations.dart';
import '../../common/colors.dart';

class ThankDiary extends StatefulWidget {
  @override
  ThankDiaryState createState() => ThankDiaryState();
}

class ThankDiaryState extends State<ThankDiary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightPinks,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_qt_record')),
        drawer: AppDrawer(),
        body: Center(child: Text("ThankDiary")));
  }
}
