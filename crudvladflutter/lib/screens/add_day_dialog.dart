import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDayDialog extends StatefulWidget {
  @override
  _AddDayDialogState createState() => _AddDayDialogState();
}

class _AddDayDialogState extends State<AddDayDialog> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String dayName = '';
  List<String> selectedSubjects = [];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      firestore.collection('days').add({
        'name': dayName,
        'subjects': selectedSubjects.map((subject) => {'name': subject}).toList(),
      }).then((_) {
        Navigator.of(context).pop(); // Закрыть диалоговое окно
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить день'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Имя дня'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите имя дня';
                }
                return null;
              },
              onChanged: (value) {
                dayName = value;
              },
            ),
            SizedBox(height: 8),
            Text('Выберите предметы:'),
            StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('subjects').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Ошибка: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final subjects = snapshot.data!.docs;

                return Wrap(
                  spacing: 8,
                  children: subjects.map((subject) {
                    final subjectName = subject['name'];
                    return ChoiceChip(
                      label: Text(subjectName),
                      selected: selectedSubjects.contains(subjectName),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedSubjects.add(subjectName);
                          } else {
                            selectedSubjects.remove(subjectName);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Сохранить день'),
            ),
          ],
        ),
      ),
    );
  }
}
