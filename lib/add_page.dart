import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController title;
  @override
  void initState() {
    super.initState();
    title = TextEditingController();
  }

  @override
  void dispose() {
    title.dispose();

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
                  if (value == "1") {
                    return null;
                  }
                  return "标题不能为空";
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
              ),
            ),
          ],
        ),
        autovalidate: true,
      ),
    );
  }
}
