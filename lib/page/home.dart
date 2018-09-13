import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_app/page/add_page.dart';
import 'package:todo_app/entity/todo_entity.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/widget/confilm_dialog.dart';

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
    return Dismissible(
      child: InkWell(
        onLongPress: () => _delete(data),
        child: ListTile(
          title: Text(
            data.title,
          ),
          subtitle: Text(
            data.remark,
          ),
        ),
      ),
      key: ValueKey(data),
      onDismissed: (dis) => realDelete(data),
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
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
            onSure: () => realDelete(data),
            title: '确定要删除"${data.title}"吗？',
          ),
    );
  }

  realDelete(TodoEntity data) => TodoModel.of(context).deleteData(data);
}
