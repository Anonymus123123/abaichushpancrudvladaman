class Subject {
  final String name;

  Subject(this.name);

  factory Subject.fromFirestore(Map<String, dynamic> data) {
    return Subject(data['name'] as String);
  }
}
