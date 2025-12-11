import '../entities/task.dart';

/// Task repository interface - Domain layer
/// Defines contract for task data operations
abstract class TaskRepository {
  /// Get all tasks
  Future<List<Task>> getAllTasks();
  
  /// Get task by id
  Future<Task?> getTaskById(int id);
  
  /// Create a new task
  Future<int> createTask(Task task);
  
  /// Update an existing task
  Future<void> updateTask(Task task);
  
  /// Delete a task
  Future<void> deleteTask(int id);
  
  /// Toggle task completion status
  Future<void> toggleTaskCompletion(int id);
  
  /// Get tasks by category
  Future<List<Task>> getTasksByCategory(TaskCategory category);
  
  /// Search tasks by query
  Future<List<Task>> searchTasks(String query);
}

