import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import '../repository/notification_repository.dart';
import '../entity/notification_entity.dart';

class GetNotifications {
  final NotificationRepository repository;
  GetNotifications(this.repository);
  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}
