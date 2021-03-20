import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/component/componentStyle.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController _curPasswordController = new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _confirmNewPasswordController =
      new TextEditingController();
  ComponentStyle componentStyle = new ComponentStyle();

  Future<User> _changePassword() async {
    User userResult;
    try {
      final response =
          await API.transaction(context, API.changePassword, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'userEmail': UserInfo.loginUser.email,
        'oldPassword': _curPasswordController.text,
        'newPassword': _newPasswordController.text
      });

      userResult = User.fromJson(json.decode(response));
      setState(() {
        _isLoading = false;
      });
      if (userResult.result == 'success') {
        showAlertDialog(
                context, Translations.of(context).trans('password_changed'))
            .then((value) => Navigator.pop(context));
      } else if (userResult.errorCode == '00') {
        showAlertDialog(
            context, Translations.of(context).trans('not_match_cur_password'));
      } else {
        showAlertDialog(context,
            '[' + userResult.errorCode + ']' + userResult.errorMessage);
      }
    } on Exception catch (exception) {
      errorMessage(context, exception);
    } catch (error) {
      errorMessage(context, error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    return userResult;
  }

  void _apply() {
    if (_formKey.currentState.validate()) {
      hideKeyboard(context);
      setState(() {
        _isLoading = true;
        _changePassword();
      });
    }
  }

  Widget _actionIcon() {
    return TextButton(
      child: Text(Translations.of(context).trans('apply'),
          style: TextStyle(color: AppColors.darkGray)),
      onPressed: _apply,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _oldPassword = Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          maxLength: 20,
          obscureText: true,
          controller: _curPasswordController,
          decoration: componentStyle.whiteGreyInput(
              Translations.of(context).trans('current_password')),
          validator: (value) {
            if (value.isEmpty) {
              return Translations.of(context).trans('validate_empty_password');
            } else if (!validatePassword(value)) {
              return Translations.of(context).trans('validate_wrong_password');
            }
            return null;
          },
        ));

    final _newPassword = Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          maxLength: 20,
          obscureText: true,
          controller: _newPasswordController,
          decoration: componentStyle
              .whiteGreyInput(Translations.of(context).trans('new_password')),
          validator: (value) {
            if (value.isEmpty) {
              return Translations.of(context).trans('validate_empty_password');
            } else if (!validatePassword(value)) {
              return Translations.of(context).trans('validate_wrong_password');
            }
            return null;
          },
        ));

    final _confirmNewPassword = Padding(
        padding: EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          maxLength: 20,
          obscureText: true,
          controller: _confirmNewPasswordController,
          decoration: componentStyle.whiteGreyInput(
              Translations.of(context).trans('new_password_confirm')),
          validator: (value) {
            if (value.isEmpty) {
              return Translations.of(context).trans('validate_empty_password');
            } else if (value != _newPasswordController.text) {
              return Translations.of(context)
                  .trans('validate_not_match_password_confirm');
            }
            return null;
          },
        ));

    return Scaffold(
        appBar: appBarComponent(
            context, Translations.of(context).trans('change_password'),
            actionWidget: _actionIcon()),
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _oldPassword,
                              _newPassword,
                              _confirmNewPassword
                            ]))))));
  }
}
