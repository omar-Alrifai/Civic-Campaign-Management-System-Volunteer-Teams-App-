part of 'campaign_management_bloc.dart';

abstract class CampaignManagementState extends Equatable {
  const CampaignManagementState();

  @override
  List<Object?> get props => [];
}

// بيانات النموذج لـ CreateCampaignPage
class CreateCampaignFormData extends Equatable {
  final String title;
  final String description;
  final int? requiredAmount;
  final String? area;
  final double? longitude;
  final double? latitude;
  final String? selectedCategoryName;
  final int? categoryId;
  final String? imagePath;
  final int? numberOfParticipants;
  final DateTime? executionDate;
  final LatLng? selectedLocation;

  const CreateCampaignFormData({
    this.title = '',
    this.description = '',
    this.requiredAmount,
    this.area,
    this.longitude,
    this.latitude,
    this.selectedCategoryName,
    this.categoryId,
    this.imagePath,
    this.numberOfParticipants,
    this.executionDate,
    this.selectedLocation,
  });

  CreateCampaignFormData copyWith({
    String? title,
    String? description,
    int? requiredAmount,
    String? area,
    double? longitude,
    double? latitude,
    String? selectedCategoryName,
    int? categoryId,
    String? imagePath,
    int? numberOfParticipants,
    DateTime? executionDate,
    LatLng? selectedLocation,
  }) {
    return CreateCampaignFormData(
      title: title ?? this.title,
      description: description ?? this.description,
      requiredAmount: requiredAmount ?? this.requiredAmount,
      area: area ?? this.area,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      selectedCategoryName: selectedCategoryName ?? this.selectedCategoryName,
      categoryId: categoryId ?? this.categoryId,
      imagePath: imagePath ?? this.imagePath,
      numberOfParticipants: numberOfParticipants ?? this.numberOfParticipants,
      executionDate: executionDate ?? this.executionDate,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    requiredAmount,
    area,
    longitude,
    latitude,
    selectedCategoryName,
    categoryId,
    imagePath,
    numberOfParticipants,
    executionDate,
    selectedLocation,
  ];
}

class CampaignManagementInitial extends CampaignManagementState {
  final CreateCampaignFormData formData;
  const CampaignManagementInitial({
    this.formData = const CreateCampaignFormData(),
  });
  @override
  List<Object?> get props => [formData];
}

class CampaignManagementLoading extends CampaignManagementState {
  final CreateCampaignFormData
  formData; // الحفاظ على بيانات النموذج أثناء التحميل
  const CampaignManagementLoading({required this.formData});
  @override
  List<Object?> get props => [formData];
}

class CampaignFormUpdated extends CampaignManagementState {
  final CreateCampaignFormData formData;
  const CampaignFormUpdated({required this.formData});
  @override
  List<Object?> get props => [formData];
}

class CampaignCreatedSuccess extends CampaignManagementState {
  final String message;
  const CampaignCreatedSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class CampaignStatusUpdatedSuccess extends CampaignManagementState {
  final String message;
  const CampaignStatusUpdatedSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class CampaignManagementError extends CampaignManagementState {
  final String message;
  final CreateCampaignFormData formData; // الحفاظ على بيانات النموذج عند الخطأ
  const CampaignManagementError({
    required this.message,
    required this.formData,
  });
  @override
  List<Object?> get props => [message, formData];
}
