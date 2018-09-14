import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/entity/todo_entity.dart';

class TodoModel extends Model {
  static TodoModel of(BuildContext context) =>
      ScopedModel.of<TodoModel>(context);

  List<TodoEntity> _list = [];
  var _dataHelper;

  TodoModel() {
    _SaveDateHelper.getInstance().then((helper) {
      _dataHelper = helper;
      _list = _dataHelper.loadSavedData();
      notifyListeners();
    });
  }

  set list(List<TodoEntity> list) {
    this._list.clear();
    this._list.addAll(list);
    notifyListeners();
  }

  List<TodoEntity> get list {
    List<TodoEntity> result = [];
    result.addAll(_list);
    return result;
  }

  addData(TodoEntity entity, {int index = 0}) {
    _list.insert(index, entity);
    notifyListeners();
  }

  deleteData(TodoEntity entity) {
    _list.remove(entity);
    notifyListeners();
  }

  deleteAtIndex(int index) {
    _list.removeAt(index);
    notifyListeners();
  }

  updateData() {
    notifyListeners();
  }

  @protected
  void notifyListeners() {
    super.notifyListeners();
  }
}

class _SaveDateHelper {
  _SaveDateHelper();

  static Future<_SaveDateHelper> getInstance() async {
    var instance = _SaveDateHelper();
    await instance._init();
    return instance;
  }

  Database db;

  _init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "todo.db");
    db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE todo (_id INTEGER PRIMARY KEY, title TEXT, remark TEXT, datetime INTEGER ,level INTEGER)");
  }

  void saveData(TodoEntity entity) async {
    var list =
        await db.rawQuery("SELECT * from todo where _id = ?", [entity.id]);
    if (list == null || list.isEmpty) {
      insertData(entity);
    } else {
      // update

    }
  }

  Future<TodoEntity> queryData(TodoEntity entity) async {
    if (entity.id != null) {
      return entity;
    }
    List<Map<String, dynamic>> result;
    result = await db.query("todo", where: "_id = ?", whereArgs: [entity.id]);

  }

  void insertData(TodoEntity entity) async {
    await db.insert("todo", {
      "_id": entity.id,
      "title": entity.title,
      "remark": entity.remark,
      "datetime": entity.dateTime.millisecondsSinceEpoch,
      "level": Level.values.indexOf(entity.level),
    });
  }

  Future<List<TodoEntity>> loadSavedData() async {
    List<TodoEntity> list = [];
    var queryResult = await db.rawQuery("SELECT * from todo");
    for (var map in queryResult) {
//      var id = map["_id"];
      var title = map['title'];
      var remark = map['remark'];
      var dateTime = map['datetime'];
      var level = map['level'];

      var entity = TodoEntity();
      entity.title = title;
      entity.remark = remark;
      entity.dateTime = DateTime.fromMillisecondsSinceEpoch(dateTime);
      entity.level = Level.values[level];

      list.add(entity);
    }
    return list;
  }
}
