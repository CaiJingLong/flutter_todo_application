import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo_app/entity/todo_entity.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/page/add_page.dart';
import 'package:todo_app/page/edit_page.dart';
import 'package:todo_app/widget/confilm_dialog.dart';
import 'package:todo_app/widget/thing.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的事项'),
        actions: <Widget>[
          IconButton(
            onPressed: () => setState(() => isEditing = !isEditing),
            icon: Icon(
              Icons.edit,
            ),
            color: isEditing ? Colors.grey : Colors.white,
          ),
        ],
      ),
      body: Container(
        child: ScopedModelDescendant<TodoModel>(
          builder: (BuildContext context, Widget child, TodoModel model) {
            return _buildContent(model);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(TodoModel model) {
    var list = model.list;

    if (list == null || list.isEmpty) {
      return Center(
        child: Text('没有待办事项，去添加一个吧'),
      );
    }

    return ListView.separated(
      itemBuilder: (ctx, i) => _buildItem(ctx, i, list[i]),
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1.0,
          color: Theme.of(context).dividerColor,
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index, TodoEntity data) {
    return Dismissible(
      child: InkWell(
        onLongPress: () => _delete(data),
        child: ThingItem(
          data: data,
          index: index,
          editing: isEditing,
        ),
        onTap: () => _onItemTap(data),
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

  void _onItemTap(TodoEntity data) {
    if (isEditing) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => EditPage(
                data: data,
              ),
        ),
      );
    }
  }
}
