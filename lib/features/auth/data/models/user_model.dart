import 'package:demo/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;

  const UserModel({required this.uid, required this.email});

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(uid: user.uid, email: user.email ?? '');
  }

  UserEntity toEntity() => UserEntity(uid: uid, email: email);
}
