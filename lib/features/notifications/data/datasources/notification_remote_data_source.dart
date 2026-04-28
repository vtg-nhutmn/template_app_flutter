import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/features/notifications/data/models/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class NotificationRemoteDataSource {
  Stream<List<NotificationModel>> watchNotifications();
  Future<void> markAsRead(String notifId);
  Future<void> createNotification({
    required String title,
    required String body,
    required String type,
    String? relatedId,
    required bool isGlobal,
    String? targetUserId,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotificationRemoteDataSourceImpl(this._firestore, this._auth);

  @override
  Stream<List<NotificationModel>> watchNotifications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('notifications')
        .where(
          Filter.or(
            Filter('isGlobal', isEqualTo: true),
            Filter('targetUserId', isEqualTo: userId),
          ),
        )
        .snapshots()
        .map((snapshot) {
          final models = snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc.id, doc.data()))
              .toList();
          models.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return models;
        })
        .handleError(
          (e) => throw ServerException(message: 'Không thể tải thông báo: $e'),
        );
  }

  @override
  Future<void> markAsRead(String notifId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    try {
      await _firestore.collection('notifications').doc(notifId).update({
        'readBy': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw ServerException(message: 'Không thể đánh dấu đã đọc: $e');
    }
  }

  @override
  Future<void> createNotification({
    required String title,
    required String body,
    required String type,
    String? relatedId,
    required bool isGlobal,
    String? targetUserId,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'title': title,
        'body': body,
        'type': type,
        'relatedId': relatedId,
        'isGlobal': isGlobal,
        'targetUserId': targetUserId,
        'readBy': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(message: 'Không thể tạo thông báo: $e');
    }
  }
}
