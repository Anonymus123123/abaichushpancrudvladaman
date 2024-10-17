import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  final String name;

  Subject({required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class Note {
  final String id;
  final String noteText;
  final Timestamp timestamp;
  final Subject subject;

  Note({
    required this.id,
    required this.noteText,
    required this.timestamp,
    required this.subject,
  });

  // Creating a Note from a Firestore document
  factory Note.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      noteText: data['note'],
      timestamp: data['timestamp'],
      subject: Subject.fromJson(data['subject'] ?? {}),
    );
  }

  // Convert Note to JSON (for adding or updating)
  Map<String, dynamic> toJson() {
    return {
      'note': noteText,
      'timestamp': timestamp,
      'subject': subject.toJson(),
    };
  }
}
