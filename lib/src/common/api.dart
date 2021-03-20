import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/model/TransactionResult.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';

class API {
  //static String serverAddress = 'http://192.168.64.2/col/';
  static String serverAddress = 'https://christian-life.xyz/';
  static String qtLinkSwim =
      'http://qt.swim.org/user_utf/dailybible/user_print_web.php?edit_all=';
  static String qtLinkWordforToday =
      'https://www.rhema.co.nz/the-word-for-today';
  static String serverURL = serverAddress + 'apis/';
  static final String systemImageURL = serverAddress + 'images/system/';
  static final String diaryImageURL = serverAddress + 'images/diary/';
  static final String privacyPolicy = serverAddress + 'web/privacy_policy.php';

  static String register = serverURL + 'user/register.php';
  static String login = serverURL + 'user/login.php';
  static String resetPassword = serverURL + 'user/reset_password.php';
  static String changePassword = serverURL + 'user/change_password.php';
  static String checkLogin = serverURL + 'user/check_login.php';

  static String getUserGoal = serverURL + 'goal/get_user_goal.php';
  static String setUserGoal = serverURL + 'goal/set_user_goal.php';
  static String resetUserGoal = serverURL + 'goal/reset_user_goal.php';

  static String setPrayingProgress =
      serverURL + 'goal/set_praying_progress.php';

  static String setBibleProgress = serverURL + 'goal/set_bible_progress.php';
  static String getGoalProgress = serverURL + 'goal/get_goal_progress.php';
  static String getMonthGoalProgress =
      serverURL + 'goal/get_month_goal_progress.php';

  static String getBiblePlan = serverURL + 'reading_bible/bible_plan.php';
  static String bibleBooks = serverURL + 'reading_bible/bible_books.php';
  static String getBible = serverURL + 'reading_bible/get_bible.php';
  static String biblePlanList = serverURL + 'reading_bible/bible_plan_list.php';
  static String biblePlanDetail =
      serverURL + 'reading_bible/bible_plan_detail.php';
  static String todayBible = serverURL + 'reading_bible/get_today_bible.php';

  static String getThankCategoryList =
      serverURL + 'thank_diary/get_thank_category_list.php';
  static String thanksDiaryList =
      serverURL + 'thank_diary/thank_diary_list.php';
  static String thanksDiaryDetail =
      serverURL + 'thank_diary/thank_diary_detail.php';
  static String thanksDiaryWrite =
      serverURL + 'thank_diary/thank_diary_write.php';
  static String thanksDiaryDelete =
      serverURL + 'thank_diary/thank_diary_delete.php';

  static String qtRecordList = serverURL + 'qt_record/qt_record_list.php';
  static String qtRecordDetail = serverURL + 'qt_record/qt_record_detail.php';
  static String qtRecordWrite = serverURL + 'qt_record/qt_record_write.php';
  static String qtRecordDelete = serverURL + 'qt_record/qt_record_delete.php';

  static String biblePhrase = serverURL + 'bible_phrase/bible_phrase.php';

  static Future<dynamic> transaction(BuildContext context, var url,
      {Map param}) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    param['jwt'] = jwt;
    param['keepLogin'] = UserInfo.loginUser.keepLogin;

    //print('param: $param');
    final response = await http
        .post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': "application/json; charset=UTF-8"
            },
            body: jsonEncode(param))
        .catchError((e) {
      print(e.error);
    });

    try {
      //print(response.body);
      // Error
      if (response.statusCode != 200) {
        showAlertDialog(
            context, Translations.of(context).trans('error_message'));
        return null;
      } else if (response == null ||
          response.body == null ||
          response.body == '') {
        return null;
      }

      TransactionResult transactionResult =
          TransactionResult.fromJson(json.decode(response.body));

      if (transactionResult.errorMessage == 'Expired token') {
        logout(context, 'expired');
        return null;
      } else if (transactionResult.errorMessage == 'Invalid token') {
        logout(context, 'Invalid');
        return null;
      } else {
        Map<String, dynamic> map = json.decode(response.body);

        if (map['jwt'] != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('jwt', map['jwt']);
        }
      }
    } on Exception catch (exception) {
      errorMessage(context, exception);
      return null;
    } catch (error) {
      errorMessage(context, error);
      return null;
    }

    return response.body;
  }

  static Future<void> logout(BuildContext context, String errorType) async {
    String text = '';
    if (errorType == 'expired') {
      text = 'login_expired';
    } else {
      text = 'invalid_token';
    }

    await showAlertDialog(context, Translations.of(context).trans(text))
        .then((value) async {
      UserInfo userInfo = new UserInfo();
      userInfo.logtOutProcess(context);

      Navigator.pushReplacementNamed(context, '/');
    });
  }
}
