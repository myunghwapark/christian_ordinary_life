import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';
import 'package:christian_ordinary_life/src/model/BiblePlan.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalBiblePlanDetail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadioBox extends StatelessWidget {
  final BiblePlan _item;
  final AppButtons buttons = new AppButtons();
  RadioBox(this._item);

  Future<void> _goDetail(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => GoalBiblePlanDetail(_item)));
  }

  @override
  Widget build(BuildContext context) {
    // To get _contentSpace Size
    double _deviceWidth = MediaQuery.of(context).size.width;
    double _radioButtonWidth = 45;
    double _containerPadding = 10;
    double _containerMargin = 7;
    double _contentSpace = (_deviceWidth -
        _radioButtonWidth -
        (_containerPadding * 2) -
        (_containerMargin * 2) -
        50);

    final _radioButton = Container(
        width: _radioButtonWidth,
        padding: EdgeInsets.all(10),
        child: Icon(
          _item.isSelected
              ? FontAwesomeIcons.checkCircle
              : FontAwesomeIcons.circle,
          color: _item.isSelected ? AppColors.orange : Colors.grey[200],
        ));

    final _period = Container(
        child: Text(
      '${Translations.of(context).trans('period')}: ${getPlanPeriod(context, _item.planPeriod)}',
      style: TextStyle(fontSize: 15),
    ));

    final _volume = Container(
        child: Text(
            '${Translations.of(context).trans('volume')}: ${_item.planVolume}',
            style: TextStyle(fontSize: 15)));

    final _planTitle = Container(
      child: Text(
        _item.planTitle,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: '12LotteMartHappy',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGray),
      ),
    );

    final _planSubTitle = Container(
        padding: EdgeInsets.only(top: 7),
        width: _contentSpace,
        child: (_item.planSubTitle != null && _item.planSubTitle != '')
            ? Text(_item.planSubTitle,
                softWrap: true, maxLines: 10, style: TextStyle(fontSize: 14))
            : Container());

    final _viewPlan = Container(
        height: 30,
        width: _contentSpace,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            buttons.outerlineGreyButton(
                Translations.of(context).trans('view_plan'), () {
              _goDetail(context);
            })
          ],
        ));

    return Container(
      padding: EdgeInsets.only(
          top: 15.0,
          left: _containerPadding,
          right: _containerPadding,
          bottom: 10),
      margin: EdgeInsets.only(
          top: 5, left: _containerMargin, right: _containerMargin, bottom: 5),
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _radioButton,
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: _contentSpace,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _item.biblePlanId != 'custom' ? _period : Container(),
                    _item.biblePlanId != 'custom' ? _volume : Container(),
                  ],
                ),
              ),
              _planTitle,
              _planSubTitle,
              _item.biblePlanId != 'custom' ? _viewPlan : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
