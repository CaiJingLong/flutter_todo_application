enum Level {
  high,
  normal,
  low,
}

class TodoEntity {
  String title;
  String remark;
  DateTime dateTime;
  Level level;

  TodoEntity(
      {this.title, this.remark, this.dateTime, this.level = Level.normal});
}
