import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/features/profile/data/models/profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile({
    required String displayName,
    required String phone,
    required String email,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<ProfileModel> getProfile() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'Chưa đăng nhập');
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists || doc.data() == null) {
        throw const ServerException(
          message: 'Không tìm thấy thông tin người dùng',
        );
      }

      return ProfileModel.fromFirestore(user.uid, doc.data()!);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Không thể tải thông tin người dùng: $e');
    }
  }

  @override
  Future<void> updateProfile({
    required String displayName,
    required String phone,
    required String email,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw const ServerException(message: 'Chưa đăng nhập');

    try {
      final updates = <String, dynamic>{
        'displayName': displayName,
        'phone': phone,
      };
      if (email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
        updates['email'] = email;
      }

      await _firestore.collection('users').doc(user.uid).update(updates);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Không thể cập nhật thông tin: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw const ServerException(message: 'Chưa đăng nhập');

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          throw const ServerException(message: 'Mật khẩu hiện tại không đúng');
        case 'weak-password':
          throw const ServerException(
            message: 'Mật khẩu mới quá yếu (ít nhất 6 ký tự)',
          );
        default:
          throw ServerException(message: 'Đổi mật khẩu thất bại: ${e.message}');
      }
    } catch (e) {
      throw ServerException(message: 'Đổi mật khẩu thất bại: $e');
    }
  }
}
