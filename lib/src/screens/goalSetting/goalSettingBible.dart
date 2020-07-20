import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import '../../common/translations.dart';
import '../../component/appBarComponent.dart';
import 'goalBibleCustom1.dart';
import '../../model/Bible.dart';

class GoalSettingBible extends StatefulWidget {
  @override
  GoalSettingBibleState createState() => GoalSettingBibleState();
}

class GoalSettingBibleState extends State<GoalSettingBible> {
  List<Bible> biblePlan = <Bible>[];

  void setData(List<Bible> newBiblePlan) {
    biblePlan = newBiblePlan;
  }

  int _selected = 0;

  Future<void> _onRadioChanged(int value) async {
    setState(() {
      _selected = value;
    });
    if (value == 3) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoalSettingBibleCustom(biblePlan: biblePlan),
        ),
      );
      /*
        Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
      */
    }

    print('Value = $value');
  }

  Widget rows(String radioTitle, String description, int radioVar) {
    return Column(
      children: [
        RadioListTile(
            title: Text(radioTitle,
                style: TextStyle(fontSize: 20, color: AppColors.darkGray)),
            value: radioVar,
            groupValue: _selected,
            onChanged: (int value) {
              _onRadioChanged(value);
            }),
        Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Text(
              description,
              textAlign: TextAlign.start,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBack(context,
          Translations.of(context).trans('bible_reading_plan'), null, null),
      body: Container(
        color: AppColors.lightOrange,
        padding: EdgeInsets.all(20),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          rows(Translations.of(context).trans('bible_plan_year_1'),
              Translations.of(context).trans('bible_plan_year_1_ment'), 0),
          rows(Translations.of(context).trans('bible_plan_year_2'),
              Translations.of(context).trans('bible_plan_year_2_ment'), 1),
          rows(
              Translations.of(context).trans('bible_plan_whole_90days'),
              Translations.of(context).trans('bible_plan_whole_90days_ment'),
              2),
          rows(Translations.of(context).trans('bible_plan_custom'),
              Translations.of(context).trans('bible_plan_custom_ment'), 3),
        ]),
      ),
    );
  }
}
