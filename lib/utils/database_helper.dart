import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/models/event_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 創建筆記表
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdTime TEXT NOT NULL,
        colorId INTEGER NOT NULL
      )
    ''');

    // 創建事件表
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        isAllDay INTEGER NOT NULL,
        startTime TEXT,
        endTime TEXT
      )
    ''');
  }

  // 筆記相關操作
  Future<List<Note>> getNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'createdTime DESC');
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> getNote(int id) async {
    final db = await database;
    final maps = await db.query(
      'notes',
      columns: ['id', 'title', 'content', 'createdTime', 'colorId'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    }
    return null;
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toJson());
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 事件相關操作
  Future<List<Event>> getEvents() async {
    final db = await database;
    final result = await db.query('events', orderBy: 'date ASC');
    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<Event?> getEvent(int id) async {
    final db = await database;
    final maps = await db.query(
      'events',
      columns: ['id', 'title', 'description', 'date', 'isAllDay', 'startTime', 'endTime'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    }
    return null;
  }

  Future<int> insertEvent(Event event) async {
    final db = await database;
    return await db.insert('events', event.toJson());
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return db.update(
      'events',
      event.toJson(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}