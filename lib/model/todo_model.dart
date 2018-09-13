import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_app/entity/todo_entity.dart';

class TodoModel extends Model {
  static TodoModel of(BuildContext context) => ScopedModel.of<TodoModel>(context);

  List<TodoEntity> _list = [];

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
    _saveData();
  }

  void _saveData() async {}
}
