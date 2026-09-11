part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class UpdateSignUpForm extends SignUpEvent {
  final String? name;
  final String? email;
  final String? password;
  final String? phone;
  final int? age;
  final String? gender;
  final String? bio;
  final String? area;
  final double? latitude;
  final double? longitude;
  final List<String>? skills;
  final List<String>? volunteerFields;
  final String? imagePath;

  const UpdateSignUpForm({
    this.name,
    this.email,
    this.password,
    this.phone,
    this.age,
    this.gender,
    this.bio,
    this.area,
    this.latitude,
    this.longitude,
    this.skills,
    this.volunteerFields,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    phone,
    age,
    gender,
    bio,
    area,
    latitude,
    longitude,
    skills,
    volunteerFields,
    imagePath,
  ];
}

class SubmitSignUp extends SignUpEvent {
  const SubmitSignUp();
  @override
  List<Object?> get props => [];
}

class NextStepTapped extends SignUpEvent {
  const NextStepTapped();
}

class PreviousStepTapped extends SignUpEvent {
  const PreviousStepTapped();
}
