import 'dart:async';
import 'package:christian_ordinary_life/src/model/QT.dart';
import 'dbHelper.dart';

class QtRecordBloc {
  QtRecordBloc() {
    getQtRecords(null);
  }
  final _qtRecordController = StreamController<List<QT>>.broadcast();

  get qtRecord => _qtRecordController.stream;
  dispose() {
    _qtRecordController.close();
  }

  getQtRecords(String searchWord) async {
    _qtRecordController.sink.add(await DBHelper().getAllQTRecord(searchWord));
  }

  addQtRecord(QT qt) async {
    await DBHelper().insertQtRecord(qt);
    getQtRecords(null);
  }

  deleteQtRecord(int id) async {
    await DBHelper().deleteQtRecord(id);
    getQtRecords(null);
  }

  updateQtRecord(QT qt) async {
    await DBHelper().updateQtRecord(qt);
    getQtRecords(null);
  }
}
