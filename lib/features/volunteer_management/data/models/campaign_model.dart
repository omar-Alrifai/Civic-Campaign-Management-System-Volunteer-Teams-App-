import 'package:graduationregistration/features/volunteer_management/data/models/location_model.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/rating_model.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/user_model.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/location_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/rating_entity.dart';

class CampaignModel extends CampaignEntity {
  const CampaignModel({
    required int id,
    required String? title,
    required String? description,
    required String? status,
    required DateTime? executionDate,
    required UserModel? user,
    required String? imageUrl,
    required String? category,
    required LocationModel? location,
    required String? donationTotal,
    required int? numberOfParticipants,
    required int? joinedParticipants,
    required String? requiredAmount,
    required String? type,
    double? avgRating,
    List<RatingModel>? ratings,
  }) : super(
         id: id,
         title: title,
         description: description,
         status: status,
         executionDate: executionDate,
         user: user,
         imageUrl: imageUrl,
         category: category,
         location: location,
         donationTotal: donationTotal,
         numberOfParticipants: numberOfParticipants,
         joinedParticipants: joinedParticipants,
         requiredAmount: requiredAmount,
         type: type,
         avgRating: avgRating,
         ratings: ratings,
       );
  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      executionDate: json['execution_date'] != null
          ? DateTime.parse(json['execution_date'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      imageUrl: json['image_url'],
      category: json['category'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      donationTotal: json['donation_total'],
      numberOfParticipants: json['number_of_participants'],
      joinedParticipants: json['joined_participants'],
      requiredAmount: json['required_amount'],
      type: json['type'],
      avgRating: (json['avg_rating'] != null)
          ? (json['avg_rating']).toDouble()
          : null,
      ratings: json['ratings'] != null
          ? (json['ratings'])
                .map<RatingModel>((e) => RatingModel.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'execution_date': executionDate?.toIso8601String(),
      'user': user?.toJson(),
      'image_url': imageUrl ?? "",
      'category': category,
      'location': location?.toJson(),
      'donation_total': donationTotal,
      'number_of_participants': numberOfParticipants,
      'joined_participants': joinedParticipants,
      'required_amount': requiredAmount,
      'type': type,
      'avg_rating': avgRating,
      'ratings': ratings?.map((e) => e.toJson()).toList(),
    };
  }

  factory CampaignModel.fromEntity(CampaignEntity entity) {
    return CampaignModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      executionDate: entity.executionDate,
      user: entity.user,
      imageUrl: entity.imageUrl,
      category: entity.category,
      location: entity.location,
      donationTotal: entity.donationTotal,
      numberOfParticipants: entity.numberOfParticipants,
      joinedParticipants: entity.joinedParticipants,
      requiredAmount: entity.requiredAmount,
      type: entity.type,
    );
  }
}
