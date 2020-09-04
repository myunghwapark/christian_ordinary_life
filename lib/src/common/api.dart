import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';

class API {
  static String serverURL = 'http://192.168.64.2/col/apis/';

  static String register = serverURL + 'user/register.php';
  static String login = serverURL + 'user/login.php';

  static String getUserGoal = serverURL + 'goal/get_user_goal.php';
  static String setUserGoal = serverURL + 'goal/set_user_goal.php';

  static String setPrayingProgress =
      serverURL + 'goal/set_praying_progress.php';

  static String setBibleProgress = serverURL + 'goal/set_bible_progress.php';
  static String getGoalProgress = serverURL + 'goal/get_goal_progress.php';

  static String bibleBooks = serverURL + 'reading_bible/bible_books.php';
  static String getBible = serverURL + 'reading_bible/get_bible.php';
  static String biblePlanList = serverURL + 'reading_bible/bible_plan_list.php';
  static String biblePlanDetail =
      serverURL + 'reading_bible/bible_plan_detail.php';
  static String todayBible = serverURL + 'reading_bible/get_today_bible.php';

  static String thanksDiaryList =
      serverURL + 'thank_diary/thank_diary_list.php';
  static String thanksDiaryWrite =
      serverURL + 'thank_diary/thank_diary_write.php';
  static String thanksDiaryDelete =
      serverURL + 'thank_diary/thank_diary_delete.php';

  static String qtRecordList = serverURL + 'qt_record/qt_record_list.php';
  static String qtRecordWrite = serverURL + 'qt_record/qt_record_write.php';
  static String qtRecordDelete = serverURL + 'qt_record/qt_record_delete.php';

  static Future<dynamic> transaction(BuildContext context, String url,
      {Object param}) async {
    final response = await http
        .post(url,
            headers: <String, String>{
              'Content-Type': "application/json; charset=UTF-8"
            },
            body: jsonEncode(param))
        .catchError((e) {
      print(e.error);
    });

    try {
      // Error
      if (response.statusCode != 200) {
        showAlertDialog(
            context, Translations.of(context).trans('error_message'));
        return null;
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
}
