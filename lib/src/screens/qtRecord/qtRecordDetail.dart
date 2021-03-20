import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:share/share.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:christian_ordinary_life/src/common/userInfo.dart';
import 'package:christian_ordinary_life/src/common/api.dart';
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
  String _text = '';
  String _subject = '';
  bool _isLoading = false;

  Future<void> getQtRecord() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await API.transaction(context, API.qtRecordDetail, param: {
        'userSeqNo': UserInfo.loginUser.seqNo,
        'qtRecordSeqNo': widget.qt.seqNo,
        'qtDate': widget.qt.qtDate
      }).then((response) {
        setState(() {
          _isLoading = false;
        });

        QT qt = QT.fromJson(json.decode(response));
        List<QT> tempList;
        if (qt.detail.length != 0) {
          tempList = qt.detail.map((model) => QT.fromJson(model)).toList();
          setState(() {
            detailQt = tempList[0];

            _subject = '[' +
                getDateOfWeek(DateTime.parse(detailQt.qtDate)) +
                '/' +
                detailQt.bible +
                '] ' +
                detailQt.title;

            _text = detailQt.content;
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
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    return TextButton(
      child: Text(
        Translations.of(context).trans('edit'),
        style: TextStyle(color: AppColors.darkGray),
      ),
      onPressed: _goQtRecordWrite,
    );
  }

  void _share(BuildContext context) async {
    final RenderBox box = context.findRenderObject();

    await Share.share(_text,
        subject: _subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    final _qtDate = detailQt.qtDate != null
        ? SelectableText(
            getDateOfWeek(DateTime.parse(detailQt.qtDate)),
            style: TextStyle(color: AppColors.darkGray),
          )
        : Container();

    final _qtTitle = detailQt.bible != null
        ? SelectableText(
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
            child: SelectableText(detailQt.content))
        : Container();

    return Scaffold(
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_qt_record'),
            actionWidget: actionIcon()),
        body: LoadingOverlay(
            isLoading: _isLoading,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.black,
            child: SingleChildScrollView(
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _qtDate,
                          IconButton(
                              icon: Icon(
                                Icons.ios_share,
                                color: AppColors.sky,
                              ),
                              onPressed: () {
                                _share(context);
                              }),
                        ]),
                    _qtTitle,
                    Divider(
                      color: AppColors.greenPoint,
                    ),
                    _qtContent
                  ],
                ),
              ),
            )));
  }

  @override
  void initState() {
    getQtRecord();
    super.initState();
  }
}
