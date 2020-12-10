import 'package:flutter/material.dart';

Widget timeBox(BuildContext context, String _setHour, String _setMinute,
    Color _setColor, GestureTapCallback onTap) {
  return InkWell(
      child: Container(
        width: 155,
        padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 50,
              height: 40,
              child: Center(
                  child: Text(
                _setHour,
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: _setColor,
              ),
            ),
            Container(
                padding: EdgeInsets.all(5),
                child: Text(':', style: TextStyle(color: _setColor))),
            Container(
              width: 50,
              height: 40,
              child: Center(
                  child:
                      Text(_setMinute, style: TextStyle(color: Colors.white))),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: _setColor,
              ),
            ),
          ],
        ),
      ),
      onTap: onTap);
}
