import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:flutter/material.dart';

class AppButtons {
  Widget outerlineGreyButton(String title, GestureTapCallback method) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: AppColors.almostWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: AppColors.yellowishGreen))),
      child: Text(
        title,
        style: TextStyle(color: AppColors.darkGray),
      ),
      onPressed: method,
    );
  }

  Widget outerlineMintButton(String title, GestureTapCallback method) {
    return OutlinedButton(
      onPressed: method,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.marine),
        shape: StadiumBorder(),
        onSurface: AppColors.marine.withOpacity(0.1),
      ),
      child: Text(
        title,
        style: TextStyle(color: AppColors.greenPoint),
      ),
    );
  }

  Widget filledGreenButton(String title, GestureTapCallback method) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: method,
          style: ElevatedButton.styleFrom(
            primary: AppColors.greenPointMild,
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: AppColors.greenPointMild),
            ),
          ),
          child:
              Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
        ));
  }

  Widget filledGreyButton(String title, GestureTapCallback method) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: method,
          style: ElevatedButton.styleFrom(
              primary: Colors.grey,
              padding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Colors.grey),
              )),
          child: Text(title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              )),
        ));
  }

  Widget filledOrangeButton(String title, GestureTapCallback method) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: method,
          style: ElevatedButton.styleFrom(
            primary: Colors.orange[300],
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.orange[300]),
            ),
          ),
          child: Text(title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              )),
        ));
  }

  Widget filledWhiteMintButton(String title, GestureTapCallback method) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: method,
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: AppColors.mint),
            ),
          ),
          child: Text(title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGray,
              )),
        ));
  }

  Widget filledWhiteCustomButton(
      String title, GestureTapCallback method, Color borderColor) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: method,
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: borderColor),
            ),
          ),
          child: Text(title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGray,
              )),
        ));
  }
}
