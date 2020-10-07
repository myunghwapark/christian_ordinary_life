import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/screens/auth/login.dart';
import 'package:christian_ordinary_life/src/screens/auth/register.dart';
import 'package:christian_ordinary_life/src/screens/auth/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  static User loginUser;
  SharedPreferences prefs;

  Future<User> getUserInfo() async {
    prefs = await SharedPreferences.getInstance();

    loginUser = new User();
    loginUser.name = prefs.getString("userName");
    loginUser.email = prefs.getString("userEmail");
    loginUser.seqNo = prefs.getString("userSeqNo");

    return loginUser;
  }

  Future<void> logout(BuildContext context) async {
    final result = await showConfirmDialog(
        context, Translations.of(context).trans('confirm_logout'));

    if (result == 'ok') {
      prefs.setString('userName', '');
      prefs.setString('userEmail', '');
      prefs.setString('userSeqNo', '');
    }
  }

  bool loginCheck() {
    if (loginUser == null || loginUser.name == null || loginUser.name == '') {
      return false;
    } else
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
      showRegister(context);
    } else if (result == 'resetPassword') {
      showResetPassword(context);
    } else if (result == 'success') {
      await SharedPreferences.getInstance().then((value) {
        loginUser = new User();
        loginUser.name = value.getString('userName') ?? '';
        loginUser.email = value.getString('userEmail') ?? '';
        loginUser.seqNo = value.getString('userSeqNo') ?? '';
      });

      if (method != null) {
        method();
      }
    }
  }

  void showRegister(BuildContext context) async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) {
          return Register();
        });

    if (result == 'login') {
      showLogin(context);
    }
  }

  void showResetPassword(BuildContext context) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext builder) => ResetPassword());
  }
}
