// lib/supabase/storage_service.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_init.dart';
import 'auth_service.dart';
import '../utils/constants.dart';

class StorageService {
  static SupabaseClient get _client => SupabaseInit.client;

  /// Upload avatar image and return public URL
  static Future<String?> uploadAvatar(File imageFile) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return null;

    final fileExt = imageFile.path.split('.').last;
    final filePath = '$userId/avatar.$fileExt';

    await _client.storage.from(AppConstants.avatarsBucket).upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = _client.storage
        .from(AppConstants.avatarsBucket)
        .getPublicUrl(filePath);

    return publicUrl;
  }
}
