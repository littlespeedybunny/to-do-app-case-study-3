import '../entities/note.dart';

/// Note repository interface - Domain layer
/// Defines contract for note data operations
abstract class NoteRepository {
  /// Get all notes
  Future<List<Note>> getAllNotes();
  
  /// Get note by id
  Future<Note?> getNoteById(int id);
  
  /// Create a new note
  Future<int> createNote(Note note);
  
  /// Update an existing note
  Future<void> updateNote(Note note);
  
  /// Delete a note
  Future<void> deleteNote(int id);
  
  /// Search notes by query
  Future<List<Note>> searchNotes(String query);
}

