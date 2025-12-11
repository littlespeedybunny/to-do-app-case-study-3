import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/glowing_add_button.dart';
import '../../../core/utils/page_transitions.dart';
import '../../../l10n/app_localizations.dart';
import '../../viewmodels/note_viewmodel.dart';
import '../../widgets/note_card.dart';
import '../../widgets/search_bar.dart' show CustomSearchBar;
import 'add_note_dialog.dart';

/// Notes tab screen
/// Displays list of notes with search and add functionality
class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NoteViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.all(AppConstants.getPadding(context)),
          child: CustomSearchBar(
            hintText: l10n.searchNotes,
            onChanged: (query) => viewModel.searchNotes(query),
            onClear: () => viewModel.clearSearch(),
          ),
        ),

        // Notes list
        Expanded(
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewModel.notes.isEmpty
                  ? _buildEmptyState(context)
                  : _buildNotesList(context, viewModel),
        ),

        // Add button - responsive
        Padding(
          padding: EdgeInsets.all(AppConstants.getPadding(context)),
          child: GlowingAddButton(
            onPressed: () => _showAddNoteDialog(context),
            tooltip: l10n.addNote,
            label: MediaQuery.of(context).size.width >= 600 &&
                    MediaQuery.of(context).orientation == Orientation.portrait
                ? l10n.addNote
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noNotes,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(BuildContext context, NoteViewModel viewModel) {
    final padding = AppConstants.getPadding(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive grid: 2 columns for small screens, 3 for medium, 4 for large
    final crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
            ? 3
            : 4;

    // Daha iyi görünüm için aspect ratio ayarı
    final aspectRatio = screenWidth < 600 ? 0.9 : 0.85;

    return GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: aspectRatio,
      ),
      itemCount: viewModel.notes.length,
      itemBuilder: (context, index) {
        final note = viewModel.notes[index];
        return NoteCard(
          note: note,
          index: index,
          onDelete: () => viewModel.deleteNote(note.id!),
        );
      },
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    Navigator.of(context).push(
      CustomDialogRoute(
        builder: (context) => const AddNoteDialog(),
        barrierDismissible: true,
      ),
    );
  }
}
