import 'package:flutter/foundation.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

/// Note ViewModel - Presentation layer (MVVM)
/// Manages note state and business logic
class NoteViewModel extends ChangeNotifier {
  final NoteRepository _repository;
  
  List<Note> _notes = [];
  bool _isLoading = false;
  String _searchQuery = '';

  NoteViewModel(this._repository);

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  /// Load all notes
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_searchQuery.isEmpty) {
        _notes = await _repository.getAllNotes();
      } else {
        _notes = await _repository.searchNotes(_searchQuery);
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new note
  Future<bool> addNote(String title, String content) async {
    if (title.trim().isEmpty) return false;

    try {
      final note = Note(
        title: title.trim(),
        content: content.trim(),
        createdAt: DateTime.now(),
      );
      await _repository.createNote(note);
      await loadNotes();
      return true;
    } catch (e) {
      debugPrint('Error adding note: $e');
      return false;
    }
  }

  /// Delete a note
  Future<void> deleteNote(int id) async {
    try {
      await _repository.deleteNote(id);
      await loadNotes();
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }

  /// Search notes
  Future<void> searchNotes(String query) async {
    _searchQuery = query;
    await loadNotes();
  }

  /// Clear search
  Future<void> clearSearch() async {
    _searchQuery = '';
    await loadNotes();
  }
}

