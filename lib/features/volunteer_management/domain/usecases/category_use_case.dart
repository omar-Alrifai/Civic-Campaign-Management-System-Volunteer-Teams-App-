import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/category.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class GetCategoriesUseCase {
  final VolunteerManagementRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<MyCategory>>> call() async {
    return await repository.getCategories();
  }
}
