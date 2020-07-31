import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordWrite.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';

class QtRecordDetail extends StatefulWidget {
  final QT qt;
  const QtRecordDetail(this.qt);

  @override
  QtRecordDetailState createState() => QtRecordDetailState();
}

class QtRecordDetailState extends State<QtRecordDetail> {
  QT detailQt;

  Future<void> _goQtRecordWrite() async {
    await Navigator.push(context,
            MaterialPageRoute(builder: (context) => QtRecordWrite(widget.qt)))
        .then((value) {
      setState(() {});
    });
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('edit')),
      onPressed: _goQtRecordWrite,
      textColor: AppColors.greenPoint,
    );
  }

  @override
  void initState() {
    //detailQt = DBHelper().getQtRecord(widget.qt.qtRecordId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _qtTitle = Text(
      getDateOfWeek(context, DateTime.parse(widget.qt.date)),
      style: TextStyle(color: AppColors.darkGray),
    );

    final _qtBible = Text(
      (widget.qt.bible != null ? '[${widget.qt.bible}] ' : '') +
          widget.qt.title,
      style: TextStyle(color: AppColors.black, fontSize: 18),
    );

    final _qtContent = Text(widget.qt.content);

    return Scaffold(
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(context,
            Translations.of(context).trans('menu_qt_record'), actionIcon()),
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
                _qtTitle,
                _qtBible,
                Divider(
                  color: AppColors.greenPoint,
                ),
                _qtContent
              ],
            ),
          ),
        ));
  }
}
