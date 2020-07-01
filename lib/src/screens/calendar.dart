import 'package:flutter/material.dart';
import '../navigation/appDrawer.dart';

class Calendar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Calendar"),
            ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("Calendar")
        )
    );
  }
}