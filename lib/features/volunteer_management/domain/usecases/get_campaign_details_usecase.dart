import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class GetCampaignDetailsUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  GetCampaignDetailsUsecase({required this.volunteerManagementRepository});

  Future<Either<Failure, CampaignEntity>> call({
    required int campaignId,
  }) async {
    return await volunteerManagementRepository.getCampaignDetails(
      campaignId: campaignId,
    );
  }
}
