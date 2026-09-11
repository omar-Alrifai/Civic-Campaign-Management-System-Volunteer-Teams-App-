import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/regions_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class GetAllRegionsUseCase {
  final VolunteerManagementRepository repository;

  GetAllRegionsUseCase(this.repository);
  Future<Either<Failure, List<RegionEntity>>> call() async {
    return await repository.getAllRegions();
  }
}
