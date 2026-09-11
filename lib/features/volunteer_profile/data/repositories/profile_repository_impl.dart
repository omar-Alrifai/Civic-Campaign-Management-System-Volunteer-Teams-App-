import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/core/error/failures.dart';
import 'package:graduationregistration/core/network/network_info.dart';
import 'package:graduationregistration/features/volunteer_profile/data/datasources/profile_remote_data_source.dart';
import 'package:graduationregistration/features/volunteer_profile/data/datasources/volunteer_profile_local_data_source.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/entity/volunteer_profile_entity.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/repository/profile_repository.dart';

class VolunteerProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final VolunteerProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  VolunteerProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, VolunteerProfileEntity>> getVolunteerProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.getVolunteerProfile();
        localDataSource.cacheProfile(remoteProfile);
        return Right(remoteProfile.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProfile = await localDataSource.getCachedProfile();
        if (localProfile != null) {
          return Right(localProfile.toEntity());
        } else {
          return Left(OfflineFailure());
        }
      } on EmptyCacheException {
        return Left(OfflineFailure());
      }
    }
  }

  @override
  Future<Either<Failure, VolunteerProfileEntity>>
  refreshVolunteerProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProfile = await remoteDataSource.getVolunteerProfile();
        localDataSource.cacheProfile(remoteProfile); // تخزين في الكاش
        return Right(remoteProfile.toEntity());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
