import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:graduationregistration/core/error/exceptions.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:graduationregistration/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/campaign_model.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/category_model.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/joining_request_model.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/regions_model.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/user_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

abstract class VolunteerManagementRemoteDataSource {
  Future<Unit> acceptToJoinTheCampaign(int participantId);
  Future<Unit> changeCampaignStatus(int projectId);
  Future<Unit> createProjectOrCampaign({
    required String title,
    required String description,
    required int requiredAmount,
    required String area,
    required double longitude,
    required double latitude,
    required int categoryId,
    required String image,
    required int numberOfParticipants,
    required String executionDate,
  });

  Future<List<CampaignModel>> getAllCampaigns({String? status});

  Future<List<CampaignModel>> getAllCampaignsByCategory(
    int categoryId, {
    String? status,
  });
  Future<List<JoiningRequestModel>> getAllJoiningRequestToCampaign();
  Future<CampaignModel> getCampaignDetails(int campaignId);
  Future<Unit> refuseToJoinTheCampaign(int participantId);
  Future<List<CampaignModel>> getAllCampaignsCreatedByVolunteerAdmin({
    String? status,
  });

  Future<List<CampaignModel>> searchCampaigns({String query});

  Future<List<CategoryModel>> getCategories();

  Future<List<RegionModel>> getAllRegions();

  Future<UserProfileModel> getUserProfileByUserId(int userId);
}

const Map<String, int> skillNameToId = {
  'تمريض': 1,
  'طبخ': 2,
  'جمع تبرعات': 3,
  'تصوير': 4,
  'مهنية': 5,
};
const Map<String, int> volunteerFieldNameId = {
  'ترميم بيوت': 1,
  'توزيع مساعدات': 2,
  'تنظيم فعالية': 3,
  'إغاثة الكوارث': 4,
  'مساعدات الطريق': 5,
  'تنظيف البيئة': 6,
};

