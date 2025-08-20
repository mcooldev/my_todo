import 'package:my_todo/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///
const String tableDb = "tasks";
const String colId = "id";
const String colTitle = "title";
const String colCompleted = "completed";

///
class DbHelper {
  /// constants

  ///
  static Database? _database;

  /// Get data base
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  /// Initialize the data base
  static Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'tasks_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableDb (
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colTitle TEXT NOT NULL,
            $colCompleted INTEGER NOT NULL DEFAULT 0
            )
          ''');
      },
    );
  }

  /// Insert data
  static Future<Task> insertData(Task task) async {
    final Database db = await getDatabase();
    final int newId = await db.insert('tasks', task.toJsonWithoutId());
    return task.copyWith(id: newId);
  }

  /// Update data
  static Future<int> updateData(Task task) async {
    final db = await getDatabase();
    return db.update(
      tableDb,
      task.toJson(),
      where: "$colId = ?",
      whereArgs: [task.id],
    );
  }

  /// Delete data
  static Future<int> deleteData(int index) async {
    final Database db = await getDatabase();
    return db.delete(tableDb, where: "$colId = ?", whereArgs: [index]);
  }

  /// Get all tasks
  static Future<List<Task>> getAllTasks() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      tableDb,
      columns: [colId, colTitle, colCompleted],
    );

    if (maps.isNotEmpty) {
      return maps.map((map) => Task.fromJson(map)).toList();
    }
    return [];
  }
}
