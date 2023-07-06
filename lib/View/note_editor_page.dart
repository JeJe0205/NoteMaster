import 'package:flutter/material.dart';
import 'package:note_master/Model/note.dart';
import 'package:note_master/helpers/image_picker_helper.dart' as helper;
import 'dart:io';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({Key? key, this.note}) : super(key: key);

  @override
  _NoteEditorPageState createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String _imagePath = '';
  List<bool> _checkboxValues = [];
  List<TextEditingController> _checkboxControllers = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
    _imagePath = widget.note?.imagePath ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    for (var controller in _checkboxControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _pickImage() async {
    final helper.ImagePickerHelper imagePicker = helper.ImagePickerHelper();
    final imagePath = await imagePicker.pickImageFromGallery();

    if (imagePath != null) {
      setState(() {
        _imagePath = imagePath;
      });
    }
  }

  void _addCheckbox() {
    setState(() {
      _checkboxValues.add(false);
      _checkboxControllers.add(TextEditingController());
    });
  }

  Future<void> _saveNote() async {
    final newNote = Note(
      title: _titleController.text,
      content: _contentController.text,
      creationDate: DateTime.now(),
      imagePath: _imagePath,
      checkboxTexts:
          _checkboxControllers.map((controller) => controller.text).toList(),
    );

    if (widget.note != null) {
      widget.note!.updateNote(
        newTitle: _titleController.text,
        newContent: _contentController.text,
        newImagePath: _imagePath,
      );
      Navigator.pop(context, widget.note);
    } else {
      Navigator.pop(context, newNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'Create Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16.0),
            for (int i = 0; i < _checkboxControllers.length; i++)
              Row(
                children: [
                  Checkbox(
                    value: _checkboxValues[i],
                    onChanged: (value) {
                      setState(() {
                        _checkboxValues[i] = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _checkboxControllers[i],
                      decoration: InputDecoration(
                        labelText: 'Checkbox ${i + 1}',
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Content',
              ),
            ),
            SizedBox(height: 16.0),
            if (_imagePath.isNotEmpty)
              Image.file(
                File(_imagePath),
                height: 200,
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Add Image'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addCheckbox,
              child: Text('Add Checkbox'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
