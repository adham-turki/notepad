import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/note.dart';
import 'database_helper_web.dart';
import 'database_helper_mobile.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  
  late final DatabaseHelperWeb _webHelper;
  late final DatabaseHelperMobile _mobileHelper;

  DatabaseHelper._init() {
    _webHelper = DatabaseHelperWeb();
    _mobileHelper = DatabaseHelperMobile();
  }

  Future<dynamic> get database async {
    if (kIsWeb) {
      return null; // Web doesn't use SQLite database
    }
    return await _mobileHelper.database;
  }

  // User operations
  Future<int> createUser(User user) async {
    if (kIsWeb) {
      return await _webHelper.createUser(user);
    } else {
      return await _mobileHelper.createUser(user);
    }
  }

  Future<User?> getUserByEmail(String email) async {
    if (kIsWeb) {
      return await _webHelper.getUserByEmail(email);
    } else {
      return await _mobileHelper.getUserByEmail(email);
    }
  }

  Future<User?> getUserById(int id) async {
    if (kIsWeb) {
      return await _webHelper.getUserById(id);
    } else {
      return await _mobileHelper.getUserById(id);
    }
  }

  // Note operations
  Future<int> createNote(Note note) async {
    if (kIsWeb) {
      return await _webHelper.createNote(note);
    } else {
      return await _mobileHelper.createNote(note);
    }
  }

  Future<List<Note>> getNotesByUserId(int userId) async {
    if (kIsWeb) {
      return await _webHelper.getNotesByUserId(userId);
    } else {
      return await _mobileHelper.getNotesByUserId(userId);
    }
  }

  Future<int> updateNote(Note note) async {
    if (kIsWeb) {
      return await _webHelper.updateNote(note);
    } else {
      return await _mobileHelper.updateNote(note);
    }
  }

  Future<int> deleteNote(int id) async {
    if (kIsWeb) {
      return await _webHelper.deleteNote(id);
    } else {
      return await _mobileHelper.deleteNote(id);
    }
  }

  // New method to toggle pin status
  Future<int> toggleNotePin(int noteId, bool isPinned) async {
    if (kIsWeb) {
      return await _webHelper.toggleNotePin(noteId, isPinned);
    } else {
      return await _mobileHelper.toggleNotePin(noteId, isPinned);
    }
  }

  Future close() async {
    if (!kIsWeb) {
      await _mobileHelper.close();
    }
  }
}