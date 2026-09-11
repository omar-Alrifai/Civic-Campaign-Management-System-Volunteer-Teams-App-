import 'package:equatable/equatable.dart';

class OnboardingPageEntity extends Equatable {
  final String title;
  final String imagePath;
  final String description;

  const OnboardingPageEntity({
    required this.title,
    required this.imagePath,
    required this.description,
  });

  @override
  List<Object?> get props => [title, imagePath, description];
}
