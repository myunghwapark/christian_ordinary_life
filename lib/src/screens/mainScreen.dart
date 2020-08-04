import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/translations.dart';
import '../common/colors.dart';
import '../common/util.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  var _checkVars = {
    'qt': false,
    'praying': false,
    'bible': false,
    'thank': false,
  };

  String _year = '';
  String _date = '';
  DateTime _currentDateTime;

  @override
  void initState() {
    _currentDateTime = new DateTime.now();
    _year = getYear(_currentDateTime);
    _date = getDate(_currentDateTime);
    super.initState();
  }

  Widget _createMainItems({String item, String text}) {
    return ListTile(
        title: Row(
          children: (<Widget>[
            Container(
                padding: EdgeInsets.only(left: 8.0, bottom: 15),
                child: Icon(
                  _checkVars[item] == true
                      ? FontAwesomeIcons.checkCircle
                      : FontAwesomeIcons.circle,
                  color: _checkVars[item] == true
                      ? AppColors.marine
                      : AppColors.lightGray,
                  size: 35,
                )),
            Container(
              padding: EdgeInsets.only(top: 5, left: 14.0, bottom: 15),
              child: Text(
                text,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _checkVars[item] == true
                      ? AppColors.marine
                      : AppColors.lightGray,
                  fontSize: 30,
                  fontFamily: '12LotteMartHappy',
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
          ]),
        ),
        onTap: () {
          setState(() {
            _checkVars[item] = !_checkVars[item];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final _leftArrow = GestureDetector(
      child: Icon(
        Icons.arrow_back_ios,
        color: AppColors.lightGray,
        size: 35,
      ),
      onTap: () {
        setState(() {
          print('left button');
          _currentDateTime = _currentDateTime.add(new Duration(days: -1));
          _year = getYear(_currentDateTime);
          _date = getDate(_currentDateTime);
        });
      },
    );

    final _dateForm = Flexible(
      fit: FlexFit.tight,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _year,
              style: TextStyle(
                fontFamily: '12LotteMartHappy',
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            Text(
              _date,
              style: TextStyle(
                fontFamily: '12LotteMartHappy',
                fontSize: 30,
              ),
            ),
          ]),
      flex: 1,
    );

    final _goalCheck = Flexible(
      fit: FlexFit.tight,
      child: ListView(
        children: <Widget>[
          _createMainItems(
              item: 'qt', text: Translations.of(context).trans('qt')),
          _createMainItems(
              item: 'praying', text: Translations.of(context).trans('pray')),
          _createMainItems(
              item: 'bible',
              text: Translations.of(context).trans('menu_reading_bible')),
          _createMainItems(
              item: 'thank',
              text: Translations.of(context).trans('menu_thank_diary')),
        ],
      ),
      flex: 2,
    );

    final _rightArrow = GestureDetector(
      child: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.lightGray,
        size: 35,
      ),
      onTap: () {
        setState(() {
          print('right button');
          _currentDateTime = _currentDateTime.add(new Duration(days: 1));
          _year = getYear(_currentDateTime);
          _date = getDate(_currentDateTime);
        });
      },
    );

    final _scriptualPhrase = Flexible(
      fit: FlexFit.tight,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          Translations.of(context).pharaseTrans('mark_9_23'),
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ]),
      flex: 1,
    );

    return Container(
      child: Row(
        children: [
          _leftArrow,
          Expanded(
              child: Column(children: [
            _dateForm,
            _goalCheck,
            _scriptualPhrase,
          ])),
          _rightArrow,
        ],
      ),
    );
  }
}
