import '../../core/constants/app_constants.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../database/database_helper.dart';

/// Note repository implementation - Data layer
/// Implements NoteRepository interface using SQLite
class NoteRepositoryImpl implements NoteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Note>> getAllNotes() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      AppConstants.notesTable,
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Note.fromJson(json)).toList();
  }

  @override
  Future<Note?> getNoteById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      AppConstants.notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Note.fromJson(result.first);
  }

  @override
  Future<int> createNote(Note note) async {
    final db = await _dbHelper.database;
    return await db.insert(
      AppConstants.notesTable,
      note.toJson()..remove('id'),
    );
  }

  @override
  Future<void> updateNote(Note note) async {
    final db = await _dbHelper.database;
    await db.update(
      AppConstants.notesTable,
      note.toJson()..remove('id'),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<void> deleteNote(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      AppConstants.notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      AppConstants.notesTable,
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Note.fromJson(json)).toList();
  }
}

