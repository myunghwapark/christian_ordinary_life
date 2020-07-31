import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/database/dbHelper.dart';
import 'package:christian_ordinary_life/src/database/qtRecordBloc.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordDetail.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordWrite.dart';
import 'package:christian_ordinary_life/src/navigation/appDrawer.dart';
import 'package:christian_ordinary_life/src/component/appBarComponent.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:christian_ordinary_life/src/common/colors.dart';

class QTRecord extends StatefulWidget {
  @override
  QTRecordState createState() => QTRecordState();
}

class QTRecordState extends State<QTRecord> {
  TextEditingController editingController = TextEditingController();
  final QtRecordBloc _qtRecordBloc = QtRecordBloc();
  Widget _qtList;
  String keyWord;
  FocusNode _searchFieldNode = FocusNode();

  Future<void> _goQtRecordWrite() async {
    await Navigator.push(context,
            MaterialPageRoute(builder: (context) => QtRecordWrite(null)))
        .then((value) {
      setState(() {
        _qtList = _getList(keyWord);
      });
    });
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('write')),
      onPressed: _goQtRecordWrite,
      textColor: AppColors.greenPoint,
    );
  }

  Widget _getList(String keyword) {
    return FutureBuilder(
        future: DBHelper().getAllQTRecord(keyword),
        builder: (BuildContext context, AsyncSnapshot<List<QT>> snapshot) {
          return (snapshot.hasData && snapshot.data.length != 0)
              ? ListView.separated(
                  itemCount: snapshot.data.length,
                  separatorBuilder: (context, index) {
                    if (index == 0) return SizedBox.shrink();
                    return const Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    QT item = snapshot.data[index];
                    return Dismissible(
                      key: UniqueKey(),
                      child: GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      (item.bible != null
                                              ? '[${item.bible}] '
                                              : '') +
                                          item.title,
                                      style: TextStyle(
                                          color: AppColors.black, fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )),
                                Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      getDate(
                                          context, DateTime.parse(item.date)),
                                      style: TextStyle(
                                          color: AppColors.greenPointMild),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )),
                                Text(
                                  item.content,
                                  style: TextStyle(color: AppColors.darkGray),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )
                              ],
                            )),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QtRecordDetail(item),
                            ),
                          ).then((value) {
                            setState(() {
                              _qtList = _getList(keyWord);
                            });
                          });
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(Translations.of(context).trans('no_data')),
                );
        });
  }

  @override
  initState() {
    _qtList = _getList(null);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _qtRecordBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(context,
            Translations.of(context).trans('menu_qt_record'), actionIcon()),
        drawer: AppDrawer(),
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Container(
                height: 57,
                padding: EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
                child: TextField(
                  focusNode: _searchFieldNode,
                  onSubmitted: (value) {
                    setState(() {
                      keyWord = value;
                      _qtList = _getList(value);
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  controller: editingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.marine, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    labelText: Translations.of(context).trans('search'),
                    hintText: Translations.of(context).trans('search'),
                    prefixIcon: Icon(
                      Icons.search,
                      color: _searchFieldNode.hasFocus
                          ? Colors.blue
                          : AppColors.marine,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _qtList,
              )
            ])));
  }
}
