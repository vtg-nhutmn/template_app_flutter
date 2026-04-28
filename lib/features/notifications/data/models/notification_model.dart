import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? relatedId;
  final bool isGlobal;
  final String? targetUserId;
  final List<String> readBy;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.relatedId,
    required this.isGlobal,
    this.targetUserId,
    required this.readBy,
    required this.createdAt,
  });

  factory NotificationModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final createdAt = data['createdAt'];
    String createdAtStr = '';
    if (createdAt is Timestamp) {
      createdAtStr = createdAt.toDate().toIso8601String();
    } else if (createdAt != null) {
      createdAtStr = createdAt.toString();
    }

    return NotificationModel(
      id: id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      type: data['type'] as String? ?? 'broadcast',
      relatedId: data['relatedId'] as String?,
      isGlobal: data['isGlobal'] as bool? ?? true,
      targetUserId: data['targetUserId'] as String?,
      readBy: List<String>.from(data['readBy'] as List? ?? []),
      createdAt: createdAtStr,
    );
  }

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    title: title,
    body: body,
    type: type,
    relatedId: relatedId,
    isGlobal: isGlobal,
    targetUserId: targetUserId,
    readBy: readBy,
    createdAt: createdAt,
  );
}
