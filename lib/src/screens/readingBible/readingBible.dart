import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';

class ReadingBible extends StatefulWidget {
  static const routeName = '/readingBible';

  final User loginUser;
  ReadingBible(this.loginUser);

  @override
  ReadingBibleState createState() => ReadingBibleState();
}

class ReadingBibleState extends State<ReadingBible> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_reading_bible')),
        drawer: AppDrawer(),
        body: Center(child: Text("ReadingBible")));
  }
}
