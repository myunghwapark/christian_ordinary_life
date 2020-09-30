import 'dart:convert';

import 'package:christian_ordinary_life/src/common/api.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordWrite.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';

class QtRecordDetail extends StatefulWidget {
  final QT qt;
  final User loginUser;
  const QtRecordDetail({this.qt, this.loginUser});

  @override
  QtRecordDetailState createState() => QtRecordDetailState();
}

class QtRecordDetailState extends State<QtRecordDetail> {
  QT detailQt = new QT();

  Future<void> getQtRecord() async {
    try {
      await API.transaction(context, API.qtRecordDetail, param: {
        'qtRecordSeqNo': widget.qt.seqNo,
        'qtDate': widget.qt.qtDate
      }).then((response) {
        QT qt = QT.fromJson(json.decode(response));
        List<QT> tempList;
        if (qt.detail.length != 0) {
          tempList = qt.detail.map((model) => QT.fromJson(model)).toList();
          setState(() {
            detailQt = tempList[0];
          });
        } else {
          showAlertDialog(
                  context, Translations.of(context).trans('no_data_detail'))
              .then((value) => Navigator.pop(context));
        }
      });
    } on Exception catch (exception) {
      errorMessage(context, exception);
      return null;
    } catch (error) {
      errorMessage(context, error);
      return null;
    }
  }

  Future<void> _goQtRecordWrite() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QtRecordWrite(
                  qt: detailQt,
                ))).then((value) {
      if (value == 'delete') {
        Navigator.pop(context);
      } else {
        setState(() {
          detailQt = value;
        });
      }
    });
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('edit')),
      onPressed: _goQtRecordWrite,
      textColor: AppColors.darkGray,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _qtDate = detailQt.qtDate != null
        ? Text(
            getDateOfWeek(DateTime.parse(detailQt.qtDate)),
            style: TextStyle(color: AppColors.darkGray),
          )
        : Container();

    final _qtTitle = detailQt.bible != null
        ? Text(
            ((detailQt.bible != null && detailQt.bible != '')
                    ? '[${detailQt.bible}] '
                    : '') +
                detailQt.title,
            style: TextStyle(color: AppColors.black, fontSize: 18),
          )
        : Container();

    final _qtContent = detailQt.content != null
        ? Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            constraints: BoxConstraints(minHeight: 100),
            child: Text(detailQt.content))
        : Container();

    return Scaffold(
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_qt_record'),
            actionWidget: actionIcon()),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _qtDate,
                _qtTitle,
                Divider(
                  color: AppColors.greenPoint,
                ),
                _qtContent
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    //detailQt = widget.qt;
    getQtRecord();
    super.initState();
  }
}
