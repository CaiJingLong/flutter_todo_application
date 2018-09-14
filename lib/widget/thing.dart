import 'package:datetime_helper/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/entity/todo_entity.dart';

class ThingItem extends StatefulWidget {
  final TodoEntity data;
  final int index;

  const ThingItem({Key key, @required this.data, @required this.index}) : super(key: key);

  @override
  _ThingItemState createState() => _ThingItemState();
}

class _ThingItemState extends State<ThingItem> {
  TodoEntity get item => widget.data;

  @override
  Widget build(BuildContext context) {
    var dateTime = item.dateTime;
    var level = item.level;
    Color color;
    FontWeight fontWeight = FontWeight.normal;
    if (level == Level.high) {
      color = Colors.red;
      fontWeight = FontWeight.bold;
    } else if (level == Level.low) {
      color = Colors.grey;
    } else {
      color = Colors.black;
    }
    var tile = ListTile(
      leading: Container(
        constraints: BoxConstraints(minWidth: 20.0),
        child: Text(
          widget.index.toString(),
          textAlign: TextAlign.center,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(color: color, fontWeight: fontWeight),
      ),
      trailing: Text(_buildDateString(dateTime)),
    );
    return tile;
  }

  String _buildDateString(DateTime dateTime) {
    if (DateHelper.isToday(dateTime)) {
      return "${_twoDigits(dateTime.hour)} : ${_twoDigits(dateTime.minute)} ";
    }
    if (isSameYear(dateTime)) {
      return "${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}";
    }
    return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}";
  }

  static bool isSameYear(DateTime date) {
    var now = DateTime.now();
    return now.year == date.year;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
