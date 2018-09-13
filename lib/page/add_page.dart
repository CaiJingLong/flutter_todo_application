import 'package:flutter/material.dart';
import 'package:todo_app/entity/todo_entity.dart';
import 'package:todo_app/model/todo_model.dart';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController title;
  TextEditingController remark;

  @override
  void initState() {
    super.initState();
    title = TextEditingController();
    remark = TextEditingController();
  }

  @override
  void dispose() {
    title.dispose();
    remark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加待办事项'),
      ),
      body: Form(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "标题",
                ),
                validator: (value) {
                  print("value = $value");
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return "标题不能为空";
                  }
                  return null;
                },
                controller: title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "备注信息",
                ),
                controller: remark,
              ),
            ),
          ],
        ),
        autovalidate: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: Icon(Icons.done),
      ),
    );
  }

  void _submit() {
    var todoEntity = TodoEntity(
      title: title.text.trim(),
      remark: remark.text?.trim() ?? "",
      dateTime: DateTime.now(),
    );
    TodoModel.of(context).addData(todoEntity);
    Navigator.pop(context);
  }
}
