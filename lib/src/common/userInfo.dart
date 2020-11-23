import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/model/TransactionResult.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/screens/auth/login.dart';
import 'package:christian_ordinary_life/src/screens/auth/register.dart';
import 'package:christian_ordinary_life/src/screens/auth/resetPassword.dart';

class UserInfo {
  static User loginUser;
  SharedPreferences prefs;

  Future<User> getUserInfo() async {
    loginUser = new User();
    //final storage = new FlutterSecureStorage();
    // String jwt = await storage.read(key: "jwt");
    prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");

    if (jwt != null) {
      loginUser.jwt = jwt;

      loginUser = new User();
      loginUser.name = prefs.getString("userName");
      loginUser.email = prefs.getString("userEmail");
      loginUser.seqNo = prefs.getString("userSeqNo");
      loginUser.keepLogin = prefs.getBool("keepLogin");
    }

    return loginUser;
  }

  Future<void> logout(BuildContext context) async {
    final result = await showConfirmDialog(
        context, Translations.of(context).trans('confirm_logout'));

    if (result == 'ok') {
      logtOutProcess(context);
    }
  }

  Future<void> logtOutProcess(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', '');
    prefs.setString('userEmail', '');
    prefs.setString('userSeqNo', '');
    prefs.setBool('keepLogin', false);
    prefs.setString('jwt', '');

    loginUser = null;
  }

  bool loginCheck() {
    if (loginUser == null || loginUser.name == null || loginUser.name == '') {
      return false;
    } else
      return true;
  }

  Future<bool> checkLoginServer(BuildContext context) async {
    if (!loginCheck()) return false;

    TransactionResult result;
    try {
      await API.transaction(context, API.checkLogin,
          param: {'userSeqNo': UserInfo.loginUser.seqNo}).then((response) {
        if (response != null) {
          result = TransactionResult.fromJson(json.decode(response));
          if (result.result == 'success') {
            return true;
          }
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    }

    return true;
  }

  Future<void> showLogin(BuildContext context,
      {GestureTapCallback method}) async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Login();
        });

    if (result == 'register') {
      showRegister(context, callBackMethod: method);
    } else if (result == 'resetPassword') {
      showResetPassword(context);
    } else if (result == 'success') {
      prefs = await SharedPreferences.getInstance();

      loginUser = new User();
      loginUser.jwt = prefs.getString("jwt");
      loginUser.name = prefs.getString("userName");
      loginUser.email = prefs.getString("userEmail");
      loginUser.seqNo = prefs.getString("userSeqNo");

      if (method != null) {
        method();
      }
    }
  }

  void showRegister(BuildContext context,
      {GestureTapCallback callBackMethod}) async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Register();
        });

    if (result == 'login') {
      showLogin(context, method: callBackMethod);
    }
  }

  void showResetPassword(BuildContext context) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) => ResetPassword());
  }
}
