import 'dart:convert';

import '../core/http_client.dart';
import '../shared/models/note.dart';

class NoteRepository {
  NoteRepository._();
  static final NoteRepository _instance = NoteRepository._();
  factory NoteRepository() {
    return _instance;
  }

  Future<List<Note>> loadNotes({ 
    String? searchKey,
    String? userId,
    String? topicId,
  }) async {
    final Map<String, dynamic> params = {
      if (searchKey != null)
        'searchKey': searchKey,
      if (userId != null)
        'userId': userId,
      if (topicId != null)
        'topicId': topicId,
    };
    final response = await httpClient.get(Uri.http('notes', '', params));

    if (response.statusCode < 400) {
      final String data = response.body;
      final parsed = jsonDecode(data).cast<Map<String, dynamic>>();
      final List<Note> notes = parsed.map<Note>((json) => Note.fromJson(json)).toList();
      return notes;
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<Note> loadNote(String itemId) async {
    final response = await httpClient.get(Uri.http('notes', '/$itemId'));

    if (response.statusCode < 400) {
      String data = response.body;
      final Note note = Note.fromJson(jsonDecode(data));
      return note;
    } else {
      throw Exception('Failed to load note');
    }
  }

  Future<Note> addNote(Note note) async {
    final response = await httpClient.post(
      Uri.http('notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note),
    );

    if (response.statusCode < 400) {
      String data = response.body;
      final Note newItem = Note.fromJson(jsonDecode(data));
      return newItem;
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<Note> updateNote(Note note) async {
    final response = await httpClient.patch(
      Uri.http('notes', '/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note),
    );

    if (response.statusCode < 400) {
      String data = response.body;
      final Note updatedItem = Note.fromJson(jsonDecode(data));
      return updatedItem;
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<Note> deleteNote(Note note) async {
    final response = await httpClient.delete(
      Uri.http('notes', '/${note.id}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode < 400) {
      return note;
    } else {
      throw Exception('Failed to delete note');
    }
  }
}