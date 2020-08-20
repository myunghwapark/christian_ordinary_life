import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalBibleCustom2 extends StatefulWidget {
  final BibleUserPlan bibleUserPlan;
  GoalBibleCustom2({this.bibleUserPlan});

  @override
  GoalBibleCustom2State createState() => GoalBibleCustom2State();
}

class GoalBibleCustom2State extends State<GoalBibleCustom2> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BibleUserPlan bibleUserPlan = new BibleUserPlan();
  TextEditingController _daysController = new TextEditingController();
  String _period = '';
  String _periodMent = '';
  int period = 0;
  int totalChapters = 0;

  void _complete() {
    if (_daysController.text.isEmpty) {
      showToast(
          scaffoldKey, Translations.of(context).trans('bible_period_validate'));
      return;
    } else if (period > totalChapters) {
      showToast(scaffoldKey,
          Translations.of(context).trans('bible_custom_period_warning'));
      return;
    }
    bibleUserPlan.planPeriod = _daysController.text;
    Navigator.pop(
        context, {"result": "complete", "bibleUserPlan": bibleUserPlan});
  }

  void _setPeriod(value) {
    period = int.parse(_daysController.text);
    totalChapters = bibleUserPlan.customTotalChapters;
    int dayReading = (totalChapters / period).round();
    var now = new DateTime.now();
    String startDay = DateFormat.yMMMMd().format(now);
    String endDay = DateFormat.yMMMMd().format(now.add(Duration(days: period)));

    bibleUserPlan.planPeriod = dayReading.toString();
    bibleUserPlan.planEndDate = now.add(Duration(days: period)).toString();

    setState(() {
      _period = startDay + ' ~ ' + endDay;
      _periodMent =
          '${Translations.of(context).trans('bible_custom_ment', param1: totalChapters.toString(), param2: dayReading.toString(), param3: period.toString())}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final _label = Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        Translations.of(context).trans('title_set_period'),
        style: TextStyle(
          fontFamily: '12LotteMartHappy',
          color: AppColors.darkGray,
          fontSize: 20,
        ),
        textAlign: TextAlign.start,
      ),
    );

    final _customDate = Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.sky),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: AppColors.lightSky),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.only(right: 10),
                  width: 150,
                  height: 40,
                  child: TextField(
                    controller: _daysController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.marine, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    )),
                    onChanged: _setPeriod,
                  )),
              Text(Translations.of(context).trans('days'))
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child:
                Text('${Translations.of(context).trans('period')}: $_period'),
          )
        ],
      ),
    );

    final _periodDetail = Container(
      padding: EdgeInsets.all(10),
      child: Text(_periodMent),
    );

    return Scaffold(
        key: scaffoldKey,
        body: GestureDetector(
            child: Column(
              children: [
                appBarCustom(context,
                    Translations.of(context).trans('bible_plan_custom'),
                    leaderText: Translations.of(context).trans('prev'),
                    actionText: Translations.of(context).trans('done'),
                    onActionTap: _complete),
                Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [_label, _customDate, _periodDetail]))
              ],
            ),
            onTap: () => FocusScope.of(context).unfocus()));
  }

  @override
  void initState() {
    bibleUserPlan = widget.bibleUserPlan;
    super.initState();
  }
}