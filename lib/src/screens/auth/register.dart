import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';

class Register extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

Future<User> registerUser(BuildContext context, User user) async {
  User userResult;

  try {
    final response = await API.transaction(context, API.register, param: {
      'userName': user.name,
      'userEmail': user.email,
      'userPassword': user.password,
      'userGrade': 'U002_002'
    });

    userResult = User.fromJson(json.decode(response));

    // Success
    if (userResult.result == 'success') {
      showAlertDialog(
              context, Translations.of(context).trans('success_register'))
          .then((value) => Navigator.pop(context, 'login'));
    } else if (userResult.errorCode == '01') {
      final result = await showConfirmDialog(
          context, Translations.of(context).trans('duplicate_email'));

      if (result == 'ok') {
        Navigator.pop(context, 'login');
      }
    } else {
      showAlertDialog(
          context,
          (Translations.of(context).trans('register_fail_message') +
              '\n' +
              userResult.errorMessage));
    }
  } on Exception catch (exception) {
    errorMessage(context, exception);
  } catch (error) {
    errorMessage(context, error);
  }

  return userResult;
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordConfirmController = TextEditingController();

    _register(BuildContext context) {
      User newUser = User(
          email: emailController.text,
          name: nameController.text,
          password: passwordController.text);

      registerUser(context, newUser);
    }

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

    final _closeButton = AppBar(
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

    final _registerLabel = Text(
      Translations.of(context).trans('register'),
      style: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontFamily: '12LotteMartHappy',
      ),
      textAlign: TextAlign.center,
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
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        hintText: Translations.of(context).trans('email'),
        hintStyle: TextStyle(color: AppColors.greenPointMild),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        prefixIcon: Icon(
          Icons.mail,
          color: AppColors.greenPointMild,
        ),
      ),
    );

    final _name = TextFormField(
      controller: nameController,
      autofocus: false,
      maxLength: 15,
      validator: (value) {
        if (value.isEmpty) {
          return Translations.of(context).trans('validate_name');
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        hintText: Translations.of(context).trans('name'),
        hintStyle: TextStyle(color: AppColors.greenPointMild),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: AppColors.greenPointMild,
        ),
      ),
    );

    final _password = TextFormField(
      controller: passwordController,
      autofocus: false,
      maxLength: 20,
      obscureText: true,
      validator: (value) {
        if (value.isEmpty) {
          return Translations.of(context).trans('validate_empty_password');
        } else if (!validatePassword(value)) {
          return Translations.of(context).trans('validate_wrong_password');
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        hintText: Translations.of(context).trans('password'),
        hintStyle: TextStyle(color: AppColors.greenPointMild),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: AppColors.greenPointMild,
        ),
      ),
    );

    final _passwordConfirm = TextFormField(
      controller: passwordConfirmController,
      autofocus: false,
      obscureText: true,
      maxLength: 20,
      validator: (value) {
        if (value.isEmpty) {
          return Translations.of(context).trans('validate_empty_password');
        } else if (value != passwordController.text) {
          return Translations.of(context)
              .trans('validate_not_match_password_confirm');
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        hintText: Translations.of(context).trans('confirm_password'),
        hintStyle: TextStyle(color: AppColors.greenPointMild),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: AppColors.greenPointMild,
        ),
      ),
    );

    final _registerButton = SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _register(context);
            }
          },
          color: AppColors.greenPointMild,
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: AppColors.greenPointMild),
          ),
          child: Text(Translations.of(context).trans('register'),
              style: TextStyle(fontSize: 14)),
        ));

    return Stack(children: <Widget>[
      _background,
      Positioned(
        child: _closeButton,
      ),
      Positioned(
          child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _registerLabel,
                    Container(
                      height: 20,
                    ),
                    _email,
                    SizedBox(height: 10.0),
                    _name,
                    SizedBox(height: 10.0),
                    _password,
                    SizedBox(height: 10.0),
                    _passwordConfirm,
                    SizedBox(height: 14.0),
                    _registerButton,
                    SizedBox(height: 20.0),
                  ],
                ),
              )))
    ]);
  }
}
