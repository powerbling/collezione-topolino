import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:collezione_topolino/models/physical_copy.dart';

class DatabaseConnection with ChangeNotifier {
  static DatabaseConnection? _instance;

  DatabaseConnection._();

  factory DatabaseConnection() {
    return _instance ??= DatabaseConnection._();
  }

  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    WidgetsFlutterBinding.ensureInitialized();

    return await openDatabase(
      join(await getDatabasesPath(), 'topolino_collection.db'),
      onCreate: (db, version) {
        return db.execute(
          """CREATE TABLE Copies
                (
                  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                  number INTEGER NOT NULL,
                  reprint TEXT,
                  condition INTEGER,
                  dateAdded INTEGER
                )""",
        );
      },
      version: 1,
    );
  }

  Future<void> insertCopy(PhysicalCopy copy) async {
    final db = await database;

    db.insert(
      'Copies',
      copy.toMap(),
    );

    notifyListeners();
  }

  Future<void> removeCopy(int id) async {
    final db = await database;

    db.delete(
      'Copies',
      where: 'id = ?',
      whereArgs: [id],
    );

    notifyListeners();
  }

  Future<void> removeAllByNumber(int number) async {
    final db = await database;

    db.delete(
      'Copies',
      where: 'number = ?',
      whereArgs: [number],
    );

    notifyListeners();
  }

  Future<void> updateCopy(PhysicalCopy copy) async {
    final db = await database;

    db.update(
      'Copies',
      copy.toMap(),
    );

    notifyListeners();
  }

  Future<List<PhysicalCopy?>> fetchAllCopies() async {
    final db = await database;

    final List<Map<String, dynamic>> asMaps = await db.query('Copies');

    return List.generate(asMaps.length, (i) => PhysicalCopy.fromMap(asMaps[i]));
  }

  Future<PhysicalCopy?> fetchCopy(int id) async {
    final db = await database;

    final Map<String, dynamic>? asMap = (await db.query(
      'Copies',
      where: 'id = ?',
      whereArgs: [id],
    ))[0];

    if (asMap == null) return null;

    return PhysicalCopy.fromMap(asMap);
  }

  Future<List<PhysicalCopy?>> fetchByNumber(int number) async {
    final db = await database;

    final List<Map<String, dynamic>> asMaps = await db.query(
      'Copies',
      where: 'number = ?',
      whereArgs: [number],
    );

    return List.generate(asMaps.length, (i) => PhysicalCopy.fromMap(asMaps[i]));
  }
}
