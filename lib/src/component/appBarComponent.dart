import 'package:flutter/material.dart';
import '../common/colors.dart';

Widget appBarComponent(BuildContext context, String title,
    {Widget actionWidget}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: AppColors.darkGray, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.white,
    iconTheme: new IconThemeData(
      color: AppColors.lightGray,
    ),
    actions: actionWidget != null ? <Widget>[actionWidget] : [],
  );
}

Widget appBarBack(BuildContext context, String title,
    {GestureTapCallback onBackTap, Widget actionWidget}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: AppColors.darkGray, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.white,
    iconTheme: new IconThemeData(
      color: AppColors.lightGray,
    ),
    leading: new IconButton(
      icon: new Icon(Icons.arrow_back_ios),
      onPressed: onBackTap == null ? () => Navigator.pop(context) : onBackTap,
    ),
    actions: actionWidget != null ? <Widget>[actionWidget] : [],
  );
}

Widget appBarCustom(
  BuildContext context,
  String title, {
  String leaderText,
  GestureTapCallback onLeaderTap,
  String actionText,
  GestureTapCallback onActionTap,
}) {
  return Container(
    height: 70,
    padding: EdgeInsets.only(top: 10),
    color: Colors.teal,
    child: Row(children: [
      Container(
          width: 86,
          child: FlatButton(
            child: Text(
              leaderText,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            onPressed: onLeaderTap == null
                ? () => Navigator.pop(context)
                : onLeaderTap,
          )),
      Expanded(
          child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
        textAlign: TextAlign.center,
      )),
      Container(
          width: 86,
          child: FlatButton(
            child: Text(
              actionText,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            onPressed: onActionTap,
          ))
    ]),
  );
}

Widget sliverAppBar(BuildContext context, String title, {Widget actionWidget}) {
  return SliverAppBar(
    title: Text(
      title,
      style: TextStyle(color: AppColors.darkGray, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.white,
    iconTheme: new IconThemeData(
      color: AppColors.lightGray,
    ),
    floating: true,
    expandedHeight: 50,
    actions: actionWidget != null ? <Widget>[actionWidget] : [],
  );
}
