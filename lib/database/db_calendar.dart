import 'package:sqflite/sqflite.dart' as sql;

class DBCalendar {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''CREATE TABLE calendar (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        timer INTEGER NOT NULL,
        elapsed INTEGER NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        date TEXT NOT NULL
      )''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("database_calendar.db", version: 2,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    },
        onUpgrade:
            (sql.Database database, int oldVersion, int newVersion) async {});
  }

  static Future<int> createData(
    String title,
    String description,
    int timer,
    int elapsed,
    int completed,
    String date,
  ) async {
    final db = await DBCalendar.db();

    final data = {
      'title': title,
      'description': description,
      'timer': timer,
      'elapsed': elapsed,
      'completed': completed,
      'date': date,
    };
    final id = await db.insert('calendar', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DBCalendar.db();
    return db.query('calendar', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getDataForDate(
      DateTime date) async {
    final db = await DBCalendar.db();

    final List<Map<String, dynamic>> data = await db.query('calendar',
        where: 'tanggal = ?', whereArgs: [date.toString()], orderBy: 'id');

    return data;
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await DBCalendar.db();
    return db.query('calendar', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getSingleDate(DateTime date) async {
    final db = await DBCalendar.db();
    String formattedDate = date.toIso8601String();

    String sqlQuery =
        "SELECT * FROM calendar WHERE DATE(date) = DATE('$formattedDate')";
    // print("test: ${db.rawQuery(sqlQuery)}");
    // final test = await db.rawQuery(sqlQuery);
    // print(test);
    return await db.rawQuery(sqlQuery);
  }

  static Future<int> updateData(
    int id,
    String title,
    String description,
    int timer,
    int elapsed,
    int completed,
    DateTime date,
  ) async {
    final db = await DBCalendar.db();
    final data = {
      'title': title,
      'description': description,
      'timer': timer,
      'elapsed': elapsed,
      'completed': completed,
      'date': date,
    };
    final result =
        await db.update('calendar', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await DBCalendar.db();
    await db.delete('calendar', where: 'id = ?', whereArgs: [id]);
  }
}
