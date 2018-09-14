import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:oktoast/oktoast.dart';

import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/page/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final TodoModel todoModel = TodoModel();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      child: OKToast(
        child: new MaterialApp(
          title: 'Flutter Demo',
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
        ),
      ),
      model: todoModel,
    );
  }
}
