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

  TodoEntity entity = TodoEntity();

  Level currentLevel = Level.normal;

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
    return Form(
      child: Scaffold(
        appBar: AppBar(
          title: Text('添加待办事项'),
        ),
        body: ListView(
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
            _buildRadios(),
          ],
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) => FloatingActionButton(
                onPressed: () => _submit(context),
                child: Icon(Icons.done),
              ),
        ),
      ),
      autovalidate: true,
    );
  }

  _buildRadios() {
    return Container(
      height: 55.0,
      child: Row(
        children: <Widget>[
          _buildRadio(Level.normal),
          _buildRadio(Level.low),
          _buildRadio(Level.high),
        ],
      ),
    );
  }

  _buildRadio(Level level) {
    String text = "正常";
    if (level == Level.high) {
      text = "高";
    } else if (level == Level.low) {
      text = "低";
    }
    return Expanded(
      child: FormField<Level>(
        builder: (state) => RadioListTile<Level>(
              groupValue: this.currentLevel,
              onChanged: (Level value) {
                this.currentLevel = value;
                setState(() {});
              },
              value: level,
              title: Text(text),
            ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!Form.of(context).validate()) {
      return;
    }

    var todoEntity = TodoEntity(
      title: title.text.trim(),
      remark: remark.text?.trim() ?? "",
      dateTime: DateTime.now(),
      level: this.currentLevel,
    );
    TodoModel.of(context).addData(todoEntity);
    Navigator.pop(context);
  }
}
