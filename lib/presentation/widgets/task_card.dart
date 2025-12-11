import 'package:flutter/material.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/animated_card.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/task.dart';
import '../../l10n/app_localizations.dart';

/// Task card widget with glass effect
/// Displays task information with completion toggle
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final int index;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = _getCategoryColor(context, task.category);

    return AnimatedCard(
      index: index,
      delay: Duration(milliseconds: index * 50),
      child: GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: task.isCompleted,
            onChanged: (_) => onToggle(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          // Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.isCompleted
                        ? colorScheme.onSurface.withOpacity(0.5)
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: categoryColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getCategoryName(context, task.category).toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormatter.formatDateShort(context, task.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () => _showDeleteConfirmation(context),
            color: colorScheme.error,
          ),
        ],
      ),
      ),
    );
  }

  Color _getCategoryColor(BuildContext context, TaskCategory category) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (category) {
      case TaskCategory.personal:
        // Kişisel için pembe/rose tonu - "Tümü" mavi kalacak
        return isDark ? const Color(0xFFFF6B9D) : const Color(0xFFEC4899);
      case TaskCategory.work:
        return colorScheme.secondary;
      case TaskCategory.school:
        return Colors.purple;
      case TaskCategory.other:
        // Diğer kategorisi için farklı bir renk (yeşil)
        return isDark ? const Color(0xFF00FF88) : const Color(0xFF10B981);
    }
  }

  String _getCategoryName(BuildContext context, TaskCategory category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case TaskCategory.personal:
        return l10n.personal;
      case TaskCategory.work:
        return l10n.work;
      case TaskCategory.school:
        return l10n.school;
      case TaskCategory.other:
        return l10n.other;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTaskTitle),
        content: Text(l10n.deleteTaskMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

