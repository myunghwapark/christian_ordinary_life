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
  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();

  void _goQtRecordWrite() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QtRecordWrite()));
  }

  Widget actionIcon() {
    return FlatButton(
      child: Text(Translations.of(context).trans('write')),
      onPressed: _goQtRecordWrite,
      textColor: AppColors.greenPoint,
    );
  }

  @override
  initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void filterSearchResults(String query) {
      List<String> dummySearchList = List<String>();
      dummySearchList.addAll(duplicateItems);
      if (query.isNotEmpty) {
        List<String> dummyListData = List<String>();
        dummySearchList.forEach((item) {
          if (item.contains(query)) {
            dummyListData.add(item);
          }
        });
        setState(() {
          items.clear();
          items.addAll(dummyListData);
        });
        return;
      } else {
        setState(() {
          items.clear();
          items.addAll(duplicateItems);
        });
      }
    }

    return Scaffold(
        backgroundColor: AppColors.lightSky,
        appBar: appBarComponent(context,
            Translations.of(context).trans('menu_qt_record'), actionIcon()),
        drawer: AppDrawer(),
        body: Container(
            child: Column(children: <Widget>[
          Container(
            height: 60,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
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
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${items[index]}'),
                );
              },
            ),
          )
        ])));
  }
}
