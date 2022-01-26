class Task {
  late String id, title, date, time, status;
  late int remind;
  Task(
      {required this.title,
      required this.date,
      required this.time,
      required this.status,
      required this.remind});

  Task.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) return;

    id = map['id'].toString();
    title = map['title'];
    date = map['date'];
    time = map['time'];
    status = map['status'];
    remind = map['remind'];
  }

  toJson() {
    return {
      //   'id': id,
      'title': title,
      'date': date,
      'time': time,
      'status': status,
      'remind': remind,
    };
  }
}
