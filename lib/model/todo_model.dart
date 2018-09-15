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
  _SaveDateHelper _dataHelper;

  TodoModel() {
    _SaveDateHelper.getInstance().then((helper) async {
      _dataHelper = helper;
      _list = await _dataHelper.loadSavedData();
      sort();
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

  sort() {
    _list.sort((v1, v2) {
      if (v1.finish == v2.finish) {
      } else if (v1.finish) {
        return 1;
      } else {
        return -1;
      }

      var i = v1.level.index.compareTo(v2.level.index);
      if (i != 0) {
        return i;
      }
      return v2.dateTime.compareTo(v1.dateTime);
    });
  }

  addData(TodoEntity entity, {int index = 0}) async {
    _list.insert(index, entity);
    sort();
    await _dataHelper.saveData(entity);
    notifyListeners();
  }

  deleteData(TodoEntity entity) async {
    _list.remove(entity);
    await _dataHelper.deleteData(entity);
    notifyListeners();
  }

  deleteAtIndex(int index) async {
    var entity = _list.removeAt(index);
    await _dataHelper.deleteData(entity);
    notifyListeners();
  }

  updateData() async {
    for (var entity in _list) {
      await _dataHelper.updateData(entity);
    }
    sort();
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
    db = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  FutureOr _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE todo (_id INTEGER PRIMARY KEY, title TEXT, remark TEXT, datetime INTEGER ,level INTEGER)");
  }

  FutureOr _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (newVersion == 2) {
      db.execute("ALTER TABLE todo ADD finish Boolean FALSE;");
    }
  }

  Future saveData(TodoEntity entity) async {
    var data = await queryData(entity);

    if (data == null) {
      var id = await insertData(entity);
      print("insert id = $id");
      entity.id = id;
    } else {
      await updateData(entity);
    }
  }

  Future<TodoEntity> queryData(TodoEntity entity) async {
    if (entity.id != null) {
      return entity;
    }
    List<Map<String, dynamic>> result =
        await db.query("todo", where: "_id = ?", whereArgs: [entity.id]);

    if (result == null || result.isEmpty) {
      return null;
    }
    return result.map((item) {
      return convertMapToEntity(item);
    }).elementAt(0);
  }

  Future<int> insertData(TodoEntity entity) async {
    await db.insert("todo", convertEntityToMap(entity));
    var list = await db.query(
      "todo",
      columns: ["_id"],
      where: "datetime = ?",
      whereArgs: [entity.dateTime.millisecondsSinceEpoch],
    );

    return list[0]["_id"];
  }

  Future deleteData(TodoEntity entity) async {
    await db.delete(
      "todo",
      where: "_id = ?",
      whereArgs: [entity.id],
    );
  }

  Future updateData(TodoEntity entity) async {
    await db.update(
      "todo",
      convertEntityToMap(entity),
      where: "_id = ?",
      whereArgs: [entity.id],
    );
  }

  Future<List<TodoEntity>> loadSavedData() async {
    List<TodoEntity> list = [];
    var queryResult = await db.rawQuery("SELECT * from todo");
    for (var map in queryResult) {
      var entity = convertMapToEntity(map);
      list.add(entity);
    }
    return list;
  }

  TodoEntity convertMapToEntity(Map<String, dynamic> map) {
    var f = map["finish"];
    var todoEntity = TodoEntity(
        title: map["title"],
        remark: map['remark'],
        level: Level.values[map["level"]],
        dateTime: DateTime.fromMillisecondsSinceEpoch(map["datetime"]),
        finish: map["finish"] == 1)
      ..id = map["_id"];
    return todoEntity;
  }

  Map<String, dynamic> convertEntityToMap(
    TodoEntity entity, {
    bool convertId = false,
  }) {
    var params = {
      "title": entity.title,
      "remark": entity.remark,
      "datetime": entity.dateTime.millisecondsSinceEpoch,
      "level": Level.values.indexOf(entity.level),
      "finish": entity.finish,
    };
    if (convertId == true) {
      params["_id"] = entity.id;
    }
    return params;
  }
}
