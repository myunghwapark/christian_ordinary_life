import 'package:flutter/material.dart';
import '../common/translations.dart';

Widget appBarCustom(BuildContext context, String title, GestureTapCallback onTap) {
  return Container(
    padding: EdgeInsets.only(top:15),
    color: Colors.teal,
    child: Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            }, 
          )
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 4,
          child: Text(
            Translations.of(context).trans('bible_plan_custom'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
            textAlign: TextAlign.center,
          )
        ),

        Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: FlatButton(
            child: Text(
              Translations.of(context).trans('next'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
            ),
            onPressed: onTap, 
          )
        )
      ]
    ),
  );
}