import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/entity/volunteer_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, VolunteerProfileEntity>> getVolunteerProfile();
  Future<Either<Failure, VolunteerProfileEntity>> refreshVolunteerProfile();
}
