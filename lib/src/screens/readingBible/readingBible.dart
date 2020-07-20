import 'package:flutter/material.dart';
import '../../navigation/appDrawer.dart';
import '../../component/appBarComponent.dart';
import '../../common/translations.dart';
import '../../common/colors.dart';

class ReadingBible extends StatefulWidget {
  @override
  ReadingBibleState createState() => ReadingBibleState();
}

class ReadingBibleState extends State<ReadingBible> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarComponent(context,
            Translations.of(context).trans('menu_reading_bible'), null),
        drawer: AppDrawer(),
        body: Center(child: Text("ReadingBible")));
  }
}
