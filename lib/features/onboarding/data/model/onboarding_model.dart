import 'package:equatable/equatable.dart';

class OnBoardingModel extends Equatable {
  final String? title;
  final String? image;
  final String? body;

  const OnBoardingModel({this.title, this.image, this.body});

  @override
  List<Object?> get props => [title, image, body];
}
