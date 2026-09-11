import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graduationregistration/core/app_theme.dart';
import 'package:graduationregistration/features/auth/presentation/pages/my_bloc_observer.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/auth_core_bloc/auth_core_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/password_reset/password_reset_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/signup/sign_up_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/verification/verification_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/pages/sign_in_page.dart';
import 'package:graduationregistration/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:graduationregistration/features/notifications/presentation/firebase/api_notification_firebase.dart';
import 'package:graduationregistration/features/notifications/presentation/firebase/notification_service.dart';
import 'package:graduationregistration/features/onboarding/domian/usecases/is_onboarding_completed_usecase.dart';
import 'package:graduationregistration/features/onboarding/presentation/onboarding/on_boarding_bloc.dart';
import 'package:graduationregistration/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaign_management_bloc/campaign_management_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/joining_requests_bloc/joining_requests_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/lookups_bloc/lookups_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/user_profile_bloc/profile_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/volunteer_leader_home_page.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/bloc/profile_bloc.dart';
import 'package:graduationregistration/injection_container.dart' as di;

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp();
  await NotificationService.init();
  await FirebaseApi().initNotifications();
  Bloc.observer = MyBLocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<SignUpBloc>()),
        BlocProvider(create: (_) => di.sl<VerificationBloc>()),
        BlocProvider(create: (_) => di.sl<PasswordResetBloc>()),
        BlocProvider(
          create: (_) => di.sl<AuthCoreBloc>()..add(const CheckAuthStatus()),
        ),
        BlocProvider(create: (_) => di.sl<CampaignBloc>()),
        BlocProvider(create: (_) => di.sl<JoiningRequestsBloc>()),
        BlocProvider(create: (_) => di.sl<CampaignManagementBloc>()),
        BlocProvider(create: (_) => di.sl<LookupsBloc>()),
        BlocProvider(create: (_) => di.sl<ProfileBloc>()),
        BlocProvider(create: (_) => di.sl<OnboardingBloc>()),
        BlocProvider<NotificationBloc>(
          create: (_) => di.sl<NotificationBloc>(),
        ),
        BlocProvider<UserProfileBloc>(create: (_) => di.sl<UserProfileBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'تطبيق التطوع',
        theme: appTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar')],
        locale: const Locale('ar'),
        home: _buildInitialRoute(),
        navigatorObservers: [routeObserver],
      ),
    );
  }

  Widget _buildInitialRoute() {
    return FutureBuilder<bool>(
      future: di
          .sl<IsOnboardingCompletedUseCase>()
          .call(), // التحقق من إكمال الـ onboarding
      builder: (context, snapshot) {
        // اعرض شاشة تحميل بسيطة أو CircularProgressIndicator بينما ننتظر
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ); // شاشة تحميل مؤقتة
        }

        final bool onboardingCompleted = snapshot.data ?? false;

        // إذا لم تكتمل الـ onboarding، اعرض OnboardingPage
        if (!onboardingCompleted) {
          return const OnboardingPage();
        } else {
          // إذا اكتملت الـ onboarding، تحقق من حالة المصادقة (هل المستخدم مسجل الدخول؟)
          return BlocBuilder<AuthCoreBloc, AuthCoreState>(
            builder: (context, authState) {
              // إذا كان AuthCoreBloc لا يزال في حالة التحقق أو التهيئة، اعرض شاشة تحميل
              if (authState is AuthCheckLoading ||
                  authState is AuthCoreInitial) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (authState is Authenticated) {
                // المستخدم مسجل الدخول، اذهب للصفحة الرئيسية
                return const VolunteerLeaderHomePage();
              } else {
                // المستخدم غير مسجل الدخول، اذهب لصفحة تسجيل الدخول (LoginPage)
                return LoginPage(); // لا تستخدم const هنا إذا كان LoginPage لديه TextEditingControllers
              }
            },
          );
        }
      },
    );
  }
}
