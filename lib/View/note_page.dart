import 'package:flutter/material.dart';
import 'package:note_master/Model/note.dart';
import 'package:sensors_plus/sensors_plus.dart';

class NotePage extends StatefulWidget {
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
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  double _accelerometerThreshold = 12.0; // Adjust the threshold as needed

  @override
  void initState() {
    super.initState();
    // Start listening to accelerometer events
    accelerometerEvents.listen((event) {
      setState(() {
        if (event.x.abs() > _accelerometerThreshold ||
            event.y.abs() > _accelerometerThreshold ||
            event.z.abs() > _accelerometerThreshold) {
          // Shake detected, delete the first note
          if (widget.notes.isNotEmpty) {
            widget.onNoteDeleted(widget.notes.first);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // Stop listening to accelerometer events
    accelerometerEvents.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        final note = widget.notes[index];
        return ListTile(
          key: ValueKey(note),
          title: Text(note.title),
          subtitle: Text(note.content),
          onTap: () => widget.onNoteSelected(note),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => widget.onNoteDeleted(note),
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        widget.onNoteMoved(oldIndex, newIndex);
      },
    );
  }
}
