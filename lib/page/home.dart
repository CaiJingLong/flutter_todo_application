import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_app/page/add_page.dart';
import 'package:todo_app/entity/todo_entity.dart';
import 'package:todo_app/model/todo_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的事项'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _add,
          )
        ],
      ),
      body: Container(
        child: ScopedModelDescendant<TodoModel>(
            builder: (BuildContext context, Widget child, TodoModel model) {
          var list = model.list;
          return ListView.builder(
            itemBuilder: (ctx, i) => _buildItem(ctx, i, list[i]),
            itemCount: list.length,
          );
        }),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, TodoEntity data) {
    return InkWell(
      onLongPress: () => _delete(data),
      child: ListTile(
        title: Text(
          data.title,
        ),
        subtitle: Text(
          data.remark,
        ),
      ),
    );
  }

  void _add() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddTodoPage(),
      ),
    );
  }

  _delete(TodoEntity data) {
    TodoModel.of(context).deleteData(data);
  }
}
