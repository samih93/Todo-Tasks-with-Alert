import 'package:sqflite/sqflite.dart';

class TodoDbHelper {
  TodoDbHelper._();
  static final TodoDbHelper db = TodoDbHelper._();
  late Database database;

  Future createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print("database created");
        db
            .execute(
                "Create Table events(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,date TEXT , starttime TEXT , endtime TEXT , status TEXT , remind INTEGER)")
            .then((value) => print('table created'))
            .catchError((onError) => print(onError.toString()));
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }
}
