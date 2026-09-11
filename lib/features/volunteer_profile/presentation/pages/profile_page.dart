import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/core/widget/loading_widget.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/auth_core_bloc/auth_core_bloc.dart';
import 'package:graduationregistration/features/auth/presentation/pages/sign_in_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/bloc/profile_bloc.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/bloc/profile_event.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/bloc/profile_state.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/logout_dialog.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/profile_content.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/profile_error_widget.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/shake_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 4;
  final _shakeKey = GlobalKey<ShakeWidgetState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const LoadVolunteerProfileEvent());
    });

    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _colorAnimation =
        ColorTween(
          begin: AppColors.OceanBlue.withOpacity(0.3),
          end: AppColors.OceanBlue.withOpacity(0.8),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
          ),
        );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const LogoutDialog());
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تأكيد الخروج'),
            content: const Text('هل أنت متأكد أنك تريد الخروج من التطبيق؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Do not allow exit
                child: const Text('لا'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Allow exit
                child: const Text('نعم'),
              ),
            ],
          ),
        )) ??
        false; // If dialog is dismissed without selection, do not exit
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_didPop, _r) async {
        if (!_didPop && await _onWillPop()) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.OceanBlue, Colors.white],
              stops: const [0.0, 0.2],
            ),
          ),
          child: SafeArea(
            child: BlocListener<AuthCoreBloc, AuthCoreState>(
              listener: (context, state) {
                if (state is Unauthenticated) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                } else if (state is SignOutFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileError) {
                    _shakeKey.currentState?.shake();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        action: SnackBarAction(
                          label: 'إعادة المحاولة',
                          textColor: Colors.white,
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                              const LoadVolunteerProfileEvent(),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (state is VolunteerProfileLoaded) {
                    _animationController.forward();
                  } else if (state is ProfileLoading) {
                    _animationController.repeat(reverse: true);
                  }
                },
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(
                      child: LoadingWidget(
                        textColor: AppColors.OceanBlue,
                        shaderMaskColors: [
                          AppColors.OceanBlue,
                          AppColors.WhisperWhite,
                        ],
                        spinKitChasingDots: AppColors.CharcoalGrey,
                      ),
                    );
                  } else if (state is VolunteerProfileLoaded) {
                    return ProfileContent(
                      profile: state.profile,
                      shakeKey: _shakeKey,
                      animationController: _animationController,
                      fadeAnimation: _fadeAnimation,
                      scaleAnimation: _scaleAnimation,
                      colorAnimation: _colorAnimation,
                      slideAnimation: _slideAnimation,
                      onLogoutPressed: () =>
                          _showLogoutConfirmationDialog(context),
                      onRefresh: () async {
                        _animationController.reset();
                        context.read<ProfileBloc>().add(
                          const RefreshVolunteerProfileEvent(),
                        );
                      },
                    );
                  } else if (state is ProfileError) {
                    return ProfileErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<ProfileBloc>().add(
                          const LoadVolunteerProfileEvent(),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('جاري تحميل الملف الشخصي...'),
                  );
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          navBarColor: AppColors.OceanBlue,
          buttonBackgroundColor: AppColors.OceanBlue,
        ),
      ),
    );
  }
}
