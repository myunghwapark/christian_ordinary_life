import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';
import 'package:christian_ordinary_life/src/model/BiblePlan.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingBible.dart';
import 'package:flutter/material.dart';

class ReadingBibleComplete extends StatefulWidget {
  ReadingBibleCompleteState createState() => ReadingBibleCompleteState();
}

class ReadingBibleCompleteState extends State<ReadingBibleComplete> {
  String bibleVolme;
  AppButtons appButtons = new AppButtons();
  BiblePlan biblePlan = BiblePlan();
  bool _first = true;

  _getBibleGoal() {
    if (GoalInfo.goal.biblePlanId == 'custom') {
      bibleVolme = '';
      List<dynamic> tempList = List<dynamic>();
      tempList = json.decode(GoalInfo.goal.customBible);
      setState(() {
        for (int i = 0; i < tempList.length; i++) {
          bibleVolme += Translations.of(context).trans(tempList[i]['book']);
          if (i != (tempList.length - 1)) bibleVolme += ', ';
        }
      });
    } else {
      _getBiblePlan();
    }
    _first = false;
  }

  final TextStyle newPlanContentStyle = TextStyle(
      color: AppColors.darkGray,
      fontSize: 20,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400);

  final TextStyle contentStyle = TextStyle(
      color: AppColors.darkGray,
      fontSize: 16,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400);

  void _goBiblePlan(BuildContext context) {
    BibleUserPlan bibleUserPlan = new BibleUserPlan();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GoalSettingBible(newPlan: true, bibleUserPlan: bibleUserPlan)),
    );
  }

  Future<void> _getBiblePlan() async {
    BiblePlan result;
    try {
      await API.transaction(context, API.getBiblePlan, param: {
        'language': UserInfo.language,
        'biblePlanId': GoalInfo.goal.biblePlanId
      }).then((response) {
        result = BiblePlan.fromJson(json.decode(response));

        if (result.result == 'success') {
          setState(() {
            List<BiblePlan> tempList;
            tempList = result.biblePlanList
                .map((model) => BiblePlan.fromJson(model))
                .toList();
            biblePlan = tempList[0];
            bibleVolme = biblePlan.planVolume;
          });
        } else {
          errorMessage(context, result.errorMessage);
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (_first) _getBibleGoal();
    final background = Container(
      decoration: new BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[AppColors.pastelYellow, AppColors.pastelMint],
        ),
      ),
    );

    final _titleBar = AppBar(
      title: Text(
        Translations.of(context).trans('complete_reading_bible'),
        style: TextStyle(color: AppColors.darkGray),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          child: Text(
            Translations.of(context).trans('confirm'),
            style: TextStyle(color: AppColors.darkGray),
          ),
        )
      ],
    );

    final _congratulationImg = Image(
      image: AssetImage(UserInfo.language == "ko"
          ? "assets/images/bible_congratulation_ko.png"
          : "assets/images/bible_congratulation_en.png"),
      width: MediaQuery.of(context).copyWith().size.width - 100,
    );

    final _line = Container(
      color: Colors.grey[400],
      width: MediaQuery.of(context).copyWith().size.width / 2,
      height: 1,
      margin: EdgeInsets.only(top: 30, bottom: 30),
    );

    final _period = Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Text(
        '${Translations.of(context).trans('period')}: ${GoalInfo.goal.biblePlanStartDate} ~ ${getToday()}',
        style: contentStyle,
      ),
    );

    final _volume = Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Text(
        '${Translations.of(context).trans('volume')}: $bibleVolme',
        style: contentStyle,
      ),
    );

    final _mentNewPlan = Container(
        margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
        child: Text(
          Translations.of(context).trans('new_bible_plan_ment'),
          style: newPlanContentStyle,
          textAlign: TextAlign.center,
        ));

    final _btnNewPlan = Container(
      width: MediaQuery.of(context).copyWith().size.width - 100,
      child: appButtons.filledWhiteMintButton(
          Translations.of(context).trans('choose_bible_plan'), () {
        _goBiblePlan(context);
      }),
    );

    return Stack(children: <Widget>[
      background,
      Positioned(
        child: _titleBar,
      ),
      Positioned(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            _congratulationImg,
            _line,
            _period,
            _volume,
            _mentNewPlan,
            _btnNewPlan,
            SizedBox(
              height: 90,
            ),
          ],
        ),
      ))
    ]);
  }

  @override
  void initState() {
    super.initState();
  }
}
