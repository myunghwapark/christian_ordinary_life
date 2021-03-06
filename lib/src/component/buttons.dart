import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:flutter/material.dart';

class AppButtons {
  Widget outerlineGreyButton(String title, GestureTapCallback method) {
    return OutlineButton(
      color: AppColors.almostWhite,
      child: Text(title),
      onPressed: method,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: AppColors.yellowishGreen)),
    );
  }

  Widget outerlineMintButton(String title, GestureTapCallback method) {
    return OutlineButton(
      onPressed: method,
      borderSide: BorderSide(color: AppColors.marine),
      shape: StadiumBorder(),
      child: Text(
        title,
        style: TextStyle(color: AppColors.greenPoint),
      ),
      highlightColor: AppColors.marine.withOpacity(0.1),
    );
  }

  Widget filledGreenButton(String title, GestureTapCallback method) {
    return SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: method,
          color: AppColors.greenPointMild,
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: AppColors.greenPointMild),
          ),
          child: Text(title, style: TextStyle(fontSize: 14)),
        ));
  }

  Widget filledGreyButton(String title, GestureTapCallback method) {
    return SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: method,
          color: Colors.grey,
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.grey),
          ),
          child: Text(title, style: TextStyle(fontSize: 14)),
        ));
  }

  Widget filledOrangeButton(String title, GestureTapCallback method) {
    return SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: method,
          color: Colors.orange[300],
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.orange[300]),
          ),
          child: Text(title, style: TextStyle(fontSize: 14)),
        ));
  }

  Widget filledWhiteMintButton(String title, GestureTapCallback method) {
    return SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: method,
          color: Colors.white,
          textColor: AppColors.darkGray,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: AppColors.mint),
          ),
          child: Text(title, style: TextStyle(fontSize: 14)),
        ));
  }

  Widget filledWhiteCustomButton(
      String title, GestureTapCallback method, Color borderColor) {
    return SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: method,
          color: Colors.white,
          textColor: AppColors.darkGray,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: borderColor),
          ),
          child: Text(title, style: TextStyle(fontSize: 14)),
        ));
  }
}
