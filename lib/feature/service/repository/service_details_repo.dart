import 'package:demandium/api/remote/client_api.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/app_constants.dart';

class ServiceDetailsRepo {
  final ApiClient apiClient;
  ServiceDetailsRepo({required this.apiClient});

  Future<Response> getServiceDetails(String serviceID, String fromPage) async {
    if (fromPage == "search_page") {
      return await apiClient.getData(
        '${AppConstants.serviceDetailsUri}/$serviceID?attribute=service',
      );
    } else {
      return await apiClient.getData(
        '${AppConstants.serviceDetailsUri}/$serviceID',
      );
    }
  }

  Future<Response> getServiceReviewList(String serviceID, int offset) async {
    return await apiClient.getData(
      '${AppConstants.getServiceReviewList}$serviceID?offset=$offset&limit=10',
    );
  }

  Future<Response> getProviderBasedOnSubcategory(String subcategoryId) async {
    return await apiClient.getData(
      "${AppConstants.getProviderBasedOnSubcategory}?sub_category_id=$subcategoryId",
    );
  }

  Future<Response> getProviderList({
    required int offset,
    int limit = 50,
    required Map<String, dynamic> body,
  }) async {
    return await apiClient.postData(
      "${AppConstants.getProviderList}?limit=$limit&offset=$offset",
      body,
    );
  }
}
