import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickPhoto(WidgetRef ref, String entranceId) async {
  return ImagePicker().pickImage(source: ImageSource.gallery);
}
