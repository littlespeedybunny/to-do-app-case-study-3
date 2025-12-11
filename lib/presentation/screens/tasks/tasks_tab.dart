import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/glowing_add_button.dart';
import '../../../core/utils/page_transitions.dart';
import '../../../domain/entities/task.dart';
import '../../../l10n/app_localizations.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../widgets/task_card.dart';
import '../../widgets/search_bar.dart' show CustomSearchBar;
import '../../widgets/category_filter_chip.dart';
import 'add_task_dialog.dart';

/// Tasks tab screen
/// Displays list of tasks with search, filter, and add functionality
class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Search and filter
        Padding(
          padding: EdgeInsets.all(AppConstants.getPadding(context)),
          child: Column(
            children: [
              CustomSearchBar(
                hintText: l10n.searchTasks,
                onChanged: (query) => viewModel.searchTasks(query),
                onClear: () => viewModel.clearFilters(),
              ),
              const SizedBox(height: 12),
              _buildCategoryFilters(context, viewModel),
            ],
          ),
        ),

        // Tasks list
        Expanded(
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.tasks.isEmpty
                  ? _buildEmptyState(context)
                  : _buildTasksList(context, viewModel),
        ),

        // Add button - responsive
        Padding(
          padding: EdgeInsets.all(AppConstants.getPadding(context)),
          child: GlowingAddButton(
            onPressed: () => _showAddTaskDialog(context),
            tooltip: l10n.addTask,
            label: MediaQuery.of(context).size.width >= 600 &&
                    MediaQuery.of(context).orientation == Orientation.portrait
                ? l10n.addTask
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters(BuildContext context, TaskViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CategoryFilterChip(
            label: l10n.all,
            isSelected: viewModel.selectedCategory == null,
            onSelected: () => viewModel.filterByCategory(null),
          ),
          const SizedBox(width: 6),
          ...TaskCategory.values.map((category) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CategoryFilterChip(
                  label: _getCategoryName(context, category),
                  category: category,
                  isSelected: viewModel.selectedCategory == category,
                  onSelected: () => viewModel.filterByCategory(category),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noTasks,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, TaskViewModel viewModel) {
    final pendingTasks = viewModel.pendingTasks;
    final completedTasks = viewModel.completedTasks;
    final padding = AppConstants.getPadding(context);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: padding),
      children: [
        if (pendingTasks.isNotEmpty) ...[
          _buildSectionHeader(context, _getSectionTitle(context, 'Pending')),
          ...pendingTasks.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TaskCard(
                  task: entry.value,
                  index: entry.key,
                  onToggle: () =>
                      viewModel.toggleTaskCompletion(entry.value.id!),
                  onDelete: () => viewModel.deleteTask(entry.value.id!),
                ),
              )),
        ],
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildSectionHeader(context, _getSectionTitle(context, 'Completed')),
          ...completedTasks.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TaskCard(
                  task: entry.value,
                  index: pendingTasks.length + entry.key,
                  onToggle: () =>
                      viewModel.toggleTaskCompletion(entry.value.id!),
                  onDelete: () => viewModel.deleteTask(entry.value.id!),
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  String _getSectionTitle(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'Pending':
        return l10n.pending;
      case 'Completed':
        return l10n.completed;
      default:
        return key;
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

  void _showAddTaskDialog(BuildContext context) {
    Navigator.of(context).push(
      CustomDialogRoute(
        builder: (context) => const AddTaskDialog(),
        barrierDismissible: true,
      ),
    );
  }
}
