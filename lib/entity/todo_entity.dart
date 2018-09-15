enum Level {
  high,
  normal,
  low,
  finish,
}

class TodoEntity {
  int id;
  String title;
  String remark;
  DateTime dateTime;
  Level level;
  bool finish;

  TodoEntity({
    this.title,
    this.remark,
    this.dateTime,
    this.level = Level.normal,
    this.finish = false,
  });
}
