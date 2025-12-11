import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

/// Category filter chip widget - Modern, compact design
class CategoryFilterChip extends StatelessWidget {
  final String label;
  final TaskCategory? category;
  final bool isSelected;
  final VoidCallback onSelected;

  const CategoryFilterChip({
    super.key,
    required this.label,
    this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final chipColor = category != null
        ? _getCategoryColor(context, category!)
        : colorScheme.primary;

    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor.withOpacity(isDark ? 0.25 : 0.15)
              : (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? chipColor
                : (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1)),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: chipColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? (isDark
                    ? chipColor
                    : Color.lerp(chipColor, Colors.black, 0.3) ?? chipColor)
                : (isDark
                    ? Colors.white.withOpacity(0.7)
                    : colorScheme.onSurface.withOpacity(0.7)),
            letterSpacing: 0.5,
          ),
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
}
