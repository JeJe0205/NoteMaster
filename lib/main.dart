import 'package:flutter/material.dart';
import 'package:note_master/Model/note.dart';
import 'package:note_master/View/note_page.dart';
import 'package:note_master/View/note_editor_page.dart';

void main() {
  runApp(const NoteMasterApp());
}

class NoteMasterApp extends StatelessWidget {
  const NoteMasterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteMaster',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: NoteHomePage(),
    );
  }
}

class NoteHomePage extends StatefulWidget {
  const NoteHomePage({Key? key}) : super(key: key);

  @override
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];

  void _openNoteEditorPage(Note? note) async {
    final updatedNote = await Navigator.push<Note?>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorPage(note: note),
      ),
    );

    if (updatedNote != null) {
      setState(() {
        if (note != null) {
          // Update existing note
          final index = notes.indexOf(note);
          notes[index] = updatedNote;
        } else {
          // Create new note
          notes.add(updatedNote);
        }
        // Update filteredNotes as well
        _filterNotes('');
      });
    }
  }

  void _deleteNote(Note note) {
    setState(() {
      notes.remove(note);
      // Remove note from filteredNotes as well
      filteredNotes.remove(note);
    });
  }

  void _filterNotes(String query) {
    setState(() {
      filteredNotes = notes.where((note) {
        final titleLower = note.title.toLowerCase();
        final contentLower = note.content.toLowerCase();
        final queryLower = query.toLowerCase();

        return titleLower.contains(queryLower) ||
            contentLower.contains(queryLower);
      }).toList();
    });
  }

  void _moveNotePosition(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final note = filteredNotes.removeAt(oldIndex);
      filteredNotes.insert(newIndex, note);
    });
  }

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteMaster'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterNotes,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: NotePage(
              notes: filteredNotes,
              onNoteSelected: _openNoteEditorPage,
              onNoteDeleted: _deleteNote,
              onNoteMoved: _moveNotePosition,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteEditorPage(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
