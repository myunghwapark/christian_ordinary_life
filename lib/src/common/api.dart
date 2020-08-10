import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';

class API {
  static String serverURL = 'http://192.168.64.2/col/apis/';

  static String register = serverURL + 'user/register.php';
  static String login = serverURL + 'user/login.php';
  static String thanksDiaryList =
      serverURL + 'thank_diary/thank_diary_list.php';
  static String thanksDiaryDetail =
      serverURL + 'thank_diary/thank_diary_detail.php';
  static String thanksDiaryWrite =
      serverURL + 'thank_diary/thank_diary_write.php';
  static String thanksDiaryDelete =
      serverURL + 'thank_diary/thank_diary_delete.php';

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