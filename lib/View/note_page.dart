import 'package:flutter/material.dart';
import 'package:note_master/Model/note.dart';

class NotePage extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteSelected;
  final Function(Note) onNoteDeleted;
  final Function(int, int) onNoteMoved;

  const NotePage({
    Key? key,
    required this.notes,
    required this.onNoteSelected,
    required this.onNoteDeleted,
    required this.onNoteMoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          key: ValueKey(note),
          title: Text(note.title),
          subtitle: Text(note.content),
          onTap: () => onNoteSelected(note),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onNoteDeleted(note),
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        onNoteMoved(oldIndex, newIndex);
      },
    );
  }
}
