import 'package:flutter/material.dart';
import '../../navigation/appDrawer.dart';
import '../../component/appBarComponent.dart';
import '../../common/translations.dart';
import '../../common/colors.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightBgGray,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_settings'), null),
        drawer: AppDrawer(),
        body: Center(child: Text("Settings")));
  }
}
