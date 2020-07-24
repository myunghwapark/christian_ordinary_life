import 'package:christian_ordinary_life/src/common/util.dart';
import 'package:christian_ordinary_life/src/database/dbHelper.dart';
import 'package:christian_ordinary_life/src/database/qtRecordBloc.dart';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'package:christian_ordinary_life/src/screens/qtRecord/qtRecordWrite.dart';
import 'package:flutter/material.dart';
import '../../navigation/appDrawer.dart';
import '../../component/appBarComponent.dart';
import '../../common/translations.dart';
import '../../common/colors.dart';

class QTRecord extends StatefulWidget {
  @override
  QTRecordState createState() => QTRecordState();
}

class QTRecordState extends State<QTRecord> {
  TextEditingController editingController = TextEditingController();
  final QtRecordBloc _qtRecordBloc = QtRecordBloc();
  Widget _qtList;
  String keyWord;

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
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    QT item = snapshot.data[index];
                    return Dismissible(
                      key: UniqueKey(),
                      child: ListTile(
                        title: Text(
                          item.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(),
                        ),
                        leading: Text(
                          getDate(context, DateTime.parse(item.date)),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.lightGray,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QtRecordWrite(item),
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
            child: Column(children: <Widget>[
          Container(
            height: 57,
            padding:
                const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  keyWord = value;
                  _qtList = _getList(value);
                });
              },
              textAlignVertical: TextAlignVertical.center,
              controller: editingController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.marine, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  contentPadding: EdgeInsets.all(8),
                  labelText: Translations.of(context).trans('search'),
                  hintText: Translations.of(context).trans('search'),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  fillColor: AppColors.marine),
            ),
          ),
          Expanded(
            child: _qtList,
          )
        ])));
  }
}
