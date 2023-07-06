import 'package:image_picker/image_picker.dart';

class Note {
  String title;
  String content;
  DateTime creationDate;
  String imagePath;
  List<String> checkboxTexts;

  Note({
    required this.title,
    required this.content,
    required this.creationDate,
    this.imagePath = '',
    required this.checkboxTexts,
  });

  void updateNote({
    required String newTitle,
    required String newContent,
    String? newImagePath,
  }) {
    title = newTitle;
    content = newContent;
    if (newImagePath != null) {
      imagePath = newImagePath;
    }
  }
}

class Checklist {
  String title;
  List<String> tasks;
  List<bool> completed;

  Checklist({
    required this.title,
    required this.tasks,
  }) : completed = List<bool>.filled(tasks.length, false);

  void updateTaskStatus(int index, bool isCompleted) {
    completed[index] = isCompleted;
  }
}

class ImagePickerHelper {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return pickedImage.path;
    }
    return null;
  }

  Future<String?> captureImageWithCamera() async {
    final capturedImage =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (capturedImage != null) {
      return capturedImage.path;
    }
    return null;
  }
}
