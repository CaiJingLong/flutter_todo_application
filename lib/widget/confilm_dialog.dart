import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  final Function onSure;
  final String title;

  const ConfirmDialog({Key key, this.onSure, this.title}) : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: <Widget>[
        FlatButton(
          onPressed: _onDismiss,
          child: Text('取消'),
        ),
        FlatButton(
          onPressed: _onSure,
          child: Text('确定'),
        ),
      ],
    );
  }

  void _onDismiss() {
    Navigator.of(context).pop();
  }

  void _onSure() {
    Navigator.of(context).pop();
    widget.onSure?.call();
  }
}
