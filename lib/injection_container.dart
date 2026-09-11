import 'package:get_it/get_it.dart';
import 'package:graduationregistration/core/network/network_info.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:graduationregistration/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:graduationregistration/features/auth/domain/repositories/auth_repository.dart';
import 'package:graduationregistration/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:graduationregistration/features/auth/domain/usecases/confirm_password_reset_usecase.dart';
import 'package:graduationregistration/features/auth/domain/usecases/confirm_register_usecase.dart';
import 'package:graduationregistration/features/auth/domain/usecases/get_cached_user_use_case.dart';
import 'package:graduationregistration/features/auth/domain/usecases/get_token_use_case.dart';
import 'package:graduationregistration/features/auth/domain/usecases/login_use_case.dart';
import 'package:graduationregistration/features/auth/domain/usecases/logout_use_case.dart';
import 'package:graduationregistration/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:graduationregistration/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:graduationregistration/features/auth/domain/usecases/resend_code_usecase.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/auth_core_bloc/auth_core_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/signup/sign_up_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/verification/verification_bloc.dart';
import 'package:graduationregistration/features/notifications/data/datasource/notification_remote_data_source.dart';
import 'package:graduationregistration/features/notifications/data/repository/notification_repository_imp.dart';
import 'package:graduationregistration/features/notifications/domain/repository/notification_repository.dart';
import 'package:graduationregistration/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:graduationregistration/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:graduationregistration/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:graduationregistration/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:graduationregistration/features/onboarding/domian/repositories/onboarding_repository.dart';
import 'package:graduationregistration/features/onboarding/domian/usecases/is_onboarding_completed_usecase.dart';
import 'package:graduationregistration/features/onboarding/domian/usecases/set_onboarding_completed_usecase.dart';
import 'package:graduationregistration/features/onboarding/presentation/onboarding/on_boarding_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/data/datasources/volunteer_management_local_data_source.dart';
import 'package:graduationregistration/features/volunteer_management/data/datasources/volunteer_management_remote_data_source.dart';
import 'package:graduationregistration/features/volunteer_management/data/repositories/volunteer_management_repository_impl.dart';
import 'package:graduationregistration/features/volunteer_management/domain/repositories/volunteer_management_repository.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/accept_to_join_the_campaign_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/category_use_case.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/change_campaign_status_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/create_project_or_campaign_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_campaigns_by_category_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_campaigns_created_by_volunteer_admin_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_campaigns_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_joining_request_to_campaign_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_all_regions.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_campaign_details_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/get_user_profile_by_userid.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/refuse_to_join_the_campaign_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/domain/usecases/search_campaigns_usecase.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaign_management_bloc/campaign_management_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/joining_requests_bloc/joining_requests_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/lookups_bloc/lookups_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/user_profile_bloc/profile_bloc.dart';
import 'package:graduationregistration/features/volunteer_profile/data/datasources/profile_remote_data_source.dart';
import 'package:graduationregistration/features/volunteer_profile/data/datasources/volunteer_profile_local_data_source.dart';
import 'package:graduationregistration/features/volunteer_profile/data/repositories/profile_repository_impl.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/repository/profile_repository.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/usecases/get_volunteer_profile_usecase.dart';
import 'package:graduationregistration/features/volunteer_profile/domain/usecases/refresh_volunteer_profile_usecase.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/bloc/profile_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  //! Bloc
  sl.registerFactory(
    () => SignUpBloc(registerUserUseCase: sl(), verificationBloc: sl()),
  );
  sl.registerFactory(
    () => AuthCoreBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      getTokenUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => VerificationBloc(confirmUseCase: sl(), resendUseCase: sl()),
  );
  sl.registerFactory(
    () =>
        PasswordResetBloc(requestResetUseCase: sl(), confirmResetUseCase: sl()),
  );

  //! Use Cases
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmRegistrationUseCase(sl()));

  sl.registerLazySingleton(() => ResendCodeUseCase(sl()));
  sl.registerLazySingleton(() => RequestPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => GetTokenUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  //! Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  //! DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );

  //! External

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // //! 2th feature (Profile)

  //! 3th feature (Volunteer Management).

  //! Features - Volunteer Management
  // Bloc
  sl.registerFactory(
    () => CampaignBloc(
      getAllCampaignsUsecase: sl(),
      getAllCampaignsCreatedByVolunteerAdminUsecase: sl(),
      getCampaignDetailsUsecase: sl(),
      getAllCampaignsByCategoryUsecase: sl(),
      searchCampaignsUsecase: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerFactory(
    () => JoiningRequestsBloc(
      getAllJoiningRequestToCampaignUsecase: sl(),
      acceptToJoinTheCampaignUsecase: sl(),
      refuseToJoinTheCampaignUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => CampaignManagementBloc(
      createProjectOrCampaignUsecase: sl(),
      changeCampaignStatusUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => LookupsBloc(getCategoriesUseCase: sl(), getAllRegionsUseCase: sl()),
  );

  sl.registerFactory(
    () => UserProfileBloc(getUserProfileByUserIdUseCase: sl()),
  );
  // Use cases
  sl.registerLazySingleton(
    () => AcceptToJoinTheCampaignUsecase(volunteerManagementRepository: sl()),
  );
  sl.registerLazySingleton(
    () => ChangeCampaignStatusUsecase(volunteerManagementRepository: sl()),
  );
  sl.registerLazySingleton(
    () => CreateProjectOrCampaignUsecase(volunteerManagementRepository: sl()),
  );
  sl.registerLazySingleton(
    () => GetAllCampaignsByCategoryUsecase(volunteerManagementRepository: sl()),
  );
  sl.registerLazySingleton(
    () => GetAllCampaignsUsecase(volunteerManagementRepository: sl()),
  );
  sl.registerLazySingleton(
    () => GetAllJoiningRequestToCampaignUsecase(
      volunteerManagementRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetCampaignDetailsUsecase(volunteerManagementRepository: sl()),
  );
  sl.registerLazySingleton(
    () => RefuseToJoinTheCampaignUsecase(volunteerManagementRepository: sl()),
  );

  sl.registerLazySingleton(
    () => GetAllCampaignsCreatedByVolunteerAdminUsecase(
      volunteerManagementRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => SearchCampaignsUsecase(volunteerManagementRepository: sl()),
  );

  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetAllRegionsUseCase(sl()));

  sl.registerLazySingleton(() => GetUserProfileByUserIdUsecase(sl()));
  // Repositories
  sl.registerLazySingleton<VolunteerManagementRepository>(
    () => VolunteerManagementRepositoryImpl(
      volunteerManagementRemoteDataSource: sl(),
      volunteerManagementLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<VolunteerManagementRemoteDataSource>(
    () => VolunteerManagementRemoteDataSourceImpl(
      client: sl(),
      authLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<VolunteerManagementLocalDataSource>(
    () => VolunteerManagementLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Profile (NEW REGISTRATIONS)
  // Use cases
  sl.registerLazySingleton(() => GetVolunteerProfileUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => RefreshVolunteerProfileUseCase(repository: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => VolunteerProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl(), authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<VolunteerProfileLocalDataSource>(
    () => VolunteerProfileLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Blocs
  sl.registerFactory(
    () => ProfileBloc(
      getVolunteerProfileUseCase: sl(),
      refreshVolunteerProfileUseCase: sl(),
    ),
  );

  //! Features - Onboarding (NEW REGISTRATIONS)
  // Use cases
  sl.registerLazySingleton(
    () => SetOnboardingCompletedUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => IsOnboardingCompletedUseCase(repository: sl()),
  );

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Blocs
  sl.registerFactory(() => OnboardingBloc(setOnboardingCompletedUseCase: sl()));

  //! notification
  //bloc
  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(getNotifications: sl()),
  );

  // use case
  sl.registerLazySingleton<GetNotifications>(() => GetNotifications(sl()));

  // repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  //data source
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      client: sl(),
      authLocalDataSource: sl(),
    ),
  );
}
