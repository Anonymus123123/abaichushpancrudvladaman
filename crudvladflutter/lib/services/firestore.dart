import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

class FirestoreService {
  final CollectionReference notes =
  FirebaseFirestore.instance.collection('notes');

  Future<void> addNote(Note note) {
    return notes.add(note.toJson());
  }

  Stream<List<Note>> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) => Note.fromDocument(doc)).toList();
      },
    );
  }

  Future<void> updateNote(Note note) {
    return notes.doc(note.id).update(note.toJson());
  }

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}