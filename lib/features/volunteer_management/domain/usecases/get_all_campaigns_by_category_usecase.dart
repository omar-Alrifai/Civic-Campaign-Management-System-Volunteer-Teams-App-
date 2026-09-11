import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class GetAllCampaignsByCategoryUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  GetAllCampaignsByCategoryUsecase({
    required this.volunteerManagementRepository,
  });

  Future<Either<Failure, List<CampaignEntity>>> call({
    required int categoryId,
    String? status,
  }) async {
    return await volunteerManagementRepository.getAllCampaignsByCategory(
      categoryId: categoryId,
      status: status,
    );
  }
}
