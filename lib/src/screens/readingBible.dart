import 'package:flutter/material.dart';
import '../navigation/appDrawer.dart';

class ReadingBible extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("ReadingBible"),
            ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("ReadingBible")
        )
    );
  }
}