import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../navigation/appDrawer.dart';
import '../../component/appBarComponent.dart';
import '../../common/translations.dart';
import '../../common/colors.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ],
            ),
            SettingsSection(
              title: Translations.of(context).trans('backup_restoration'),
              tiles: [
                SettingsTile(
                  title:
                      Translations.of(context).trans('sending_data_by_email'),
                  leading: Icon(Icons.email),
                  onTap: () {},
                ),
                SettingsTile(
                  title: Translations.of(context).trans('data_restoration'),
                  leading: Icon(Icons.restore),
                  onTap: () {},
                ),
              ],
            ),
            SettingsSection(
              title: Translations.of(context).trans('info'),
              tiles: [
                SettingsTile(
                  title: Translations.of(context).trans('bug_report'),
                  leading: Icon(FontAwesomeIcons.bug),
                  onTap: () {},
                ),
                SettingsTile(
                  title: Translations.of(context).trans('writing_review'),
                  leading: Icon(Icons.rate_review),
                  onTap: () {},
                ),
                SettingsTile(
                  title: Translations.of(context).trans('donation'),
                  leading: Icon(FontAwesomeIcons.donate),
                  onTap: () {},
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
