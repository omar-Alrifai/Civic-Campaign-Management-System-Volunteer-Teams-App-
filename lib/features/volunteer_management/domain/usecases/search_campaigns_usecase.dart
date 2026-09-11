import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class SearchCampaignsUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  SearchCampaignsUsecase({required this.volunteerManagementRepository});

  Future<Either<Failure, List<CampaignEntity>>> call({
    required String query,
    String? categoryFilter,
    String? statusFilter,
  }) async {
    return await volunteerManagementRepository.searchCampaigns(
      query: query,
      categoryFilter: categoryFilter,
      statusFilter: statusFilter,
    );
  }
}
