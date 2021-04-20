import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/Goal.dart';
import 'package:christian_ordinary_life/src/screens/settings/changePassword.dart';
import 'package:christian_ordinary_life/src/screens/settings/donation.dart';
import 'package:christian_ordinary_life/src/screens/settings/howToUse.dart';
import 'package:christian_ordinary_life/src/screens/settings/privacyPolicy.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/component/customPicker.dart';
import 'package:christian_ordinary_life/src/model/Alarm.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  CommonSettings commonSettings = new CommonSettings();
  String _selectedLanguage;
  List<String> languageOption = [];
  CustomPicker _languagePicker;
  bool _first = true;
  Alarm qtAlarm = new Alarm();
  Alarm prayingAlarm = new Alarm();

  Future<void> _goalReset() async {
    var confirmResult = await showConfirmDialog(
        context, Translations.of(context).trans('confirm_reset_goal'));
    if (confirmResult == 'ok') {
      setState(() {
        _isLoading = true;
      });

      Goal result = new Goal();
      try {
        await API.transaction(context, API.resetUserGoal,
            param: {'userSeqNo': UserInfo.loginUser.seqNo}).then((response) {
          print(response);
          result = Goal.fromJson(json.decode(response));

          setState(() {
            _isLoading = false;
          });

          if (result.result == 'success') {
            showToast(
                context, Translations.of(context).trans('reset_goal_success'));
          } else if (result.errorCode == '02') {
            showToast(context, Translations.of(context).trans('no_goal'));
          } else {
            errorMessage(context, result.errorMessage);
          }
        });
      } on Exception catch (exception) {
        errorMessage(context, exception);
      } catch (error) {
        errorMessage(context, error);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goHowToUse() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HowToUse()));
  }

  void _goChangePassword() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChangePassword()));
  }

  void _goDonation() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Donation()));
  }

  void _goContactDeveloper() {
    _sendEmil();
  }

  void _goPrivacyPolicy() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PrivacyPolicy()));
  }

  Future<void> _sendEmil() async {
    final Email email = Email(
      subject: Translations.of(context).trans('contact_title'),
      recipients: ['christianlifemanager@gmail.com'],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _saveLanguage() async {
    await showConfirmDialog(
            context, Translations.of(context).trans('language_change_confirm'))
        .then((value) async {
      if (value == 'ok') {
        await commonSettings.setLanguage(_selectedLanguage);
      }
    });
  }

  void _showLanguagePicker() async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 2.5,
              child: _languagePicker);
        });

    if (result != null) _setLanguage(result);
  }

  void _setLanguage(int selected) {
    setState(() {
      _selectedLanguage = languageOption[selected];
      _saveLanguage();
    });
  }

  void _makeLanguageOption() {
    List<Widget> pickerList = [];
    for (int i = 0; i < languageOption.length; i++) {
      pickerList.add(Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Text(Translations.of(context).trans(languageOption[i])),
              )
            ],
          )));
    }
    CustomPicker customPicker = new CustomPicker(
      pickerList: pickerList,
      selectedItem: CommonSettings.language == 'ko' ? 0 : 1,
    );
    _languagePicker = customPicker;
  }

  @override
  Widget build(BuildContext context) {
    if (_first) {
      _makeLanguageOption();
      _first = false;
    }

    final _userSettingTitle = Container(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
      child: Text(
        Translations.of(context).trans('user'),
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );

    final _userSettings = Container(
        color: Colors.white,
        child: ListTile(
            title: Text(Translations.of(context).trans('change_password')),
            leading: Icon(
              Icons.lock,
              color: AppColors.yellowishGreenDarker,
            ),
            onTap: () {
              _goChangePassword();
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[350],
            )));

    final _commonSettingTitle = Container(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
      child: Text(
        Translations.of(context).trans('common'),
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );

    final _commonSettingUsageGuide = Container(
        color: Colors.white,
        child: ListTile(
          title: Text(Translations.of(context).trans('usage_guide')),
          //subtitle: 'English',
          leading: Icon(
            Icons.description,
            color: AppColors.yellowishGreenDarker,
          ),
          onTap: () {
            _goHowToUse();
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[350],
          ),
        ));

    final _commonSettingPrivacyPolicy = Container(
        color: Colors.white,
        child: ListTile(
          title: Text(Translations.of(context).trans('privacy_policy')),
          leading: Icon(Icons.security, color: AppColors.yellowishGreenDarker),
          onTap: () {
            _goPrivacyPolicy();
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[350],
          ),
        ));

    final _commonSettingContractDeveloper = Container(
        color: Colors.white,
        child: ListTile(
          title: Text(Translations.of(context).trans('contact_developer')),
          leading: Icon(Icons.send, color: AppColors.yellowishGreenDarker),
          onTap: () {
            _goContactDeveloper();
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[350],
          ),
        ));

    final _commonSettingDonation = Container(
        color: Colors.white,
        child: ListTile(
            title: Text(Translations.of(context).trans('donation')),
            leading: Icon(FontAwesomeIcons.donate,
                color: AppColors.yellowishGreenDarker),
            onTap: () {
              _goDonation();
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[350],
            )));

    final _appSettingTitle = Container(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
      child: Text(
        Translations.of(context).trans('setting'),
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
    );

    final _appSettingGoalReset = Container(
        color: Colors.white,
        child: ListTile(
          title: Text(Translations.of(context).trans('goal_reset')),
          leading:
              Icon(Icons.gps_not_fixed, color: AppColors.yellowishGreenDarker),
          onTap: () {
            _goalReset();
          },
          trailing: Container(
            width: 20,
          ),
        ));

    final _appSettingLanguage = Container(
      color: Colors.white,
      child: ListTile(
        title: Text(Translations.of(context).trans('language')),
        subtitle: Text(Translations.of(context).trans(_selectedLanguage)),
        leading: Icon(Icons.language, color: AppColors.yellowishGreenDarker),
        onTap: () {
          _showLanguagePicker();
        },
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[350],
        ),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.lightBgGray,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_settings')),
        drawer: AppDrawer(),
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: ListView(
              children: [
                _userSettingTitle,
                _userSettings,
                _commonSettingTitle,
                _commonSettingUsageGuide,
                _commonSettingPrivacyPolicy,
                _commonSettingContractDeveloper,
                _commonSettingDonation,
                _appSettingTitle,
                _appSettingGoalReset,
                _appSettingLanguage
              ],
            )));
  }

  @override
  void initState() {
    languageOption.add('ko');
    languageOption.add('en');

    _selectedLanguage = CommonSettings.language;

    super.initState();
  }
}
