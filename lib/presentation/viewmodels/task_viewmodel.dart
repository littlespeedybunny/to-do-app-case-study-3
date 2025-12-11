import 'package:flutter/foundation.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

/// Task ViewModel - Presentation layer (MVVM)
/// Manages task state and business logic
class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String _searchQuery = '';
  TaskCategory? _selectedCategory;

  TaskViewModel(this._repository);

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TaskCategory? get selectedCategory => _selectedCategory;

  /// Get pending tasks
  List<Task> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  
  /// Get completed tasks
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  /// Load all tasks
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_selectedCategory != null) {
        _tasks = await _repository.getTasksByCategory(_selectedCategory!);
      } else if (_searchQuery.isNotEmpty) {
        _tasks = await _repository.searchTasks(_searchQuery);
      } else {
        _tasks = await _repository.getAllTasks();
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new task
  Future<bool> addTask(String title, TaskCategory category) async {
    if (title.trim().isEmpty) return false;

    try {
      final task = Task(
        title: title.trim(),
        category: category,
        createdAt: DateTime.now(),
      );
      await _repository.createTask(task);
      await loadTasks();
      return true;
    } catch (e) {
      debugPrint('Error adding task: $e');
      return false;
    }
  }

  /// Toggle task completion
  Future<void> toggleTaskCompletion(int id) async {
    try {
      await _repository.toggleTaskCompletion(id);
      await loadTasks();
    } catch (e) {
      debugPrint('Error toggling task: $e');
    }
  }

  /// Delete a task
  Future<void> deleteTask(int id) async {
    try {
      await _repository.deleteTask(id);
      await loadTasks();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  /// Filter by category
  Future<void> filterByCategory(TaskCategory? category) async {
    _selectedCategory = category;
    await loadTasks();
  }

  /// Search tasks
  Future<void> searchTasks(String query) async {
    _searchQuery = query;
    await loadTasks();
  }

  /// Clear filters
  Future<void> clearFilters() async {
    _searchQuery = '';
    _selectedCategory = null;
    await loadTasks();
  }
}

