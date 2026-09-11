part of 'campaigns_bloc.dart';

abstract class CampaignState extends Equatable {
  const CampaignState();

  @override
  List<Object?> get props => [];
}

class CampaignInitial extends CampaignState {}

class CampaignLoading extends CampaignState {
  final List<CampaignEntity>? oldCampaigns;

  const CampaignLoading({this.oldCampaigns});

  @override
  List<Object?> get props => [oldCampaigns];
}

class CampaignsLoaded extends CampaignState {
  final List<CampaignEntity> campaigns;

  const CampaignsLoaded({required this.campaigns});

  @override
  List<Object?> get props => [campaigns];
}

class CampaignDetailsLoaded extends CampaignState {
  final CampaignEntity campaign;

  const CampaignDetailsLoaded({required this.campaign});

  @override
  List<Object?> get props => [campaign];
}

class CampaignError extends CampaignState {
  final String message;
  final List<CampaignEntity>? oldCampaigns; // للحفاظ على البيانات عند الخطأ

  const CampaignError({required this.message, this.oldCampaigns});

  @override
  List<Object?> get props => [message, oldCampaigns];
}
