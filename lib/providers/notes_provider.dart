import 'package:flutter/foundation.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/utils/database_helper.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  NotesProvider() {
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    _notes = await DatabaseHelper.instance.getNotes();
    notifyListeners();
  }

  Future<Note> addNote(Note note) async {
    final id = await DatabaseHelper.instance.insertNote(note);
    final newNote = note.copy(id: id);
    _notes.add(newNote);
    notifyListeners();
    return newNote;
  }

  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.updateNote(note);
    final index = _notes.indexWhere((item) => item.id == note.id);
    if (index >= 0) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
}