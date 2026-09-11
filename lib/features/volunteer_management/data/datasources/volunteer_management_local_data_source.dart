import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/campaign_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class VolunteerManagementLocalDataSource {
  // for Volunteer campaigns only
  Future<Unit> cacheCampaigns(List<CampaignModel> campaigns);
  Future<List<CampaignModel>> getCachedCampaigns();

  // for all campaigns
  Future<Unit> cacheAllCampaigns(List<CampaignModel> campaigns);
  Future<List<CampaignModel>> getCachedAllCampaigns();
}

const CASHED_CAMPAIGNS = "CASHED_CAMPAIGNS";
const CACHED_ALL_CAMPAIGNS = "CACHED_ALL_CAMPAIGNS";

class VolunteerManagementLocalDataSourceImpl
    implements VolunteerManagementLocalDataSource {
  final SharedPreferences sharedPreferences;

  VolunteerManagementLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Unit> cacheCampaigns(List<CampaignModel> campaigns) async {
    List campaignsJson = campaigns
        .map<Map<String, dynamic>>((campaign) => campaign.toJson())
        .toList();
    await sharedPreferences.setString(
      CASHED_CAMPAIGNS,
      jsonEncode(campaignsJson),
    );
    return Future.value(unit);
  }

  @override
  Future<List<CampaignModel>> getCachedCampaigns() async {
    final campaignsJson = sharedPreferences.getString(CASHED_CAMPAIGNS);
    if (campaignsJson != null) {
      List decodeJsonData = json.decode(campaignsJson);
      List<CampaignModel> jsonToCampaignModel = decodeJsonData
          .map<CampaignModel>(
            (jsonCampaignsModel) => CampaignModel.fromJson(jsonCampaignsModel),
          )
          .toList();
      return jsonToCampaignModel;
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> cacheAllCampaigns(List<CampaignModel> campaigns) async {
    final campaignsJson = campaigns
        .map<Map<String, dynamic>>((c) => c.toJson())
        .toList();
    await sharedPreferences.setString(
      CACHED_ALL_CAMPAIGNS,
      jsonEncode(campaignsJson),
    );
    return Future.value(unit);
  }

  @override
  Future<List<CampaignModel>> getCachedAllCampaigns() async {
    final jsonString = sharedPreferences.getString(CACHED_ALL_CAMPAIGNS);
    if (jsonString != null) {
      final decodedData = json.decode(jsonString) as List;
      return decodedData
          .map<CampaignModel>((jsonMap) => CampaignModel.fromJson(jsonMap))
          .toList();
    } else {
      throw EmptyCacheException();
    }
  }
}
