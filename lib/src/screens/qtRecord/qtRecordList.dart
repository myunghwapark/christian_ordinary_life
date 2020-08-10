import 'package:christian_ordinary_life/src/component/searchBox.dart';
import 'package:flutter/material.dart';
import 'package:christian_ordinary_life/src/model/User.dart';
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
  static const routeName = '/qtRecord';

  final User loginUser;
  QTRecord(this.loginUser);

  @override
  QTRecordState createState() => QTRecordState();
}

class QTRecordState extends State<QTRecord> {
  TextEditingController searchController = TextEditingController();
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
      textColor: AppColors.darkGray,
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
                                      getDate(DateTime.parse(item.date)),
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
    GestureTapCallback _onSubmitted = () {
      setState(() {
        keyWord = searchController.text;
        _qtList = _getList(keyWord);
      });
    };

    return Scaffold(
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(
            context, Translations.of(context).trans('menu_qt_record'),
            actionWidget: actionIcon()),
        drawer: AppDrawer(),
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              searchBox(context, AppColors.marine, _searchFieldNode,
                  searchController, _onSubmitted),
              Expanded(
                child: _qtList,
              )
            ])));
  }
}
