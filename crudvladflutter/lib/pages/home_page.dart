import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudvladflutter/services/firestore.dart'; // FirestoreService и модель Note
import 'package:flutter/material.dart';
import 'package:crudvladflutter/models/note.dart'; // Импорт модели Note

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController textController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  void openNoteBox({Note? note}) {
    // Если редактируем заметку, заполняем текстовое поле существующим текстом
    if (note != null) {
      textController.text = note.noteText;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? 'Add Note' : 'Update Note'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter your note',
            border: OutlineInputBorder(),
          ),
          maxLines: null, // Позволяет вводить текст любой длины
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (note == null) {
                // Добавление новой заметки
                Note newNote = Note(
                  id: '', // Firestore сгенерирует ID автоматически
                  noteText: textController.text,
                  timestamp: Timestamp.now(),
                );
                firestoreService.addNote(newNote);
              } else {
                // Обновление существующей заметки
                Note updatedNote = Note(
                  id: note.id,
                  noteText: textController.text,
                  timestamp: Timestamp.now(),
                );
                firestoreService.updateNote(updatedNote);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: Text(note == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes & Subjects")),
      body: _currentIndex == 0 ? buildNotesTab() : buildSubjectsTab(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        onPressed: () => openNoteBox(),
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subject),
            label: 'Subjects',
          ),
        ],
      ),
    );
  }

  Widget buildNotesTab() {
    return StreamBuilder<List<Note>>(
      stream: firestoreService.getNotesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Note> notesList = snapshot.data!;

          return ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              Note note = notesList[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(note.noteText, style: const TextStyle(fontSize: 16)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => openNoteBox(note: note),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => firestoreService.deleteNote(note.id),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text("No notes available", style: TextStyle(fontSize: 18)),
          );
        }
      },
    );
  }

  Widget buildSubjectsTab() {
    // Здесь можно добавить логику для отображения контента таба Subjects.
    return const Center(
      child: Text("Subjects content goes here", style: TextStyle(fontSize: 18)),
    );
  }
}
