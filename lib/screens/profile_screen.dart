// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../supabase/auth_service.dart';
import '../supabase/database_service.dart';
import '../supabase/storage_service.dart';
import '../models/user_model.dart';
import '../utils/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl= TextEditingController();

  UserModel? _user;
  File? _pickedImage;
  bool _loading = true;
  bool _saving  = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await AuthService.fetchProfile();
      if (mounted) {
        setState(() {
          _user = user;
          _nameCtrl.text  = user?.name  ?? '';
          _phoneCtrl.text = user?.phone ?? '';
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 600,
    );
    if (result != null && mounted) {
      setState(() => _pickedImage = File(result.path));
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      String? avatarUrl = _user?.avatarUrl;

      // Upload new avatar if picked
      if (_pickedImage != null) {
        avatarUrl = await StorageService.uploadAvatar(_pickedImage!);
      }

      final updated = await DatabaseService.updateProfile(
        name: _nameCtrl.text.trim(),
        avatarUrl: avatarUrl,
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      );

      if (!mounted) return;
      setState(() => _user = updated);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: const [
            Icon(Icons.check_circle_outline, color: AppTheme.success, size: 18),
            SizedBox(width: 8),
            Text('Profile updated successfully!'),
          ]),
          backgroundColor: AppTheme.surfaceAlt,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.surfaceAlt,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: LoadingWidget(message: 'Loading profile...'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Avatar picker ─────────────────────────────────────────────
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.accent, width: 2.5),
                        gradient: (_pickedImage == null && _user?.avatarUrl == null)
                            ? const LinearGradient(
                                colors: [AppTheme.accent, AppTheme.accentGlow],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accent.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _pickedImage != null
                            ? Image.file(_pickedImage!, fit: BoxFit.cover)
                            : (_user?.avatarUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: _user!.avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => _fallback(),
                                  )
                                : _fallback()),
                      ),
                    ),
                  ),
                  // Edit badge
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.bg, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ).animate().scale(curve: Curves.elasticOut, duration: 600.ms),

              const SizedBox(height: 8),
              Text('Tap to change photo',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12)),

              const SizedBox(height: 32),

              // ── Email (read-only) ──────────────────────────────────────────
              _sectionLabel('Account Info'),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _user?.email ?? '',
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined,
                      color: AppTheme.textSecondary),
                ),
              ).animate(delay: 100.ms).fadeIn(),

              const SizedBox(height: 16),

              // ── Name ──────────────────────────────────────────────────────
              _sectionLabel('Personal Details'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: AppTheme.textSecondary),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ).animate(delay: 200.ms).fadeIn(),

              const SizedBox(height: 16),

              // ── Phone ─────────────────────────────────────────────────────
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined,
                      color: AppTheme.textSecondary),
                ),
              ).animate(delay: 300.ms).fadeIn(),

              const SizedBox(height: 36),

              CustomButton(
                label: 'Save Profile',
                onTap: _saveProfile,
                isLoading: _saving,
                icon: Icons.save_rounded,
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallback() {
    final name = _user?.name ?? 'S';
    return Container(
      color: AppTheme.accent,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'S',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 38,
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
