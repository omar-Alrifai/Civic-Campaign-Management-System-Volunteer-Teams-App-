import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class CreateProjectOrCampaignUsecase {
  final VolunteerManagementRepository volunteerManagementRepository;

  CreateProjectOrCampaignUsecase({required this.volunteerManagementRepository});

  Future<Either<Failure, Unit>> call({
    required String title,
    required String description,
    required int requiredAmount,
    required String area,
    required double longitude,
    required double latitude,
    required int categoryId,
    required String image,
    required int numberOfParticipants,
    required String executionDate,
  }) async {
    return await volunteerManagementRepository.createProjectOrCampaign(
      title: title,
      description: description,
      requiredAmount: requiredAmount,
      area: area,
      longitude: longitude,
      latitude: latitude,
      categoryId: categoryId,
      image: image,
      numberOfParticipants: numberOfParticipants,
      executionDate: executionDate,
    );
  }
}
