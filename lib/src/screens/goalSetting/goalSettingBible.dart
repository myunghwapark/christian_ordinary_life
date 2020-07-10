import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import '../../common/translations.dart';
import '../../component/appBarComponent.dart';

class GoalSettingBible extends StatefulWidget {
  @override
  GoalSettingBibleState createState() => GoalSettingBibleState();
}

class GoalSettingBibleState extends State<GoalSettingBible> {

  int _selected = 0;
  bool visibleVar = true;


  void _onRadioChanged(int value) {
    setState((){
      _selected = value;
      if(value == 0) {
        visibleVar = true;
      }
      else {
        visibleVar = false;
      }

      _actionIcon();
    });

    print('Value = $value');
  }
  

  Widget rows(String radioTitle, String description, int radioVar) {
    return Column(
      children: [
        RadioListTile(
          title: Text(
            radioTitle,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.darkGray
            )
          ),
          value: radioVar, 
          groupValue: _selected, 
          onChanged: (int value){
            _onRadioChanged(value);
          }
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right:15, bottom:20),
          child: Text(
            description,
            textAlign: TextAlign.start,
          )
        )
      ], 
    );
            
  }

  void _next() {

  }

  Widget _actionIcon() {
    if(_selected == 3) {
      return FlatButton(
        child: Text(Translations.of(context).trans('next')),
        onPressed: _next,
        textColor: AppColors.greenPoint,
      );
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarComponent(context, Translations.of(context).trans('bible_reading_plan'), null, _actionIcon()),
      body: Container(
        color: AppColors.lightOrange,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            rows(Translations.of(context).trans('bible_plan_year_1'), Translations.of(context).trans('bible_plan_year_1_ment'), 0),
            rows(Translations.of(context).trans('bible_plan_year_2'), Translations.of(context).trans('bible_plan_year_2_ment'), 1),
            rows(Translations.of(context).trans('bible_plan_whole_90days'), Translations.of(context).trans('bible_plan_whole_90days_ment'), 2),
            rows(Translations.of(context).trans('bible_plan_custom'), Translations.of(context).trans('bible_plan_custom_ment'), 3),
          ]
        
        ),
      ),
    );
  }
}