import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class GetAllCampaignsCreatedByVolunteerAdminUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  GetAllCampaignsCreatedByVolunteerAdminUsecase({
    required this.volunteerManagementRepository,
  });

  Future<Either<Failure, List<CampaignEntity>>> call({String? status}) async {
    return await volunteerManagementRepository
        .getAllCampaignsCreatedByVolunteerAdmin(status: status);
  }
}
