import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:christian_ordinary_life/src/screens/auth/login.dart';
import 'package:christian_ordinary_life/src/screens/auth/register.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends State {
  var userName = '';
  var userEmail = '';
  Widget memberInfo;
  SharedPreferences prefs;

  Future<Null> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("userName");
    });
  }

  Future<void> _logout() async {
    final result = await showConfirmDialog(
        context, Translations.of(context).trans('confirm_logout'));

    if (result == 'ok') {
      prefs.setString('userName', '');
      prefs.setString('userEmail', '');
      setState(() {
        userName = '';
        userEmail = '';
      });
    }
  }

  Widget _createDrawerItem(
      {IconData icon,
      String text,
      GestureTapCallback onTap,
      String linkURL,
      Color iconColor,
      Color textColor}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon,
              color: iconColor != null ? iconColor : AppColors.greenPointMild),
          Padding(
            padding: EdgeInsets.only(top: 3, left: 16.0),
            child: Text(
              text,
              style: TextStyle(
                  color: textColor != null ? textColor : AppColors.blackGreen,
                  fontSize: 18),
            ),
          )
        ],
      ),
      onTap: linkURL == null
          ? onTap
          : () async {
              if (userName == null || userName == '') {
                var result = await showConfirmDialog(
                    context, Translations.of(context).trans('login_needs'));

                if (result == 'ok') {
                  _showLogin(context);
                }
              } else {
                Navigator.pushReplacementNamed(context, linkURL);
              }
            },
    );
  }

  Widget loginJoin(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
            width: 40,
            height: 25,
            child: FlatButton(
              color: Colors.transparent,
              padding: EdgeInsets.all(0),
              splashColor: Colors.transparent,
              onPressed: () {
                _showLogin(context);
              },
              child: Text(
                Translations.of(context).trans('login'),
                style: TextStyle(color: AppColors.greenPoint, fontSize: 14),
              ),
            )),
        Text(' | ',
            style: TextStyle(color: AppColors.greenPoint, fontSize: 14)),
        SizedBox(
            width: 60,
            height: 25,
            child: FlatButton(
              color: Colors.transparent,
              padding: EdgeInsets.all(0),
              splashColor: Colors.transparent,
              onPressed: () {
                _showRegister(context);
              },
              child: Text(
                Translations.of(context).trans('register'),
                style: TextStyle(color: AppColors.greenPoint, fontSize: 14),
              ),
            )),
      ],
    );
  }

  Widget user(BuildContext context) {
    return Text((Translations.of(context).trans('manOfGod', param: userName)));
  }

  void _showLogin(BuildContext context) async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Login();
        });

    if (result == 'register') {
      _showRegister(context);
    } else if (result == 'success') {
      await SharedPreferences.getInstance().then((value) {
        userName = value.getString('userName') ?? '';

        setState(() {
          memberInfo = user(context);
        });
      });
    }
  }

  void _showRegister(BuildContext context) async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Register();
        });

    if (result == 'login') {
      _showLogin(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final _appTitle = GestureDetector(
        child: Container(
          height: 93,
          child: Row(
            children: [
              Text(
                Translations.of(context).trans('app_title1'),
                style: TextStyle(
                  color: AppColors.blackGreen,
                  fontSize: 20,
                ),
              ),
              Text(
                Translations.of(context).trans('app_title2'),
                style: TextStyle(color: AppColors.greenPoint, fontSize: 18),
              ),
              Text(
                Translations.of(context).trans('app_title3'),
                style: TextStyle(color: AppColors.blackGreen, fontSize: 20),
              ),
              Text(
                Translations.of(context).trans('app_title4'),
                style: TextStyle(color: AppColors.greenPoint, fontSize: 18),
              ),
              Text(
                Translations.of(context).trans('app_title5'),
                style: TextStyle(color: AppColors.blackGreen, fontSize: 20),
              ),
              Text(
                Translations.of(context).trans('app_title6'),
                style: TextStyle(color: AppColors.greenPoint, fontSize: 18),
              ),
            ],
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
          ),
          padding: EdgeInsets.only(top: 60, left: 20),
        ),
        onTap: () => {Navigator.pushReplacementNamed(context, '/')});

    if (userName == null || userName == '') {
      memberInfo = loginJoin(context);
    } else {
      memberInfo = user(context);
    }

    return Drawer(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/drawer_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _appTitle,
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: memberInfo),
              Divider(
                color: Colors.white,
              ),
              _createDrawerItem(
                  icon: Icons.location_searching,
                  text: Translations.of(context).trans('menu_goal_setting'),
                  linkURL: '/goalSetting'),
              _createDrawerItem(
                  icon: FontAwesomeIcons.bible,
                  text: Translations.of(context).trans('menu_reading_bible'),
                  linkURL: '/readingBible'),
              _createDrawerItem(
                  icon: FontAwesomeIcons.pen,
                  text: Translations.of(context).trans('menu_qt_record'),
                  linkURL: '/qtRecord'),
              _createDrawerItem(
                  icon: FontAwesomeIcons.heart,
                  text: Translations.of(context).trans('menu_thank_diary'),
                  linkURL: '/thankDiary'),
              _createDrawerItem(
                  icon: Icons.calendar_today,
                  text: Translations.of(context).trans('menu_calendar'),
                  linkURL: '/calendar'),
              _createDrawerItem(
                  icon: Icons.settings,
                  text: Translations.of(context).trans('menu_settings'),
                  linkURL: '/settings'),
              (userName == null || userName == '')
                  ? Text('')
                  : _createDrawerItem(
                      icon: FontAwesomeIcons.doorOpen,
                      text: Translations.of(context).trans('logout'),
                      onTap: () {
                        _logout();
                      },
                      iconColor: Colors.grey,
                      textColor: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
