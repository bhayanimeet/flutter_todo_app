import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/sqlite_db_model.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper dbHelper = DBHelper._();

  Database? db;

  static const tableName = "Task";
  static const id = "id";
  static const time = "time";
  static const task = "task";

  Future<void> dataTable() async {
    String directory = await getDatabasesPath();
    String path = join(directory, "demo.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        String query = "CREATE TABLE IF NOT EXISTS $tableName($id INTEGER PRIMARY KEY AUTOINCREMENT,$time TEXT,$task TEXT)";
        await db.execute(query);
      },
    );
  }

  Future<int> insertData({required Task data}) async {
    await dataTable();

    String query = "INSERT INTO $tableName($time,$task) VALUES(?,?)";
    List args = [data.time,data.task];

    int res = await db!.rawInsert(query, args);

    return res;
  }

  Future<List<Task>> selectData() async {
    await dataTable();

    String query = "SELECT * FROM $tableName;";

    List<Map<String, dynamic>> allTasks = await db!.rawQuery(query);

    List<Task> allTask = allTasks.map((e) => Task.fromMap(data: e)).toList();

    return allTask;
  }

  Future<int> deleteData({required int index}) async {
    await dataTable();

    String query = "DELETE FROM $tableName WHERE $id=?;";

    int res = await db!.rawDelete(query, [index]);

    return res;
  }
}