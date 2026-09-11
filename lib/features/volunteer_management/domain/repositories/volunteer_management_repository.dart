import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/category.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/joining_requests_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/regions_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/user_profile_entity.dart';

abstract class VolunteerManagementRepository {
  Future<Either<Failure, CampaignEntity>> getCampaignDetails({
    required int campaignId,
  });
  Future<Either<Failure, List<CampaignEntity>>> getAllCampaigns({
    String? status, // "منجزة", "نشطة", or null for all
  });
  Future<Either<Failure, List<CampaignEntity>>> getAllCampaignsByCategory({
    //! updated
    required int categoryId,
    String? status, // "منجزة", "نشطة", or null for all
  });
  Future<Either<Failure, List<JoiningRequestsEntity>>>
  getAllJoiningRequestToCampaign();
  Future<Either<Failure, Unit>> refuseToJoinTheCampaign({
    required int participantId,
  });
  Future<Either<Failure, Unit>> acceptToJoinTheCampaign({
    required int participantId,
  });

  Future<Either<Failure, Unit>> changeCampaignStatus({required int projectId});

  Future<Either<Failure, Unit>> createProjectOrCampaign({
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
  });

  Future<Either<Failure, List<CampaignEntity>>>
  getAllCampaignsCreatedByVolunteerAdmin({
    String? status, // منجزة، نشطة، أو فارغة للجميع
  });

  Future<Either<Failure, List<CampaignEntity>>> searchCampaigns({
    required String query,
    String? categoryFilter,
    String? statusFilter,
  });

  Future<Either<Failure, List<MyCategory>>> getCategories();

  Future<Either<Failure, List<RegionEntity>>> getAllRegions();

  Future<Either<Failure, UserProfileEntity>> getProfileByUserId(int userId);
}
