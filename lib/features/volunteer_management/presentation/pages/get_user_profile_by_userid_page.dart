import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/user_profile_entity.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/user_profile_bloc/profile_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/user_profile_avatar_header.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/user_profile_chips.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/user_profile_error_view.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/user_profile_header_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/user_profile_info_row.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/user_profile_section_card.dart';

class GetUserProfileByUserIdPage extends StatefulWidget {
  final int userId;
  final String userName;

  const GetUserProfileByUserIdPage({
    super.key,
    required this.userId,
    this.userName = 'User Profile',
  });

  @override
  State<GetUserProfileByUserIdPage> createState() =>
      _GetUserProfileByUserIdPageState();
}

class _GetUserProfileByUserIdPageState extends State<GetUserProfileByUserIdPage>
    with SingleTickerProviderStateMixin {
  late final UserProfileBloc _bloc;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<UserProfileBloc>();
    _bloc.add(GetUserProfileByUserIdEvent(userId: widget.userId));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _animationController.reset();
    _bloc.add(GetUserProfileByUserIdEvent(userId: widget.userId));
    await Future.delayed(const Duration(milliseconds: 300));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.OceanBlue, Colors.white],
              stops: [0.0, 0.2],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    UserProfileHeaderBar(
                      userName: widget.userName,
                      animationController: _animationController,
                      fadeAnimation: _fadeAnimation,
                      scaleAnimation: _scaleAnimation,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: BlocConsumer<UserProfileBloc, UserProfileState>(
                          listener: (context, state) {
                            if (state is ProfileError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is ProfileLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ProfileLoaded) {
                              return FadeTransition(
                                opacity: _fadeAnimation,
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: _buildProfileContent(
                                    context,
                                    state.userProfile,
                                  ),
                                ),
                              );
                            } else if (state is ProfileError) {
                              return UserProfileErrorView(
                                message: state.message,
                                fadeAnimation: _fadeAnimation,
                                slideAnimation: _slideAnimation,
                                onRetry: () {
                                  _bloc.add(
                                    GetUserProfileByUserIdEvent(
                                      userId: widget.userId,
                                    ),
                                  );
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfileEntity profile) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserProfileAvatarHeader(
            profile: profile,
            animationController: _animationController,
            fadeAnimation: _fadeAnimation,
            scaleAnimation: _scaleAnimation,
          ),
          const SizedBox(height: 24),
          UserProfileSectionCard(
            title: 'معلومات الاتصال',
            animationController: _animationController,
            fadeAnimation: _fadeAnimation,
            children: [
              UserProfileInfoRow(
                icon: Icons.email,
                text: profile.email,
                animationController: _animationController,
                fadeAnimation: _fadeAnimation,
              ),
              UserProfileInfoRow(
                icon: Icons.phone,
                text: profile.phone,
                animationController: _animationController,
                fadeAnimation: _fadeAnimation,
              ),
              UserProfileInfoRow(
                icon: Icons.location_on,
                text: profile.location.name!,
                animationController: _animationController,
                fadeAnimation: _fadeAnimation,
              ),
            ],
          ),
          const SizedBox(height: 16),
          UserProfileSectionCard(
            title: 'عني',
            animationController: _animationController,
            fadeAnimation: _fadeAnimation,
            children: [
              UserProfileInfoRow(
                icon: Icons.cake,
                text: 'العمر: ${profile.age}',
                animationController: _animationController,
                fadeAnimation: _fadeAnimation,
              ),
              UserProfileInfoRow(
                icon: Icons.person,
                text: 'الجنس: ${profile.gender}',
                animationController: _animationController,
                fadeAnimation: _fadeAnimation,
              ),
              const SizedBox(height: 12),
              SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOut,
                      ),
                    ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    profile.bio,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          UserProfileSectionCard(
            title: 'المهارات',
            animationController: _animationController,
            fadeAnimation: _fadeAnimation,
            children: [
              if (profile.skills.isNotEmpty)
                UserProfileChips(
                  items: profile.skills,
                  animationController: _animationController,
                  fadeAnimation: _fadeAnimation,
                )
              else
                _buildAnimatedText('لاتوجد مهارات حاليا.'),
            ],
          ),
          const SizedBox(height: 16),
          UserProfileSectionCard(
            title: 'مجالات الاهتمام',
            animationController: _animationController,
            fadeAnimation: _fadeAnimation,
            children: [
              if (profile.fields.isNotEmpty)
                UserProfileChips(
                  items: profile.fields,
                  animationController: _animationController,
                  fadeAnimation: _fadeAnimation,
                )
              else
                _buildAnimatedText('لايوجد مجالات اهتمام بعد.'),
            ],
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              'Profile created: ${profile.createdAt.toLocal().toIso8601String().split('T')[0]}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAnimatedText(String text) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOut,
            ),
          ),
      child: FadeTransition(opacity: _fadeAnimation, child: Text(text)),
    );
  }
}
