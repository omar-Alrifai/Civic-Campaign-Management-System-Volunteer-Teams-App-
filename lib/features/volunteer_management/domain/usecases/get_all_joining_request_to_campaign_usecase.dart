import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/joining_requests_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class GetAllJoiningRequestToCampaignUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  GetAllJoiningRequestToCampaignUsecase({
    required this.volunteerManagementRepository,
  });

  Future<Either<Failure, List<JoiningRequestsEntity>>> call() async {
    return await volunteerManagementRepository.getAllJoiningRequestToCampaign();
  }
}
