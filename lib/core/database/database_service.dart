import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/media_item.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  Database? _db;

  Future<void> init() async {
    final path = join(await getDatabasesPath(), 'medialog.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Database get db {
    if (_db == null) throw StateError('Database not initialised');
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE media (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        progress INTEGER NOT NULL DEFAULT 0,
        total_length INTEGER NOT NULL DEFAULT 1,
        status TEXT NOT NULL DEFAULT 'active'
      )
    ''');
  }

  // INSERT
  Future<int> insertMedia(MediaItem item) async {
    return db.insert('media', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // READ ALL
  Future<List<MediaItem>> getAllMedia() async {
    final maps = await db.query('media', orderBy: 'id DESC');
    return maps.map(MediaItem.fromMap).toList();
  }

  // UPDATE PROGRESS
  Future<void> incrementProgress(int id, int current, int total) async {
    final next = (current + 1).clamp(0, total);
    final status = next >= total ? 'completed' : 'active';
    await db.update(
      'media',
      {'progress': next, 'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE FULL
  Future<void> updateMedia(MediaItem item) async {
    await db.update('media', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  // DELETE
  Future<void> deleteMedia(int id) async {
    await db.delete('media', where: 'id = ?', whereArgs: [id]);
  }
}
