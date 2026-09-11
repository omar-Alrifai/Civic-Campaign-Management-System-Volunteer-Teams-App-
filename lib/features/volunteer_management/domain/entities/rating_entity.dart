import 'package:equatable/equatable.dart';

class RatingEntity extends Equatable {
  final int? id;
  final int? rating;
  final String? comment;
  final String? user;
  final DateTime? date;
  RatingEntity({
    this.id,
    required this.rating,
    this.comment,
    required this.user,
    required this.date,
  });

  @override
  List<Object?> get props => [id, rating, comment, user, date];
}
