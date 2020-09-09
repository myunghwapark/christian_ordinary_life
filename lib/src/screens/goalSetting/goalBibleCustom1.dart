import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:badges/badges.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/BibleUserPlan.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/model/Bible.dart';
import 'goalBibleCustom2.dart';

class GoalBibleCustom1 extends StatefulWidget {
  @override
  GoalBibleCustom1State createState() => GoalBibleCustom1State();

  final User loginUser;
  final Goal goal;
  final BibleUserPlan bibleUserPlan;
  final bool newBiblePlan;
  GoalBibleCustom1(
      {this.loginUser, this.goal, this.bibleUserPlan, this.newBiblePlan});
}

class GoalBibleCustom1State extends State<GoalBibleCustom1> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BibleUserPlan bibleUserPlan = new BibleUserPlan();
  List biblePlan = <Bible>[];
  var oldTestaments = <Bible>[];
  var newTestaments = <Bible>[];
  Map _oldTestament, _newTestament;
  bool first = true;

  void _bibleSetInit() {
    if (bibleUserPlan != null &&
        bibleUserPlan.customBible != null &&
        bibleUserPlan.customBible != '') {
      int totalChapters = 0;
      List<dynamic> biblePlanTemp = json.decode(bibleUserPlan.customBible);
      biblePlanTemp.asMap().forEach((index, obj) {
        Bible bible = new Bible(
            obj['book'],
            Translations.of(context).trans(obj['book']),
            int.parse(obj['volume']),
            checked: true);
        bible.setCheckOrder((index + 1));
        totalChapters += bible.chapters;
        biblePlan.add(bible);
      });
      bibleUserPlan.customTotalChapters = totalChapters;
    }
  }

  void _getBible() {
    _bibleSetInit();
    if (biblePlan == null) biblePlan = <Bible>[];

    if (oldTestaments.length == 0) {
      _oldTestament = Translations.of(context).bible('old_testament');
      _oldTestament.forEach((key, value) {
        bool selected = false;
        int order;

        if (biblePlan != null) {
          biblePlan.forEach((obj) {
            Bible bible = obj;
            if (bible.id == key && bible.checked) {
              selected = true;
              order = bible.checkOrder;
            }
          });
        }
        oldTestaments.add(Bible(key, value['title'], value['chapters'],
            checked: selected, checkOrder: order));
      });
    }

    if (newTestaments.length == 0) {
      _newTestament = Translations.of(context).bible('new_testament');
      _newTestament.forEach((key, value) {
        bool selected = false;
        int order;

        if (biblePlan != null) {
          biblePlan.forEach((obj) {
            Bible bible = obj;
            if (bible.id == key && bible.checked) {
              selected = true;
              order = bible.checkOrder;
            }
          });
        }
        newTestaments.add(Bible(key, value['title'], value['chapters'],
            checked: selected, checkOrder: order));
      });
    }

    first = false;
  }

  void _setBibleOrder(Bible bible) {
    bool exist = false;
    if (bible != null) {
      for (int i = 0; i < biblePlan.length; i++) {
        if (bible.title == biblePlan[i].title) {
          biblePlan.removeAt(i);
          exist = true;
        }
      }
      if (!exist) {
        biblePlan.add(bible);
      }
    }

    int totalChapters = 0;
    // Make order
    biblePlan.asMap().forEach((index, currentBible) {
      currentBible.setCheckOrder(index + 1);
      totalChapters += currentBible.chapters;
      newTestaments.forEach((value) {
        Bible tempBible = value;
        if (currentBible.id == tempBible.id) {
          tempBible.setCheckOrder(index + 1);
        }
      });
      oldTestaments.forEach((value) {
        Bible tempBible = value;
        if (currentBible.id == tempBible.id) {
          tempBible.setCheckOrder(index + 1);
        }
      });
    });
    bibleUserPlan.customTotalChapters = totalChapters;
    bibleUserPlan.customBible = biblePlan.toString();
  }

  Widget _displayBibles(Bible bible) {
    return InkWell(
      child: Badge(
        badgeColor: Colors.orange,
        shape: BadgeShape.circle,
        borderRadius: 20,
        toAnimate: true,
        animationType: BadgeAnimationType.slide,
        position: BadgePosition.topLeft(top: 2, left: -6),
        badgeContent: Text(
          bible.getCheckOrder().toString(),
          style: TextStyle(color: Colors.white),
        ),
        showBadge: bible.getChecked() ? true : false,
        child: Container(
          width: 100,
          padding: EdgeInsets.all(8),
          child: Text(
            bible.title,
            style: TextStyle(
              color: AppColors.lightBlack,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
              color: bible.getChecked()
                  ? AppColors.marine
                  : AppColors.moreLightGray,
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
      onTap: () {
        setState(() {
          bible.setChecked(!bible.getChecked());
          _setBibleOrder(bible);
        });
      },
    );
  }

  void _nextSetting() async {
    if (biblePlan.length == 0) {
      showToast(
          scaffoldKey, Translations.of(context).trans('bible_custom_validate'));
      return;
    }
    bibleUserPlan.customBible = biblePlan.toString();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoalBibleCustom2(
          bibleUserPlan: bibleUserPlan,
          newBiblePlan: widget.newBiblePlan,
        ),
      ),
    ).then((value) {
      if (value != null && value['result'] == 'complete') {
        Navigator.pop(context,
            {"result": "complete", "bibleUserPlan": value['bibleUserPlan']});
      }
    });
  }

  void _goToBack() {
    Navigator.pop(context, {"result": "cancel"});
  }

  @override
  Widget build(BuildContext context) {
    if (first) {
      _getBible();
    }
    final _bibleSelectionLabel = Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        Translations.of(context).trans('bible_selection'),
        style: TextStyle(
          fontFamily: '12LotteMartHappy',
          color: AppColors.darkGray,
          fontSize: 20,
        ),
        textAlign: TextAlign.start,
      ),
    );

    final _subtitle = Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Text(
          Translations.of(context).trans('bible_selection_ment'),
          style: TextStyle(color: AppColors.darkGray, fontSize: 16),
          textAlign: TextAlign.start,
        ));

    final _oldTestamentTitle = Text(
      Translations.of(context).trans('old_testament'),
      style: TextStyle(color: Colors.black, fontSize: 16),
      textAlign: TextAlign.start,
    );

    final _oldTestaments = GridView.count(
      //physics: ScrollPhysics(),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 2.5,
      shrinkWrap: true,
      children: oldTestaments.map((Bible bible) {
        return Center(
          child: _displayBibles(bible),
        );
      }).toList(),
    );

    final _newTestamentTitle = Container(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        Translations.of(context).trans('new_testament'),
        style: TextStyle(color: Colors.black, fontSize: 16),
        textAlign: TextAlign.start,
      ),
    );

    final _newTestaments = GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 2.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: newTestaments.map((Bible bible) {
        return Center(
          child: _displayBibles(bible),
        );
      }).toList(),
    );

    return Scaffold(
        key: scaffoldKey,
        body: Column(children: [
          appBarCustom(
              context, Translations.of(context).trans('title_goal_setting'),
              leaderText: Translations.of(context).trans('cancel'),
              onLeaderTap: _goToBack,
              actionText: Translations.of(context).trans('next'),
              onActionTap: _nextSetting),
          Container(
            height: (MediaQuery.of(context).copyWith().size.height - 70),
            padding: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  _bibleSelectionLabel,
                  _subtitle,
                  _oldTestamentTitle,
                  _oldTestaments,
                  _newTestamentTitle,
                  _newTestaments,
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  )
                ]),
          )
        ]));
  }

  @override
  initState() {
    bibleUserPlan = widget.bibleUserPlan;
    super.initState();
  }
}
