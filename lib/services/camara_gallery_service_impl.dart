import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:map_track_app/services/camara_gallery_service.dart';
import 'package:path_provider/path_provider.dart';


class CameraGalleryServiceImpl extends CameraGalleryService {
  final ImagePicker _picker = ImagePicker();
  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (photo == null) return null;
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo == null) return null;
    return _saveToPersistentStorage(photo);
  }

  Future<String> _saveToPersistentStorage(XFile photo) async {
    final directory = await getApplicationDocumentsDirectory();
    final String newPath = '${directory.path}/${photo.name}';

    final File imageFile = File(photo.path);
    final savedImage = await imageFile.copy(newPath);

    return savedImage.path;
  }
}