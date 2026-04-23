// lib/models/user_model.dart

class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final String? avatarUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    this.avatarUrl,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      name: map['name'] ?? 'Student',
      avatarUrl: map['avatar_url'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'phone': phone,
        'name': name,
        'avatar_url': avatarUrl,
      };

  UserModel copyWith({
    String? name,
    String? avatarUrl,
    String? phone,
  }) =>
      UserModel(
        id: id,
        email: email,
        phone: phone ?? this.phone,
        name: name ?? this.name,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        createdAt: createdAt,
      );
}
