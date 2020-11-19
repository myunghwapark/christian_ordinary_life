import 'package:flutter/material.dart';
import '../common/colors.dart';

Widget appBarComponent(BuildContext context, String title,
    {Widget actionWidget}) {
  return AppBar(
    centerTitle: true,
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
    centerTitle: true,
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
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Colors.teal,
    leadingWidth: 95,
    leading: FlatButton(
      child: Text(
        leaderText,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      onPressed:
          onLeaderTap == null ? () => Navigator.pop(context) : onLeaderTap,
    ),
    actions: <Widget>[
      FlatButton(
        child: Text(
          actionText,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        onPressed: onActionTap,
      )
    ],
  );
}

Widget sliverAppBar(BuildContext context, String title, {Widget actionWidget}) {
  return SliverAppBar(
    centerTitle: true,
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
