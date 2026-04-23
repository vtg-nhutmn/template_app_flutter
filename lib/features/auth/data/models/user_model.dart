import 'package:architecture/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String accessToken;

  const UserModel({required this.accessToken});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(accessToken: json['accessToken'] as String);
  }

  Map<String, dynamic> toJson() => {'accessToken': accessToken};

  UserEntity toEntity() => UserEntity(accessToken: accessToken);
}
