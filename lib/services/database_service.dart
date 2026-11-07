import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/history_item.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'talktranslo_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE translations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            source_text TEXT NOT NULL,
            translated_text TEXT NOT NULL,
            source_lang TEXT NOT NULL,
            target_lang TEXT NOT NULL,
            timestamp INTEGER NOT NULL,
            is_favorite INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_translations_timestamp ON translations (timestamp DESC)',
        );
        await db.execute(
          'CREATE INDEX idx_translations_favorite ON translations (is_favorite)',
        );
      },
    );
  }

  Future<int> insertTranslation(TranslationHistoryItem item) async {
    final db = await database;

    // Check if the latest translation has identical text and language pair
    final latest = await db.query(
      'translations',
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (latest.isNotEmpty) {
      final latestItem = TranslationHistoryItem.fromMap(latest.first);
      if (latestItem.sourceText.trim() == item.sourceText.trim() &&
          latestItem.translatedText.trim() == item.translatedText.trim() &&
          latestItem.sourceLang == item.sourceLang &&
          latestItem.targetLang == item.targetLang) {
        // Update timestamp of existing entry instead of duplicating
        await db.update(
          'translations',
          {'timestamp': item.timestamp.millisecondsSinceEpoch},
          where: 'id = ?',
          whereArgs: [latestItem.id],
        );
        return latestItem.id!;
      }
    }

    return await db.insert(
      'translations',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TranslationHistoryItem>> getAllTranslations() async {
    final db = await database;
    final maps = await db.query(
      'translations',
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => TranslationHistoryItem.fromMap(m)).toList();
  }

  Future<List<TranslationHistoryItem>> getFavoriteTranslations() async {
    final db = await database;
    final maps = await db.query(
      'translations',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => TranslationHistoryItem.fromMap(m)).toList();
  }

  Future<List<TranslationHistoryItem>> searchTranslations(String query) async {
    final db = await database;
    final maps = await db.query(
      'translations',
      where: 'source_text LIKE ? OR translated_text LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => TranslationHistoryItem.fromMap(m)).toList();
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'translations',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTranslation(int id) async {
    final db = await database;
    return await db.delete(
      'translations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearAllHistory({bool keepFavorites = false}) async {
    final db = await database;
    if (keepFavorites) {
      return await db.delete(
        'translations',
        where: 'is_favorite = ?',
        whereArgs: [0],
      );
    } else {
      return await db.delete('translations');
    }
  }
}
