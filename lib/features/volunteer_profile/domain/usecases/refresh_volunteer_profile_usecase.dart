import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/entity/volunteer_profile_entity.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/repository/profile_repository.dart';

class RefreshVolunteerProfileUseCase {
  final ProfileRepository repository;

  RefreshVolunteerProfileUseCase({required this.repository});

  Future<Either<Failure, VolunteerProfileEntity>> call() async {
    return await repository.refreshVolunteerProfile();
  }
}
