import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String username, required String password});
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required String displayName,
    required String phone,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw const ServerException(message: 'Tên đăng nhập không tồn tại');
      }

      final data = query.docs.first.data();
      final email = data['email'] as String;
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final isActive = data['isActive'] as bool? ?? true;
      if (!isActive) {
        await _firebaseAuth.signOut();
        throw const ServerException(
          message:
              'Tài khoản đã bị vô hiệu hóa, vui lòng liên hệ quản trị viên',
        );
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: _mapFirebaseAuthError(e.code),
        statusCode: null,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Đăng nhập thất bại: $e');
    }
  }

  @override
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required String displayName,
    required String phone,
  }) async {
    try {
      final existing = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw const ServerException(message: 'Tên đăng nhập đã được sử dụng');
      }
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'displayName': displayName,
        'phone': phone,
        'isActive': true,
        'role': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _firebaseAuth.signOut();

      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: _mapFirebaseAuthError(e.code));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Đăng ký thất bại: $e');
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Tài khoản không tồn tại';
      case 'wrong-password':
        return 'Mật khẩu không đúng';
      case 'invalid-credential':
        return 'Thông tin đăng nhập không hợp lệ';
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu quá yếu (ít nhất 6 ký tự)';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'too-many-requests':
        return 'Quá nhiều lần thử, vui lòng thử lại sau';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng';
      default:
        return 'Đã xảy ra lỗi, vui lòng thử lại';
    }
  }
}
