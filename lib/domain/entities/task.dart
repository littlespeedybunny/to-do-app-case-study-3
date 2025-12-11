import '../../core/utils/category_color_helper.dart';

/// Task entity - Domain layer
/// Represents a task with title, category, and completion status
enum TaskCategory {
  personal,
  work,
  school,
  other,
}

/// Task entity
class Task {
  final int? id;
  final String title;
  final TaskCategory category;
  final bool isCompleted;
  final DateTime createdAt;
  final String categoryColor;

  const Task({
    this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
    required this.createdAt,
    String? categoryColor,
  }) : categoryColor = categoryColor ?? '';

  /// Create a copy with updated fields
  Task copyWith({
    int? id,
    String? title,
    TaskCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
    String? categoryColor,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      categoryColor: categoryColor ?? this.categoryColor,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'categoryColor': categoryColor.isNotEmpty
          ? categoryColor
          : CategoryColorHelper.getCategoryColorHex(category),
    };
  }

  /// Create from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    final category = TaskCategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => TaskCategory.other,
    );
    return Task(
      id: json['id'] as int?,
      title: json['title'] as String,
      category: category,
      isCompleted: (json['isCompleted'] as int) == 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      categoryColor: json['categoryColor'] as String? ??
          CategoryColorHelper.getCategoryColorHex(category),
    );
  }
}

