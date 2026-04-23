import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String uid;
  final String username;
  final String email;
  final String displayName;
  final String? phone;
  final bool isActive;
  final bool role;
  final String createdAt;

  const ProfileEntity({
    required this.uid,
    required this.username,
    required this.email,
    required this.displayName,
    this.phone,
    required this.isActive,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    uid,
    username,
    email,
    displayName,
    phone,
    isActive,
    role,
    createdAt,
  ];
}
