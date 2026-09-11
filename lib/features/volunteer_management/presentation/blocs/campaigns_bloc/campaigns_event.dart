part of 'campaigns_bloc.dart';

abstract class CampaignEvent extends Equatable {
  const CampaignEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllCampaignsEvent extends CampaignEvent {
  final String? status;

  const LoadAllCampaignsEvent({this.status});

  @override
  List<Object?> get props => [status];
}

class LoadCampaignsByCategoryEvent extends CampaignEvent {
  final int categoryId;
  final String? status;

  const LoadCampaignsByCategoryEvent({required this.categoryId, this.status});

  @override
  List<Object?> get props => [categoryId, status];
}

class LoadCampaignDetailsEvent extends CampaignEvent {
  final int campaignId;

  const LoadCampaignDetailsEvent({required this.campaignId});

  @override
  List<Object?> get props => [campaignId];
}

class LoadVolunteerAdminCampaignsEvent extends CampaignEvent {
  final String? status;

  const LoadVolunteerAdminCampaignsEvent({this.status});

  @override
  List<Object?> get props => [status];
}

class RefreshAllCampaignsEvent extends CampaignEvent {
  final String? status;
  const RefreshAllCampaignsEvent({this.status});
  @override
  List<Object?> get props => [status];
}

class RefreshVolunteerAdminCampaignsEvent extends CampaignEvent {
  final String? status;
  const RefreshVolunteerAdminCampaignsEvent({this.status});
  @override
  List<Object?> get props => [status];
}

class SearchCampaignsEvent extends CampaignEvent {
  final String query;
  final String? categoryFilter;
  final String? statusFilter;

  const SearchCampaignsEvent({
    required this.query,
    this.categoryFilter,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [query, categoryFilter, statusFilter];
}
