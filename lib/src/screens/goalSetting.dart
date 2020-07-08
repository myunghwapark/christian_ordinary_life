import 'package:flutter/material.dart';
import '../common/translations.dart';
import '../common/colors.dart';

class GoalSetting extends StatefulWidget {
  @override
  GoalSettingState createState() => GoalSettingState();
}


class GoalSettingState extends State<GoalSetting> {

  bool _qtVar = false;
  bool _prayingVar = false;
  bool _readingBible = false;
  bool _writingDiary = false;

  _setState(String title, bool value) {
    switch(title) {
      case 'qt':
        _qtVar = value;
        break;
      case 'praying':
        _prayingVar = value;
        break;
      case 'bible':
        _readingBible = value;
        break;
      case 'diary':
        _writingDiary = value;
        break;
    }
  }

  Widget _createGoal(String target, String title, Color bgColor, bool checkboxVar){
    return Flexible(
        fit: FlexFit.tight,
        flex: 1,
        child: InkWell(
          onTap: () => {
            debugPrint(target)
          },
          child: Container(
            color: bgColor,
            padding: EdgeInsets.all(20),
            child: Row(
              
              children: [
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.white
                  ),
                  child: Checkbox(
                    value: checkboxVar, 
                    onChanged: (bool newValue) => {
                      setState((){
                        _setState(target, newValue);
                      })
                    },
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
                    )
                  )
                ),
                if(target != 'diary') Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )
        )
        
      );
  }


  _save() {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                Translations.of(context).trans('title_goal_setting'),
                style: TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.bold,
                ),
            ),
            backgroundColor: Colors.white,
            
            iconTheme: new IconThemeData(
              color: AppColors.lightGray,
            ),
            
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: () => {
                Navigator.pushReplacementNamed(context, '/')
              },
            ),
            
            actions: <Widget>[
              FlatButton(
                child: Text(Translations.of(context).trans('save')),
                onPressed: _save,
                textColor: AppColors.greenPoint,
              )
            ],
        ),
        body: Column(
            children: [
              _createGoal('qt', Translations.of(context).trans('daily_qt'), AppColors.blueSky, _qtVar),
              _createGoal('praying', Translations.of(context).trans('daily_praying'), AppColors.mint, _prayingVar),
              _createGoal('bible', Translations.of(context).trans('daily_bible'), AppColors.lightOrange, _readingBible),
              _createGoal('diary', Translations.of(context).trans('daily_thank'), AppColors.lightPink, _writingDiary),
            ]
          )
      );
  }
}