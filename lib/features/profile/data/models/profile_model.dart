import '../../domain/entities/profile_entity.dart';

class RoleModel {
  final int id;
  final String name;
  final String description;
  final List<String> permissions;

  const RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      permissions: List<String>.from(json['permissions'] as List),
    );
  }

  RoleEntity toEntity() => RoleEntity(
    id: id,
    name: name,
    description: description,
    permissions: permissions,
  );
}

class ProfileModel {
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
  final RoleModel role;

  const ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      branchId: json['branchId'] as int,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      roleId: json['roleId'] as int,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      role: RoleModel.fromJson(json['role'] as Map<String, dynamic>),
    );
  }

  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    code: code,
    name: name,
    username: username,
    branchId: branchId,
    email: email,
    phone: phone,
    roleId: roleId,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
    role: role.toEntity(),
  );
}
