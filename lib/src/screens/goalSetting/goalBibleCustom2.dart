import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSettingComplete.dart';

class GoalBibleCustom2 extends StatefulWidget {
  final BibleUserPlan bibleUserPlan;
  final bool newBiblePlan;
  GoalBibleCustom2({this.bibleUserPlan, this.newBiblePlan});

  @override
  GoalBibleCustom2State createState() => GoalBibleCustom2State();
}

class GoalBibleCustom2State extends State<GoalBibleCustom2> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BibleUserPlan bibleUserPlan = new BibleUserPlan();
  TextEditingController _daysController = new TextEditingController();
  GoalInfo goalInfo = new GoalInfo();
  String _period = '';
  String _periodMent = '';
  int period = 0;
  int totalChapters = 0;
  bool _isLoading = false;

  Future<void> setUserGoal() async {
    if (!goalInfo.checkContent(context, bibleUserPlan)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      goalInfo.setUserGoal(context, bibleUserPlan).then((value) {
        setState(() {
          _isLoading = false;
        });

        if (value.result == 'success') {
          bool nothingSelected = false;

          // For the case of when a user chooses nothing, next page must show a different message.
          if (!GoalInfo.goal.readingBible &&
              !GoalInfo.goal.thankDiary &&
              !GoalInfo.goal.qtRecord &&
              !GoalInfo.goal.praying) {
            nothingSelected = true;
          }
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => GoalSettingComplete(nothingSelected)));
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    if (widget.newBiblePlan) {
      setUserGoal();
    } else {
      Navigator.pop(
          context, {"result": "complete", "bibleUserPlan": bibleUserPlan});
    }
  }

  void _setPeriod(value) {
    period = int.parse(value);
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
    if (bibleUserPlan.planPeriod != null && bibleUserPlan.planPeriod != '') {
      _setPeriod(_daysController.text);
    }
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
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: GestureDetector(
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
                onTap: () => FocusScope.of(context).unfocus())));
  }

  @override
  void initState() {
    bibleUserPlan = widget.bibleUserPlan;
    if (bibleUserPlan != null &&
        bibleUserPlan.planPeriod != null &&
        bibleUserPlan.planPeriod != '0') {
      _daysController.text = bibleUserPlan.planPeriod;
    }
    super.initState();
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }
}
