import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/BiblePlan.dart';
import 'package:christian_ordinary_life/src/model/BiblePlanDetail.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';

class GoalBiblePlanDetail extends StatefulWidget {
  final BiblePlan biblePlan;
  GoalBiblePlanDetail(this.biblePlan);

  @override
  GoalBiblePlanDetailState createState() => GoalBiblePlanDetailState();
}

class GoalBiblePlanDetailState extends State<GoalBiblePlanDetail> {
  List<BiblePlanDetail> biblePlanDetailList = new List<BiblePlanDetail>();
  bool _isLoading = false;

  Future<void> _getBiblePlanDetail() async {
    BiblePlanDetail data;

    setState(() {
      _isLoading = true;
    });

    try {
      await API.transaction(context, API.biblePlanDetail, param: {
        'biblePlanId': widget.biblePlan.biblePlanId
      }).then((response) {
        data = BiblePlanDetail.fromJson(json.decode(response));

        setState(() {
          _isLoading = false;
        });

        if (data.result == 'success') {
          setState(() {
            biblePlanDetailList = data.biblePlanDetail
                .map((model) => BiblePlanDetail.fromJson(model))
                .toList();

            biblePlanDetailList.forEach((obj) {
              List chapterList = json.decode(obj.chapter);

              chapterList.asMap().forEach((index, value) {
                if (index == 0) obj.chapter = '';
                if (index != 0) obj.chapter += ', ';

                String book = Translations.of(context).trans(value['book']);
                String chapterType;
                if (value['book'] == 'ps')
                  chapterType = 'chapter_ps';
                else
                  chapterType = 'chapter';
                String chapter = Translations.of(context).trans(chapterType);

                obj.chapter += '$book ${value['volume']}$chapter';
              });
            });
          });
        } else {
          errorMessage(context, data.errorMessage);
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

  @override
  Widget build(BuildContext context) {
    // To get _contentSpace Size
    double _deviceWidth = MediaQuery.of(context).size.width;
    double _containerPadding = 20;
    double _containerMargin = 20;
    double _contentSpace = (_deviceWidth - (_containerPadding * 2));

    final _title = Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(widget.biblePlan.planTitle,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontFamily: '12LotteMartHappy',
              fontSize: 18,
              color: AppColors.lightBrown)),
    );

    final _period = Flexible(
        fit: FlexFit.tight,
        flex: 1,
        child: Text(
          '${Translations.of(context).trans('period')}: ${getPlanPeriod(context, widget.biblePlan.planPeriod)}',
          style: TextStyle(fontSize: 15),
        ));

    final _volume = Flexible(
        fit: FlexFit.tight,
        flex: 1,
        child: Text(
            '${Translations.of(context).trans('volume')}: ${widget.biblePlan.planVolume}',
            style: TextStyle(fontSize: 15)));

    final _titleBox = Container(
      height: 90,
      width: _contentSpace,
      padding: EdgeInsets.all(_containerPadding),
      margin: EdgeInsets.only(
          left: _containerMargin,
          right: _containerMargin,
          top: _containerMargin,
          bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title,
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_period, _volume],
          ),
        ],
      ),
    );

    final _list = Container(
      padding: EdgeInsets.all(_containerPadding),
      margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      height: (MediaQuery.of(context).copyWith().size.height - 260),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: biblePlanDetailList.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
                color: AppColors.orange,
              ),
          itemBuilder: (BuildContext context, int index) {
            return Row(children: [
              Container(
                width: 60,
                child: Text(
                  Translations.of(context).trans('day_order',
                      param1: biblePlanDetailList[index].days),
                  style: TextStyle(fontSize: 13),
                ),
              ),
              Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Text(biblePlanDetailList[index].chapter,
                      style: TextStyle(fontSize: 13)))
            ]);
          }),
    );

    return Scaffold(
        backgroundColor: AppColors.lightOrange,
        appBar: appBarComponent(
          context,
          Translations.of(context).trans('bible_reading_plan'),
        ),
        body: SafeArea(
            child: LoadingOverlay(
                isLoading: _isLoading,
                opacity: 0.5,
                progressIndicator: CircularProgressIndicator(),
                color: Colors.black,
                child: ListView(
                  children: [_titleBox, _list],
                ))));
  }

  @override
  void initState() {
    _getBiblePlanDetail();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
