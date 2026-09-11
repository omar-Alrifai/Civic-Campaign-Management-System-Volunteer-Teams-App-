import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/user_profile_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class GetUserProfileByUserIdUsecase {
  final VolunteerManagementRepository repository;

  GetUserProfileByUserIdUsecase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(int userId) async {
    return await repository.getProfileByUserId(userId);
  }
}
