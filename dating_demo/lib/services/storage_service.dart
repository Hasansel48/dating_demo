import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Galeriden veya kameradan resim seçer
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Resim seçilemedi: $e');
    }
  }

  /// Profil fotoğrafını Firebase Storage'a yükler
  Future<String> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Dosya referansı oluştur
      final String fileName = 'profile_$userId.jpg';
      final Reference ref = _storage.ref().child('profiles/$fileName');

      // Metadata ekle
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Dosyayı yükle
      final UploadTask uploadTask = ref.putFile(imageFile, metadata);

      // Yükleme tamamlanana kadar bekle
      final TaskSnapshot snapshot = await uploadTask;

      // Download URL'ini al
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Fotoğraf yüklenemedi: $e');
    }
  }

  /// Profil fotoğrafını siler
  Future<void> deleteProfilePhoto({required String userId}) async {
    try {
      final String fileName = 'profile_$userId.jpg';
      final Reference ref = _storage.ref().child('profiles/$fileName');
      await ref.delete();
    } catch (e) {
      throw Exception('Fotoğraf silinemedi: $e');
    }
  }

  /// Yükleme ilerlemesini dinler
  Stream<double> uploadProgress(UploadTask uploadTask) {
    return uploadTask.snapshotEvents.map((TaskSnapshot snapshot) {
      return snapshot.bytesTransferred / snapshot.totalBytes;
    });
  }
}
