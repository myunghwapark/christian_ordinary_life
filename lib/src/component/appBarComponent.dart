import 'package:flutter/material.dart';
import '../common/colors.dart';

Widget appBarComponent(BuildContext context, String title, GestureTapCallback onTap, Widget actionWidget) {
  return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.darkGray,
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      
      iconTheme: new IconThemeData(
        color: AppColors.lightGray,
      ),
      
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back_ios),
        onPressed: onTap == null? () => {
          Navigator.pop(context)
        } : onTap,
      ),

      actions: actionWidget != null ? <Widget>[actionWidget] : [],
      
    );
}
