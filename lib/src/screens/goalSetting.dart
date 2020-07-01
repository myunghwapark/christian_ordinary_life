import 'package:flutter/material.dart';
import '../navigation/appDrawer.dart';

class GoalSetting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("GoalSetting"),
            ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("GoalSetting")
        )
    );
  }
}