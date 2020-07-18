import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:badges/badges.dart';
import '../../common/translations.dart';
import '../../common/colors.dart';
import '../../component/appBarCustom.dart';
import '../../model/Bible.dart';


var oldTestaments = <Bible>[];
var newTestaments = <Bible>[];
var biblePlan = <Bible>[];
Map _oldTestament, _newTestament;

void _getBible(BuildContext context) {
  _oldTestament = Translations.of(context).bible('old_testament');
  _oldTestament.forEach((key, value) => oldTestaments.add(Bible(key, value['title'], value['chapters'], false)));

  _newTestament = Translations.of(context).bible('new_testament');
  _newTestament.forEach((key, value) => newTestaments.add(Bible(key, value['title'], value['chapters'], false)));
}

void _setBibleOrder(Bible bible) {
  bool exist = false;
  for(int i=0; i<biblePlan.length; i++) {
    if(bible.title == biblePlan[i].title) {
      biblePlan.removeAt(i);
      exist = true;
    }
  }
  if(!exist) {
    biblePlan.add(bible);
  }
  // Make order
  for(int i=0; i<biblePlan.length; i++) {
    Bible currentBible = biblePlan[i];
    currentBible.setCheckOrder(i+1);
  }
  print('biblePlan: $biblePlan');
}

Widget _displayBibles(Bible bible, StateSetter bottomSheetState) {
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
        style: TextStyle(
          color: Colors.white
        ),
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
          color: bible.getChecked() ? AppColors.marine : AppColors.moreLightGray,
          borderRadius: BorderRadius.circular(20)
        ),
      ),
    ),
    onTap: () {
      bottomSheetState((){
        bible.setChecked(!bible.getChecked());
        _setBibleOrder(bible);
      });
      
    },
  );
}
/* 
List<Widget> _buildRowList() {
  List<Widget> lines = [];
  int count = 0;
  List<Widget> placesForLine = [];
  for(Bible bible in oldTestaments) {
    if(count % 3 == 0) {
      placesForLine = [];
    }
    placesForLine.add(_displayBibles(bible));
    lines.add(Row(children: placesForLine));
  }

  return lines;
} */

Widget selectBibleScreen(BuildContext context, StateSetter bottomSheetState) {
  return Container(
    padding: EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Padding(
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
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            Translations.of(context).trans('bible_selection_ment'),
            style: TextStyle(
              color: AppColors.darkGray,
              fontSize: 16
            ),
            textAlign: TextAlign.start,
          )
        ),
        Text(
          Translations.of(context).trans('old_testament'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16
          ),
          textAlign: TextAlign.start,
        ),
        /* Column(
          children: _buildRowList()
        ), */
        
        Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            shrinkWrap: true,
            children: oldTestaments.map((Bible bible){
              return Center(
                  child: _displayBibles(
                    bible, bottomSheetState
                  ),
                );
            }).toList(),
          )
        ), 
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            Translations.of(context).trans('new_testament'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            shrinkWrap: true,
            children: newTestaments.map((Bible bible){
              return Center(
                  child: _displayBibles(
                    bible, bottomSheetState
                  ),
                );
            }).toList(),
          )
        ), 
      ]
    )
  );
}

Future<void> goalBibleCustom1(BuildContext context, GestureTapCallback onClose) async {
  
  _getBible(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext builder) {
      return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSheetState) {
            return FractionallySizedBox(
              heightFactor: 1,
              child: Container(
                child: Column(
                  children: [
                    appBarCustom(context, Translations.of(context).trans('bible_plan_custom'), onClose),
                    selectBibleScreen(context, bottomSheetState)
                  ]
                ),
              ),
            );
          });
          
        }
      );
    }
  );
}