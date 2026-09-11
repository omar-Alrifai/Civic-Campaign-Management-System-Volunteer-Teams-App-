import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class GetAllCampaignsUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  GetAllCampaignsUsecase({required this.volunteerManagementRepository});

  Future<Either<Failure, List<CampaignEntity>>> call({String? status}) async {
    return await volunteerManagementRepository.getAllCampaigns(status: status);
  }
}
