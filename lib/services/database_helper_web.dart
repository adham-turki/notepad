import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/note.dart';

class DatabaseHelperWeb {
  // Web-specific storage methods using SharedPreferences
  Future<List<User>> _getWebUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final usersList = jsonDecode(usersJson) as List;
    return usersList.map((json) => User.fromMap(json)).toList();
  }

  Future<void> _saveWebUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = jsonEncode(users.map((user) => user.toMap()).toList());
    await prefs.setString('users', usersJson);
  }

  Future<List<Note>> _getWebNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString('notes') ?? '[]';
    final notesList = jsonDecode(notesJson) as List;
    return notesList.map((json) => Note.fromMap(json)).toList();
  }

  Future<void> _saveWebNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = jsonEncode(notes.map((note) => note.toMap()).toList());
    await prefs.setString('notes', notesJson);
  }

  Future<int> _getNextWebUserId() async {
    final users = await _getWebUsers();
    if (users.isEmpty) return 1;
    return users.map((u) => u.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<int> _getNextWebNoteId() async {
    final notes = await _getWebNotes();
    if (notes.isEmpty) return 1;
    return notes.map((n) => n.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
  }

  // User operations
  Future<int> createUser(User user) async {
    final users = await _getWebUsers();
    final newId = await _getNextWebUserId();
    final newUser = User(
      id: newId,
      email: user.email,
      password: user.password,
      name: user.name,
      profilePicture: user.profilePicture,
      createdAt: user.createdAt,
    );
    users.add(newUser);
    await _saveWebUsers(users);
    return newId;
  }

  Future<User?> getUserByEmail(String email) async {
    final users = await _getWebUsers();
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUserById(int id) async {
    final users = await _getWebUsers();
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Note operations
  Future<int> createNote(Note note) async {
    final notes = await _getWebNotes();
    final newId = await _getNextWebNoteId();
    final newNote = Note(
      id: newId,
      title: note.title,
      content: note.content,
      userId: note.userId,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      color: note.color,
      isImportant: note.isImportant,
      isPinned: note.isPinned, // Include pinned status
    );
    notes.add(newNote);
    await _saveWebNotes(notes);
    return newId;
  }

  Future<List<Note>> getNotesByUserId(int userId) async {
    final notes = await _getWebNotes();
    final userNotes = notes.where((note) => note.userId == userId).toList();
    
    // Sort by pinned status first, then by updated date
    userNotes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    
    return userNotes;
  }

  Future<int> updateNote(Note note) async {
    final notes = await _getWebNotes();
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      notes[index] = note;
      await _saveWebNotes(notes);
      return 1;
    }
    return 0;
  }

  Future<int> deleteNote(int id) async {
    final notes = await _getWebNotes();
    final initialLength = notes.length;
    notes.removeWhere((note) => note.id == id);
    await _saveWebNotes(notes);
    return initialLength - notes.length;
  }

  // New method to toggle pin status
  Future<int> toggleNotePin(int noteId, bool isPinned) async {
    final notes = await _getWebNotes();
    final index = notes.indexWhere((note) => note.id == noteId);
    if (index != -1) {
      notes[index] = notes[index].copyWith(
        isPinned: isPinned,
        updatedAt: DateTime.now(),
      );
      await _saveWebNotes(notes);
      return 1;
    }
    return 0;
  }
}