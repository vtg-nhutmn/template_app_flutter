import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  final String uid;
  final String username;
  final String email;
  final String displayName;
  final String? phone;
  final bool isActive;
  final bool role;
  final String createdAt;

  const ProfileModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.displayName,
    this.phone,
    required this.isActive,
    required this.role,
    required this.createdAt,
  });

  factory ProfileModel.fromFirestore(String uid, Map<String, dynamic> data) {
    final createdAt = data['createdAt'];
    String createdAtStr = '';
    if (createdAt is Timestamp) {
      createdAtStr = createdAt.toDate().toIso8601String();
    } else if (createdAt != null) {
      createdAtStr = createdAt.toString();
    }

    return ProfileModel(
      uid: uid,
      username: data['username'] as String? ?? '',
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      phone: data['phone'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      role: data['role'] as bool? ?? false,
      createdAt: createdAtStr,
    );
  }

  ProfileEntity toEntity() => ProfileEntity(
    uid: uid,
    username: username,
    email: email,
    displayName: displayName,
    phone: phone,
    isActive: isActive,
    role: role,
    createdAt: createdAt,
  );
}
