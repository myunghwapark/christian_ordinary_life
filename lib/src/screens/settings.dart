import 'package:flutter/material.dart';
import '../navigation/appDrawer.dart';

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Settings"),
            ),
        drawer: AppDrawer(),
        body: Center(
            child: Text("Settings")
        )
    );
  }
}