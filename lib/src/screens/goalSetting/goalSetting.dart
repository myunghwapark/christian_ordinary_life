import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'goalSettingQT.dart';
import 'goalSettingBible.dart';
import 'goalSettingPraying.dart';

class GoalSetting extends StatefulWidget {
  static const routeName = '/goalSetting';

  final User loginUser;
  GoalSetting(this.loginUser);

  @override
  GoalSettingState createState() => GoalSettingState();
}

class GoalSettingState extends State<GoalSetting> {
  var _checkVars = {
    'qt': false,
    'praying': false,
    'bible': false,
    'diary': false,
  };

  _goToSettingDetail(String title, bool value) {
    setState(() {
      _checkVars[title] = value;

      switch (title) {
        case 'qt':
          if (value == true) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GoalSettingQT()));
          }
          break;
        case 'praying':
          if (value == true) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GoalSettingPraying()));
          }
          break;
        case 'bible':
          if (value == true) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GoalSettingBible()));
          }
          break;
      }
    });
  }

  Widget _createGoal(
      String target, String title, Color bgColor, bool checkboxVar) {
    return Flexible(
        fit: FlexFit.tight,
        flex: 1,
        child: InkWell(
            onTap: () => {_goToSettingDetail(target, !_checkVars[target])},
            child: Container(
              color: bgColor,
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: Checkbox(
                      value: checkboxVar,
                      onChanged: (bool newValue) =>
                          {_goToSettingDetail(target, newValue)},
                      activeColor: AppColors.darkGray,
                    ),
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(top: 3),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ))),
                  if (target != 'diary')
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            )));
  }

  _save() {}

  _goToMain() {
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('save')),
      onPressed: _save,
      textColor: AppColors.greenPoint,
    );
  }

  @override
  void initState() {
    super.initState();
    print('loginUser: ${widget.loginUser.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarBack(
            context,
            Translations.of(context).trans('qt_notice_setting_title'),
            _goToMain,
            actionIcon()),
        body: Column(children: [
          _createGoal('qt', Translations.of(context).trans('daily_qt'),
              AppColors.blueSky, _checkVars['qt']),
          _createGoal(
              'praying',
              Translations.of(context).trans('daily_praying'),
              AppColors.mint,
              _checkVars['praying']),
          _createGoal('bible', Translations.of(context).trans('daily_bible'),
              AppColors.lightOrange, _checkVars['bible']),
          _createGoal('diary', Translations.of(context).trans('daily_thank'),
              AppColors.pastelPink, _checkVars['diary']),
        ]));
  }
}
