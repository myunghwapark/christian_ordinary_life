import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/Goal.dart';
import '../model/QT.dart';
import '../model/ThankDiary.dart';
import '../model/BiblePlan.dart';
import '../model/BiblePlanDetail.dart';

final String tableThankDiary = 'THANK_DIARY';
final String tableQtRecord = 'QT_RECORD';
final String tableBiblePlan = 'BIBLE_PLAN';
final String tableBiblePlanDetail = 'BIBLE_PLAN_DETAIL';
final String tableGoal = 'GOAL';
final String tableSettings = 'SETTINGS';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'COLDB.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableThankDiary(
            thank_diary_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            title TEXT,
            date TEXT,
            content TEXT
          )
        ''');

      await db.execute('''
          CREATE TABLE $tableQtRecord(
            qt_record_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            title TEXT,
            date TEXT,
            bible TEXT,
            content TEXT
          )
        ''');

      await db.execute('''
          CREATE TABLE $tableBiblePlan(
            bible_plan_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            plan_start_date TEXT,
            plan_end_date TEXT,
            plan_period INTEGER,
            plan_actual_start_date TEXT,
            plan_actual_end_date TEXT,
            plan_type TEXT,
            bibles TEXT,
            plan_status TEXT
          )
        ''');

      await db.execute('''
          CREATE TABLE $tableBiblePlanDetail(
            bible_plan_detail_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            bible_plan_id INTEGER,
            bible_title TEXT,
            chapter_start INTEGER,
            chapter_end INTEGER,
            read_progress INTEGER,
            read_yn TEXT,
            read_date TEXT
          )
        ''');

      await db.execute('''
          CREATE TABLE $tableGoal(
            goal_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            reading_bible TEXT,
            thank_diary TEXT,
            qt_record TEXT,
            praying TEXT,
            praying_time INTEGER,
            praying_duration INTEGER,
            goal_set_date TEXT
          )
        ''');

      await db.execute('''
          CREATE TABLE $tableSettings(
            first_user TEXT
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  // Goal
  insertGoal(Goal goal) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $tableGoal(reading_bible, thank_diary, qt_record, praying, praying_time, praying_duration, goal_set_date) VALUES(?, ?, ?, ?, ?, ?, ?)',
        [
          goal.readingBible,
          goal.thankDiary,
          goal.qtRecord,
          goal.praying,
          goal.prayingTime,
          goal.prayingDuration,
          goal.goalSetDate
        ]);
    return res;
  }

  updateGoal(Goal goal) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE $tableGoal SET reading_bible = ?, thank_diary = ?, qt_record = ?, praying = ?, praying_time = ?, praying_duration = ?, goal_set_date = ? WHERE goal_id = ?',
        [
          goal.readingBible,
          goal.thankDiary,
          goal.qtRecord,
          goal.praying,
          goal.prayingTime,
          goal.prayingDuration,
          goal.goalSetDate,
          goal.goalId
        ]);
    return res;
  }

  getGoal(int goalId) async {
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $tableGoal WHERE goal_id = ?', [goalId]);
    return res.isNotEmpty
        ? Goal(
            goalId: res.first['goal_id'],
            readingBible: res.first['reading_bible'],
            thankDiary: res.first['thank_diary'],
            qtRecord: res.first['qt_record'],
            praying: res.first['praying'],
            prayingTime: res.first['praying_time'],
            prayingDuration: res.first['praying_duration'],
            goalSetDate: res.first['goal_set_date'])
        : Null;
  }

  // QT Record
  insertQtRecord(QT qt) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $tableQtRecord(title, date, bible, content) VALUES(?, ?, ?, ?)',
        [qt.title, qt.date, qt.bible, qt.content]);
    return res;
  }

  updateQtRecord(QT qt) async {
    final db = await database;
    var res = await db.rawUpdate(
        'UPDATE $tableQtRecord SET title = ?, date = ?, bible = ?, content = ? WHERE qt_record_id = ?',
        [qt.title, qt.date, qt.bible, qt.content, qt.qtRecordId]);
    return res;
  }

  Future<List<QT>> getAllQTRecord() async {
    final db = await database;
    var res =
        await db.rawQuery('SELECT * FROM $tableQtRecord ORDER BY date DESC');
    List<QT> list = res.isNotEmpty
        ? res
            .map((c) => QT(
                qtRecordId: c['qt_record_id'],
                title: c['title'],
                date: c['date'],
                bible: c['bible'],
                content: c['content']))
            .toList()
        : [];
    return list;
  }

  getQtRecord(int qtRecordId) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $tableQtRecord WHERE qt_record_id = ?', [qtRecordId]);
    return res.isNotEmpty
        ? QT(
            qtRecordId: res.first['qt_record_id'],
            title: res.first['title'],
            date: res.first['date'],
            bible: res.first['bible'],
            content: res.first['content'])
        : Null;
  }

  deleteQtRecord(int qtRecordId) async {
    final db = await database;
    var res = db.rawDelete(
        'DELETE FROM $tableQtRecord WHERE qt_record_id = ?', [qtRecordId]);
    return res;
  }

  // Thank Diary
  insertThankDiary(ThankDiary thanksDiary) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $tableThankDiary(title, date, content) VALUES(?, ?, ?)',
        [thanksDiary.title, thanksDiary.date, thanksDiary.content]);
    return res;
  }

  updateThankDiary(ThankDiary thanksDiary) async {
    final db = await database;
    var res = await db.rawUpdate(
        'UPDATE $tableThankDiary SET title = ?, date = ?, content = ? WHERE thank_diary_id = ?',
        [
          thanksDiary.title,
          thanksDiary.date,
          thanksDiary.content,
          thanksDiary.thankDiaryId
        ]);
    return res;
  }

  Future<List<ThankDiary>> getAllThankDiary() async {
    final db = await database;
    var res =
        await db.rawQuery('SELECT * FROM $tableThankDiary ORDER BY date DESC');
    List<ThankDiary> list = res.isNotEmpty
        ? res
            .map((c) => ThankDiary(
                thankDiaryId: c['thank_diary_id'],
                title: c['title'],
                date: c['date'],
                content: c['content']))
            .toList()
        : [];
    return list;
  }

  getThankDiary(int thankDiaryId) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $tableThankDiary WHERE thank_diary_id = ?',
        [thankDiaryId]);
    return res.isNotEmpty
        ? ThankDiary(
            thankDiaryId: res.first['thank_diary_id'],
            title: res.first['title'],
            date: res.first['date'],
            content: res.first['content'])
        : Null;
  }

  deleteThankDiary(int thankDiaryId) async {
    final db = await database;
    var res = db.rawDelete(
        'DELETE FROM $tableThankDiary WHERE thank_diary_id = ?',
        [thankDiaryId]);
    return res;
  }

  // Bible Plan
  insertBiblePlan(BiblePlan biblePlan) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $tableBiblePlan(plan_start_date, plan_end_date, plan_period, plan_type, bibles, plan_status) VALUES(?, ?, ?, ?, ?, ?)',
        [
          biblePlan.planStartDate,
          biblePlan.planEndDate,
          biblePlan.planPeriod,
          biblePlan.planType,
          biblePlan.bibles,
          biblePlan.planStatus
        ]);
    return res;
  }

  updateBiblePlan(BiblePlan biblePlan) async {
    final db = await database;
    var res = await db.rawUpdate(
        'UPDATE $tableBiblePlan SET plan_actual_end_date = ?, plan_status = ? WHERE bible_plan_id = ?',
        [biblePlan.planActualEndDate, biblePlan.planStatus]);
    return res;
  }
}
