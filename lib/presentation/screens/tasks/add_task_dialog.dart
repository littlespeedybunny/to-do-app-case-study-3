import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../domain/entities/task.dart';
import '../../../l10n/app_localizations.dart';
import '../../viewmodels/task_viewmodel.dart';

/// Dialog for adding a new task
class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TaskCategory _selectedCategory = TaskCategory.personal;
  late FocusNode _titleFocusNode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final padding = isSmallScreen ? 20.0 : 32.0;
    final maxWidth = isSmallScreen ? size.width * 0.9 : 520.0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetAnimationDuration: const Duration(milliseconds: 300),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 40,
        vertical: isSmallScreen ? 24 : 60,
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: size.height * 0.85,
          ),
          child: SingleChildScrollView(
            child: GlassContainer(
              padding: EdgeInsets.all(padding),
              borderRadius: BorderRadius.circular(28),
              opacity: isDark
                  ? 0.1
                  : 0.25, // Koyu temada eski opacity, açık temada yüksek
              blur: isDark
                  ? 10.0
                  : 15.0, // Koyu temada eski blur, açık temada daha fazla
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with icon and title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      colorScheme.primary.withOpacity(0.3),
                                      colorScheme.secondary.withOpacity(0.3),
                                    ]
                                  : [
                                      colorScheme.primary.withOpacity(0.15),
                                      colorScheme.secondary.withOpacity(0.15),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.task_alt_rounded,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            l10n.addTask,
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Task title input
                    Text(
                      l10n.taskTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withOpacity(0.9)
                            : colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.white : null,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.taskTitle,
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.03),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colorScheme.error,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: colorScheme.error,
                            width: 2.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.pleaseEnterTaskTitle;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onChanged: (_) {
                        // Validation state'ini güncelle
                        _formKey.currentState?.validate();
                      },
                    ),
                    const SizedBox(height: 28),

                    // Category selection
                    Text(
                      l10n.category,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withOpacity(0.9)
                            : colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCategorySelector(context, l10n, isDark, colorScheme),
                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            l10n.cancel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white.withOpacity(0.7)
                                  : colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                isDark
                                    ? colorScheme.secondary
                                    : colorScheme.primary.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _saveTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.save,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: TaskCategory.values.map((category) {
        final isSelected = _selectedCategory == category;
        final categoryColor = _getCategoryColor(context, category);
        final categoryName = _getCategoryName(context, category);
        final icon = _getCategoryIcon(category);

        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? categoryColor.withOpacity(isDark ? 0.25 : 0.2)
                  : (isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.03)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? categoryColor
                    : (isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1)),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? (isDark
                          ? categoryColor
                          : Color.lerp(categoryColor, Colors.black, 0.3) ??
                              categoryColor)
                      : (isDark
                          ? Colors.white.withOpacity(0.6)
                          : colorScheme.onSurface.withOpacity(0.6)),
                ),
                const SizedBox(width: 8),
                Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? (isDark
                            ? categoryColor
                            : Color.lerp(categoryColor, Colors.black, 0.3) ??
                                categoryColor)
                        : (isDark
                            ? Colors.white.withOpacity(0.8)
                            : colorScheme.onSurface.withOpacity(0.8)),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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

  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.personal:
        return Icons.person_outline_rounded;
      case TaskCategory.work:
        return Icons.work_outline_rounded;
      case TaskCategory.school:
        return Icons.school_outlined;
      case TaskCategory.other:
        return Icons.category_outlined;
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

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<TaskViewModel>();
      final success = await viewModel.addTask(
        _titleController.text,
        _selectedCategory,
      );

      if (success && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
