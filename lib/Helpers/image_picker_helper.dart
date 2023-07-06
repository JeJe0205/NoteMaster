import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<String?> captureImageWithCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    return image?.path;
  }
}
