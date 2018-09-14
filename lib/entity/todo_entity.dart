enum Level {
  high,
  normal,
  low,
}

class TodoEntity {
  int id;
  String title;
  String remark;
  DateTime dateTime;
  Level level;

  TodoEntity(
      {this.title, this.remark, this.dateTime, this.level = Level.normal});
}
