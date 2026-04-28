import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? relatedId;
  final bool isGlobal;
  final String? targetUserId;
  final List<String> readBy;
  final String createdAt;

  const NotificationEntity({
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

  bool isReadBy(String userId) => readBy.contains(userId);

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    type,
    relatedId,
    isGlobal,
    targetUserId,
    readBy,
    createdAt,
  ];
}
