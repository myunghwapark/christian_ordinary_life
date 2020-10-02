import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/screens/settings/contactDeveloper.dart';
import 'package:christian_ordinary_life/src/screens/settings/donation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _goalReset() async {
    var confirmResult = await showConfirmDialog(
        context, Translations.of(context).trans('confirm_reset_goal'));
    if (confirmResult == 'ok') {
      Goal result = new Goal();
      try {
        await API.transaction(context, API.resetUserGoal,
            param: {'userSeqNo': UserInfo.loginUser.seqNo}).then((response) {
          result = Goal.fromJson(json.decode(response));
          if (result.result == 'success') {
            showToast(_scaffoldKey,
                Translations.of(context).trans('reset_goal_success'));
          } else if (result.errorCode == '02') {
            showToast(_scaffoldKey, Translations.of(context).trans('no_goal'));
          } else {
            errorMessage(context, result.errorMessage);
          }
        });
      } on Exception catch (exception) {
        errorMessage(context, exception);
      } catch (error) {
        errorMessage(context, error);
      }
    }
  }

  void _goDonation() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Donation()));
  }

  void _goContactDeveloper() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ContactDeveloper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.lightBgGray,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_settings')),
        drawer: AppDrawer(),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Translations.of(context).trans('common'),
              tiles: [
                SettingsTile(
                  title: Translations.of(context).trans('usage_guide'),
                  //subtitle: 'English',
                  leading: Icon(Icons.description),
                  onTap: () {},
                ),
                SettingsTile(
                  title: Translations.of(context).trans('privacy_policy'),
                  leading: Icon(Icons.security),
                  onTap: () {},
                ),
                SettingsTile(
                  title: Translations.of(context).trans('goal_reset'),
                  leading: Icon(Icons.gps_not_fixed),
                  onTap: _goalReset,
                ),
              ],
            ),
            SettingsSection(
              title: Translations.of(context).trans('info'),
              tiles: [
                SettingsTile(
                  title: Translations.of(context).trans('contact_developer'),
                  leading: Icon(FontAwesomeIcons.bug),
                  onTap: () {
                    _goContactDeveloper();
                  },
                ),
                /* SettingsTile(
                  title: Translations.of(context).trans('writing_review'),
                  // leading: Icon(Icons.rate_review),
                  leading: Icon(Icons.mood),
                  onTap: () {},
                ), */
                SettingsTile(
                  title: Translations.of(context).trans('donation'),
                  leading: Icon(FontAwesomeIcons.donate),
                  onTap: () {
                    _goDonation();
                  },
                ),
                /* SettingsTile.switchTile(
                title: 'Use fingerprint',
                leading: Icon(Icons.fingerprint),
                switchValue: value,
                onToggle: (bool value) {},
              ), */
              ],
            ),
          ],
        ));
  }
}
