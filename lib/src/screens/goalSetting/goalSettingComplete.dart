import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/userInfo.dart';

class GoalSettingComplete extends StatefulWidget {
  final bool nothingSelected;
  GoalSettingComplete(this.nothingSelected);

  @override
  GoalSettingCompleteState createState() => GoalSettingCompleteState();
}

class GoalSettingCompleteState extends State<GoalSettingComplete> {
  @override
  Widget build(BuildContext context) {
    final background = Container(
      decoration: new BoxDecoration(color: AppColors.blueSky),
    );

    final closeButton = AppBar(
      title: Text(Translations.of(context).trans('goal_set_complete_title')),
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          child: Text(
            Translations.of(context).trans('confirm'),
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
      leading: Container(),
    );

    String normarMent = Translations.of(context).trans('goal_setted');
    String nothingMent = Translations.of(context)
        .trans('goal_setted_nothing', param1: UserInfo.loginUser.name);

    return Stack(children: <Widget>[
      background,
      Positioned.fill(
        child: Image.asset(
          "assets/images/church_bg.png",
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomLeft,
        ),
      ),
      Positioned(
        child: closeButton,
      ),
      Positioned(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Text(
              widget.nothingSelected ? nothingMent : normarMent,
              style: TextStyle(
                  color: AppColors.darkGray,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            )),
            SizedBox(
              height: 30,
            ),
            Image(
              image: AssetImage(CommonSettings.language == "ko"
                  ? "assets/images/cheers_ko.png"
                  : "assets/images/cheers_en.png"),
              width: MediaQuery.of(context).copyWith().size.width - 100,
            ),
            SizedBox(
              height: 90,
            ),
          ],
        ),
      ))
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
