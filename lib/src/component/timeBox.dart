import 'package:flutter/material.dart';
import '../common/colors.dart';


Widget timeBox(BuildContext context, String timeTitle, bool visibleVar, String _setHour, String _setMinute, Color _setColor, GestureTapCallback onTap) {

  
  return Visibility(
    visible: visibleVar,
    child: InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 10, left:20, right:20, bottom: 10),
        margin: EdgeInsets.only(top:5, left:10, right:10, bottom:20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              timeTitle,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.greenPoint
              ),
            ),
            Spacer(flex: 1,),
            Container(
              width: 50,
              height: 40,
              child: Center(
                child: Text(
                  _setHour, 
                  style:TextStyle(
                    color: Colors.white,
                  ),
                )
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: _setColor,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:Text(':', style:TextStyle(
                color: AppColors.marine))
            ),
            Container(
              width: 50,
              height: 40,
              child: Center(
                child:Text(
                  _setMinute, style:TextStyle(
                  color: Colors.white)
                )
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: _setColor,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
        ),
      ),
      onTap: onTap
    )
  );
}