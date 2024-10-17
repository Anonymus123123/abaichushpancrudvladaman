import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String subjectName = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      firestore.collection('subjects').add({'name': subjectName}).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Предмет добавлен')),
        );
        setState(() {
          subjectName = ''; // Очистка поля после добавления
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Админ панель'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Имя предмета'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя предмета';
                  }
                  return null;
                },
                onChanged: (value) {
                  subjectName = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Добавить предмет'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
