import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:christian_ordinary_life/src/screens/auth/login.dart';
import 'package:christian_ordinary_life/src/screens/auth/register.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';

class AppDrawer extends StatelessWidget {
  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.greenPointMild),
          Padding(
            padding: EdgeInsets.only(top: 3, left: 16.0),
            child: Text(
              text,
              style: TextStyle(color: AppColors.blackGreen, fontSize: 18),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    void _showLogin() async {
      final result = await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext builder) {
            return Login();
          });

      if (result != null) {}
    }

    void _showRegister() async {
      final result = await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext builder) {
            return Register();
          });

      if (result != null) {}
    }

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
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          width: 40,
                          height: 25,
                          child: FlatButton(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(0),
                            splashColor: Colors.transparent,
                            onPressed: _showLogin,
                            child: Text(
                              Translations.of(context).trans('login'),
                              style: TextStyle(
                                  color: AppColors.greenPoint, fontSize: 14),
                            ),
                          )),
                      Text(' | ',
                          style: TextStyle(
                              color: AppColors.greenPoint, fontSize: 14)),
                      SizedBox(
                          width: 55,
                          height: 25,
                          child: FlatButton(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(0),
                            splashColor: Colors.transparent,
                            onPressed: _showRegister,
                            child: Text(
                              Translations.of(context).trans('register'),
                              style: TextStyle(
                                  color: AppColors.greenPoint, fontSize: 14),
                            ),
                          )),
                    ],
                  )),
              Divider(
                color: Colors.white,
              ),
              _createDrawerItem(
                  icon: Icons.location_searching,
                  text: Translations.of(context).trans('menu_goal_setting'),
                  onTap: () => {
                        Navigator.pushReplacementNamed(context, '/goalSetting')
                      }),
              _createDrawerItem(
                  icon: FontAwesomeIcons.bible,
                  text: Translations.of(context).trans('menu_reading_bible'),
                  onTap: () => {
                        Navigator.pushReplacementNamed(context, '/readingBible')
                      }),
              _createDrawerItem(
                  icon: FontAwesomeIcons.pen,
                  text: Translations.of(context).trans('menu_qt_record'),
                  onTap: () =>
                      {Navigator.pushReplacementNamed(context, '/qtRecord')}),
              _createDrawerItem(
                  icon: FontAwesomeIcons.heart,
                  text: Translations.of(context).trans('menu_thank_diary'),
                  onTap: () =>
                      {Navigator.pushReplacementNamed(context, '/thankDiary')}),
              _createDrawerItem(
                  icon: Icons.calendar_today,
                  text: Translations.of(context).trans('menu_calendar'),
                  onTap: () =>
                      {Navigator.pushReplacementNamed(context, '/calendar')}),
              _createDrawerItem(
                  icon: Icons.settings,
                  text: Translations.of(context).trans('menu_settings'),
                  onTap: () =>
                      {Navigator.pushReplacementNamed(context, '/settings')}),
            ],
          ),
        ),
      ),
    );
  }
}