class VolunteerManagementRemoteDataSourceImpl
    implements VolunteerManagementRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource authLocalDataSource;

  VolunteerManagementRemoteDataSourceImpl({
    required this.client,
    required this.authLocalDataSource,
  });

  Future<String?> _getToken() async {
    final token = await authLocalDataSource.getToken();
    return token;
  }

  Map<String, dynamic> _buildRequestBody({
    String? status,
    required String type,
  }) {
    final Map<String, dynamic> body = {'type': type};
    if (status != null && status.isNotEmpty) {
      body['status'] = status;
    }
    return body;
  }

  @override
  Future<Unit> acceptToJoinTheCampaign(int participantId) async {
    final token = await _getToken();

    final response = await client.post(
      Uri.parse('$baseUrl/api/project/approve-join/$participantId'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': 'تمت الموافقة'}),
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> changeCampaignStatus(int projectId) async {
    final token = await _getToken();
    final response = await client.post(
      Uri.parse('$baseUrl/api/volunteer/$projectId/promote'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': 'منجزة'}),
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> createProjectOrCampaign({
    required String title,
    required String description,
    required int requiredAmount,
    required String area,
    required double longitude,
    required double latitude,
    required int categoryId,
    required String image,
    required int numberOfParticipants,
    required String executionDate,
  }) async {
    final token = await _getToken();

    var uri = Uri.parse('$baseUrl/api/client/project/create');
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['required_amount'] = requiredAmount.toString();
    request.fields['area'] = area;
    request.fields['longitude'] = longitude.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['category_id'] = categoryId.toString();
    request.fields['number_of_participant'] = numberOfParticipants.toString();
    request.fields['execution_date'] = executionDate;

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image,
          filename: basename(image),
        ),
      );
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return unit;
    } else {
      print('Create Project response status: ${response.statusCode}');
      print('Create Project response body: ${response.body}');
      throw ServerException();
    }
  }

  @override
  Future<List<CampaignModel>> getAllCampaigns({String? status}) async {
    //! updated
    final response = await client.post(
      Uri.parse('$baseUrl/api/client/project/all'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: json.encode(_buildRequestBody(type: "حملة رسمية", status: status)),
    );
    print("response request is : ${response.request}");
    print("body is :${json.encode({"type": "حملة رسمية"})}");
    print("Response of Get All Campaigns :${response.body}");
    print("Status code is :${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      final List<CampaignModel> campaigns = jsonList
          .map((json) => CampaignModel.fromJson(json))
          .toList();
      return campaigns;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CampaignModel>> getAllCampaignsByCategory(
    int categoryId, {
    String? status,
  }) async {
    //! updated
    final response = await client.post(
      Uri.parse('$baseUrl/api/client/project/all/$categoryId'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: json.encode(_buildRequestBody(type: "حملة رسمية", status: status)),
    );
    print("Response of Get All Campaigns By category :${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      final List<CampaignModel> campaigns = jsonList
          .map((json) => CampaignModel.fromJson(json))
          .toList();
      return campaigns;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<JoiningRequestModel>> getAllJoiningRequestToCampaign() async {
    final token = await _getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/api/project/pending-joins'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      final List<JoiningRequestModel> requests = jsonList
          .map((json) => JoiningRequestModel.fromJson(json))
          .toList();
      return requests;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CampaignModel> getCampaignDetails(int campaignId) async {
    final token = await _getToken();

    final response = await client.get(
      Uri.parse('$baseUrl/api/client/project/show/$campaignId'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print("Response of Get Campaign Detials :${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body)['data'];
      final CampaignModel campaign = CampaignModel.fromJson(json);
      return campaign;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> refuseToJoinTheCampaign(int participantId) async {
    final token = await _getToken();

    final response = await client.post(
      Uri.parse('$baseUrl/api/project/approve-join/$participantId'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': 'تم الرفض'}),
    );
    print("Response of refuse :${response.body}");
    print("status code of refuse :${response.statusCode}");

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CampaignModel>> getAllCampaignsCreatedByVolunteerAdmin({
    String? status,
  }) async {
    //! updated
    final token = await _getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/api/client/project/myProjects'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      final List<CampaignModel> campaigns = jsonList
          .map((json) => CampaignModel.fromJson(json))
          .toList();
      return campaigns;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CampaignModel>> searchCampaigns({String? query}) async {
    final List<CampaignModel> allCampaigns = await getAllCampaigns(
      status: null,
    );
    final String lowerCaseQuery = query!.toLowerCase();
    return allCampaigns.where((campaign) {
      final String title = campaign.title?.toLowerCase() ?? '';
      final String description = campaign.description?.toLowerCase() ?? '';
      final String category = campaign.category?.toLowerCase() ?? '';
      final String locationName = campaign.location?.name?.toLowerCase() ?? '';
      return title.contains(lowerCaseQuery) ||
          description.contains(lowerCaseQuery) ||
          category.contains(lowerCaseQuery) ||
          locationName.contains(lowerCaseQuery);
    }).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.get(
      Uri.parse("$baseUrl/api/categories/"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['status'] != true ||
          decoded['data'] == null ||
          decoded['data'] is! List) {
        throw ServerException();
      }

      final List<dynamic> dataList = decoded['data'];
      final categories = dataList
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      return categories;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<RegionModel>> getAllRegions() async {
    final token = await _getToken();
    final response = await client.get(
      Uri.parse("$baseUrl/api/client/complaint/allRegions"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['status'] == true &&
          decoded['data'] != null &&
          decoded['data'] is List) {
        final List<dynamic> dataList = decoded['data'];
        final regions = dataList
            .map((json) => RegionModel.fromJson(json))
            .toList();

        return regions;
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserProfileModel> getUserProfileByUserId(int userId) async {
    final token = await _getToken();
    try {
      final response = await client.get(
        Uri.parse("$baseUrl/api/client/profile/show/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['status'] == true && responseBody['data'] != null) {
          return UserProfileModel.fromJson(
            responseBody['data'] as Map<String, dynamic>,
          );
        } else {
          throw ServerException1(
            message: responseBody['message'] ?? 'Failed to get profile data.',
          );
        }
      } else {
        print(
          'Failed to load profile for user $userId. Status code: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
        throw ServerException1(
          statusCode: response.statusCode,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } on Exception catch (e) {
      print('Error in getProfileByUserId remote data source: $e');
      throw ServerException();
    }
  }
}
