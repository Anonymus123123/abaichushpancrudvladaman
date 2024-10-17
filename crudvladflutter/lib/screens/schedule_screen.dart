import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_day_dialog.dart'; // Импортируйте диалог добавления дня
import 'admin_panel.dart'; // Импортируйте админ-панель

class ScheduleScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Расписание'),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanel()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('days').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final days = snapshot.data!.docs;

          return ListView.builder(
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final subjects = day['subjects'] as List;
              return ListTile(
                title: Text(day['name']),
                subtitle: Text(subjects.map((s) => s['name']).join(', ')),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddDayDialog(), // Открытие диалога
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
