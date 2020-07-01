import 'package:flutter/material.dart';
import '../navigation/appDrawer.dart';

class QTRecord extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("QTRecord"),
            ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("QTRecord")
        )
    );
  }
}