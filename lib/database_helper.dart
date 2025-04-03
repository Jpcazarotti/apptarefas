import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String tableTarefa = "Tarefas";

  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, "dbTarefas.db"),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableTarefa (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tarefa TEXT NOT NULL,
            status INTEGER NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  //Create
  static Future<void> adicionarTarefa(String tarefa) async {
    final db = await getDatabase();
    await db.insert(tableTarefa, {'tarefa': tarefa, 'status': 0});
  }

  //Read
  static Future<List<Map<String, dynamic>>> getTarefas() async {
    final db = await getDatabase();
    return await db.query(tableTarefa);
  }

  //Update
  static Future<void> editarTarefa() async {}

  //Delete
  static Future<void> deletarTarefa() async {}
}
