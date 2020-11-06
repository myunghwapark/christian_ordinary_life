import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/component/buttons.dart';
import 'package:christian_ordinary_life/src/component/componentStyle.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/model/User.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AppButtons appButtons = new AppButtons();
  ComponentStyle componentStyle = new ComponentStyle();
  CommonSettings commonSettings = new CommonSettings();

  bool _keepMeLoginVar = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<User> loginUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('keepLogin', _keepMeLoginVar);

    User userResult;
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await API.transaction(context, API.login, param: {
        'userEmail': user.email,
        'userPassword': user.password,
        'keepLogin': _keepMeLoginVar
      });
      userResult = User.fromJson(json.decode(response));
      setState(() {
        _isLoading = false;
      });

      if (userResult.result == 'success') {
        // Save user information
        prefs.setString('userName', userResult.name);
        prefs.setString('userEmail', userResult.email);
        prefs.setString('userSeqNo', userResult.seqNo);

        Navigator.pop(context, 'success');
      } else if (userResult.errorCode == '01') {
        showAlertDialog(
            context, Translations.of(context).trans('wrong_information'));
      } else {
        showAlertDialog(
            context,
            (Translations.of(context).trans('login_fail_message') +
                '\n' +
                userResult.errorMessage));
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

  void getKeepLogin() async {
    setState(() {
      _keepMeLoginVar = UserInfo.loginUser.keepLogin == null
          ? false
          : UserInfo.loginUser.keepLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final background = Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );

    final closeButton = AppBar(
      title: Text(""),
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
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

    final loginLabel = Text(
      Translations.of(context).trans('login'),
      style: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontFamily: '12LotteMartHappy',
      ),
      textAlign: TextAlign.center,
    );

    final email = TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        maxLength: 50,
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

    final password = TextFormField(
        controller: passwordController,
        maxLength: 20,
        autofocus: false,
        obscureText: true,
        validator: (value) {
          if (value.isEmpty) {
            return Translations.of(context).trans('validate_empty_password');
          }
          return null;
        },
        decoration: componentStyle.whiteGreenInput(
            Translations.of(context).trans('password'), Icons.lock));

    final keepLogin = Row(children: <Widget>[
      Theme(
          data: ThemeData(unselectedWidgetColor: AppColors.greenPointMild),
          child: Checkbox(
            value: _keepMeLoginVar,
            onChanged: (bool newValue) => {
              setState(() {
                _keepMeLoginVar = newValue;
              })
            },
            activeColor: AppColors.greenPointMild,
          )),
      Text(Translations.of(context).trans('keep_login')),
    ]);

    final loginButton = appButtons
        .filledGreenButton(Translations.of(context).trans('login'), () {
      if (_formKey.currentState.validate()) {
        hideKeyboard(context);
        User userInfo = User(
            email: emailController.text, password: passwordController.text);

        loginUser(userInfo);
      }
    });

    final labelOr = Container(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Divider(
                color: AppColors.greenPointMild,
              ),
            ),
            Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  'OR',
                  style: TextStyle(color: AppColors.greenPointMild),
                )),
            Flexible(
                flex: 1,
                child: Divider(
                  color: AppColors.greenPointMild,
                ))
          ],
        ));

    final otherOption = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context, 'register');
          },
          child: Text(
            Translations.of(context).trans('register'),
            style: TextStyle(color: AppColors.greenPoint),
          ),
        ),
        Text(' | '),
        GestureDetector(
          child: Text(
            Translations.of(context).trans('reset_password'),
            style: TextStyle(color: AppColors.greenPoint),
          ),
          onTap: () {
            Navigator.pop(context, 'resetPassword');
          },
        ),
      ],
    );

    return Stack(children: <Widget>[
      background,
      Positioned(
          child: LoadingOverlay(
              isLoading: _isLoading,
              opacity: 0.5,
              progressIndicator: CircularProgressIndicator(),
              color: Colors.black,
              child: GestureDetector(
                  onTap: () {
                    hideKeyboard(context);
                  },
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
                                closeButton,
                                loginLabel,
                                Container(
                                  height: 20,
                                ),
                                email,
                                SizedBox(height: 10.0),
                                password,
                                keepLogin,
                                loginButton,
                                labelOr,
                                otherOption,
                                Padding(
                                  padding: EdgeInsets.all(110),
                                ),
                              ],
                            ),
                          ))))))
    ]);
  }

  @override
  void initState() {
    getKeepLogin();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
