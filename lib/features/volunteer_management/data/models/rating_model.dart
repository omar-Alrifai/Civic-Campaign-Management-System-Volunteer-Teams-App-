import 'package:graduationregistration/features/volunteer_management/domain/entities/rating_entity.dart';

class RatingModel extends RatingEntity {
  RatingModel({
    int? id,
    required int? rating,
    String? comment,
    required String? user,
    DateTime? date,
  }) : super(id: id, rating: rating, comment: comment, user: user, date: date);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      user: json['user'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'user': user,
      'date': date?.toIso8601String(),
    };
  }
}
