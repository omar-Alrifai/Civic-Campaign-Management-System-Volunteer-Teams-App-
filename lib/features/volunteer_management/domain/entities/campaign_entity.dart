import 'package:equatable/equatable.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/location_model.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/rating_model.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/user_model.dart';

class CampaignEntity extends Equatable {
  final int id;
  final String? title;
  final String? description;
  final String? status;
  final DateTime? executionDate;
  final UserModel? user;
  final String? imageUrl;
  final String? category;
  final LocationModel? location;
  final String? donationTotal;
  final int? numberOfParticipants;
  final int? joinedParticipants;
  final String? requiredAmount;
  final String? type;
  final double? avgRating;

  final List<RatingModel>? ratings;
  const CampaignEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.executionDate,
    required this.user,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.donationTotal,
    required this.numberOfParticipants,
    required this.joinedParticipants,
    required this.requiredAmount,
    required this.type,
    this.avgRating,
    this.ratings,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    executionDate,
    user,
    imageUrl,
    category,
    location,
    donationTotal,
    numberOfParticipants,
    joinedParticipants,
    requiredAmount,
    type,
    avgRating,
    ratings,
  ];
}
