import '../../core/constants/app_constants.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../database/database_helper.dart';

/// Task repository implementation - Data layer
/// Implements TaskRepository interface using SQLite
class TaskRepositoryImpl implements TaskRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Task>> getAllTasks() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      AppConstants.tasksTable,
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Task.fromJson(json)).toList();
  }

  @override
  Future<Task?> getTaskById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      AppConstants.tasksTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Task.fromJson(result.first);
  }

  @override
  Future<int> createTask(Task task) async {
    final db = await _dbHelper.database;
    return await db.insert(
      AppConstants.tasksTable,
      task.toJson()..remove('id'),
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    final db = await _dbHelper.database;
    await db.update(
      AppConstants.tasksTable,
      task.toJson()..remove('id'),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      AppConstants.tasksTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> toggleTaskCompletion(int id) async {
    final task = await getTaskById(id);
    if (task != null) {
      await updateTask(task.copyWith(isCompleted: !task.isCompleted));
    }
  }

  @override
  Future<List<Task>> getTasksByCategory(TaskCategory category) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      AppConstants.tasksTable,
      where: 'category = ?',
      whereArgs: [category.name],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Task.fromJson(json)).toList();
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      AppConstants.tasksTable,
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Task.fromJson(json)).toList();
  }
}

