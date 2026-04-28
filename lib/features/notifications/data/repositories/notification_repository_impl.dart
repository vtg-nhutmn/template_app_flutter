import 'package:demo/core/errors/exceptions.dart';
import 'package:demo/core/errors/failures.dart';
import 'package:demo/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:demo/features/notifications/domain/entities/notification_entity.dart';
import 'package:demo/features/notifications/domain/repositories/notification_repository.dart';
import 'package:fpdart/fpdart.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Stream<Either<Failure, List<NotificationEntity>>> watchNotifications() {
    return _dataSource
        .watchNotifications()
        .map<Either<Failure, List<NotificationEntity>>>(
          (models) => Right(models.map((m) => m.toEntity()).toList()),
        )
        .handleError(
          (e) => Left(
            ServerFailure(
              message: e is ServerException ? e.message : e.toString(),
            ),
          ),
        );
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notifId) async {
    try {
      await _dataSource.markAsRead(notifId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Lỗi không xác định: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createNotification({
    required String title,
    required String body,
    required String type,
    String? relatedId,
    required bool isGlobal,
    String? targetUserId,
  }) async {
    try {
      await _dataSource.createNotification(
        title: title,
        body: body,
        type: type,
        relatedId: relatedId,
        isGlobal: isGlobal,
        targetUserId: targetUserId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Lỗi không xác định: $e'));
    }
  }
}
