import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class ChangeCampaignStatusUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  ChangeCampaignStatusUsecase({required this.volunteerManagementRepository});

  Future<Either<Failure, Unit>> call({required int projectId}) async {
    return await volunteerManagementRepository.changeCampaignStatus(
      projectId: projectId,
    );
  }
}
