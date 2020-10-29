import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';
import 'package:christian_ordinary_life/src/component/componentStyle.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/model/User.dart';

class ResetPassword extends StatefulWidget {
  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  AppButtons appButtons = new AppButtons();
  ComponentStyle componentStyle = new ComponentStyle();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<User> _resetPassword() async {
    User userResult;
    try {
      final response = await API.transaction(context, API.resetPassword,
          param: {
            'recipientEmail': emailController.text,
            'language': CommonSettings.language
          });

      userResult = User.fromJson(json.decode(response));
      setState(() {
        _isLoading = false;
      });
      if (userResult.result == 'success') {
        showAlertDialog(context,
                Translations.of(context).trans('reset_password_success'))
            .then((value) => Navigator.pop(context));
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

  @override
  Widget build(BuildContext context) {
    final _background = Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );

    final _closeButton = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            Translations.of(context).trans('close'),
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );

    final _resetPasswordLabel = Text(
      Translations.of(context).trans('reset_password'),
      style: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontFamily: '12LotteMartHappy',
      ),
      textAlign: TextAlign.center,
    );

    final _ment = Text(
      Translations.of(context).trans('reset_password_ment'),
      style: TextStyle(color: AppColors.darkGray, fontSize: 16),
    );

    final _email = TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        maxLength: 20,
        validator: (value) {
          if (value.isEmpty) {
            return Translations.of(context).trans('validate_empty_email');
          } else if (!validateEmail(value)) {
            return Translations.of(context).trans('validate_wrong_email');
          }
          return null;
        },
        autofocus: false,
        decoration: componentStyle.whiteGreenInput(
            Translations.of(context).trans('email'), Icons.mail));

    final _sendButton = appButtons
        .filledGreenButton(Translations.of(context).trans('send'), () {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        _resetPassword();
      }
    });

    return LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
        color: Colors.black,
        child: Stack(children: <Widget>[
          _background,
          Positioned(
              child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            _closeButton,
                            _resetPasswordLabel,
                            SizedBox(height: 10.0),
                            _ment,
                            Container(
                              height: 20,
                            ),
                            _email,
                            SizedBox(height: 10.0),
                            _sendButton,
                            SizedBox(height: 14.0),
                          ],
                        ),
                      ))))
        ]));
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
