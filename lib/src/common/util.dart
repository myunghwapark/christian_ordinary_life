import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';

String wrongImage() {
  return 'assets/images/wrong_image.png';
}

/*
  return type: String
  ex) 7월 22일 수요일 or Wednesday, July 22
*/
String getTodayFormat() {
  var now = new DateTime.now();
  return DateFormat.MMMMEEEEd().format(now);
}

/*
  return type: String
  ex) 2022년 or 2020
*/
String getTodayYear() {
  var now = new DateTime.now();
  return DateFormat.y().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 수요일 or Wednesday, July 22 2020
*/
String getDateOfWeek(DateTime now) {
  if (now == null) return '';
  return DateFormat.yMMMMEEEEd().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 or July 22 2020
*/
String getDate(DateTime now) {
  if (now == null) return '';
  return DateFormat.yMMMMd().format(now);
}

/*
  return type: String
  ex) 2022년 7월 22일 or 2020
*/
String getYear(DateTime now) {
  if (now == null) return '';
  return DateFormat.y().format(now);
}

/*
  return type: String
  ex) 2020-08-28
*/
String getToday() {
  var now = new DateTime.now();
  final template = DateFormat('yyyy-MM-dd');
  return template.format(now);
}

/*
  return type: String
  ex) 2020-08
*/
String getTodayYearMonth() {
  var now = new DateTime.now();
  final template = DateFormat('yyyy-MM');
  return template.format(now);
}

DateTime convertDateFromString(String strDate) {
  DateTime date = DateTime.parse(strDate);
  return date;
}

List timepickerChanged(List timeArray) {
  int hour = timeArray[0], minute = timeArray[1];
  List<String> timeStrings = new List<String>(2);

  if (hour < 10) {
    timeStrings[0] = '0' + hour.toString();
  } else {
    timeStrings[0] = hour.toString();
  }

  if (minute < 10) {
    timeStrings[1] = '0' + minute.toString();
  } else {
    timeStrings[1] = minute.toString();
  }

  return timeStrings;
}

Future<void> showAlertDialog(BuildContext context, String alertText) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(alertText),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<String> showConfirmDialog(BuildContext context, String alertText) async {
  String result = await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        //title: Text('AlertDialog Demo'),
        content: Text(alertText),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context, "ok");
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, "cancel");
            },
          ),
        ],
      );
    },
  );

  return result;
}

void showLoading(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showToast(GlobalKey<ScaffoldState> scaffordKey, String toastText,
    {SnackBarAction action}) {
  //final scaffold = Scaffold.of(context);
  scaffordKey.currentState.showSnackBar(SnackBar(
    content: Text(toastText),
    action: action != null ? action : null,
  ));
}

Future<String> showImageDialog(BuildContext context, Image image) async {
  AlertDialog alert = AlertDialog(
    content: new SingleChildScrollView(
      child: new ListBody(children: <Widget>[
        GestureDetector(
          child: Container(child: image != null ? image : null),
          onTap: () => Navigator.pop(context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.pop(context, "delete");
                  },
                )),
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.edit),
                color: Colors.grey,
                onPressed: () {
                  Navigator.pop(context, "edit");
                },
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: FlatButton(
                  child: Text(
                    Translations.of(context).trans('close'),
                    textAlign: TextAlign.right,
                  ),
                  color: Colors.grey.withOpacity(0.0),
                  onPressed: () {
                    Navigator.pop(context, "close");
                  },
                ))
          ],
        )
      ]),
    ),
  );

  String result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });

  return result;
}

bool validatePassword(String value) {
  Pattern pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*~]).{8,}$';
  RegExp regex = new RegExp(pattern);

  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

void errorMessage(BuildContext context, dynamic e) {
  showAlertDialog(context,
      (Translations.of(context).trans('error_message') + '\n' + e.toString()));
}

String getPlanPeriod(BuildContext context, String period) {
  if (period == null) return null;
  String _periodType = period.substring(period.length - 1, period.length);
  String _planPeriod = period.substring(0, period.length - 1);

  switch (_periodType) {
    case 'd':
      _periodType = Translations.of(context).trans("day");
      break;
    case 'w':
      _periodType = Translations.of(context).trans("week");
      break;
    default:
  }
  return _planPeriod + _periodType;
}

Size getSizes(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  final size = renderBox.size;
  return size;
}
