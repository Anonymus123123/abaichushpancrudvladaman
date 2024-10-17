import 'package:cloud_firestore/cloud_firestore.dart';
import 'subject.dart';

class Day {
  final String name;
  final List<Subject> subjects;

  Day(this.name, this.subjects);

  factory Day.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final subjectsList = (data['subjects'] as List<dynamic>)
        .map((subject) => Subject.fromFirestore(subject))
        .toList();
    return Day(data['name'] as String, subjectsList);
  }
}
