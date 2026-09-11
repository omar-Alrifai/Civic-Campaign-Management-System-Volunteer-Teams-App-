part of 'campaign_management_bloc.dart';

abstract class CampaignManagementEvent extends Equatable {
  const CampaignManagementEvent();

  @override
  List<Object?> get props => [];
}

// الحدث الأساسي لإنشاء حملة جديدة
class CreateNewCampaignEvent extends CampaignManagementEvent {
  final String title;
  final String description;
  final int requiredAmount;
  final String area;
  final double longitude;
  final double latitude;
  final int categoryId;
  final String image;
  final int numberOfParticipants;
  final String executionDate;

  const CreateNewCampaignEvent({
    required this.title,
    required this.description,
    required this.requiredAmount,
    required this.area,
    required this.longitude,
    required this.latitude,
    required this.categoryId,
    required this.image,
    required this.numberOfParticipants,
    required this.executionDate,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    requiredAmount,
    area,
    longitude,
    latitude,
    categoryId,
    image,
    numberOfParticipants,
    executionDate,
  ];
}

// حدث لتغيير حالة الحملة
class ChangeCampaignStatusEvent extends CampaignManagementEvent {
  final int projectId;

  const ChangeCampaignStatusEvent({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

// حدث لإعادة تعيين حالة Bloc
class ResetCampaignManagementStateEvent extends CampaignManagementEvent {
  const ResetCampaignManagementStateEvent();
}

// أحداث جديدة لتحديث حقول نموذج إنشاء الحملة
class UpdateCreateCampaignForm extends CampaignManagementEvent {
  final String? title;
  final String? description;
  final int? requiredAmount;
  final String? area;
  final double? longitude;
  final double? latitude;
  final String? selectedCategoryName;
  final String? imagePath;
  final int? numberOfParticipants;
  final DateTime? executionDate;
  final LatLng? selectedLocation;

  const UpdateCreateCampaignForm({
    this.title,
    this.description,
    this.requiredAmount,
    this.area,
    this.longitude,
    this.latitude,
    this.selectedCategoryName,
    this.imagePath,
    this.numberOfParticipants,
    this.executionDate,
    this.selectedLocation,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    requiredAmount,
    area,
    longitude,
    latitude,
    selectedCategoryName,
    imagePath,
    numberOfParticipants,
    executionDate,
    selectedLocation,
  ];
}

// حدث لإرسال النموذج
class SubmitCreateCampaignForm extends CampaignManagementEvent {
  const SubmitCreateCampaignForm();
  @override
  List<Object?> get props => [];
}
