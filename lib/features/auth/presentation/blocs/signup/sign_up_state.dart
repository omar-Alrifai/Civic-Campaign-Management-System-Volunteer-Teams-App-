part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

final class SignUpInitial extends SignUpState {}

class SignUpFormUpdated extends SignUpState {
  final SignUpFormData formData;
  const SignUpFormUpdated(this.formData);
  @override
  List<Object?> get props => [formData];
}

class SignUpFormData {
  final int currentStep;
  final String name;
  final String email;
  final String password;
  final String phone;
  final int? age;
  final String? gender;
  final String? bio;
  final String? area;
  final double? latitude;
  final double? longitude;
  final List<String> skills;
  final List<String> volunteerFields;
  final String? imagePath;

  const SignUpFormData({
    this.currentStep = 0,
    this.name = '',
    this.email = '',
    this.password = '',
    this.phone = '',
    this.age,
    this.gender,
    this.bio,
    this.area,
    this.latitude,
    this.longitude,
    this.skills = const [],
    this.volunteerFields = const [],
    this.imagePath,
  });

  SignUpFormData copyWith({
    int? currentStep,
    String? name,
    String? email,
    String? password,
    String? phone,
    int? age,
    String? gender,
    String? bio,
    String? area,
    double? latitude,
    double? longitude,
    List<String>? skills,
    List<String>? volunteerFields,
    String? imagePath,
  }) {
    return SignUpFormData(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      area: area ?? this.area,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      skills: skills ?? this.skills,
      volunteerFields: volunteerFields ?? this.volunteerFields,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;
  const SignUpFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class SignUpStepChanged extends SignUpState {
  final int currentStep;

  const SignUpStepChanged({required this.currentStep});

  @override
  List<Object?> get props => [currentStep];
}
