import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/screens/auth/register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _keepMeLoginVar = false;
  final _formKey = GlobalKey<FormState>();

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
      maxLength: 20,
      validator: (value) {
        if (value.isEmpty) {
          return Translations.of(context).trans('validate_empty_email');
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

    final loginButton = SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {}
          },
          color: AppColors.greenPointMild,
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: AppColors.greenPointMild),
          ),
          child: Text(Translations.of(context).trans('login'),
              style: TextStyle(fontSize: 14)),
        ));

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
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext builder) {
                  return Register();
                });
          },
          child: Text(
            Translations.of(context).trans('register'),
            style: TextStyle(color: AppColors.greenPoint),
          ),
        ),
        Text(' | '),
        GestureDetector(
          onTap: () {},
          child: Text(
            Translations.of(context).trans('reset_password'),
            style: TextStyle(color: AppColors.greenPoint),
          ),
        ),
      ],
    );

    return Stack(children: <Widget>[
      background,
      Positioned(
        child: closeButton,
      ),
      Positioned(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
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
                    SizedBox(height: 14.0),
                  ],
                ),
              )))
    ]);
  }
}
