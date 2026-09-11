import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/network/network_info.dart';
import 'package:graduationregistration/features/volunteer_management/data/datasources/volunteer_management_local_data_source.dart';
import 'package:graduationregistration/features/volunteer_management/data/datasources/volunteer_management_remote_data_source.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/campaign_model.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/category.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/joining_requests_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/regions_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/user_profile_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';

class VolunteerManagementRepositoryImpl
    implements VolunteerManagementRepository {
  final VolunteerManagementLocalDataSource volunteerManagementLocalDataSource;
  final VolunteerManagementRemoteDataSource volunteerManagementRemoteDataSource;
  final NetworkInfo networkInfo;

  VolunteerManagementRepositoryImpl({
    required this.volunteerManagementLocalDataSource,
    required this.volunteerManagementRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> acceptToJoinTheCampaign({
    required int participantId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await volunteerManagementRemoteDataSource.acceptToJoinTheCampaign(
          participantId,
        );
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> changeCampaignStatus({
    required int projectId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await volunteerManagementRemoteDataSource.changeCampaignStatus(
          projectId,
        );
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await volunteerManagementRemoteDataSource.createProjectOrCampaign(
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
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<CampaignModel>>> getAllCampaigns({
    String? status,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteCampaigns = await volunteerManagementRemoteDataSource
            .getAllCampaigns(status: status);
        await volunteerManagementLocalDataSource.cacheAllCampaigns(
          remoteCampaigns,
        );
        return Right(remoteCampaigns);
      } else {
        return Left(OfflineFailure());
      }
    } on EmptyCacheException {
      if (await networkInfo.isConnected) {
        final remoteCampaigns = await volunteerManagementRemoteDataSource
            .getAllCampaigns(status: status);
        await volunteerManagementLocalDataSource.cacheAllCampaigns(
          remoteCampaigns,
        );
        return Right(remoteCampaigns);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CampaignEntity>>> getAllCampaignsByCategory({
    //! updated
    required int categoryId,
    String? status,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await volunteerManagementRemoteDataSource
            .getAllCampaignsByCategory(categoryId, status: status);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<JoiningRequestsEntity>>>
  getAllJoiningRequestToCampaign() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await volunteerManagementRemoteDataSource
            .getAllJoiningRequestToCampaign();
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, CampaignEntity>> getCampaignDetails({
    required int campaignId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await volunteerManagementRemoteDataSource
            .getCampaignDetails(campaignId);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> refuseToJoinTheCampaign({
    required int participantId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await volunteerManagementRemoteDataSource
            .refuseToJoinTheCampaign(participantId);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<CampaignEntity>>>
  getAllCampaignsCreatedByVolunteerAdmin({String? status}) async {
    //! updated
    if (await networkInfo.isConnected) {
      try {
        final result = await volunteerManagementRemoteDataSource
            .getAllCampaignsCreatedByVolunteerAdmin(status: status);
        if (status == null || status.isEmpty) {
          volunteerManagementLocalDataSource.cacheCampaigns(result);
        }
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      if (status == null || status.isEmpty) {
        try {
          final cachedCampaigns = await volunteerManagementLocalDataSource
              .getCachedCampaigns();
          return Right(cachedCampaigns);
        } on EmptyCacheException {
          return Left(EmptyCacheFailure());
        }
      }
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<CampaignEntity>>> searchCampaigns({
    required String query,
    String? categoryFilter,
    String? statusFilter,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await volunteerManagementRemoteDataSource
            .searchCampaigns(query: query);

        List<CampaignEntity> filteredResults = result;
        if (categoryFilter != null && categoryFilter != 'جميع التصنيفات') {
          final int categoryId = 0;
        }
        if (statusFilter != null && statusFilter != 'جميع الحملات') {
          filteredResults = filteredResults
              .where((c) => c.status == statusFilter)
              .toList();
        }
        return Right(filteredResults);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedCampaigns = await volunteerManagementLocalDataSource
            .getCachedCampaigns();
        final String lowerCaseQuery = query.toLowerCase();
        final List<CampaignModel> localSearchResults = cachedCampaigns.where((
          campaign,
        ) {
          final String title = campaign.title?.toLowerCase() ?? '';
          final String description = campaign.description?.toLowerCase() ?? '';
          return title.contains(lowerCaseQuery) ||
              description.contains(lowerCaseQuery);
        }).toList();

        List<CampaignEntity> filteredLocalResults = localSearchResults;
        if (categoryFilter != null && categoryFilter != 'جميع التصنيفات') {}
        if (statusFilter != null && statusFilter != 'جميع الحملات') {
          filteredLocalResults = filteredLocalResults
              .where((c) => c.status == statusFilter)
              .toList();
        }

        return Right(filteredLocalResults);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<RegionEntity>>> getAllRegions() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRegions = await volunteerManagementRemoteDataSource
            .getAllRegions();
        return Right(remoteRegions);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<MyCategory>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories = await volunteerManagementRemoteDataSource
            .getCategories();
        return Right(remoteCategories);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getProfileByUserId(
    int userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final userProfileModel = await volunteerManagementRemoteDataSource
            .getUserProfileByUserId(userId);
        return Right(userProfileModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
