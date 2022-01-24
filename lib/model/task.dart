class Task {
  late String id, title, date, time, status;
  Task(
      {required this.title,
      required this.date,
      required this.time,
      required this.status});

  Task.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) return;

    id = map['id'];
    title = map['title'];
    date = map['date'];
    time = map['time'];
    status = map['status'];
  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'status':status,
    };
  }
}
