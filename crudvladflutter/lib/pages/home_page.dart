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
  final TextEditingController textController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  void openNoteBox({Note? note}) {
    // If we're editing a note, fill the text fields with the existing data
    if (note != null) {
      textController.text = note.noteText;
      subjectController.text = note.subject.name;
    } else {
      textController.clear();
      subjectController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? 'Add Note' : 'Update Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter your note',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                hintText: 'Enter subject name',
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (note == null) {
                // Adding a new note
                Note newNote = Note(
                  id: '', // Firestore will generate the ID automatically
                  noteText: textController.text,
                  timestamp: Timestamp.now(),
                  subject: Subject(name: subjectController.text),
                );
                await firestoreService.addNote(newNote);
              } else {
                // Updating an existing note
                Note updatedNote = Note(
                  id: note.id,
                  noteText: textController.text,
                  timestamp: Timestamp.now(),
                  subject: Subject(name: subjectController.text),
                );
                await firestoreService.updateNote(updatedNote);
              }
              textController.clear();
              subjectController.clear();
              Navigator.pop(context);
              setState(() {}); // Refresh the UI to reflect the changes
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
      body: buildNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildNotesList() {
    return StreamBuilder<List<Note>>(
      stream: firestoreService.getNotesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Note> notesList = snapshot.data!;

          if (notesList.isEmpty) {
            return const Center(
              child: Text("No notes available", style: TextStyle(fontSize: 18)),
            );
          }

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
                    child: Text(
                      note.noteText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  subtitle: Text(
                    'Subject: ${note.subject.name}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => openNoteBox(note: note),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          await firestoreService.deleteNote(note.id);
                          setState(() {}); // Refresh the UI after deletion
                        },
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
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
