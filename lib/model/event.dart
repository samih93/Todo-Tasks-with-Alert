class Event {
  late String id, title, date, starttime, endtime, status;
  late int remind;
  Event(
      {required this.title,
      required this.date,
      required this.starttime,
      required this.endtime,
      required this.status,
      required this.remind});

  Event.CustomConstructor(
      {required String title, required this.starttime, required this.endtime});

  Event.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) return;

    id = map['id'].toString();
    title = map['title'];
    date = map['date'];
    starttime = map['starttime'];
    endtime = map['endtime'];
    status = map['status'];
    remind = map['remind'];
  }

  toJson() {
    return {
      //   'id': id,
      'title': title,
      'date': date,
      'starttime': starttime,
      'endtime': endtime,
      'status': status,
      'remind': remind,
    };
  }
}
