import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:christian_ordinary_life/src/component/calendar.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';

String wrongImage() {
  return 'assets/images/temp_image.png';
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
  ex) 2020-08-28
*/
String getCalDateFormat(DateTime now) {
  if (now == null) return null;
  final template = DateFormat('yyyy-MM-dd');
  return template.format(now);
}

/*
  return type: String
  ex) 2020-08
*/
String getTodayYearMonth(DateTime now) {
  final template = DateFormat('yyyy-MM');
  return template.format(now);
}

bool isBeforeDate(DateTime compareDate) {
  var now = new DateTime.now();
  return compareDate.isBefore(now);
}

int dateDifferenceInDays(DateTime targetDate) {
  DateTime now = new DateTime.now();
  int different = targetDate.difference(now).inDays;

  return different;
}

int dateDifferenceInHours(DateTime targetDate) {
  DateTime now = new DateTime.now();
  int different = targetDate.difference(now).inHours;

  return different;
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
            child: Text(Translations.of(context).trans('cancel')),
            onPressed: () {
              Navigator.pop(context, "cancel");
            },
          ),
          FlatButton(
            child: Text(Translations.of(context).trans('confirm')),
            onPressed: () {
              Navigator.pop(context, "ok");
            },
          ),
        ],
      );
    },
  );

  return result;
}

Future<DateTime> showCalendar(
    BuildContext context, DateTime date, double topPadding) async {
  final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext builder) {
        return Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: topPadding,
            ),
            child: Calendar(date));
      });

  return result;
}

void showToast(GlobalKey<ScaffoldState> scaffoldKey, String toastText,
    {SnackBarAction action}) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
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
                flex: 2,
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
  Pattern pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*~]).{8,}$';
  // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*~]).{8,}$';
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
  if (e.toString() != 'Expired token') {
    try {
      showAlertDialog(
          context,
          (Translations.of(context).trans('error_message') +
              '\n' +
              e.toString()));
    } on Exception catch (exception) {
      print(exception.toString());
      return null;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
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

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}
