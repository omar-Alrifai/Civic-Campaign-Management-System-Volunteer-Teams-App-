import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class AcceptToJoinTheCampaignUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  AcceptToJoinTheCampaignUsecase({required this.volunteerManagementRepository});
  Future<Either<Failure, Unit>> call({required int participantId}) async {
    return await volunteerManagementRepository.acceptToJoinTheCampaign(
      participantId: participantId,
    );
  }
}
