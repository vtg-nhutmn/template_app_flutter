import 'package:equatable/equatable.dart';

class RoleEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final List<String> permissions;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });

  @override
  List<Object?> get props => [id, name, description, permissions];
}

class ProfileEntity extends Equatable {
  final int id;
  final String code;
  final String name;
  final String username;
  final int branchId;
  final String email;
  final String? phone;
  final int roleId;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final RoleEntity role;

  const ProfileEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.username,
    required this.branchId,
    required this.email,
    this.phone,
    required this.roleId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    username,
    branchId,
    email,
    phone,
    roleId,
    isActive,
    createdAt,
    updatedAt,
    role,
  ];
}
