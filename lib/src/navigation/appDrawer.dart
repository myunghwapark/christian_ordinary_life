import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:christian_ordinary_life/src/common/goalInfo.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/model/TodayBible.dart';
import 'package:christian_ordinary_life/src/screens/goalSetting/goalSetting.dart';
import 'package:christian_ordinary_life/src/screens/processCalendar.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordList.dart';
import 'package:christian_ordinary_life/src/screens/readingBible/readingBible.dart';
import 'package:christian_ordinary_life/src/screens/settings/settings.dart';
import 'package:christian_ordinary_life/src/screens/thankDiary/thankDiaryList.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';

class AppDrawer extends StatefulWidget {
  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends State {
  UserInfo userInfo = new UserInfo();
  GoalInfo goalInfo = new GoalInfo();
  Widget memberInfo;
  TodayBible todayBible = new TodayBible();
  bool _isLoading = false;

  Widget _createDrawerItem(
      {String target,
      IconData icon,
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
              if (!userInfo.loginCheck()) {
                var result = await showConfirmDialog(
                    context, Translations.of(context).trans('login_needs'));

                if (result == 'ok') {
                  userInfo.showLogin(context, method: () {
                    setState(() {
                      memberInfo = user(context);

                      Navigator.pushReplacementNamed(context, '/');
                    });
                  });
                }
              } else {
                if (target != null && target == 'bible') {
                  if (todayBible.result == 'success') {
                    Navigator.pushReplacementNamed(context, linkURL,
                        arguments: todayBible);
                  } else {
                    showConfirmDialog(
                            context,
                            Translations.of(context)
                                .trans('no_bible_plan_ment'))
                        .then((value) {
                      if (value == 'ok') {
                        if (GoalInfo.goal.readingBible) {
                          goalInfo.goBiblePlan(context);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, GoalSetting.routeName);
                        }
                      } else {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    });
                  }
                } else {
                  Navigator.pushReplacementNamed(context, linkURL);
                }
              }
            },
    );
  }

  Widget loginJoin(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
            height: 40,
            child: TextButton(
              style: ButtonStyle(
                  //backgroundColor: Colors.transparent,
                  //padding: EdgeInsets.all(0),
                  //splashColor: Colors.transparent,
                  ),
              onPressed: () {
                userInfo.showLogin(context, method: () {
                  setState(() {
                    memberInfo = user(context);

                    Navigator.pushReplacementNamed(context, '/');
                  });
                });
              },
              child: Text(
                Translations.of(context).trans('login'),
                style: TextStyle(color: AppColors.greenPoint, fontSize: 14),
              ),
            )),
        Text(' | ',
            style: TextStyle(color: AppColors.greenPoint, fontSize: 14)),
        SizedBox(
            child: TextButton(
          /* color: Colors.transparent,
              padding: EdgeInsets.all(0),
              splashColor: Colors.transparent, */
          onPressed: () {
            userInfo.showRegister(context, callBackMethod: () {
              setState(() {
                memberInfo = user(context);

                Navigator.pushReplacementNamed(context, '/');
              });
            });
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
    return Text((Translations.of(context)
        .trans('manOfGod', param1: UserInfo.loginUser.name)));
  }

  Future<void> _getLoginInfo() async {
    await userInfo.getUserInfo().then((value) {
      if (this.mounted) {
        setState(() {
          UserInfo.loginUser = value;
        });
      }
    });
  }

  Future<void> _getTodaysBible() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await goalInfo.getTodaysBible(context).then((value) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          todayBible = value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getLoginInfo().then((value) {
      if (UserInfo.loginUser.seqNo != null) {
        _getTodaysBible();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
        onTap: () => Navigator.pushReplacementNamed(context, '/'));

    if (!userInfo.loginCheck()) {
      memberInfo = loginJoin(context);
    } else {
      memberInfo = user(context);
    }

    return Drawer(
        child: LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
      color: Colors.black,
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
                  icon: Icons.gps_fixed,
                  text: Translations.of(context).trans('menu_goal_setting'),
                  linkURL: GoalSetting.routeName),
              _createDrawerItem(
                  target: 'bible',
                  icon: FontAwesomeIcons.bible,
                  text: Translations.of(context).trans('menu_reading_bible'),
                  linkURL: ReadingBible.routeName),
              _createDrawerItem(
                  icon: FontAwesomeIcons.pen,
                  text: Translations.of(context).trans('menu_qt_record'),
                  linkURL: QTRecord.routeName),
              _createDrawerItem(
                  icon: FontAwesomeIcons.heart,
                  text: Translations.of(context).trans('menu_thank_diary'),
                  linkURL: ThankDiary.routeName),
              _createDrawerItem(
                  icon: Icons.calendar_today,
                  text: Translations.of(context).trans('menu_calendar'),
                  linkURL: ProcessCalendar.routeName),
              _createDrawerItem(
                  icon: Icons.settings,
                  text: Translations.of(context).trans('menu_settings'),
                  linkURL: Settings.routeName),
              (!userInfo.loginCheck())
                  ? Text('')
                  : _createDrawerItem(
                      icon: FontAwesomeIcons.doorOpen,
                      text: Translations.of(context).trans('logout'),
                      onTap: () {
                        userInfo.logout(context).then((value) => setState(() {
                              UserInfo.loginUser = null;
                              Navigator.pushReplacementNamed(context, '/');
                            }));
                      },
                      iconColor: Colors.grey,
                      textColor: Colors.grey[600]),
            ],
          ),
        ),
      ),
    ));
  }
}
