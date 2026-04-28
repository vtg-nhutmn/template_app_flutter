import 'package:demo/app/theme/app_colors.dart';
import 'package:demo/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';

class NotificationTileWidget extends StatelessWidget {
  final NotificationEntity notification;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationTileWidget({
    super.key,
    required this.notification,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isRead ? null : AppColors.primary.withValues(alpha: 0.04),
      leading: CircleAvatar(
        backgroundColor: isRead
            ? Colors.grey.shade200
            : AppColors.primary.withValues(alpha: 0.12),
        child: Icon(
          _getIcon(notification.type),
          size: 20,
          color: isRead ? Colors.grey : AppColors.primary,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            notification.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(notification.createdAt),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      trailing: isRead
          ? null
          : Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
      onTap: onTap,
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'product_added':
        return Icons.shopping_bag_outlined;
      case 'order_update':
        return Icons.receipt_long_outlined;
      default:
        return Icons.campaign_outlined;
    }
  }

  String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Vừa xong';
      if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
      if (diff.inHours < 24) return '${diff.inHours} giờ trước';
      return '${diff.inDays} ngày trước';
    } catch (_) {
      return '';
    }
  }
}
