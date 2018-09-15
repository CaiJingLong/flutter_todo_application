import 'package:flutter/material.dart';
import 'package:todo_app/entity/todo_entity.dart';
import 'package:todo_app/model/todo_model.dart';

class EditPage extends StatefulWidget {
  final TodoEntity data;

  const EditPage({Key key, this.data}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController title;
  TextEditingController remark;

  Level currentLevel = Level.normal;

  @override
  void initState() {
    super.initState();
    var data = widget.data;
    title = TextEditingController(text: data.title);
    remark = TextEditingController(text: data.remark);
    finish = widget.data.finish ?? false;
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
            _buildFinish(),
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
          _buildRadio(Level.high),
          _buildRadio(Level.low),
        ],
      ),
    );
  }

  _buildRadio(Level level) {
    String text = "正常";
    if (level == Level.high) {
      text = "高";
    } else if (level == Level.low || level == Level.finish) {
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

    var data = widget.data;

    data
      ..title = title.text.trim()
      ..remark = (remark.text?.trim() ?? "")
      ..level = this.currentLevel
      ..finish = this.finish;

    TodoModel.of(context).updateData();
    Navigator.pop(context);
  }

  bool finish;

  _buildFinish() {
    return FormField<bool>(
      builder: (FormFieldState field) {
        return CheckboxListTile(
          value: finish,
          onChanged: (v) => setState(() => this.finish = v),
          title: Text('已完成'),
        );
      },
    );
  }
}
