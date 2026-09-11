import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/auth/presentation/pages/sign_in_page.dart';
import 'package:graduationregistration/features/onboarding/presentation/onboarding/on_boarding_bloc.dart';
import 'package:graduationregistration/features/onboarding/presentation/onboarding/on_boarding_event.dart';
import 'package:graduationregistration/features/onboarding/presentation/onboarding/on_boarding_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WhisperWhite,
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingPageChanged) {
            if (_pageController.hasClients &&
                _pageController.page?.round() != state.page) {
              _pageController.animateToPage(
                state.page,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.bounceOut,
              );
            }
          } else if (state is OnboardingCompletedState) {
            _navigateToNextScreen();
          } else if (state is OnboardingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          int currentPageIndex = 0;
          if (state is OnboardingInitial) {
            currentPageIndex = state.currentPage;
          } else if (state is OnboardingPageChanged) {
            currentPageIndex = state.page;
          } else if (state is OnboardingLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: OnboardingBloc.onboardingPagesData.length,
                onPageChanged: (index) {
                  context.read<OnboardingBloc>().add(SetPageEvent(index));
                },
                itemBuilder: (context, index) {
                  final pageData = OnboardingBloc.onboardingPagesData[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          pageData.image!,
                          height: MediaQuery.of(context).size.height * 0.4,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          pageData.title!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          pageData.body!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // المؤشر والأزرار
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: OnboardingBloc.onboardingPagesData.length,
                        effect: const ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 8.0,
                          activeDotColor: AppColors.OceanBlue,
                          dotColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // زر التخطي (يظهر في الصفحات الأولى)
                          if (currentPageIndex <
                              OnboardingBloc.onboardingPagesData.length - 1)
                            TextButton(
                              onPressed: () {
                                context.read<OnboardingBloc>().add(
                                  const CompleteOnboardingEvent(),
                                );
                              },
                              child: const Text(
                                'تخطي',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          // زر التالي/البدء
                          ElevatedButton(
                            onPressed: () {
                              if (currentPageIndex <
                                  OnboardingBloc.onboardingPagesData.length -
                                      1) {
                                context.read<OnboardingBloc>().add(
                                  const NextPageEvent(),
                                );
                              } else {
                                context.read<OnboardingBloc>().add(
                                  const CompleteOnboardingEvent(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.OceanBlue,
                              foregroundColor: AppColors.WhisperWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              currentPageIndex ==
                                      OnboardingBloc
                                              .onboardingPagesData
                                              .length -
                                          1
                                  ? 'ابدأ الآن'
                                  : 'التالي',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
