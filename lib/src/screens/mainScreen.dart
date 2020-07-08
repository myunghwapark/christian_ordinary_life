import 'package:flutter/material.dart';
import '../common/translations.dart';
import '../common/colors.dart';
import '../common/util.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>{

  Widget _createMainItems({String item, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: (<Widget>
        [
          Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 15),
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.marine,
              size: 35,
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, left: 16.0, bottom: 15),
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.marine,
                fontSize: 38,
                fontFamily: '12LotteMartHappy',
                fontWeight: FontWeight.w300,
              ),
            ),
          )
        ]),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios,
            color: AppColors.lightGray,
            size: 35,
          ),
          Expanded(
            
            child:Column(
              children: [
                // Date
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getTodayYear(context),
                        style: TextStyle(
                            fontFamily: '12LotteMartHappy',
                            fontWeight: FontWeight.w800,
                            fontSize:20,
                          ),
                        ),
                      Text(
                        getTodayFormat(context),
                        style: TextStyle(
                            fontFamily: '12LotteMartHappy',
                            fontSize:30,
                          ),
                      ),
                      ]
                  ), 
                  flex: 1,
                ),
                // Goal Check
                Flexible(
                  fit: FlexFit.tight,
                  child: ListView(
                    children: <Widget>[
                      _createMainItems(item: 'qt', text: Translations.of(context).trans('qt'), onTap: () => {

                      }),
                      _createMainItems(item: 'pray', text: Translations.of(context).trans('pray'), onTap: () => {

                      }),
                      _createMainItems(item: 'bible', text: Translations.of(context).trans('menu_reading_bible'), onTap: () => {

                      }),
                      _createMainItems(item: 'thank', text: Translations.of(context).trans('menu_thank_diary'), onTap: () => {

                      }),
                    ],
                  ),
                  flex: 2,
                ),
                // Scriptural phrase
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Translations.of(context).pharaseTrans('mark_9_23'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ]
                  )
                  ,
                  flex: 1,
                ),
              ]
            )
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.lightGray,
            size: 35,
          ),
        ],
      ),
      
        
    );
  }
}