import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String noteText;
  final Timestamp timestamp;

  Note({
    required this.id,
    required this.noteText,
    required this.timestamp,
  });

  // Создание Note из документа Firestore
  factory Note.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      noteText: data['note'],
      timestamp: data['timestamp'],
    );
  }

  // Преобразование Note в JSON (например, для добавления или обновления)
  Map<String, dynamic> toJson() {
    return {
      'note': noteText,
      'timestamp': timestamp,
    };
  }
}
