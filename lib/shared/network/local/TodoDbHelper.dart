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
                "Create Table tasks(id TEXT,title TEXT,date TEXT , time TEXT , status TEXT , remind INTEGER)")
            .then((value) => print('table created'))
            .catchError((onError) => print(onError.toString()));
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }
}
