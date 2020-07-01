import 'package:flutter/material.dart';
import '../navigation/appDrawer.dart';

class ThankDiary extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("ThankDiary"),
            ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("ThankDiary")
        )
    );
  }
}