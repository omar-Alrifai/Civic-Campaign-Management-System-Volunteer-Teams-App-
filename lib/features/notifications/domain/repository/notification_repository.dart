import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';

import '../entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
}
