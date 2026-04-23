// lib/supabase/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_init.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  static SupabaseClient get _client => SupabaseInit.client;

  // ── Current session user ────────────────────────────────────────────────────
  static User? get currentUser => _client.auth.currentUser;
  static bool get isLoggedIn => currentUser != null;

  // ── Sign Up ─────────────────────────────────────────────────────────────────
  static Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'phone': phone},
    );

    if (response.user == null) return null;

    // Insert into profiles table
    await _client.from(AppConstants.profilesTable).upsert({
      'id': response.user!.id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar_url': null,
    });

    return UserModel(
      id: response.user!.id,
      email: email,
      name: name,
      phone: phone,
    );
  }

  // ── Login ───────────────────────────────────────────────────────────────────
  static Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) return null;

    // Fetch profile
    final profile = await _client
        .from(AppConstants.profilesTable)
        .select()
        .eq('id', response.user!.id)
        .maybeSingle();

    if (profile == null) {
      return UserModel(
        id: response.user!.id,
        email: email,
        name: response.user!.userMetadata?['name'] ?? 'Student',
      );
    }

    return UserModel.fromMap(profile);
  }

  // ── Sign Out ────────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ── Fetch current profile ───────────────────────────────────────────────────
  static Future<UserModel?> fetchProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final profile = await _client
        .from(AppConstants.profilesTable)
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) return null;
    return UserModel.fromMap(profile);
  }
}
