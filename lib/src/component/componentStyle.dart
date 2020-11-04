import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:flutter/material.dart';

class ComponentStyle {
  InputDecoration whiteGreenInput(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      hintText: hint,
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
        icon,
        color: AppColors.greenPointMild,
      ),
      errorMaxLines: 3,
    );
  }

  InputDecoration whiteGreyInput(String hint) {
    return InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[400], width: 2),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ));
  }

  BoxDecoration radius5() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)));
  }
}
